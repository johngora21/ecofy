import React from 'react';
import { Link, useLocation } from 'react-router-dom';
import {
  Home,
  Users,
  Brain,
  Mic,
  MessageSquare,
  BarChart3,
  Settings,
  Database,
  Smartphone,
  LogOut,
  MapPin,
  Wifi,
  GraduationCap,
  UserCheck,
  Package,

  TestTube,
  Globe
} from 'lucide-react';

const Layout = ({ children }) => {
  const location = useLocation();

  const navigation = [
    { name: 'Dashboard', href: '/', icon: Home },
    {
      category: 'Field Operations',
      items: [
        { name: 'Field Teams', href: '/field-teams', icon: UserCheck },
        { name: 'Training Programs', href: '/training-programs', icon: GraduationCap },
        { name: 'Regional Agents', href: '/regional-agents', icon: MapPin },
        { name: 'Soil Sampling', href: '/soil-sampling', icon: TestTube },
      ]
    },
    {
      category: 'IoT & Hardware',
      items: [
        { name: 'IoT Devices', href: '/iot-devices', icon: Wifi },
        { name: 'Kit Distribution', href: '/kit-distribution', icon: Package },
        { name: 'Device Analytics', href: '/device-analytics', icon: BarChart3 },
        { name: 'Field Coverage', href: '/field-coverage', icon: Globe },
      ]
    },
    { 
      category: 'AI & Training',
      items: [
        { name: 'Training Data', href: '/training-data', icon: Database },
        { name: 'Model Training', href: '/model-training', icon: Brain },
        { name: 'Voice Training', href: '/voice-training', icon: Mic },
        { name: 'User Feedback', href: '/user-feedback', icon: Users },
      ]
    },
    {
      category: 'Communication',
      items: [
        { name: 'WhatsApp Monitor', href: '/whatsapp-monitor', icon: MessageSquare },
        { name: 'SMS Gateway', href: '/sms-gateway', icon: Smartphone },
      ]
    },
    {
      category: 'Marketplace & Users',
      items: [
        { name: 'Marketplace Management', href: '/marketplace-management', icon: Package },
        { name: 'User Management', href: '/user-management', icon: Users },
      ]
    },
    {
      category: 'System',
      items: [
        { name: 'Analytics', href: '/analytics', icon: BarChart3 },
        { name: 'Settings', href: '/settings', icon: Settings },
      ]
    }
  ];

  const renderNavItem = (item) => {
    const isActive = location.pathname === item.href;
    return (
      <Link
        key={item.name}
        to={item.href}
        className={`flex items-center px-4 py-2 text-sm font-medium rounded-lg transition-colors ${
          isActive
            ? 'bg-primary/10 text-primary border-r-2 border-primary'
            : 'text-textSecondary hover:bg-backgroundSecondary hover:text-textPrimary'
        }`}
      >
        <item.icon className="w-4 h-4 mr-3" />
        {item.name}
      </Link>
    );
  };

  return (
    <div className="flex h-screen bg-backgroundPrimary">
      {/* Sidebar */}
      <div className="w-64 bg-white shadow-lg flex flex-col h-full">
        <div className="flex items-center justify-center h-16 bg-primary">
          <h1 className="text-xl font-bold text-white">EcoFy Admin</h1>
        </div>
        
        {/* Navigation - takes up remaining space */}
        <nav className="flex-1 overflow-y-auto mt-6 pb-20">
          <div className="px-4 space-y-4">
            {navigation.map((section, index) => {
              if (section.category) {
                return (
                  <div key={index}>
                    <h3 className="px-3 text-xs font-semibold text-gray-500 uppercase tracking-wider">
                      {section.category}
                    </h3>
                    <div className="mt-2 space-y-1">
                      {section.items.map(renderNavItem)}
                    </div>
                  </div>
                );
              } else {
                return renderNavItem(section);
              }
            })}
          </div>
        </nav>
        
        {/* Bottom section - fixed at bottom */}
        <div className="border-t border-gray-200 p-4 bg-white">
          <button className="flex items-center w-full px-4 py-3 text-sm font-medium text-red-600 rounded-lg hover:bg-red-50 transition-colors">
            <LogOut className="w-5 h-5 mr-3" />
            Sign Out
          </button>
        </div>
      </div>

      {/* Main content */}
      <div className="flex-1 flex flex-col overflow-hidden">
        {/* Header */}
        <header className="bg-white shadow-sm border-b border-gray-200">
          <div className="px-6 py-4 flex items-center justify-between">
            <h1 className="text-2xl font-semibold text-textPrimary">
              EcoFy Admin Dashboard
            </h1>
            <div className="flex items-center space-x-4">
              <div className="flex items-center space-x-2 text-sm text-textSecondary">
                <div className="w-2 h-2 bg-success rounded-full"></div>
                <span>System Online</span>
              </div>
              <div className="flex items-center space-x-2 text-sm text-textSecondary">
                <Wifi className="w-4 h-4" />
                <span>124 IoT Devices Active</span>
              </div>
              <div className="flex items-center space-x-2 text-sm text-textSecondary">
                <UserCheck className="w-4 h-4" />
                <span>18 Field Teams</span>
              </div>
            </div>
          </div>
        </header>

        {/* Page content */}
        <main className="flex-1 overflow-y-auto bg-backgroundPrimary p-6">
          {children}
        </main>
      </div>
    </div>
  );
};

export default Layout; 