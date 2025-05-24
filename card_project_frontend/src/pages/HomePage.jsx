import React from 'react';
import { Link } from 'react-router-dom'; // Import Link
import useAuthStore from '../store/authStore';

const HomePage = () => {
  const isAuthenticated = useAuthStore((state) => state.isAuthenticated);
  const user = useAuthStore((state) => state.user);
  const logout = useAuthStore((state) => state.logout);
  const isLoading = useAuthStore((state) => state.isLoading); // Added to check loading state

  if (isLoading && !user) { // Show loading only if user is not yet loaded
    return <div>Loading user details...</div>;
  }

  return (
    <div>
      <h1>Home Page</h1>
      {isAuthenticated && user ? (
        <div>
          <p>Welcome, {user.username}! You are authenticated.</p>
          <button onClick={logout}>Logout</button>
        </div>
      ) : (
        <div>
          <p>You are not authenticated.</p>
          <Link to="/login">Go to Login</Link>
        </div>
      )}
    </div>
  );
};

export default HomePage;
