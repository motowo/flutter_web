import React, { useState } from 'react';
import { useNavigate, Link } from 'react-router-dom';
import useCardStore from '../store/cardStore';

const CardCreatePage = () => {
  const [type, setType] = useState('');
  const [status, setStatus] = useState('');
  const [organization, setOrganization] = useState(''); // Assuming user might set this

  const navigate = useNavigate();
  const { createCard, isCreating, createError } = useCardStore();

  const handleSubmit = async (e) => {
    e.preventDefault();
    const cardData = { type, status, organization };
    // The createCard action in the store now handles navigation
    await createCard(cardData, navigate);
  };

  return (
    <div>
      <h2>Create New Card</h2>
      <form onSubmit={handleSubmit}>
        <div>
          <label htmlFor="type">Type:</label>
          <input
            type="text"
            id="type"
            value={type}
            onChange={(e) => setType(e.target.value)}
            required
          />
        </div>
        <div>
          <label htmlFor="status">Status:</label>
          <input
            type="text"
            id="status"
            value={status}
            onChange={(e) => setStatus(e.target.value)}
            required
          />
        </div>
        <div>
          <label htmlFor="organization">Organization:</label>
          <input
            type="text"
            id="organization"
            value={organization}
            onChange={(e) => setOrganization(e.target.value)}
            // required={false} // Make it optional if backend handles default
          />
        </div>
        <button type="submit" disabled={isCreating}>
          {isCreating ? 'Creating...' : 'Create Card'}
        </button>
        {createError && (
          <p style={{ color: 'red' }}>
            Error creating card: {createError.message || JSON.stringify(createError)}
          </p>
        )}
      </form>
      <br />
      <Link to="/">Back to Card List</Link>
    </div>
  );
};

export default CardCreatePage;
