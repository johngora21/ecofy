import React from 'react';
import { BookOpen, User, Star, Calendar } from 'lucide-react';

interface BooksSectionProps {
  searchTerm: string;
  selectedProduct: string;
}

const BooksSection: React.FC<BooksSectionProps> = ({ searchTerm, selectedProduct }) => {
  return (
    <div className="flex items-center justify-center py-16">
      <div className="text-center">
        <div className="text-gray-400 text-6xl mb-4">📖</div>
        <h3 className="text-lg font-medium text-gray-900 mb-2">No books available</h3>
        <p className="text-gray-500">Book data will be loaded from the backend API</p>
      </div>
    </div>
  );
};

export default BooksSection;
interface Book {
  id: number;
  title: string;
  description: string;
  author: string;
  category: 'Maize' | 'Rice' | 'Cattle' | 'General';
  pages: number;
  image: string;
  downloadUrl?: string;
}

const books: Book[] = [
  {
    id: 1,
    title: 'Complete Guide to Maize Farming',
    description: 'Comprehensive guide covering all aspects of maize cultivation, from soil preparation to harvesting.',
    author: 'Dr. John Mwangi',
    category: 'Maize',
    pages: 285,
    image: 'https://images.unsplash.com/photo-1481627834876-b7833e8f5570?w=400&h=250&fit=crop',
    downloadUrl: '#'
  },
  {
    id: 2,
    title: 'Rice Cultivation in East Africa',
    description: 'Expert insights into rice production techniques adapted for East African climate and conditions.',
    author: 'Prof. Sarah Kimani',
    category: 'Rice',
    pages: 342,
    image: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400&h=250&fit=crop',
    downloadUrl: '#'
  },
  {
    id: 3,
    title: 'Livestock Management Handbook',
    description: 'Essential guide for modern livestock farming practices, health management, and productivity optimization.',
    author: 'Dr. Michael Banda',
    category: 'Cattle',
    pages: 198,
    image: 'https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c?w=400&h=250&fit=crop',
    downloadUrl: '#'
  },
  {
    id: 4,
    title: 'Sustainable Agriculture Practices',
    description: 'Comprehensive guide to sustainable farming methods that protect the environment while maintaining productivity.',
    author: 'Dr. Grace Mwema',
    category: 'General',
    pages: 267,
    image: 'https://images.unsplash.com/photo-1524995997946-a1c2e315a42f?w=400&h=250&fit=crop',
    downloadUrl: '#'
  },
  {
    id: 5,
    title: 'Modern Maize Varieties and Genetics',
    description: 'Advanced guide to maize genetics, hybrid varieties, and breeding techniques for improved yields.',
    author: 'Prof. Daniel Ochieng',
    category: 'Maize',
    pages: 156,
    image: 'https://images.unsplash.com/photo-1592496431122-2349e0fbc666?w=400&h=250&fit=crop',
    downloadUrl: '#'
  },
  {
    id: 6,
    title: 'Integrated Pest Management for Rice',
    description: 'Comprehensive approach to managing rice pests using integrated methods for sustainable production.',
    author: 'Dr. Mary Wanjiku',
    category: 'Rice',
    pages: 189,
    image: 'https://images.unsplash.com/photo-1481627834876-b7833e8f5570?w=400&h=250&fit=crop',
    downloadUrl: '#'
  },
  {
    id: 7,
    title: 'Cattle Nutrition and Feed Management',
    description: 'Detailed guide to cattle nutrition, feed formulation, and feeding strategies for optimal health and production.',
    author: 'Prof. James Mutua',
    category: 'Cattle',
    pages: 234,
    image: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400&h=250&fit=crop',
    downloadUrl: '#'
  },
  {
    id: 8,
    title: 'Climate-Smart Agriculture',
    description: 'Strategies for adapting agricultural practices to climate change while maintaining food security.',
    author: 'Dr. Patricia Njoroge',
    category: 'General',
    pages: 298,
    image: 'https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c?w=400&h=250&fit=crop',
    downloadUrl: '#'
  }
];

interface BooksSectionProps {
  searchTerm: string;
  selectedProduct: string;
}

