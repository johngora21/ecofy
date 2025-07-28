import React from 'react';
import { X } from 'lucide-react';
import type { Farm } from '../../../../types/farm';

interface FormModalProps {
  isOpen: boolean;
  isEdit: boolean;
  formData: Partial<Farm>;
  onClose: () => void;
  onSave: () => void;
  onFormChange: (data: Partial<Farm>) => void;
}

const FormModal: React.FC<FormModalProps> = ({ 
  isOpen, 
  isEdit, 
  formData, 
  onClose, 
  onSave, 
  onFormChange 
}) => {
  if (!isOpen) return null;

  const addCrop = (crop: string) => {
    if (crop && !formData.crops?.includes(crop)) {
      onFormChange({
        ...formData,
        crops: [...(formData.crops || []), crop]
      });
    }
  };

  const removeCrop = (cropToRemove: string) => {
    onFormChange({
      ...formData,
      crops: formData.crops?.filter(crop => crop !== cropToRemove) || []
    });
  };

  const handleInputChange = (field: keyof Farm, value: unknown) => {
    onFormChange({ ...formData, [field]: value });
  };

  return (
    <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
      <div className="bg-white rounded-lg w-11/12 max-w-2xl max-h-[90vh] overflow-hidden">
        <div className="flex items-center justify-between p-6 border-b">
          <h2 className="text-xl font-bold">{isEdit ? 'Edit Farm' : 'Add New Farm'}</h2>
          <button onClick={onClose} className="p-2 hover:bg-gray-100 rounded">
            <X size={24} />
          </button>
        </div>
        
        <div className="p-6 overflow-y-auto max-h-96">
          <div className="space-y-4">
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-1">Farm Name</label>
              <input
                type="text"
                value={formData.name || ''}
                onChange={(e) => handleInputChange('name', e.target.value)}
                className="w-full p-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-emerald-500 focus:border-emerald-500"
                placeholder="Enter farm name"
              />
            </div>
            
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-1">Location</label>
              <input
                type="text"
                value={formData.location || ''}
                onChange={(e) => handleInputChange('location', e.target.value)}
                className="w-full p-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-emerald-500 focus:border-emerald-500"
                placeholder="Enter location"
              />
            </div>
            
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-1">Size (acres)</label>
              <input
                type="number"
                value={formData.sizeInAcres || ''}
                onChange={(e) => handleInputChange('sizeInAcres', parseFloat(e.target.value))}
                className="w-full p-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-emerald-500 focus:border-emerald-500"
                placeholder="Enter size in acres"
              />
            </div>
            
            <div className="grid grid-cols-2 gap-4">
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">Soil Moisture</label>
                <input
                  type="text"
                  value={formData.soilMoisture || ''}
                  onChange={(e) => handleInputChange('soilMoisture', e.target.value)}
                  className="w-full p-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-emerald-500 focus:border-emerald-500"
                  placeholder="e.g., 60%"
                />
              </div>
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">Organic Carbon</label>
                <input
                  type="text"
                  value={formData.organicCarbon || ''}
                  onChange={(e) => handleInputChange('organicCarbon', e.target.value)}
                  className="w-full p-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-emerald-500 focus:border-emerald-500"
                  placeholder="e.g., 2.5%"
                />
              </div>
            </div>
            
            <div className="grid grid-cols-2 gap-4">
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">Soil Texture</label>
                <select
                  value={formData.soilTexture || ''}
                  onChange={(e) => handleInputChange('soilTexture', e.target.value)}
                  className="w-full p-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-emerald-500 focus:border-emerald-500"
                >
                  <option value="">Select texture</option>
                  <option value="Sandy">Sandy</option>
                  <option value="Loamy">Loamy</option>
                  <option value="Clay">Clay</option>
                  <option value="Sandy Loam">Sandy Loam</option>
                  <option value="Clay Loam">Clay Loam</option>
                </select>
              </div>
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">Soil pH</label>
                <input
                  type="text"
                  value={formData.soilPH || ''}
                  onChange={(e) => handleInputChange('soilPH', e.target.value)}
                  className="w-full p-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-emerald-500 focus:border-emerald-500"
                  placeholder="e.g., 6.5"
                />
              </div>
            </div>
            
            <div className="grid grid-cols-2 gap-4">
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">Latitude</label>
                <input
                  type="text"
                  value={formData.latitude || ''}
                  onChange={(e) => handleInputChange('latitude', e.target.value)}
                  className="w-full p-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-emerald-500 focus:border-emerald-500"
                  placeholder="e.g., -6.8235"
                />
              </div>
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">Longitude</label>
                <input
                  type="text"
                  value={formData.longitude || ''}
                  onChange={(e) => handleInputChange('longitude', e.target.value)}
                  className="w-full p-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-emerald-500 focus:border-emerald-500"
                  placeholder="e.g., 37.6822"
                />
              </div>
            </div>
            
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-1">Topography</label>
              <input
                type="text"
                value={formData.topography || ''}
                onChange={(e) => handleInputChange('topography', e.target.value)}
                className="w-full p-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-emerald-500 focus:border-emerald-500"
                placeholder="e.g., Flat to gently undulating"
              />
            </div>
            
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-1">Crops</label>
              <div className="flex flex-wrap gap-2 mb-2">
                {formData.crops?.map((crop, index) => (
                  <span key={index} className="bg-emerald-100 text-emerald-800 px-3 py-1 rounded-full text-sm flex items-center gap-2">
                    {crop}
                    <button onClick={() => removeCrop(crop)} className="text-red-500 hover:text-red-700">
                      <X size={14} />
                    </button>
                  </span>
                ))}
              </div>
              <div className="flex gap-2">
                <input
                  type="text"
                  placeholder="Add crop"
                  className="flex-1 p-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-emerald-500 focus:border-emerald-500"
                  onKeyPress={(e) => {
                    if (e.key === 'Enter') {
                      addCrop(e.currentTarget.value);
                      e.currentTarget.value = '';
                    }
                  }}
                />
              </div>
            </div>
          </div>
        </div>
        
        <div className="flex justify-end gap-3 p-6 border-t">
          <button
            onClick={onClose}
            className="px-4 py-2 border border-gray-300 rounded-lg hover:bg-gray-50"
          >
            Cancel
          </button>
          <button
            onClick={onSave}
            className="px-4 py-2 bg-emerald-500 text-white rounded-lg hover:bg-emerald-600"
          >
            {isEdit ? 'Update Farm' : 'Add Farm'}
          </button>
        </div>
      </div>
    </div>
  );
};

export default FormModal;