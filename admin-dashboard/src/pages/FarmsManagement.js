import React, { useState } from 'react';
import MetricCard from '../components/MetricCard';
import ChartCard from '../components/ChartCard';
import { MapPin, Users, TrendingUp, Activity } from 'lucide-react';

const FarmsManagement = () => {
  const [searchTerm, setSearchTerm] = useState('');
  const [filterStatus, setFilterStatus] = useState('all');
  const [filterRegion, setFilterRegion] = useState('all');
  const [filterDistrict, setFilterDistrict] = useState('all');
  const [viewMode, setViewMode] = useState('table'); // 'table' or 'map'

  const regions = [
    'Arusha', 'Dar es Salaam', 'Dodoma', 'Geita', 'Iringa', 'Kagera', 
    'Katavi', 'Kigoma', 'Kilimanjaro', 'Lindi', 'Manyara', 'Mara', 
    'Mbeya', 'Morogoro', 'Mtwara', 'Mwanza', 'Njombe', 'Pemba North', 
    'Pemba South', 'Pwani', 'Rukwa', 'Ruvuma', 'Shinyanga', 'Simiyu', 
    'Singida', 'Songwe', 'Tabora', 'Tanga', 'Unguja North', 'Unguja South'
  ];

  const districts = {
    'Arusha': ['Arusha City', 'Arusha District', 'Karatu', 'Longido', 'Monduli', 'Ngorongoro'],
    'Dar es Salaam': ['Ilala', 'Kinondoni', 'Temeke', 'Ubungo', 'Kigamboni'],
    'Kilimanjaro': ['Hai', 'Moshi District', 'Moshi City', 'Mwanga', 'Rombo', 'Siha'],
    'Morogoro': ['Gairo', 'Kilombero', 'Kilosa', 'Malinyi', 'Morogoro District', 'Morogoro City', 'Mvomero', 'Ulanga']
  };

  const farms = [
    {
      id: 1,
      name: 'Green Valley Farm',
      farmer: 'John Doe',
      region: 'Arusha',
      district: 'Arusha District',
      location: 'Arusha',
      coordinates: { lat: -3.3731, lng: 36.6827 },
      size: '50 acres',
      status: 'Active',
      crops: ['Maize', 'Beans']
    },
    {
      id: 2,
      name: 'Sunrise Farm',
      farmer: 'Jane Smith',
      region: 'Kilimanjaro',
      district: 'Moshi District',
      location: 'Kilimanjaro',
      coordinates: { lat: -3.3434, lng: 37.3401 },
      size: '30 acres',
      status: 'Active',
      crops: ['Rice', 'Vegetables']
    },
    {
      id: 3,
      name: 'Mountain View Farm',
      farmer: 'Mike Johnson',
      region: 'Morogoro',
      district: 'Morogoro District',
      location: 'Morogoro',
      coordinates: { lat: -6.8235, lng: 37.6612 },
      size: '75 acres',
      status: 'Inactive',
      crops: ['Coffee', 'Tea']
    },
    {
      id: 4,
      name: 'Lake Farm',
      farmer: 'Sarah Wilson',
      region: 'Mwanza',
      district: 'Mwanza City',
      location: 'Mwanza',
      coordinates: { lat: -2.5167, lng: 32.9000 },
      size: '45 acres',
      status: 'Active',
      crops: ['Cassava', 'Sweet Potatoes']
    }
  ];

  const filteredFarms = farms.filter(farm => {
    const matchesSearch = farm.name.toLowerCase().includes(searchTerm.toLowerCase()) ||
                         farm.farmer.toLowerCase().includes(searchTerm.toLowerCase()) ||
                         farm.location.toLowerCase().includes(searchTerm.toLowerCase());
    const matchesStatus = filterStatus === 'all' || farm.status.toLowerCase() === filterStatus;
    const matchesRegion = filterRegion === 'all' || farm.region === filterRegion;
    const matchesDistrict = filterDistrict === 'all' || farm.district === filterDistrict;
    return matchesSearch && matchesStatus && matchesRegion && matchesDistrict;
  });

  const getAvailableDistricts = () => {
    if (filterRegion === 'all') return [];
    return districts[filterRegion] || [];
  };

  return (
    <div className="space-y-6">
      {/* Metrics */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
        <MetricCard
          title="Total Farms"
          value="1,234"
          change="+15%"
          changeType="positive"
          icon={MapPin}
        />
        <MetricCard
          title="Active Farms"
          value="1,156"
          change="+8%"
          changeType="positive"
          icon={Activity}
        />
        <MetricCard
          title="Farmers"
          value="987"
          change="+12%"
          changeType="positive"
          icon={Users}
        />
        <MetricCard
          title="Growth Rate"
          value="23%"
          change="+5%"
          changeType="positive"
          icon={TrendingUp}
        />
      </div>

      {/* View Mode Toggle */}
      <div className="flex justify-between items-center">
        <div className="flex space-x-2">
          <button
            onClick={() => setViewMode('table')}
            className={`px-4 py-2 rounded-md text-sm font-medium ${
              viewMode === 'table'
                ? 'bg-green-600 text-white'
                : 'bg-gray-200 text-gray-700 hover:bg-gray-300'
            }`}
          >
            Table View
          </button>
          <button
            onClick={() => setViewMode('map')}
            className={`px-4 py-2 rounded-md text-sm font-medium ${
              viewMode === 'map'
                ? 'bg-green-600 text-white'
                : 'bg-gray-200 text-gray-700 hover:bg-gray-300'
            }`}
          >
            Map View
          </button>
        </div>
      </div>

      {/* Filters */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-5 gap-4">
        <div>
          <input
            type="text"
            placeholder="Search farms..."
            value={searchTerm}
            onChange={(e) => setSearchTerm(e.target.value)}
            className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-green-500"
          />
        </div>
        <select
          value={filterStatus}
          onChange={(e) => setFilterStatus(e.target.value)}
          className="px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-green-500"
        >
          <option value="all">All Status</option>
          <option value="active">Active</option>
          <option value="inactive">Inactive</option>
        </select>
        <select
          value={filterRegion}
          onChange={(e) => {
            setFilterRegion(e.target.value);
            setFilterDistrict('all'); // Reset district when region changes
          }}
          className="px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-green-500"
        >
          <option value="all">All Regions</option>
          {regions.map(region => (
            <option key={region} value={region}>{region}</option>
          ))}
        </select>
        <select
          value={filterDistrict}
          onChange={(e) => setFilterDistrict(e.target.value)}
          className="px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-green-500"
          disabled={filterRegion === 'all'}
        >
          <option value="all">All Districts</option>
          {getAvailableDistricts().map(district => (
            <option key={district} value={district}>{district}</option>
          ))}
        </select>
      </div>

      {/* Content */}
      {viewMode === 'table' ? (
        <ChartCard title="Farm Management">
          <div className="overflow-x-auto">
            <table className="min-w-full divide-y divide-gray-200">
              <thead className="bg-gray-50">
                <tr>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Farm Name</th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Farmer</th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Region</th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">District</th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Size</th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Status</th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Actions</th>
                </tr>
              </thead>
              <tbody className="bg-white divide-y divide-gray-200">
                {filteredFarms.map((farm) => (
                  <tr key={farm.id} className="hover:bg-gray-50">
                    <td className="px-6 py-4 whitespace-nowrap">
                      <div className="text-sm font-medium text-gray-900">{farm.name}</div>
                      <div className="text-sm text-gray-500">{farm.crops.join(', ')}</div>
                    </td>
                    <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-900">{farm.farmer}</td>
                    <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-900">{farm.region}</td>
                    <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-900">{farm.district}</td>
                    <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-900">{farm.size}</td>
                    <td className="px-6 py-4 whitespace-nowrap">
                      <span className={`inline-flex px-2 py-1 text-xs font-semibold rounded-full ${
                        farm.status === 'Active' 
                          ? 'bg-green-100 text-green-800' 
                          : 'bg-red-100 text-red-800'
                      }`}>
                        {farm.status}
                      </span>
                    </td>
                    <td className="px-6 py-4 whitespace-nowrap text-sm font-medium">
                      <button className="text-green-600 hover:text-green-900 mr-3">Edit</button>
                      <button className="text-red-600 hover:text-red-900">Delete</button>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </ChartCard>
      ) : (
        <ChartCard title="Farm Locations">
          <div className="h-96 bg-gray-100 rounded-lg flex items-center justify-center">
            <div className="text-center">
              <MapPin className="w-12 h-12 text-gray-400 mx-auto mb-4" />
              <h3 className="text-lg font-medium text-gray-900 mb-2">Farm Locations Map</h3>
              <p className="text-gray-500 mb-4">Interactive map showing farm locations across Tanzania</p>
              <div className="space-y-2">
                {filteredFarms.map((farm) => (
                  <div key={farm.id} className="flex items-center justify-between p-3 bg-white rounded-lg shadow-sm">
                    <div>
                      <div className="font-medium text-gray-900">{farm.name}</div>
                      <div className="text-sm text-gray-500">{farm.farmer} • {farm.region}, {farm.district}</div>
                    </div>
                    <div className="flex items-center space-x-2">
                      <span className={`inline-flex px-2 py-1 text-xs font-semibold rounded-full ${
                        farm.status === 'Active' 
                          ? 'bg-green-100 text-green-800' 
                          : 'bg-red-100 text-red-800'
                      }`}>
                        {farm.status}
                      </span>
                      <button className="text-green-600 hover:text-green-900 text-sm">View</button>
                    </div>
                  </div>
                ))}
              </div>
            </div>
          </div>
        </ChartCard>
      )}
    </div>
  );
};

export default FarmsManagement; 