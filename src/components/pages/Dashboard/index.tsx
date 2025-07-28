import React, { useState } from 'react';
import { Cloud, TrendingUp, MapPin, Droplets } from 'lucide-react';

interface DashboardProps {
  selectedCrop: string;
  setSelectedCrop: (crop: string) => void;
}

type ActiveSection = 'market' | 'soil' | 'risks' | 'areas' | 'climate';

const Dashboard: React.FC<DashboardProps> = ({ selectedCrop, setSelectedCrop }) => {
  const [activeSection, setActiveSection] = useState<ActiveSection>('market');

  const navigationButtons = [
    { key: 'market', label: 'Market Intelligence', icon: TrendingUp },
    { key: 'soil', label: 'Soil Insights', icon: MapPin },
    { key: 'risks', label: 'Risk Assessment', icon: Cloud },
    { key: 'areas', label: 'Suitable Areas', icon: MapPin },
    { key: 'climate', label: 'Climate Type', icon: Droplets }
  ];

  const renderActiveSection = () => {
    switch (activeSection) {
      case 'market':
        return (
          <div className="bg-white rounded-lg border border-gray-200 p-6">
            <h3 className="text-lg font-semibold text-gray-900 mb-4">Market Intelligence</h3>
            <div className="text-center py-12">
              <div className="text-gray-400 text-6xl mb-4">📊</div>
              <h3 className="text-lg font-medium text-gray-900 mb-2">Market Data</h3>
              <p className="text-gray-500">Market insights will be loaded from the backend API</p>
            </div>
          </div>
        );
      case 'soil':
        return (
          <div className="bg-white rounded-lg border border-gray-200 p-6">
            <h3 className="text-lg font-semibold text-gray-900 mb-4">Soil Insights</h3>
            <div className="text-center py-12">
              <div className="text-gray-400 text-6xl mb-4">🌱</div>
              <h3 className="text-lg font-medium text-gray-900 mb-2">Soil Data</h3>
              <p className="text-gray-500">Soil analysis will be loaded from the backend API</p>
            </div>
          </div>
        );
      case 'risks':
        return (
          <div className="bg-white rounded-lg border border-gray-200 p-6">
            <h3 className="text-lg font-semibold text-gray-900 mb-4">Risk Assessment</h3>
            <div className="text-center py-12">
              <div className="text-gray-400 text-6xl mb-4">⚠️</div>
              <h3 className="text-lg font-medium text-gray-900 mb-2">Risk Data</h3>
              <p className="text-gray-500">Risk assessment will be loaded from the backend API</p>
            </div>
          </div>
        );
      case 'areas':
        return (
          <div className="bg-white rounded-lg border border-gray-200 p-6">
            <h3 className="text-lg font-semibold text-gray-900 mb-4">Suitable Areas</h3>
            <div className="text-center py-12">
              <div className="text-gray-400 text-6xl mb-4">🗺️</div>
              <h3 className="text-lg font-medium text-gray-900 mb-2">Area Data</h3>
              <p className="text-gray-500">Suitable areas will be loaded from the backend API</p>
            </div>
          </div>
        );
      case 'climate':
        return (
          <div className="bg-white rounded-lg border border-gray-200 p-6">
            <h3 className="text-lg font-semibold text-gray-900 mb-4">Climate Type</h3>
            <div className="text-center py-12">
              <div className="text-gray-400 text-6xl mb-4">🌤️</div>
              <h3 className="text-lg font-medium text-gray-900 mb-2">Climate Data</h3>
              <p className="text-gray-500">Climate information will be loaded from the backend API</p>
            </div>
          </div>
        );
      default:
        return (
          <div className="bg-white rounded-lg border border-gray-200 p-6">
            <h3 className="text-lg font-semibold text-gray-900 mb-4">Dashboard</h3>
            <div className="text-center py-12">
              <div className="text-gray-400 text-6xl mb-4">📈</div>
              <h3 className="text-lg font-medium text-gray-900 mb-2">Dashboard Data</h3>
              <p className="text-gray-500">Dashboard insights will be loaded from the backend API</p>
            </div>
          </div>
        );
    }
  };

  return (
    <div className="p-8">
      <div className="flex items-center justify-between mb-6">
        <h2 className="text-2xl font-bold text-gray-800">Dashboard</h2>
        <div className="flex items-center gap-4">
          <select 
            value={selectedCrop}
            onChange={(e) => setSelectedCrop(e.target.value)}
            className="border border-gray-300 rounded-lg px-4 py-2"
          >
            <option value="Maize">Maize</option>
            <option value="Rice">Rice</option>
            <option value="Beans">Beans</option>
          </select>
        </div>
      </div>

      {/* Navigation */}
      <div className="flex gap-2 mb-6 overflow-x-auto">
        {navigationButtons.map((button) => {
          const IconComponent = button.icon;
          return (
            <button 
              key={button.key}
              onClick={() => setActiveSection(button.key as ActiveSection)}
              className={`flex items-center gap-2 px-4 py-2 rounded-lg whitespace-nowrap transition-colors ${
                activeSection === button.key
                  ? 'bg-emerald-500 text-white' 
                  : 'border border-gray-300 hover:bg-gray-50'
              }`}
            >
              <IconComponent size={16} />
              {button.label}
            </button>
          );
        })}
      </div>

      {/* Active Section */}
      {renderActiveSection()}
    </div>
  );
};

export default Dashboard;