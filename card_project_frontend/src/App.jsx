import React, { useEffect } from 'react';
import { BrowserRouter as Router, Routes, Route, Link, Navigate } from 'react-router-dom';
import useAuthStore from './store/authStore';
import LoginPage from './pages/LoginPage';
// import HomePage from './pages/HomePage'; // No longer using generic HomePage as main
import CardListPage from './pages/CardListPage'; // Import CardListPage
import CardCreatePage from './pages/CardCreatePage'; // Import CardCreatePage
import CardDetailPage from './pages/CardDetailPage'; // Import CardDetailPage

// ProtectedRoute component
const ProtectedRoute = ({ children }) => {
  const isAuthenticated = useAuthStore((state) => state.isAuthenticated);
  // Optionally, add a check for isLoading if initial auth check is async
  // const isLoading = useAuthStore((state) => state.isLoading);
  // if (isLoading) return <div>Loading...</div>; 

  return isAuthenticated ? children : <Navigate to="/login" />;
};


function App() {
  const initializeAuth = useAuthStore((state) => state.initializeAuth);
  const isAuthenticated = useAuthStore((state) => state.isAuthenticated); // For conditional rendering of nav links

  useEffect(() => {
    initializeAuth();
  }, [initializeAuth]);

  return (
    <Router>
      <div>
        <nav>
          <ul>
            <li>
              {/* Link to / which will be CardListPage if authenticated */}
              <Link to="/">Cards</Link> 
            </li>
            {!isAuthenticated && (
              <li>
                <Link to="/login">Login</Link>
              </li>
            )}
            {/* Add other navigation links here */}
          </ul>
        </nav>

        <hr />

        <Routes>
          <Route 
            path="/" 
            element={
              <ProtectedRoute>
                <CardListPage /> 
              </ProtectedRoute>
            } 
          />
          <Route path="/login" element={<LoginPage />} />
          <Route 
            path="/cards/new" 
            element={
              <ProtectedRoute>
                <CardCreatePage />
              </ProtectedRoute>
            } 
          />
          <Route 
            path="/cards/:cardId" 
            element={
              <ProtectedRoute>
                <CardDetailPage />
              </ProtectedRoute>
            } 
          />
        </Routes>
      </div>
    </Router>
  );
}

export default App;
