import React, { useState } from 'react';
import { Search } from 'lucide-react';
import TutorialsSection from './TutorialsSection';
import EventsSection from './EventsSection';
import BusinessPlanSection from './BusinessPlanSection';
import BooksSection from './BooksSection';
import { resourcesTabs, productOptions, locationOptions, eventTypeOptions } from '../../../data/uiData';

type ResourceTab = 'tutorials' | 'events' | 'business-plan' | 'books';

const Resources: React.FC = () => {
  const [activeTab, setActiveTab] = useState<ResourceTab>('tutorials');
  const [searchTerm, setSearchTerm] = useState('');
  const [selectedProduct, setSelectedProduct] = useState('All Products');

  const renderActiveSection = () => {
    switch (activeTab) {
      case 'tutorials':
        return <TutorialsSection searchTerm={searchTerm} selectedProduct={selectedProduct} />;
      case 'events':
        return <EventsSection searchTerm={searchTerm} selectedProduct={selectedProduct} />;
      case 'business-plan':
        return <BusinessPlanSection searchTerm={searchTerm} selectedProduct={selectedProduct} />;
      case 'books':
        return <BooksSection searchTerm={searchTerm} selectedProduct={selectedProduct} />;
      default:
        return <TutorialsSection searchTerm={searchTerm} selectedProduct={selectedProduct} />;
    }
  };

  return (
    <div className="p-8">
      <h2 className="text-2xl font-bold text-gray-800 mb-6">Resources</h2>
      
      {/* Tab Navigation */}
      <div className="flex gap-4 mb-6">
        {resourcesTabs.map((tab) => (
          <button
            key={tab.id}
            onClick={() => setActiveTab(tab.id as ResourceTab)}
            className={`px-6 py-2 rounded-lg transition-colors ${
              activeTab === tab.id
                ? 'bg-emerald-500 text-white'
                : 'border border-gray-300 hover:bg-gray-50'
            }`}
          >
            {tab.label}
          </button>
        ))}
      </div>

      {/* Search and Filter Bar */}
      <div className="flex gap-4 mb-6">
        <div className="flex-1">
          <div className="relative">
            <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400" size={20} />
            <input
              type="text"
              placeholder="Search"
              value={searchTerm}
              onChange={(e) => setSearchTerm(e.target.value)}
              className="w-full pl-10 pr-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-emerald-500"
            />
          </div>
        </div>
        
        {(activeTab === 'tutorials' || activeTab === 'business-plan' || activeTab === 'books') && (
          <div>
            <select
              value={selectedProduct}
              onChange={(e) => setSelectedProduct(e.target.value)}
              className="border border-gray-300 rounded-lg px-4 py-2 focus:outline-none focus:ring-2 focus:ring-emerald-500"
            >
              {productOptions.map((product) => (
                <option key={product.value} value={product.value}>
                  {product.label}
                </option>
              ))}
            </select>
          </div>
        )}

        {activeTab === 'events' && (
          <>
            <div>
              <select className="border border-gray-300 rounded-lg px-4 py-2 focus:outline-none focus:ring-2 focus:ring-emerald-500">
                {locationOptions.map((location) => (
                  <option key={location.value} value={location.value}>
                    {location.label}
                  </option>
                ))}
              </select>
            </div>
            <div>
              <select className="border border-gray-300 rounded-lg px-4 py-2 focus:outline-none focus:ring-2 focus:ring-emerald-500">
                {eventTypeOptions.map((type) => (
                  <option key={type.value} value={type.value}>
                    {type.label}
                  </option>
                ))}
              </select>
            </div>
          </>
        )}
      </div>

      {/* Content */}
      {renderActiveSection()}
    </div>
  );
};

export default Resources;