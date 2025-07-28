import React from 'react';
import { Calendar, MapPin, Users, Clock } from 'lucide-react';

interface EventsSectionProps {
  searchTerm: string;
  selectedProduct: string;
}

const EventsSection: React.FC<EventsSectionProps> = ({ searchTerm, selectedProduct }) => {
  return (
    <div className="flex items-center justify-center py-16">
      <div className="text-center">
        <div className="text-gray-400 text-6xl mb-4">📅</div>
        <h3 className="text-lg font-medium text-gray-900 mb-2">No events available</h3>
        <p className="text-gray-500">Event data will be loaded from the backend API</p>
      </div>
    </div>
  );
};

export default EventsSection;
const events: Event[] = [
  {
    id: 1,
    title: 'Tanzania Agricultural Fair',
    description: 'Annual agricultural fair showcasing the latest farming technologies and practices.',
    date: 'June 15, 2025',
    location: 'Morogoro',
    type: 'Fair',
    image: 'https://images.unsplash.com/photo-1540575467063-178a50c2df87?w=400&h=200&fit=crop'
  },
  {
    id: 2,
    title: 'Sustainable Farming Workshop',
    description: 'Hands-on workshop focusing on sustainable farming practices for small-scale farmers.',
    date: 'July 10, 2025',
    location: 'Arusha',
    type: 'Workshop',
    image: 'https://images.unsplash.com/photo-1559827260-dc66d52bef19?w=400&h=200&fit=crop'
  },
  {
    id: 3,
    title: 'Livestock Management Seminar',
    description: 'Expert-led seminar on modern livestock management techniques.',
    date: 'July 20, 2025',
    location: 'Dodoma',
    type: 'Seminar',
    image: 'https://images.unsplash.com/photo-1548550023-2bdb3c5beed7?w=400&h=200&fit=crop'
  },
  {
    id: 4,
    title: 'Climate-Smart Agriculture Conference',
    description: 'International conference on climate adaptation strategies for agriculture.',
    date: 'August 5, 2025',
    location: 'Dar es Salaam',
    type: 'Conference',
    image: 'https://images.unsplash.com/photo-1552664730-d307ca884978?w=400&h=200&fit=crop'
  },
  {
    id: 5,
    title: 'Rice Production Workshop',
    description: 'Specialized workshop on improving rice production yields and quality.',
    date: 'August 18, 2025',
    location: 'Mwanza',
    type: 'Workshop',
    image: 'https://images.unsplash.com/photo-1586771107445-d3ca888129ff?w=400&h=200&fit=crop'
  },
  {
    id: 6,
    title: 'Agricultural Technology Fair',
    description: 'Showcase of the latest agricultural technologies and equipment.',
    date: 'September 2, 2025',
    location: 'Mbeya',
    type: 'Fair',
    image: 'https://images.unsplash.com/photo-1625246333195-78d9c38ad449?w=400&h=200&fit=crop'
  }
];

const EventsSection: React.FC<EventsSectionProps> = ({ searchTerm }) => {
  const filteredEvents = events.filter((event) => {
    const matchesSearch = event.title.toLowerCase().includes(searchTerm.toLowerCase()) ||
                         event.description.toLowerCase().includes(searchTerm.toLowerCase()) ||
                         event.location.toLowerCase().includes(searchTerm.toLowerCase());
    return matchesSearch;
  });

  const getTypeColor = (type: string) => {
    switch (type) {
      case 'Fair':
        return 'bg-purple-100 text-purple-600';
      case 'Workshop':
        return 'bg-emerald-100 text-emerald-600';
      case 'Seminar':
        return 'bg-blue-100 text-blue-600';
      case 'Conference':
        return 'bg-orange-100 text-orange-600';
      default:
        return 'bg-gray-100 text-gray-600';
    }
  };

  return (
    <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
      {filteredEvents.map((event) => (
        <div key={event.id} className="bg-white rounded-lg shadow-sm overflow-hidden hover:shadow-md transition-shadow">
          <div 
            className="h-48 bg-cover bg-center relative group"
            style={{ backgroundImage: `url(${event.image})` }}
          >
            <button className="absolute top-4 right-4 w-10 h-10 bg-white bg-opacity-20 rounded-full flex items-center justify-center backdrop-blur-sm opacity-0 group-hover:opacity-100 transition-opacity">
              <Eye className="text-white" size={16} />
            </button>
          </div>
          <div className="p-4">
            <div className="flex items-center justify-between mb-2">
              <h3 className="font-semibold text-lg text-gray-800">{event.title}</h3>
              <span className={`px-2 py-1 rounded text-xs font-medium ${getTypeColor(event.type)}`}>
                {event.type}
              </span>
            </div>
            <p className="text-gray-600 text-sm mb-4 line-clamp-2">{event.description}</p>
            <div className="space-y-2 mb-4">
              <div className="flex items-center gap-2 text-sm text-gray-500">
                <Calendar size={16} />
                <span>{event.date}</span>
              </div>
              <div className="flex items-center gap-2 text-sm text-gray-500">
                <MapPin size={16} />
                <span>{event.location}</span>
              </div>
            </div>
            <button className="w-full bg-emerald-500 text-white py-2 rounded-lg hover:bg-emerald-600 transition-colors">
              Register
            </button>
          </div>
        </div>
      ))}
      
      {filteredEvents.length === 0 && (
        <div className="col-span-full text-center py-12">
          <p className="text-gray-500 text-lg">No events found matching your criteria.</p>
        </div>
      )}
    </div>
  );
};

export default EventsSection;
};

export default EventsSection;