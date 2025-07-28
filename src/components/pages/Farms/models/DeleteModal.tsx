import React from 'react';
import type { Farm } from '../../../../types/farm';

interface DeleteModalProps {
  isOpen: boolean;
  farm: Farm | null;
  onClose: () => void;
  onConfirm: () => void;
}

const DeleteModal: React.FC<DeleteModalProps> = ({ 
  isOpen, 
  farm, 
  onClose, 
  onConfirm 
}) => {
  if (!isOpen || !farm) return null;

  return (
    <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
      <div className="bg-white rounded-lg w-96 p-6">
        <h3 className="text-lg font-semibold mb-2">Delete Farm</h3>
        <p className="text-gray-600 mb-6">
          Are you sure you want to delete {farm.name}? This action cannot be undone.
        </p>
        <div className="flex justify-end gap-3">
          <button
            onClick={onClose}
            className="px-4 py-2 border border-gray-300 rounded-lg hover:bg-gray-50"
          >
            Cancel
          </button>
          <button
            onClick={onConfirm}
            className="px-4 py-2 bg-red-500 text-white rounded-lg hover:bg-red-600"
          >
            Delete
          </button>
        </div>
      </div>
    </div>
  );
};

export default DeleteModal;