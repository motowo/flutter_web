import React, { useEffect } from 'react';
import { useParams, Link } from 'react-router-dom';
import useCardStore from '../store/cardStore';
import useCommentStore from '../store/commentStore';
import CommentItem from '../components/CommentItem';
import CommentForm from '../components/CommentForm';

const CardDetailPage = () => {
  const { cardId } = useParams();
  const { 
    selectedCard, 
    isLoadingDetail: isLoadingCard, 
    detailError: cardError, 
    fetchCardDetail 
  } = useCardStore();
  
  const { 
    comments, 
    isLoadingComments, 
    commentsError, 
    fetchComments,
    clearComments // Action to clear comments when component unmounts or cardId changes
  } = useCommentStore();

  useEffect(() => {
    if (cardId) {
      fetchCardDetail(cardId);
      fetchComments(cardId);
    }
    // Cleanup function to clear comments when the component unmounts or cardId changes
    return () => {
      clearComments();
    };
  }, [cardId, fetchCardDetail, fetchComments, clearComments]);

  if (isLoadingCard) return <p>Loading card details...</p>;
  if (cardError) return <p>Error loading card: {cardError.message || JSON.stringify(cardError)}</p>;
  if (!selectedCard) return <p>Card not found or not loaded yet.</p>;

  return (
    <div>
      <h2>Card Detail: {selectedCard.type} (ID: {selectedCard.id})</h2>
      <p><strong>Status:</strong> {selectedCard.status}</p>
      <p><strong>Owner:</strong> {selectedCard.owner_username}</p>
      <p><strong>Organization:</strong> {selectedCard.organization}</p>
      <p><strong>Created At:</strong> {new Date(selectedCard.created_at).toLocaleString()}</p>
      <p><strong>Last Updated:</strong> {new Date(selectedCard.updated_at).toLocaleString()}</p>
      {selectedCard.latest_comment_summary && (
        <p><strong>Latest Comment Summary:</strong> {selectedCard.latest_comment_summary}</p>
      )}

      <hr />
      <h3>Comments</h3>
      {isLoadingComments && <p>Loading comments...</p>}
      {commentsError && <p>Error loading comments: {commentsError.message || JSON.stringify(commentsError)}</p>}
      
      {comments.length > 0 ? (
        comments.map((comment) => (
          <CommentItem key={comment.id} comment={comment} />
        ))
      ) : (
        !isLoadingComments && <p>No comments yet.</p>
      )}

      <CommentForm cardId={cardId} />

      <br />
      <Link to="/">Back to Card List</Link>
    </div>
  );
};

export default CardDetailPage;
