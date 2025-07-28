import React from 'react';
import { Eye, Settings, Trash2 } from 'lucide-react';
import type { Farm } from '../../../types/farm';

interface FarmCardProps {
  farm: Farm;
  onView: (farm: Farm) => void;
  onEdit: (farm: Farm) => void;
  onDelete: (farm: Farm) => void;
}

const FarmCard: React.FC<FarmCardProps> = ({ farm, onView, onEdit, onDelete }) => {
  return (
    <div className="bg-white rounded-lg shadow-sm overflow-hidden hover:shadow-md transition-shadow">
      <div 
        className="h-48 bg-cover bg-center relative"
        style={{ backgroundImage: `url(${farm.image})` }}
      >
        <div className="absolute bottom-4 left-4 text-white">
          <h3 className="font-semibold text-lg">{farm.name}</h3>
          <p className="text-sm opacity-90">{farm.location}</p>
        </div>
      </div>
      <div className="p-4">
        <div className="flex items-center justify-between">
          <div>
            <div className="text-sm text-gray-500">Size</div>
            <div className="font-semibold">{farm.size}</div>
          </div>
          <div className="flex gap-2">
            <button 
              onClick={() => onView(farm)}
              className="p-2 text-emerald-500 hover:bg-emerald-50 rounded transition-colors"
              title="View farm details"
            >
              <Eye size={16} />
            </button>
            <button 
              onClick={() => onEdit(farm)}
              className="p-2 text-blue-500 hover:bg-blue-50 rounded transition-colors"
              title="Edit farm"
            >
              <Settings size={16} />
            </button>
            <button 
              onClick={() => onDelete(farm)}
              className="p-2 text-red-500 hover:bg-red-50 rounded transition-colors"
              title="Delete farm"
            >
              <Trash2 size={16} />
            </button>
          </div>
        </div>
      </div>
    </div>
  );
};

export default FarmCard;