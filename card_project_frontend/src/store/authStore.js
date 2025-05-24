import {create} from 'zustand';
import { persist, createJSONStorage } from 'zustand/middleware';
import { loginUser, registerUser, fetchAuthenticatedUser } from '../services/authService';

const useAuthStore = create(
  persist(
    (set, get) => ({
      accessToken: null,
      refreshToken: null,
      user: null,
      isAuthenticated: false,
      isLoading: false,
      error: null,

      login: async (credentials) => {
        set({ isLoading: true, error: null });
        try {
          const data = await loginUser(credentials);
          set({
            accessToken: data.access,
            refreshToken: data.refresh,
            isAuthenticated: true,
            isLoading: false,
          });
          localStorage.setItem('accessToken', data.access);
          localStorage.setItem('refreshToken', data.refresh);
          await get().fetchUser(); // Fetch user profile after successful login
          return true; // Indicate success
        } catch (error) {
          set({ error, isLoading: false, isAuthenticated: false });
          localStorage.removeItem('accessToken');
          localStorage.removeItem('refreshToken');
          return false; // Indicate failure
        }
      },

      register: async (userData) => {
        set({ isLoading: true, error: null });
        try {
          // Assuming registration does not automatically log in the user
          // or return tokens directly. Adjust if your backend does.
          await registerUser(userData);
          set({ isLoading: false });
          // Optionally, you could attempt to log in the user here
          // or prompt them to log in.
          return true; // Indicate success
        } catch (error) {
          set({ error, isLoading: false });
          return false; // Indicate failure
        }
      },

      logout: () => {
        set({
          accessToken: null,
          refreshToken: null,
          user: null,
          isAuthenticated: false,
          error: null,
        });
        localStorage.removeItem('accessToken');
        localStorage.removeItem('refreshToken');
      },

      fetchUser: async () => {
        const token = get().accessToken || localStorage.getItem('accessToken');
        if (!token) {
          set({ isAuthenticated: false, user: null }); // Ensure consistent state
          return;
        }
        set({ isLoading: true, error: null }); // Set loading true for user fetching
        try {
          const userData = await fetchAuthenticatedUser(token);
          set({ user: userData, isAuthenticated: true, isLoading: false });
        } catch (error) {
          set({ error, user: null, isAuthenticated: false, isLoading: false });
          // Potentially token is invalid, so log out
          get().logout();
        }
      },
      
      initializeAuth: () => {
        const token = localStorage.getItem('accessToken');
        if (token) {
          set({ accessToken: token });
          get().fetchUser();
        } else {
          set({ isAuthenticated: false, user: null, accessToken: null, refreshToken: null });
        }
      },
    }),
    {
      name: 'auth-storage', // name of the item in the storage (must be unique)
      storage: createJSONStorage(() => localStorage), // (optional) by default, 'localStorage' is used
      partialize: (state) => ({ 
        // Only persist tokens, other state will be re-derived or is transient
        accessToken: state.accessToken, 
        refreshToken: state.refreshToken 
      }),
    }
  )
);

// Call initializeAuth when the store is created/loaded
// This helps in rehydrating state from localStorage on app load.
// However, direct call here might be too early or not the "Zustand way".
// Prefer calling this from App.jsx or a similar top-level component.
// For now, I'll add a note about this and include initializeAuth action.

export default useAuthStore;
