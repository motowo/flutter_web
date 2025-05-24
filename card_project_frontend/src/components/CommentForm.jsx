import React, { useState } from 'react';
import useCommentStore from '../store/commentStore';

const CommentForm = ({ cardId }) => {
  const [textContent, setTextContent] = useState('');
  const [imageFile, setImageFile] = useState(null);
  const [imagePreview, setImagePreview] = useState('');

  const { addComment, uploadAndAddImageComment, isPostingComment, postCommentError } = useCommentStore();

  const handleFileChange = (e) => {
    const file = e.target.files[0];
    if (file) {
      setImageFile(file);
      const reader = new FileReader();
      reader.onloadend = () => {
        setImagePreview(reader.result);
      };
      reader.readAsDataURL(file);
    } else {
      setImageFile(null);
      setImagePreview('');
    }
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    if (!textContent && !imageFile) {
      alert('Please enter text or select an image.');
      return;
    }

    try {
      if (imageFile) {
        await uploadAndAddImageComment(cardId, imageFile, textContent);
      } else {
        await addComment(cardId, { text_content: textContent });
      }
      // Clear form on success
      setTextContent('');
      setImageFile(null);
      setImagePreview('');
      e.target.reset(); // Resets the file input
    } catch (error) {
      // Error is already set in the store, can be displayed globally or locally
      console.error("Comment submission failed:", error);
      // alert(`Failed to post comment: ${error.message || 'Unknown error'}`);
    }
  };

  return (
    <form onSubmit={handleSubmit} style={{ marginTop: '20px', padding: '10px', border: '1px solid #ddd' }}>
      <h4>Add a Comment</h4>
      <div>
        <textarea
          value={textContent}
          onChange={(e) => setTextContent(e.target.value)}
          placeholder="Write your comment..."
          rows="3"
          style={{ width: '100%', marginBottom: '10px' }}
        />
      </div>
      <div>
        <label htmlFor={`file-input-${cardId}`}>Upload Image (optional):</label>
        <input 
            type="file" 
            id={`file-input-${cardId}`} // Unique ID if multiple forms could exist
            onChange={handleFileChange} 
            accept="image/*" 
            style={{ marginBottom: '10px' }}
        />
        {imagePreview && (
          <img 
            src={imagePreview} 
            alt="Preview" 
            style={{ width: '100px', height: '100px', objectFit: 'cover', marginBottom: '10px' }} 
          />
        )}
      </div>
      <button type="submit" disabled={isPostingComment}>
        {isPostingComment ? 'Posting...' : 'Post Comment'}
      </button>
      {postCommentError && (
        <p style={{ color: 'red' }}>
          Error: {postCommentError.detail || postCommentError.message || 'Failed to post comment.'}
        </p>
      )}
    </form>
  );
};

export default CommentForm;
