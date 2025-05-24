import React, { useEffect } from 'react';
import { Link } from 'react-router-dom';
import useCardStore from '../store/cardStore';
import useAuthStore from '../store/authStore'; // To check authentication
import CardListItem from '../components/CardListItem';

const CardListPage = () => {
  const { cards, isLoading, error, fetchCards } = useCardStore();
  const { isAuthenticated } = useAuthStore(); // Ensure user is authenticated before fetching

  useEffect(() => {
    // Only fetch cards if authenticated and cards haven't been loaded (or to refresh)
    // This basic example fetches on every mount if authenticated.
    // More complex logic could prevent re-fetching if data is already fresh.
    if (isAuthenticated) {
      fetchCards();
    }
  }, [isAuthenticated, fetchCards]);

  if (!isAuthenticated) {
    // This page should be protected by a Route guard, but as a fallback:
    return <p>Please login to view cards.</p>; 
  }

  if (isLoading) {
    return <p>Loading cards...</p>;
  }

  if (error) {
    return <p>Error fetching cards: {error.message || JSON.stringify(error)}</p>;
  }

  return (
    <div>
      <h2>Card List</h2>
      <Link to="/cards/new">
        <button>Add New Card</button>
      </Link>
      {cards.length === 0 && !isLoading && (
        <p>No cards found. Why not add one?</p>
      )}
      <div>
        {cards.map((card) => (
          <CardListItem key={card.id} card={card} />
        ))}
      </div>
    </div>
  );
};

export default CardListPage;
