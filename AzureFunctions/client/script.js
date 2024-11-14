async function uploadImage() {
    const fileInput = document.getElementById('imageFile');
    const file = fileInput.files[0];
  
    if (!file) {
      alert("Please select an image file to upload.");
      return;
    }
  
    const formData = new FormData();
    formData.append("image", file);
  
    try {
      const response = await fetch('/api/uploadImage', {
        method: 'POST',
        body: formData
      });
      const result = await response.json();
      alert(result.message);
    } catch (error) {
      console.error("Upload failed:", error);
      alert("Upload failed. Please try again.");
    }
  }
  