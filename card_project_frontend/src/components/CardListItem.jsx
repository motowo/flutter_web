import React from 'react';
import { Link } from 'react-router-dom';

const CardListItem = ({ card }) => {
  return (
    <div style={{ border: '1px solid #ccc', margin: '10px', padding: '10px' }}>
      <h3>Type: {card.type}</h3>
      <p>Status: {card.status}</p>
      <p>Owner: {card.owner_username}</p>
      <p>Organization: {card.organization}</p>
      <p>Last Updated: {new Date(card.updated_at).toLocaleDateString()}</p>
      {card.latest_comment_summary && <p>Last Comment: {card.latest_comment_summary}</p>}
      <Link to={`/cards/${card.id}`}>View Details</Link>
    </div>
  );
};

export default CardListItem;
