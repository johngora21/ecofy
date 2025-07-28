import React from 'react';
import { Sparkles, FileText, Download, Star } from 'lucide-react';

interface BusinessPlanSectionProps {
  searchTerm: string;
  selectedProduct: string;
}

const BusinessPlanSection: React.FC<BusinessPlanSectionProps> = ({ searchTerm, selectedProduct }) => {
  return (
    <div className="flex items-center justify-center py-16">
      <div className="text-center">
        <div className="text-gray-400 text-6xl mb-4">📋</div>
        <h3 className="text-lg font-medium text-gray-900 mb-2">No business plans available</h3>
        <p className="text-gray-500">Business plan data will be loaded from the backend API</p>
      </div>
    </div>
  );
};

export default BusinessPlanSection;
const businessPlans: BusinessPlan[] = [
  {
    id: 1,
    title: 'Maize Farming Business Plan',
    description: 'Complete business plan for starting or expanding a maize farm in Tanzania.',
    category: 'Maize',
    isTemplateReady: true,
    image: 'https://images.unsplash.com/photo-1574323347407-f5e1ad6d020b?w=400&h=200&fit=crop'
  },
  {
    id: 2,
    title: 'Rice Production Plan',
    description: 'Detailed business plan for rice production with market analysis and financial projections.',
    category: 'Rice',
    isTemplateReady: true,
    image: 'https://images.unsplash.com/photo-1586771107445-d3ca888129ff?w=400&h=200&fit=crop'
  },
  {
    id: 3,
    title: 'Livestock Farming Proposal',
    description: 'Business plan for starting a cattle farming operation with financing options.',
    category: 'Cattle',
    isTemplateReady: true,
    image: 'https://images.unsplash.com/photo-1516467508483-a7212febe31a?w=400&h=200&fit=crop'
  },
  {
    id: 4,
    title: 'Integrated Farming System Plan',
    description: 'Comprehensive plan combining crop and livestock farming for maximum efficiency.',
    category: 'Maize',
    isTemplateReady: false,
    image: 'https://images.unsplash.com/photo-1625246333195-78d9c38ad449?w=400&h=200&fit=crop'
  },
  {
    id: 5,
    title: 'Organic Rice Farming Business',
    description: 'Specialized business plan for organic rice production and premium market targeting.',
    category: 'Rice',
    isTemplateReady: true,
    image: 'https://images.unsplash.com/photo-1581833971358-2c8b550f87b3?w=400&h=200&fit=crop'
  },
  {
    id: 6,
    title: 'Dairy Cattle Operation Plan',
    description: 'Focused business plan for dairy cattle farming with processing and distribution.',
    category: 'Cattle',
    isTemplateReady: false,
    image: 'https://images.unsplash.com/photo-1550486322-e4e3fb9b3cdb?w=400&h=200&fit=crop'
  }
];

const BusinessPlanSection: React.FC<BusinessPlanSectionProps> = ({ searchTerm, selectedProduct }) => {
  const filteredPlans = businessPlans.filter((plan) => {
    const matchesSearch = plan.title.toLowerCase().includes(searchTerm.toLowerCase()) ||
                         plan.description.toLowerCase().includes(searchTerm.toLowerCase());
    const matchesProduct = selectedProduct === 'All Products' || plan.category === selectedProduct;
    return matchesSearch && matchesProduct;
  });

  const getCategoryColor = (category: string) => {
    switch (category) {
      case 'Maize':
        return 'bg-emerald-100 text-emerald-600';
      case 'Rice':
        return 'bg-blue-100 text-blue-600';
      case 'Cattle':
        return 'bg-orange-100 text-orange-600';
      default:
        return 'bg-gray-100 text-gray-600';
    }
  };

  return (
    <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
      {filteredPlans.map((plan) => (
        <div key={plan.id} className="bg-white rounded-lg shadow-sm overflow-hidden hover:shadow-md transition-shadow">
          <div 
            className="h-48 bg-cover bg-center relative group"
            style={{ backgroundImage: `url(${plan.image})` }}
          >
            <button className="absolute top-4 right-4 w-10 h-10 bg-white bg-opacity-20 rounded-full flex items-center justify-center backdrop-blur-sm opacity-0 group-hover:opacity-100 transition-opacity">
              <Sparkles className="text-white" size={16} />
            </button>
          </div>
          <div className="p-4">
            <div className="flex items-center justify-between mb-2">
              <h3 className="font-semibold text-lg text-gray-800">{plan.title}</h3>
              <span className={`px-2 py-1 rounded text-xs font-medium ${getCategoryColor(plan.category)}`}>
                {plan.category}
              </span>
            </div>
            <p className="text-gray-600 text-sm mb-4 line-clamp-2">{plan.description}</p>
            
            {plan.isTemplateReady && (
              <div className="flex items-center gap-2 mb-4 text-sm text-gray-500">
                <FileText size={16} />
                <span>Template Ready</span>
              </div>
            )}
            
            <button className="w-full bg-emerald-500 text-white py-2 rounded-lg hover:bg-emerald-600 transition-colors">
              Generate Plan
            </button>
          </div>
        </div>
      ))}
      
      {filteredPlans.length === 0 && (
        <div className="col-span-full text-center py-12">
          <p className="text-gray-500 text-lg">No business plans found matching your criteria.</p>
        </div>
      )}
    </div>
  );
};

export default BusinessPlanSection;
  );
};

export default BusinessPlanSection;