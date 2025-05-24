import apiService from './authService'; // Import the configured axios instance

export const fetchCards = async () => {
  try {
    // The interceptor in apiService will automatically add the Authorization header
    const response = await apiService.get('/cards/');
    return response.data;
  } catch (error) {
    console.error('Fetch cards error:', error.response ? error.response.data : error.message);
    throw error.response ? error.response.data : new Error('Failed to fetch cards');
  }
};

export const createCard = async (cardData) => {
  try {
    // The interceptor in apiService will automatically add the Authorization header
    // cardData should be an object like { type: "...", status: "...", organization: "..." }
    const response = await apiService.post('/cards/', cardData);
    return response.data;
  } catch (error) {
    console.error('Create card error:', error.response ? error.response.data : error.message);
    throw error.response ? error.response.data : new Error('Failed to create card');
  }
};

export const fetchCardDetail = async (cardId) => {
  try {
    const response = await apiService.get(`/cards/${cardId}/`);
    return response.data;
  } catch (error) {
    console.error(`Fetch card detail error for card ${cardId}:`, error.response ? error.response.data : error.message);
    throw error.response ? error.response.data : new Error(`Failed to fetch card detail for card ${cardId}`);
  }
};

// Future card-related API calls can be added here, e.g.:
// export const updateCard = async (id, cardData) => { ... };
// export const deleteCard = async (id) => { ... };
