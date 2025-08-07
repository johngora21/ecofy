import React, { useState } from 'react';
import { Link, useLocation } from 'react-router-dom';
import {
  Home,
  MapPin,
  ShoppingCart,
  Users,
  MessageSquare,
  BarChart3,
  Settings,
  Package,
  TrendingUp
} from 'lucide-react';

const Layout = ({ children }) => {
  const [sidebarOpen, setSidebarOpen] = useState(false);
  const location = useLocation();

  const navigation = [
    { name: 'Dashboard', href: '/', icon: Home },
    { name: 'Farms', href: '/farms', icon: MapPin },
    { name: 'Marketplace', href: '/marketplace', icon: Package },
    { name: 'Market Price', href: '/market-price', icon: TrendingUp },
    { name: 'Orders', href: '/orders', icon: ShoppingCart },
    { name: 'Users', href: '/users', icon: Users },
    { name: 'Messages', href: '/messages', icon: MessageSquare },
    { name: 'Analytics', href: '/analytics', icon: BarChart3 },
    { name: 'Settings', href: '/settings', icon: Settings },
  ];

  // Get current page title
  const getPageTitle = () => {
    const currentPage = navigation.find(item => item.href === location.pathname);
    return currentPage ? currentPage.name : 'Dashboard';
  };

  return (
    <div className="flex h-screen bg-gray-100">
      {/* Sidebar */}
      <aside className={`bg-green-600 w-64 shadow-lg flex flex-col transition-all duration-200 ${sidebarOpen ? '' : 'hidden md:flex'}`}>
        <div className="h-16 flex items-center justify-center border-b border-green-700">
          <span className="text-xl font-bold tracking-wide text-white">Ecofy Admin</span>
        </div>
        <nav className="flex-1 py-4">
          {navigation.map((item) => (
            <Link
              key={item.name}
              to={item.href}
              className={`flex items-center px-6 py-3 text-white transition-colors ${location.pathname === item.href ? 'bg-white text-green-800 font-bold rounded-lg shadow-lg' : 'hover:bg-green-500'}`}
            >
              <item.icon className={`w-5 h-5 mr-3 ${location.pathname === item.href ? 'text-green-800' : 'text-white'}`} />
              {item.name}
            </Link>
          ))}
        </nav>
      </aside>

      {/* Main Content */}
      <div className="flex-1 flex flex-col overflow-hidden">
        {/* Header */}
        <header className="bg-white shadow-sm border-b">
          <div className="flex items-center justify-between px-6 py-4">
            <div className="flex items-center">
              <button
                onClick={() => setSidebarOpen(!sidebarOpen)}
                className="md:hidden p-2 rounded-md text-gray-600 hover:text-gray-900 hover:bg-gray-100"
              >
                <svg className="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M4 6h16M4 12h16M4 18h16" />
                </svg>
              </button>
              <h1 className="text-2xl font-bold text-gray-900 ml-4">{getPageTitle()}</h1>
            </div>
            <div className="flex items-center space-x-4">
              <div className="relative">
                <button className="flex items-center space-x-2 text-gray-700 hover:text-gray-900">
                  <div className="w-8 h-8 bg-green-600 rounded-full flex items-center justify-center">
                    <span className="text-white text-sm font-medium">A</span>
                  </div>
                  <span className="hidden md:block">Admin</span>
                </button>
              </div>
            </div>
          </div>
        </header>

        {/* Page Content */}
        <main className="flex-1 overflow-x-hidden overflow-y-auto bg-gray-50">
          <div className="container mx-auto px-6 py-8">
            {children}
          </div>
        </main>
      </div>
    </div>
  );
};

export default Layout;