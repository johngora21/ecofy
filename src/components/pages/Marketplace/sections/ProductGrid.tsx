import React from 'react';
import ProductCard from './ProductCard';
import type { MarketItem } from '../../../../types/marketplace';

interface ProductGridProps {
  items: MarketItem[];
  onAddToCart: (item: MarketItem) => void;
}

const ProductGrid: React.FC<ProductGridProps> = ({ items, onAddToCart }) => {
  if (items.length === 0) {
    return (
      <div className="flex items-center justify-center py-16">
        <div className="text-center">
          <div className="text-gray-400 text-6xl mb-4">📦</div>
          <h3 className="text-lg font-medium text-gray-900 mb-2">No products found</h3>
          <p className="text-gray-500">Try adjusting your filters or search terms</p>
        </div>
      </div>
    );
  }

  return (
    <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-6 p-6">
      {items.map((item) => (
        <ProductCard
          key={item.id}
          item={item}
          onAddToCart={onAddToCart}
        />
      ))}
    </div>
  );
};

export default ProductGrid;