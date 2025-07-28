import { useState } from 'react';
import type { Page } from './types';
import Sidebar from './components/layout/Sidebar';
import Header from './components/layout/Header';
// import Dashboard from './components/pages/Dashboard';
import Dashboard from './components/pages/Dashboard/index';
import Farms from './components/pages/Farms/Farms';
import Resources from './components/pages/Resources/Resources';
// import Marketplace from './components/pages/Marketplace/Marketplace';
import Marketplace from './components/pages/Marketplace/index';
import Orders from './components/pages/Orders/Orders';

const EcofyApp = () => {
  const [currentPage, setCurrentPage] = useState<Page>('dashboard');
  const [selectedCrop, setSelectedCrop] = useState('Maize');
  
  const renderCurrentPage = () => {
    switch (currentPage) {
      case 'dashboard':
        return <Dashboard selectedCrop={selectedCrop} setSelectedCrop={setSelectedCrop} />;
      case 'farms':
        return <Farms />;
      case 'resources':
        return <Resources />;
      case 'marketplace':
        return <Marketplace />;
      case 'orders':
        return <Orders />;
      default:
        return <Dashboard selectedCrop={selectedCrop} setSelectedCrop={setSelectedCrop} />;
    }
  };

  // Show main app (all pages are now public)
  return (
    <div className="min-h-screen bg-gray-50">
      <Sidebar 
        currentPage={currentPage} 
        setCurrentPage={setCurrentPage}
      />
      <div className="ml-64">
        <Header />
        <main className="min-h-screen">
          {renderCurrentPage()}
        </main>
      </div>
    </div>
  );
};

export default EcofyApp;