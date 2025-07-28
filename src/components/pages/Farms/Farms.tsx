import React, { useState } from 'react';
import { Plus, Eye, Settings, Trash2 } from 'lucide-react';

interface Farm {
  id: number;
  name: string;
  location: string;
  size: string;
  image: string;
  crops: string[];
}

const Farms = () => {
  const [farms, setFarms] = useState<Farm[]>([]);
  const [showAddModal, setShowAddModal] = useState(false);

  const handleAddFarm = () => {
    setShowAddModal(true);
  };

  return (
    <div className="p-8">
      <div className="flex justify-between items-center mb-6">
        <h2 className="text-2xl font-bold text-gray-800">My Farms</h2>
        <button 
          onClick={handleAddFarm}
          className="flex items-center gap-2 bg-emerald-500 text-white px-4 py-2 rounded-lg hover:bg-emerald-600"
        >
          <Plus size={20} />
          Add Farm
        </button>
      </div>

      {farms.length === 0 ? (
        <div className="text-center py-12">
          <div className="text-gray-400 mb-4">
            <svg className="w-16 h-16 mx-auto" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-5m-9 0H3m2 0h5M9 7h1m-1 4h1m4-4h1m-1 4h1m-5 10v-5a1 1 0 011-1h2a1 1 0 011 1v5m-4 0h4" />
            </svg>
          </div>
          <h3 className="text-lg font-semibold text-gray-600 mb-2">No farms yet</h3>
          <p className="text-gray-500 mb-4">Start by adding your first farm to track your agricultural activities.</p>
          <button
            onClick={handleAddFarm}
            className="bg-emerald-500 text-white px-6 py-2 rounded-lg hover:bg-emerald-600"
          >
            Add Your First Farm
          </button>
        </div>
      ) : (
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
          {farms.map((farm) => (
            <div key={farm.id} className="bg-white rounded-lg shadow-sm border border-gray-200 overflow-hidden">
              <div className="h-48 bg-gray-200 relative">
                <img
                  src={farm.image}
                  alt={farm.name}
                  className="w-full h-full object-cover"
                />
                <div className="absolute top-2 right-2 flex gap-1">
                  <button className="p-1 bg-white rounded-full shadow-sm hover:bg-gray-50">
                    <Eye size={16} className="text-gray-600" />
                  </button>
                  <button className="p-1 bg-white rounded-full shadow-sm hover:bg-gray-50">
                    <Settings size={16} className="text-gray-600" />
                  </button>
                  <button className="p-1 bg-white rounded-full shadow-sm hover:bg-gray-50">
                    <Trash2 size={16} className="text-gray-600" />
                  </button>
                </div>
              </div>
              <div className="p-4">
                <h3 className="font-semibold text-lg mb-1">{farm.name}</h3>
                <p className="text-gray-600 text-sm mb-2">{farm.location}</p>
                <div className="flex justify-between items-center text-sm">
                  <span className="text-gray-500">{farm.size}</span>
                  <span className="text-emerald-600 font-medium">{farm.crops.length} crops</span>
                </div>
              </div>
            </div>
          ))}
        </div>
      )}
    </div>
  );
};

export default Farms;