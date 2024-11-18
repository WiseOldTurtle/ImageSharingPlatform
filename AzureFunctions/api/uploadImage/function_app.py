import logging
import os
from dotenv import load_dotenv
from azure.storage.blob import BlobServiceClient
from azure.functions import HttpRequest, HttpResponse
from PIL import Image
import tempfile

# Load environment variables from .env file
load_dotenv()

# Now you can access your variables
STORAGE_CONNECTION_STRING = os.getenv("STORAGE_CONNECTION_STRING")

# Azure Storage configuration
CONTAINER_NAME = "images"
RESOLUTIONS = {
    "thumbnail": (100, 100),
    "medium": (500, 500),
    "large": (1000, 1000),
}

blob_service_client = BlobServiceClient.from_connection_string(STORAGE_CONNECTION_STRING)

def resize_image(image_path, resolution):
    """Resize image to the given resolution."""
    with Image.open(image_path) as img:
        img.thumbnail(resolution)
        temp_file = tempfile.NamedTemporaryFile(delete=False, suffix=".jpg")
        img.save(temp_file.name, format="JPEG")
        return temp_file.name

def upload_image(req: HttpRequest) -> HttpResponse:
    try:
        # Save the uploaded image
        uploaded_file = req.files["image"]
        original_file_path = tempfile.NamedTemporaryFile(delete=False, suffix=".jpg").name
        uploaded_file.save(original_file_path)

        # Process the image into different resolutions
        urls = []
        for label, resolution in RESOLUTIONS.items():
            resized_file_path = resize_image(original_file_path, resolution)

            # Upload resized image to Azure Blob Storage
            blob_client = blob_service_client.get_blob_client(
                container=CONTAINER_NAME, blob=f"{label}/{os.path.basename(resized_file_path)}"
            )
            with open(resized_file_path, "rb") as data:
                blob_client.upload_blob(data, overwrite=True)

            # Generate public URL
            urls.append(blob_client.url)

        return HttpResponse(f'{{"links": {urls}}}', mimetype="application/json")

    except Exception as e:
        logging.error(f"Error processing image: {e}")
        return HttpResponse(f'{{"error": "{str(e)}"}}', status_code=500)

