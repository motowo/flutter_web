import axios from 'axios';
import useAuthStore from '../store/authStore'; // To get the token

const API_BASE_URL = 'http://localhost:8000/api'; // Adjust if your backend URL is different

const apiService = axios.create({
  baseURL: API_BASE_URL,
  headers: {
    'Content-Type': 'application/json',
  },
});

// Request Interceptor to add the auth token
apiService.interceptors.request.use(
  (config) => {
    // Attempt to get token from localStorage first, then from Zustand store as a fallback
    // This is because the store might not be initialized when the service is first imported.
    // However, for ongoing requests after login, the store's state is the most reliable.
    // The best approach is to ensure localStorage is the primary source for the interceptor
    // and the store syncs with localStorage.
    const token = localStorage.getItem('accessToken'); 
    
    if (token) {
      config.headers['Authorization'] = `Bearer ${token}`;
    }
    return config;
  },
  (error) => {
    return Promise.reject(error);
  }
);

export const loginUser = async (credentials) => {
  try {
    const response = await apiService.post('/token/', credentials); // Django Simple JWT uses /token/
    return response.data;
  } catch (error) {
    console.error('Login error:', error.response ? error.response.data : error.message);
    throw error.response ? error.response.data : new Error('Login failed');
  }
};

export const registerUser = async (userData) => {
  try {
    const response = await apiService.post('/auth/register/', userData);
    return response.data;
  } catch (error) {
    console.error('Registration error:', error.response ? error.response.data : error.message);
    throw error.response ? error.response.data : new Error('Registration failed');
  }
};

export const fetchAuthenticatedUser = async (token) => {
  // This function might be called with a token directly (e.g. during login flow)
  // OR it might rely on the interceptor if called without a token argument
  // For clarity, if a token is passed, use it. Otherwise, interceptor handles it.
  const headers = {};
  if (token) {
    headers['Authorization'] = `Bearer ${token}`;
  }
  
  try {
    const response = await apiService.get('/auth/user/', { headers });
    return response.data;
  } catch (error)
  {
    console.error('Fetch user error:', error.response ? error.response.data : error.message);
    // If the interceptor provided the token and it's invalid, this will fail.
    // The authStore's fetchUser action already handles logging out on error.
    throw error.response ? error.response.data : new Error('Failed to fetch user details');
  }
};

export default apiService; // Export the configured axios instance
