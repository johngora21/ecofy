import React from 'react';
import { ShoppingCart, MapPin } from 'lucide-react';
import type { MarketItem } from '../../../../types/marketplace';

interface ProductCardProps {
  item: MarketItem;
  onAddToCart: (item: MarketItem) => void;
}

const ProductCard: React.FC<ProductCardProps> = ({ item, onAddToCart }) => {
  const getCategoryColor = (category: string) => {
    const colors = {
      crops: 'bg-green-100 text-green-800',
      livestock: 'bg-blue-100 text-blue-800',
      poultry: 'bg-orange-100 text-orange-800',
      fisheries: 'bg-cyan-100 text-cyan-800',
      seeds: 'bg-purple-100 text-purple-800',
      fertilizers: 'bg-yellow-100 text-yellow-800',
      equipment: 'bg-gray-100 text-gray-800'
    };
    return colors[category as keyof typeof colors] || 'bg-gray-100 text-gray-800';
  };

  const getImagePlaceholder = (category: string) => {
    const placeholders = {
      crops: 'https://images.unsplash.com/photo-1574323347407-f5e1ad6d020b?w=400&h=300&fit=crop',
      livestock: 'https://images.unsplash.com/photo-1516467508483-a7212febe31a?w=400&h=300&fit=crop',
      poultry: 'https://images.unsplash.com/photo-1548550023-2bdb3c5beed7?w=400&h=300&fit=crop',
      fisheries: 'https://images.unsplash.com/photo-1544551763-46a013bb70d5?w=400&h=300&fit=crop',
      seeds: 'https://images.unsplash.com/photo-1416879595882-3373a0480b5b?w=400&h=300&fit=crop',
      fertilizers: 'https://images.unsplash.com/photo-1625246333195-78d9c38ad449?w=400&h=300&fit=crop',
      equipment: 'https://images.unsplash.com/photo-1581578731548-c64695cc6952?w=400&h=300&fit=crop'
    };
    return placeholders[category as keyof typeof placeholders] || placeholders.crops;
  };

  return (
    <div className="bg-white border border-gray-200 rounded-lg overflow-hidden hover:shadow-lg transition-shadow">
      <div className="relative">
        <img
          src={item.image || getImagePlaceholder(item.category)}
          alt={item.name}
          className="w-full h-48 object-cover"
        />
        <div className="absolute top-3 left-3">
          <span className={`px-2 py-1 text-xs font-medium rounded-full ${getCategoryColor(item.category)}`}>
            {item.category.charAt(0).toUpperCase() + item.category.slice(1)}
          </span>
        </div>
        <button
          onClick={() => onAddToCart(item)}
          className="absolute top-3 right-3 p-2 bg-white rounded-full shadow-md hover:bg-gray-50"
        >
          <ShoppingCart size={16} className="text-gray-600" />
        </button>
      </div>
      
      <div className="p-4">
        <h3 className="font-semibold text-lg text-gray-900 mb-2">{item.name}</h3>
        <p className="text-green-600 font-bold text-xl mb-2">
          {item.price.toLocaleString()} {item.unit}
        </p>
        <p className="text-gray-600 text-sm mb-3 line-clamp-2">{item.description}</p>
        
        <div className="flex items-center text-gray-500 text-sm mb-4">
          <MapPin size={14} className="mr-1" />
          {item.location}
        </div>
        
        <button
          onClick={() => onAddToCart(item)}
          className="w-full bg-green-500 hover:bg-green-600 text-white py-2 px-4 rounded-lg transition-colors"
        >
          Add to Cart
        </button>
      </div>
    </div>
  );
};

export default ProductCard;