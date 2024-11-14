const { BlobServiceClient } = require('@azure/storage-blob');

module.exports = async function (context, req) {
  const image = req.body.image;

  if (!image) {
    context.res = {
      status: 400,
      body: "No image file uploaded."
    };
    return;
  }

  const blobServiceClient = BlobServiceClient.fromConnectionString(process.env.AzureWebJobsStorage);
  const containerClient = blobServiceClient.getContainerClient('images');

  // Upload original image
  const blockBlobClient = containerClient.getBlockBlobClient(`original-${Date.now()}.jpg`);
  await blockBlobClient.upload(image, image.length);

  // Below you could also resize and save different resolutions

  context.res = {
    status: 200,
    body: { message: "Image uploaded successfully!" }
  };
};
