async function uploadImage() {
  const fileInput = document.getElementById("imageFile");
  const file = fileInput.files[0];

  if (!file) {
      alert("Please select an image file to upload.");
      return;
  }

  const formData = new FormData();
  formData.append("image", file);

  try {
      // Replace this URL with your Function App endpoint
      const response = await fetch("https://wot-linux-function.azurewebsites.net/api/uploadImage", {
          method: "POST",
          body: formData,
      });

      const result = await response.json();

      if (result.links) {
          alert("Image processed successfully. Links are in the console.");
          console.log("Resized Image Links:", result.links);
      } else {
          alert("Something went wrong. No links returned.");
      }
  } catch (error) {
      console.error("Upload failed:", error);
      alert("Upload failed. Please try again.");
  }
}

  