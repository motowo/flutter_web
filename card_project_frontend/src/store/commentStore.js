import {create} from 'zustand';
import { 
    fetchComments as fetchCommentsService, 
    createComment as createCommentService 
} from '../services/commentService';
import { uploadImage as uploadImageService } from '../services/mediaService';

const useCommentStore = create((set, get) => ({
  comments: [],
  isLoadingComments: false,
  commentsError: null,
  isPostingComment: false,
  postCommentError: null,

  fetchComments: async (cardId) => {
    set({ isLoadingComments: true, commentsError: null });
    try {
      const data = await fetchCommentsService(cardId);
      set({ comments: data, isLoadingComments: false });
    } catch (error) {
      set({ commentsError: error, isLoadingComments: false });
    }
  },

  addComment: async (cardId, commentData) => {
    set({ isPostingComment: true, postCommentError: null });
    try {
      await createCommentService(cardId, commentData);
      set({ isPostingComment: false });
      // Refresh comments for the current card
      await get().fetchComments(cardId); 
    } catch (error) {
      set({ postCommentError: error, isPostingComment: false });
      throw error; // Re-throw to allow form to handle it
    }
  },

  uploadAndAddImageComment: async (cardId, file, optionalTextContent = '') => {
    set({ isPostingComment: true, postCommentError: null }); // Indicate loading state
    try {
      // 1. Upload image
      const formData = new FormData();
      formData.append('image', file);
      const uploadResponse = await uploadImageService(formData);
      const imageUrl = uploadResponse.image_url;

      if (!imageUrl) {
        throw new Error('Image URL not returned from upload service.');
      }

      // 2. Create comment with image URL and optional text
      await get().addComment(cardId, { 
        text_content: optionalTextContent, 
        image_url: imageUrl 
      });
      // isPostingComment will be set to false by the called addComment's success path
    } catch (error) {
      console.error('Upload and add image comment error:', error);
      set({ postCommentError: error, isPostingComment: false });
      throw error; // Re-throw to allow form to handle it
    }
  },

  clearComments: () => {
    set({ comments: [], commentsError: null });
  }
}));

export default useCommentStore;
