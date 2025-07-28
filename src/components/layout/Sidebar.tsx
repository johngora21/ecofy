import React from 'react';
import { 
  Home, 
  MapPin, 
  BookOpen, 
  ShoppingCart, 
  Package, 
  Settings
} from 'lucide-react';
import type { Page } from '../../types';

interface SidebarProps {
  currentPage: Page;
  setCurrentPage: (page: Page) => void;
}

const Sidebar: React.FC<SidebarProps> = ({ currentPage, setCurrentPage }) => {
  return (
    <div className="w-64 bg-white h-screen shadow-lg fixed left-0 top-0 z-40">
      <div className="p-6">
        <div className="flex items-center gap-3 mb-8">
          <div className="w-10 h-10 bg-emerald-500 rounded-full flex items-center justify-center text-white font-bold">
            J
          </div>
          <div>
            <div className="font-semibold text-gray-800">John Farmer</div>
            <div className="text-sm text-gray-500">Profile</div>
          </div>
        </div>

        <nav className="space-y-2">
          <button
            onClick={() => setCurrentPage('dashboard')}
            className={`w-full flex items-center gap-3 px-4 py-3 rounded-lg text-left transition-colors ${
              currentPage === 'dashboard' 
                ? 'bg-emerald-500 text-white' 
                : 'text-gray-600 hover:bg-gray-100'
            }`}
          >
            <Home size={20} />
            Dashboard
          </button>
          <button
            onClick={() => setCurrentPage('farms')}
            className={`w-full flex items-center gap-3 px-4 py-3 rounded-lg text-left transition-colors ${
              currentPage === 'farms' 
                ? 'bg-emerald-500 text-white' 
                : 'text-gray-600 hover:bg-gray-100'
            }`}
          >
            <MapPin size={20} />
            My Farms
          </button>
          <button
            onClick={() => setCurrentPage('resources')}
            className={`w-full flex items-center gap-3 px-4 py-3 rounded-lg text-left transition-colors ${
              currentPage === 'resources' 
                ? 'bg-emerald-500 text-white' 
                : 'text-gray-600 hover:bg-gray-100'
            }`}
          >
            <BookOpen size={20} />
            Resources
          </button>
          <button
            onClick={() => setCurrentPage('marketplace')}
            className={`w-full flex items-center gap-3 px-4 py-3 rounded-lg text-left transition-colors ${
              currentPage === 'marketplace' 
                ? 'bg-emerald-500 text-white' 
                : 'text-gray-600 hover:bg-gray-100'
            }`}
          >
            <ShoppingCart size={20} />
            Marketplace
          </button>
          <button
            onClick={() => setCurrentPage('orders')}
            className={`w-full flex items-center gap-3 px-4 py-3 rounded-lg text-left transition-colors ${
              currentPage === 'orders' 
                ? 'bg-emerald-500 text-white' 
                : 'text-gray-600 hover:bg-gray-100'
            }`}
          >
            <Package size={20} />
            My Orders
          </button>
        </nav>
      </div>

      <div className="absolute bottom-4 left-4 right-4">
        <button className="w-full flex items-center gap-3 px-4 py-3 text-gray-600 hover:bg-gray-100 rounded-lg">
          <Settings size={20} />
          Settings
        </button>
        <div className="mt-4 text-xs text-gray-500">
          <div>Version: 1.0.0</div>
          <div className="flex items-center gap-2">
            <div className="w-2 h-2 bg-green-500 rounded-full"></div>
            Offline Mode Available
          </div>
        </div>
      </div>
    </div>
  );
};

export default Sidebar;