import React from 'react';
import { BrowserRouter as Router, Routes, Route } from 'react-router-dom';
import Layout from './components/Layout';
import Dashboard from './pages/Dashboard';
import FarmsManagement from './pages/FarmsManagement';
import MarketplaceManagement from './pages/MarketplaceManagement';
import MarketPrice from './pages/MarketPrice';
import Orders from './pages/Orders';
import Users from './pages/Users';
import Messages from './pages/Messages';
import Analytics from './pages/Analytics';
import Settings from './pages/Settings';

function App() {
  return (
    <Router>
      <Layout>
        <Routes>
          <Route path="/" element={<Dashboard />} />
          <Route path="/farms" element={<FarmsManagement />} />
          <Route path="/marketplace" element={<MarketplaceManagement />} />
          <Route path="/market-price" element={<MarketPrice />} />
          <Route path="/orders" element={<Orders />} />
          <Route path="/users" element={<Users />} />
          <Route path="/messages" element={<Messages />} />
          <Route path="/analytics" element={<Analytics />} />
          <Route path="/settings" element={<Settings />} />
        </Routes>
      </Layout>
    </Router>
  );
}

export default App; 