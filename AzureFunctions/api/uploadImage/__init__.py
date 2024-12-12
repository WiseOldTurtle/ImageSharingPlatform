import logging
import azure.functions as func
from azure.storage.blob import BlobServiceClient
from azure.identity import DefaultAzureCredential
from PIL import Image
import io
import os
import mimetypes

# Set your blob container name
BLOB_CONTAINER = "images"

# Initialize BlobServiceClient using Managed Identity
def get_blob_service_client():
    account_url = f"https://{os.getenv('AZURE_STORAGE_ACCOUNT_NAME')}.blob.core.windows.net"
    credential = DefaultAzureCredential()  # This uses the managed identity
    return BlobServiceClient(account_url, credential)

# Resizing function
def resize_image(image, size):
    return image.resize(size, Image.ANTIALIAS)

def main(req: func.HttpRequest) -> func.HttpResponse:
    try:
        # Parse the uploaded file
        file = req.files['file']
        filename = file.filename
        file_content = file.read()

        # Validate file type
        mime_type, _ = mimetypes.guess_type(filename)
        if not mime_type or not mime_type.startswith("image/"):
            return func.HttpResponse("Please upload a valid image file (e.g., JPEG, PNG).", status_code=400)

        # Load image using PIL
        image = Image.open(io.BytesIO(file_content))
        if image.format not in ["JPEG", "PNG"]:
            return func.HttpResponse("Only JPEG and PNG images are supported.", status_code=400)

        # Initialize BlobServiceClient
        blob_service_client = get_blob_service_client()

        # Resize and upload images
        resolutions = {
            "thumbnail": (100, 100),
            "medium": (500, 500),
            "large": (1000, 1000)
        }

        for label, size in resolutions.items():
            # Resize the image
            resized_image = resize_image(image, size)

            # Save the resized image to a BytesIO object
            image_bytes = io.BytesIO()
            resized_image.save(image_bytes, format=image.format)
            image_bytes.seek(0)

            # Upload to Azure Blob Storage with a naming convention
            resized_filename = f"{label}/{filename}"
            blob_client = blob_service_client.get_blob_client(container=BLOB_CONTAINER, blob=resized_filename)
            blob_client.upload_blob(image_bytes, overwrite=True)

        return func.HttpResponse(f"Image {filename} uploaded and resized successfully.", status_code=200)

    except Exception as e:
        logging.error(f"Error: {e}")
        return func.HttpResponse(f"Failed to process image. Error: {str(e)}", status_code=500)
