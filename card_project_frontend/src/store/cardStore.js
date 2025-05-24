import {create} from 'zustand';
import { 
    fetchCards as fetchCardsService, 
    createCard as createCardService,
    fetchCardDetail as fetchCardDetailService 
} from '../services/cardService';

const useCardStore = create((set, get) => ({
  cards: [],
  isLoading: false, // For fetching list of cards
  error: null,      // For fetching list of cards
  isCreating: false, // For creating a card
  createError: null, // For creating a card

  selectedCard: null,
  isLoadingDetail: false,
  detailError: null,

  fetchCards: async () => {
    set({ isLoading: true, error: null });
    try {
      const data = await fetchCardsService();
      set({ cards: data, isLoading: false });
    } catch (error) {
      set({ error, isLoading: false });
    }
  },

  createCard: async (cardData, navigate) => {
    set({ isCreating: true, createError: null });
    try {
      const newCard = await createCardService(cardData);
      await get().fetchCards(); 
      set({ isCreating: false });
      if (navigate) {
        navigate(`/`); 
      }
    } catch (error) {
      set({ createError: error, isCreating: false });
    }
  },

  fetchCardDetail: async (cardId) => {
    set({ isLoadingDetail: true, detailError: null, selectedCard: null });
    try {
      const data = await fetchCardDetailService(cardId);
      set({ selectedCard: data, isLoadingDetail: false });
    } catch (error) {
      set({ detailError: error, isLoadingDetail: false });
    }
  },

  // Future actions like updateCard, deleteCard can be added here
}));

export default useCardStore;
