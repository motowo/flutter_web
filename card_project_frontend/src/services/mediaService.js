import apiService from './authService'; // Import the configured axios instance

export const uploadImage = async (formData) => {
  try {
    // The interceptor in apiService will automatically add the Authorization header
    // The Content-Type header needs to be 'multipart/form-data' for file uploads,
    // which Axios typically sets automatically when given a FormData object.
    const response = await apiService.post('/media/upload/', formData, {
      headers: {
        // Axios should set this automatically, but being explicit can sometimes help.
        // However, it's often better to let Axios handle it to ensure correct boundaries.
        // 'Content-Type': 'multipart/form-data', 
      },
    });
    return response.data; // Expected to be { image_url: "..." }
  } catch (error) {
    console.error('Image upload error:', error.response ? error.response.data : error.message);
    throw error.response ? error.response.data : new Error('Failed to upload image');
  }
};
