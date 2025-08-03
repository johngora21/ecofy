import React, { useState, useEffect } from 'react';
import { MapPin, Target, TrendingUp, Users, BarChart3, Globe, Navigation, Compass } from 'lucide-react';
import { AreaChart, Area, XAxis, YAxis, CartesianGrid, ResponsiveContainer, ScatterChart, Scatter, BarChart, Bar, PieChart, Pie, Cell } from 'recharts';
import MetricCard from '../components/MetricCard';
import ChartCard from '../components/ChartCard';

const FieldCoverage = () => {
  const [coverage, setCoverage] = useState({});
  const [loading, setLoading] = useState(true);

  const regionalCoverage = [
    {
      region: 'Dodoma',
      totalArea: 41311, // km²
      coveredArea: 8262,
      coverage: 20.0,
      devices: 245,
      farmers: 1250,
      potential: 3500,
      priority: 'high'
    },
    {
      region: 'Mwanza',
      totalArea: 9467,
      coveredArea: 1893,
      coverage: 20.0,
      devices: 189,
      farmers: 890,
      potential: 2100,
      priority: 'medium'
    },
    {
      region: 'Arusha',
      totalArea: 34000,
      coveredArea: 5100,
      coverage: 15.0,
      devices: 156,
      farmers: 670,
      potential: 1800,
      priority: 'high'
    },
    {
      region: 'Iringa',
      totalArea: 35743,
      coveredArea: 3574,
      coverage: 10.0,
      devices: 134,
      farmers: 560,
      potential: 2200,
      priority: 'medium'
    },
    {
      region: 'Mbeya',
      totalArea: 60350,
      coveredArea: 6035,
      coverage: 10.0,
      devices: 167,
      farmers: 780,
      potential: 2800,
      priority: 'high'
    },
    {
      region: 'Kilimanjaro',
      totalArea: 13250,
      coveredArea: 663,
      coverage: 5.0,
      devices: 89,
      farmers: 340,
      potential: 1200,
      priority: 'low'
    }
  ];

  const expansionTargets = [
    { month: 'Feb', newDevices: 45, newArea: 890, farmers: 234 },
    { month: 'Mar', newDevices: 67, newArea: 1240, farmers: 345 },
    { month: 'Apr', newDevices: 89, newArea: 1560, farmers: 456 },
    { month: 'May', newDevices: 78, newArea: 1340, farmers: 389 },
    { month: 'Jun', newDevices: 92, newArea: 1780, farmers: 512 }
  ];

  const densityAnalysis = [
    { area: 'Urban Centers', density: 4.2, efficiency: 92, cost: 'Low' },
    { area: 'Peri-Urban', density: 2.8, efficiency: 87, cost: 'Medium' },
    { area: 'Rural Dense', density: 1.5, efficiency: 78, cost: 'Medium' },
    { area: 'Rural Sparse', density: 0.6, efficiency: 65, cost: 'High' },
    { area: 'Remote Areas', density: 0.2, efficiency: 45, cost: 'Very High' }
  ];

  const priorityMapping = [
    { priority: 'High Priority', regions: 3, area: 135654, farmers: 2700, color: '#ef4444' },
    { priority: 'Medium Priority', regions: 2, area: 45817, farmers: 1450, color: '#f59e0b' },
    { priority: 'Low Priority', regions: 1, area: 13250, farmers: 340, color: '#22c55e' }
  ];

  useEffect(() => {
    setTimeout(() => {
      setCoverage({
        totalCoverage: 16.2,
        activeRegions: 6,
        plannedExpansion: 25.4,
        targetFarmers: 8990
      });
      setLoading(false);
    }, 1000);
  }, []);

  const getPriorityColor = (priority) => {
    switch (priority) {
      case 'high': return 'bg-red-100 text-red-600 border-red-200';
      case 'medium': return 'bg-yellow-100 text-yellow-600 border-yellow-200';
      case 'low': return 'bg-green-100 text-green-600 border-green-200';
      default: return 'bg-gray-100 text-gray-600 border-gray-200';
    }
  };

  const getDensityColor = (density) => {
    if (density > 3) return 'text-green-600';
    if (density > 1.5) return 'text-yellow-600';
    return 'text-red-600';
  };

  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <h1 className="text-3xl font-bold text-textPrimary">Field Coverage</h1>
        <div className="flex space-x-3">
          <button className="btn-secondary flex items-center space-x-2">
            <Globe className="w-4 h-4" />
            <span>Coverage Map</span>
          </button>
          <button className="btn-primary flex items-center space-x-2">
            <Target className="w-4 h-4" />
            <span>Plan Expansion</span>
          </button>
        </div>
      </div>

      {/* Coverage Overview */}
      <div className="grid grid-cols-1 md:grid-cols-4 gap-6">
        <MetricCard
          title="Total Coverage"
          value="16.2%"
          change="25,027 km² covered"
          icon={Globe}
          color="primary"
          trend="positive"
        />
        <MetricCard
          title="Active Regions"
          value="6"
          change="26 regions total"
          icon={MapPin}
          color="success"
          trend="positive"
        />
        <MetricCard
          title="Farmers Reached"
          value="4,490"
          change="8,990 target"
          icon={Users}
          color="info"
          trend="positive"
        />
        <MetricCard
          title="Expansion Rate"
          value="+4.8%"
          change="This quarter"
          icon={TrendingUp}
          color="secondary"
          trend="positive"
        />
      </div>

      {/* Regional Coverage Analysis */}
      <ChartCard title="Regional Coverage Analysis" description="Geographic coverage and expansion opportunities by region">
        <div className="space-y-4">
          {regionalCoverage.map((region, index) => (
            <div key={index} className="flex items-center justify-between p-4 bg-white border border-gray-200 rounded-lg hover:shadow-md transition-shadow">
              <div className="flex items-center space-x-4">
                <div className="w-12 h-12 rounded-lg bg-gradient-to-r from-green-400 to-blue-500 flex items-center justify-center">
                  <MapPin className="w-6 h-6 text-white" />
                </div>
                <div>
                  <h3 className="font-semibold text-textPrimary">{region.region}</h3>
                  <p className="text-sm text-textSecondary">
                    {region.coveredArea.toLocaleString()} km² of {region.totalArea.toLocaleString()} km²
                  </p>
                  <div className={`inline-flex items-center px-2 py-1 rounded-full text-xs border ${getPriorityColor(region.priority)} mt-1`}>
                    {region.priority} priority
                  </div>
                </div>
              </div>

              <div className="flex items-center space-x-6">
                <div className="text-center">
                  <p className="text-lg font-semibold text-primary">{region.coverage}%</p>
                  <p className="text-xs text-textSecondary">Coverage</p>
                </div>
                <div className="text-center">
                  <p className="text-lg font-semibold text-success">{region.devices}</p>
                  <p className="text-xs text-textSecondary">Devices</p>
                </div>
                <div className="text-center">
                  <p className="text-lg font-semibold text-blue-600">{region.farmers}</p>
                  <p className="text-xs text-textSecondary">Farmers</p>
                </div>
                <div className="text-center">
                  <p className="text-lg font-semibold text-purple-600">{region.potential}</p>
                  <p className="text-xs text-textSecondary">Potential</p>
                </div>
              </div>

              <div className="flex space-x-2">
                <button className="btn-secondary btn-sm">View Map</button>
                <button className="btn-primary btn-sm">Expand</button>
              </div>
            </div>
          ))}
        </div>
      </ChartCard>

      {/* Expansion Planning */}
      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
        <ChartCard title="Expansion Timeline" description="Planned deployment schedule and targets">
          <ResponsiveContainer width="100%" height={250}>
            <AreaChart data={expansionTargets}>
              <CartesianGrid strokeDasharray="3 3" />
              <XAxis dataKey="month" />
              <YAxis />
              <Area type="monotone" dataKey="newDevices" stackId="1" stroke="#22c55e" fill="#22c55e" fillOpacity={0.6} />
              <Area type="monotone" dataKey="farmers" stackId="2" stroke="#3b82f6" fill="#3b82f6" fillOpacity={0.6} />
            </AreaChart>
          </ResponsiveContainer>
        </ChartCard>

        <ChartCard title="Priority Distribution" description="Expansion priorities by region and potential">
          <ResponsiveContainer width="100%" height={250}>
            <PieChart>
              <Pie
                data={priorityMapping}
                cx="50%"
                cy="50%"
                innerRadius={60}
                outerRadius={100}
                dataKey="farmers"
              >
                {priorityMapping.map((entry, index) => (
                  <Cell key={`cell-${index}`} fill={entry.color} />
                ))}
              </Pie>
            </PieChart>
          </ResponsiveContainer>
          <div className="mt-4 space-y-2">
            {priorityMapping.map((item, index) => (
              <div key={index} className="flex items-center justify-between">
                <div className="flex items-center space-x-2">
                  <div className="w-3 h-3 rounded-full" style={{ backgroundColor: item.color }}></div>
                  <span className="text-xs text-gray-600">{item.priority}</span>
                </div>
                <span className="text-xs font-medium">{item.farmers} farmers</span>
              </div>
            ))}
          </div>
        </ChartCard>
      </div>

      {/* Density Analysis */}
      <ChartCard title="Coverage Density Analysis" description="Device density and efficiency across different area types">
        <div className="space-y-4">
          {densityAnalysis.map((area, index) => (
            <div key={index} className="flex items-center justify-between p-4 bg-white border border-gray-200 rounded-lg">
              <div className="flex items-center space-x-4">
                <div className="w-10 h-10 rounded-full bg-blue-100 flex items-center justify-center">
                  <Navigation className="w-5 h-5 text-blue-600" />
                </div>
                <div>
                  <h4 className="font-medium text-textPrimary">{area.area}</h4>
                  <p className="text-sm text-textSecondary">Coverage Type</p>
                </div>
              </div>

              <div className="flex items-center space-x-8">
                <div className="text-center">
                  <p className={`text-lg font-semibold ${getDensityColor(area.density)}`}>
                    {area.density}
                  </p>
                  <p className="text-xs text-textSecondary">Devices/km²</p>
                </div>
                <div className="text-center">
                  <p className="text-lg font-semibold text-success">{area.efficiency}%</p>
                  <p className="text-xs text-textSecondary">Efficiency</p>
                </div>
                <div className="text-center">
                  <p className={`text-sm font-medium px-2 py-1 rounded ${
                    area.cost === 'Low' ? 'bg-green-100 text-green-600' :
                    area.cost === 'Medium' ? 'bg-yellow-100 text-yellow-600' :
                    area.cost === 'High' ? 'bg-orange-100 text-orange-600' :
                    'bg-red-100 text-red-600'
                  }`}>
                    {area.cost}
                  </p>
                  <p className="text-xs text-textSecondary">Cost</p>
                </div>
              </div>
            </div>
          ))}
        </div>
      </ChartCard>

      {/* Coverage Statistics */}
      <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
        <div className="bg-white p-6 rounded-lg border border-gray-200">
          <div className="flex items-center justify-between mb-4">
            <h3 className="font-semibold text-textPrimary">Coverage Goals</h3>
            <Target className="w-5 h-5 text-green-500" />
          </div>
          <div className="space-y-3">
            <div className="flex justify-between items-center">
              <span className="text-sm text-textSecondary">2025 Target</span>
              <span className="text-sm font-medium text-green-600">35% coverage</span>
            </div>
            <div className="flex justify-between items-center">
              <span className="text-sm text-textSecondary">Current Progress</span>
              <span className="text-sm font-medium text-blue-600">16.2% coverage</span>
            </div>
            <div className="flex justify-between items-center">
              <span className="text-sm text-textSecondary">Remaining</span>
              <span className="text-sm font-medium text-yellow-600">18.8% to go</span>
            </div>
          </div>
        </div>

        <div className="bg-white p-6 rounded-lg border border-gray-200">
          <div className="flex items-center justify-between mb-4">
            <h3 className="font-semibold text-textPrimary">Expansion Costs</h3>
            <BarChart3 className="w-5 h-5 text-blue-500" />
          </div>
          <div className="space-y-3">
            <div className="flex justify-between items-center">
              <span className="text-sm text-textSecondary">Infrastructure</span>
              <span className="text-sm font-medium text-blue-600">TSh 45M</span>
            </div>
            <div className="flex justify-between items-center">
              <span className="text-sm text-textSecondary">Training & Setup</span>
              <span className="text-sm font-medium text-yellow-600">TSh 12M</span>
            </div>
            <div className="flex justify-between items-center">
              <span className="text-sm text-textSecondary">Total Investment</span>
              <span className="text-sm font-medium text-purple-600">TSh 57M</span>
            </div>
          </div>
        </div>

        <div className="bg-white p-6 rounded-lg border border-gray-200">
          <div className="flex items-center justify-between mb-4">
            <h3 className="font-semibold text-textPrimary">Impact Metrics</h3>
            <Users className="w-5 h-5 text-purple-500" />
          </div>
          <div className="space-y-3">
            <div className="flex justify-between items-center">
              <span className="text-sm text-textSecondary">Farmers Served</span>
              <span className="text-sm font-medium text-green-600">4,490</span>
            </div>
            <div className="flex justify-between items-center">
              <span className="text-sm text-textSecondary">Areas Monitored</span>
              <span className="text-sm font-medium text-blue-600">25,027 km²</span>
            </div>
            <div className="flex justify-between items-center">
              <span className="text-sm text-textSecondary">Data Points/Day</span>
              <span className="text-sm font-medium text-purple-600">12,580</span>
            </div>
          </div>
        </div>
      </div>

      {/* Map Placeholder */}
      <ChartCard title="Interactive Coverage Map" description="Geographic visualization of device deployment and coverage areas">
        <div className="h-96 bg-gradient-to-br from-green-50 to-blue-50 rounded-lg flex items-center justify-center border-2 border-dashed border-gray-300">
          <div className="text-center">
            <Compass className="w-16 h-16 text-gray-400 mx-auto mb-4" />
            <h3 className="text-lg font-semibold text-gray-600 mb-2">Interactive Coverage Map</h3>
            <p className="text-gray-500 max-w-md">
              Real-time visualization of device locations, coverage areas, and expansion opportunities across Tanzania regions.
            </p>
            <button className="btn-primary mt-4">
              Launch Map View
            </button>
          </div>
        </div>
      </ChartCard>
    </div>
  );
};

export default FieldCoverage; 