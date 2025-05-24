import apiService from './authService'; // Import the configured axios instance

export const fetchComments = async (cardId) => {
  try {
    const response = await apiService.get(`/cards/${cardId}/comments/`);
    return response.data;
  } catch (error) {
    console.error(`Fetch comments error for card ${cardId}:`, error.response ? error.response.data : error.message);
    throw error.response ? error.response.data : new Error(`Failed to fetch comments for card ${cardId}`);
  }
};

export const createComment = async (cardId, commentData) => {
  try {
    // commentData should be an object like { text_content: "...", image_url: "..." }
    // One of them can be null or undefined, but not both (backend might enforce this)
    const response = await apiService.post(`/cards/${cardId}/comments/`, commentData);
    return response.data;
  } catch (error) {
    console.error(`Create comment error for card ${cardId}:`, error.response ? error.response.data : error.message);
    throw error.response ? error.response.data : new Error(`Failed to create comment for card ${cardId}`);
  }
};
