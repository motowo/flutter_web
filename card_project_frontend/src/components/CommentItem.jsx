import React from 'react';

const CommentItem = ({ comment }) => {
  return (
    <div style={{ border: '1px solid #eee', margin: '5px 0', padding: '10px' }}>
      <p><strong>{comment.author_username || 'Anonymous'}</strong></p>
      {comment.text_content && <p>{comment.text_content}</p>}
      {comment.image_url && (
        <div>
          <img 
            src={comment.image_url} 
            alt="Comment attachment" 
            style={{ maxWidth: '200px', maxHeight: '200px', display: 'block' }} 
          />
        </div>
      )}
      <p style={{ fontSize: '0.8em', color: '#777' }}>
        Posted on: {new Date(comment.created_at).toLocaleString()}
      </p>
    </div>
  );
};

export default CommentItem;
