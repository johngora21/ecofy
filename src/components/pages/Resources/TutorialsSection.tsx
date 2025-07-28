import React from 'react';
import { Play, Clock, Star, User } from 'lucide-react';

interface TutorialsSectionProps {
  searchTerm: string;
  selectedProduct: string;
}

const TutorialsSection: React.FC<TutorialsSectionProps> = ({ searchTerm, selectedProduct }) => {
  return (
    <div className="flex items-center justify-center py-16">
      <div className="text-center">
        <div className="text-gray-400 text-6xl mb-4">📚</div>
        <h3 className="text-lg font-medium text-gray-900 mb-2">No tutorials available</h3>
        <p className="text-gray-500">Tutorial data will be loaded from the backend API</p>
      </div>
    </div>
  );
};

export default TutorialsSection;
const tutorials: Tutorial[] = [
  {
    id: 1,
    title: 'Maize Pest Control',
    description: 'Learn how to identify and control common pests that affect maize crops in Tanzania.',
    duration: '10 min',
    category: 'Maize',
    image: 'https://images.unsplash.com/photo-1574323347407-f5e1ad6d020b?w=400&h=200&fit=crop'
  },
  {
    id: 2,
    title: 'Proper Rice Planting Techniques',
    description: 'Master the proper techniques for planting rice to maximize yield and minimize water usage.',
    duration: '15 min',
    category: 'Rice',
    image: 'https://images.unsplash.com/photo-1586771107445-d3ca888129ff?w=400&h=200&fit=crop'
  },
  {
    id: 3,
    title: 'Sustainable Cattle Farming',
    description: 'Learn sustainable practices for cattle farming that improve productivity while protecting the environment.',
    duration: '20 min',
    category: 'Cattle',
    image: 'https://images.unsplash.com/photo-1516467508483-a7212febe31a?w=400&h=200&fit=crop'
  },
  {
    id: 4,
    title: 'Soil Health Management',
    description: 'Understanding soil composition and implementing practices to maintain healthy soil.',
    duration: '12 min',
    category: 'Maize',
    image: 'https://images.unsplash.com/photo-1625246333195-78d9c38ad449?w=400&h=200&fit=crop'
  },
  {
    id: 5,
    title: 'Water Management for Rice',
    description: 'Efficient water management techniques for rice cultivation in varying climates.',
    duration: '18 min',
    category: 'Rice',
    image: 'https://images.unsplash.com/photo-1581833971358-2c8b550f87b3?w=400&h=200&fit=crop'
  },
  {
    id: 6,
    title: 'Cattle Nutrition and Feeding',
    description: 'Comprehensive guide to cattle nutrition, feed types, and feeding schedules.',
    duration: '25 min',
    category: 'Cattle',
    image: 'https://images.unsplash.com/photo-1550486322-e4e3fb9b3cdb?w=400&h=200&fit=crop'
  }
];

const TutorialsSection: React.FC<TutorialsSectionProps> = ({ searchTerm, selectedProduct }) => {
  const filteredTutorials = tutorials.filter((tutorial) => {
    const matchesSearch = tutorial.title.toLowerCase().includes(searchTerm.toLowerCase()) ||
                         tutorial.description.toLowerCase().includes(searchTerm.toLowerCase());
    const matchesProduct = selectedProduct === 'All Products' || tutorial.category === selectedProduct;
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
      {filteredTutorials.map((tutorial) => (
        <div key={tutorial.id} className="bg-white rounded-lg shadow-sm overflow-hidden hover:shadow-md transition-shadow">
          <div 
            className="h-48 bg-cover bg-center relative group"
            style={{ backgroundImage: `url(${tutorial.image})` }}
          >
            <button className="absolute inset-0 flex items-center justify-center bg-black bg-opacity-30 opacity-0 group-hover:opacity-100 transition-opacity">
              <div className="w-16 h-16 bg-white bg-opacity-20 rounded-full flex items-center justify-center backdrop-blur-sm">
                <Play className="text-white ml-1" size={24} />
              </div>
            </button>
          </div>
          <div className="p-4">
            <h3 className="font-semibold text-lg mb-2 text-gray-800">{tutorial.title}</h3>
            <p className="text-gray-600 text-sm mb-4 line-clamp-2">{tutorial.description}</p>
            <div className="flex items-center justify-between">
              <div className="flex items-center gap-2 text-sm text-gray-500">
                <span>⏱ {tutorial.duration}</span>
              </div>
              <span className={`px-2 py-1 rounded text-xs font-medium ${getCategoryColor(tutorial.category)}`}>
                {tutorial.category}
              </span>
            </div>
          </div>
        </div>
      ))}
      
      {filteredTutorials.length === 0 && (
        <div className="col-span-full text-center py-12">
          <p className="text-gray-500 text-lg">No tutorials found matching your criteria.</p>
        </div>
      )}
    </div>
  );
};

export default TutorialsSection;
  );
};

export default TutorialsSection;