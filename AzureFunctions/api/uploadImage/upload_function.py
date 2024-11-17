import logging
import os
from azure.storage.blob import BlobServiceClient
from flask import Flask, request, jsonify
from PIL import Image
import tempfile

app = Flask(__name__)

# Azure Storage configuration
STORAGE_CONNECTION_STRING = os.environ.get("STORAGE_CONNECTION_STRING")
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


@app.route("/api/upload", methods=["POST"])
def upload_image():
    try:
        # Save the uploaded image
        uploaded_file = request.files["image"]
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

        return jsonify({"links": urls})

    except Exception as e:
        logging.error(f"Error processing image: {e}")
        return jsonify({"error": str(e)}), 500


if __name__ == "__main__":
    app.run(debug=True)