const BooksSection: React.FC<BooksSectionProps> = ({ searchTerm, selectedProduct }) => {

  const filteredBooks = books.filter((book) => {
    const matchesSearch = book.title.toLowerCase().includes(searchTerm.toLowerCase()) ||
                         book.description.toLowerCase().includes(searchTerm.toLowerCase()) ||
                         book.author.toLowerCase().includes(searchTerm.toLowerCase());
    const matchesProduct = selectedProduct === 'All Products' || 
                          book.category === selectedProduct || 
                          book.category === 'General';
    return matchesSearch && matchesProduct;
  });

  const getCategoryColor = (category: string) => {
    switch (category) {
      case 'Maize':
        return 'bg-yellow-100 text-yellow-800';
      case 'Rice':
        return 'bg-green-100 text-green-800';
      case 'Cattle':
        return 'bg-blue-100 text-blue-800';
      case 'General':
        return 'bg-gray-100 text-gray-800';
      default:
        return 'bg-gray-100 text-gray-800';
    }
  };

  return (
    <div className="w-full">
      {/* Books Grid */}

      {/* Books Grid */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
        {filteredBooks.map((book) => (
          <div key={book.id} className="bg-white rounded-lg shadow-md overflow-hidden hover:shadow-lg transition-shadow">
            {/* Book Image */}
            <div className="relative h-48 bg-gray-200">
              <img
                src={book.image}
                alt={book.title}
                className="w-full h-full object-cover"
                onError={(e) => {
                  e.currentTarget.src = 'data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iNDAwIiBoZWlnaHQ9IjI1MCIgdmlld0JveD0iMCAwIDQwMCAyNTAiIGZpbGw9Im5vbmUiIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyI+CjxyZWN0IHdpZHRoPSI0MDAiIGhlaWdodD0iMjUwIiBmaWxsPSIjRjNGNEY2Ii8+CjxwYXRoIGQ9Ik0xNzUgMTAwSDE4NUwyMDAgMTI1SDE4NUwxNzUgMTAwWk0yMTUgMTAwSDIyNUwyMTAgMTI1SDIyNUwyMTUgMTAwWiIgZmlsbD0iIzlDQTNBRiIvPgo8L3N2Zz4K';
                }}
              />
              <div className="absolute top-2 right-2">
                <BookOpen className="w-6 h-6 text-white bg-black bg-opacity-50 rounded p-1" />
              </div>
            </div>

            {/* Book Content */}
            <div className="p-4">
              <div className="flex items-start justify-between mb-2">
                <span className={`px-2 py-1 rounded-full text-xs font-medium ${getCategoryColor(book.category)}`}>
                  {book.category}
                </span>
                <span className="text-sm text-gray-500">{book.pages} pages</span>
              </div>
              
              <h3 className="font-bold text-lg text-gray-900 mb-2 line-clamp-2">
                {book.title}
              </h3>
              
              <p className="text-gray-600 text-sm mb-3 line-clamp-2">
                {book.description}
              </p>
              
              <p className="text-sm text-gray-500 mb-4">
                by {book.author}
              </p>

              {/* Download Button */}
              <button className="w-full bg-green-500 hover:bg-green-600 text-white py-2 px-4 rounded-lg flex items-center justify-center gap-2 transition-colors">
                <Download className="w-4 h-4" />
                Download
              </button>
            </div>
          </div>
        ))}
      </div>

      {/* No Results */}
      {filteredBooks.length === 0 && (
        <div className="text-center py-12">
          <BookOpen className="w-16 h-16 text-gray-300 mx-auto mb-4" />
          <h3 className="text-lg font-medium text-gray-900 mb-2">No books found</h3>
          <p className="text-gray-500">Try adjusting your search terms or filters.</p>
        </div>
      )}

    </div>
  );
};

export default BooksSection;
          </div>
        ))}
      </div>

      {/* No Results */}
      {filteredBooks.length === 0 && (
        <div className="text-center py-12">
          <BookOpen className="w-16 h-16 text-gray-300 mx-auto mb-4" />
          <h3 className="text-lg font-medium text-gray-900 mb-2">No books found</h3>
          <p className="text-gray-500">Try adjusting your search terms or filters.</p>
        </div>
      )}

    </div>
  );
};

export default BooksSection;