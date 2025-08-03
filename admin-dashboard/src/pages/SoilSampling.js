import React, { useState, useEffect } from 'react';
import { Plus, TestTube, MapPin, Calendar, CheckCircle, Clock, AlertTriangle } from 'lucide-react';
import { LineChart, Line, XAxis, YAxis, CartesianGrid, ResponsiveContainer, BarChart, Bar } from 'recharts';
import MetricCard from '../components/MetricCard';
import ChartCard from '../components/ChartCard';

const SoilSampling = () => {
  const [samples, setSamples] = useState([]);
  const [loading, setLoading] = useState(true);

  const sampleData = [
    {
      id: "SS-2025-001",
      farmerId: "F12345",
      farmerName: "John Mwema",
      location: "Dodoma Central",
      coordinates: "-6.1722, 35.7414",
      collectionDate: "2025-01-28",
      agentName: "Peter Makena",
      status: "completed",
      ph: 6.8,
      nitrogen: 45,
      phosphorus: 23,
      potassium: 89,
      organicMatter: 3.2,
      recommendations: "Apply lime to increase pH. Add phosphorus fertilizer."
    },
    {
      id: "SS-2025-002",
      farmerId: "F12346",
      farmerName: "Grace Nyong",
      location: "Mwanza Lakeside",
      coordinates: "-2.5164, 32.9175",
      collectionDate: "2025-01-29",
      agentName: "Amina Hassan",
      status: "analyzing",
      ph: null,
      nitrogen: null,
      phosphorus: null,
      potassium: null,
      organicMatter: null,
      recommendations: null
    },
    {
      id: "SS-2025-003",
      farmerId: "F12347",
      farmerName: "David Kisia",
      location: "Arusha Highlands",
      coordinates: "-3.3869, 36.6830",
      collectionDate: "2025-01-30",
      agentName: "Jackson Mwalimu",
      status: "collected",
      ph: null,
      nitrogen: null,
      phosphorus: null,
      potassium: null,
      organicMatter: null,
      recommendations: null
    },
    {
      id: "SS-2025-004",
      farmerId: "F12348",
      farmerName: "Mary Temba",
      location: "Mbeya Southern",
      coordinates: "-8.9094, 33.4607",
      collectionDate: "2025-01-27",
      agentName: "Grace Mbwana",
      status: "completed",
      ph: 7.2,
      nitrogen: 38,
      phosphorus: 41,
      potassium: 72,
      organicMatter: 4.1,
      recommendations: "Good soil health. Maintain current practices."
    }
  ];

  const dailyCollections = [
    { date: 'Jan 25', collected: 45, analyzed: 42 },
    { date: 'Jan 26', collected: 52, analyzed: 48 },
    { date: 'Jan 27', collected: 38, analyzed: 51 },
    { date: 'Jan 28', collected: 41, analyzed: 39 },
    { date: 'Jan 29', collected: 47, analyzed: 44 },
    { date: 'Jan 30', collected: 39, analyzed: 46 }
  ];

  const phDistribution = [
    { range: '4.0-5.5', count: 45, label: 'Acidic' },
    { range: '5.6-6.5', count: 128, label: 'Slightly Acidic' },
    { range: '6.6-7.3', count: 203, label: 'Neutral' },
    { range: '7.4-8.5', count: 89, label: 'Alkaline' }
  ];

  useEffect(() => {
    setTimeout(() => {
      setSamples(sampleData);
      setLoading(false);
    }, 1000);
  }, []);

  const getStatusColor = (status) => {
    switch (status) {
      case 'completed': return 'badge-green';
      case 'analyzing': return 'badge-blue';
      case 'collected': return 'badge-yellow';
      case 'pending': return 'badge-gray';
      default: return 'badge-gray';
    }
  };

  const getStatusIcon = (status) => {
    switch (status) {
      case 'completed': return CheckCircle;
      case 'analyzing': return TestTube;
      case 'collected': return Clock;
      case 'pending': return AlertTriangle;
      default: return Clock;
    }
  };

  const getPHCategory = (ph) => {
    if (ph < 5.6) return { label: 'Acidic', color: 'text-red-600' };
    if (ph < 6.6) return { label: 'Slightly Acidic', color: 'text-yellow-600' };
    if (ph < 7.4) return { label: 'Neutral', color: 'text-green-600' };
    return { label: 'Alkaline', color: 'text-blue-600' };
  };

  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <h1 className="text-3xl font-bold text-textPrimary">Soil Sampling</h1>
        <div className="flex space-x-3">
          <button className="btn-secondary flex items-center space-x-2">
            <MapPin className="w-4 h-4" />
            <span>Sample Map</span>
          </button>
          <button className="btn-primary flex items-center space-x-2">
            <Plus className="w-4 h-4" />
            <span>New Sample</span>
          </button>
        </div>
      </div>

      {/* Sampling Stats */}
      <div className="grid grid-cols-1 md:grid-cols-4 gap-6">
        <MetricCard
          title="Samples Collected"
          value="3,420"
          change="+89 today"
          icon={TestTube}
          color="primary"
          trend="positive"
        />
        <MetricCard
          title="Analysis Completed"
          value="2,890"
          change="84.5% completion"
          icon={CheckCircle}
          color="success"
          trend="positive"
        />
        <MetricCard
          title="Pending Analysis"
          value="530"
          change="~3 days avg"
          icon={Clock}
          color="warning"
          trend="neutral"
        />
        <MetricCard
          title="Avg pH Level"
          value="6.7"
          change="Neutral range"
          icon={TestTube}
          color="info"
          trend="positive"
        />
      </div>

      {/* Analysis Charts */}
      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
        <ChartCard title="Daily Collection & Analysis" description="Sample collection and processing trends">
          <ResponsiveContainer width="100%" height={250}>
            <LineChart data={dailyCollections}>
              <CartesianGrid strokeDasharray="3 3" />
              <XAxis dataKey="date" />
              <YAxis />
              <Line type="monotone" dataKey="collected" stroke="#22c55e" strokeWidth={2} />
              <Line type="monotone" dataKey="analyzed" stroke="#3b82f6" strokeWidth={2} />
            </LineChart>
          </ResponsiveContainer>
        </ChartCard>

        <ChartCard title="pH Distribution" description="Soil acidity levels across all samples">
          <ResponsiveContainer width="100%" height={250}>
            <BarChart data={phDistribution}>
              <CartesianGrid strokeDasharray="3 3" />
              <XAxis dataKey="range" />
              <YAxis />
              <Bar dataKey="count" fill="#22c55e" />
            </BarChart>
          </ResponsiveContainer>
        </ChartCard>
      </div>

      {/* Sample List */}
      <ChartCard title="Sample Directory" description="Track soil sample collection and analysis results">
        <div className="space-y-4">
          {loading ? (
            <div className="text-center py-8">Loading samples...</div>
          ) : (
            samples.map((sample) => {
              const StatusIcon = getStatusIcon(sample.status);
              const phCategory = sample.ph ? getPHCategory(sample.ph) : null;
              
              return (
                <div key={sample.id} className="flex items-center justify-between p-4 bg-white border border-gray-200 rounded-lg hover:shadow-md transition-shadow">
                  <div className="flex items-center space-x-4">
                    <div className={`w-12 h-12 rounded-full flex items-center justify-center ${
                      sample.status === 'completed' ? 'bg-green-100 text-green-600' :
                      sample.status === 'analyzing' ? 'bg-blue-100 text-blue-600' :
                      sample.status === 'collected' ? 'bg-yellow-100 text-yellow-600' :
                      'bg-gray-100 text-gray-600'
                    }`}>
                      <StatusIcon className="w-6 h-6" />
                    </div>
                    <div>
                      <h3 className="font-semibold text-textPrimary">{sample.id}</h3>
                      <p className="text-sm text-textSecondary">{sample.farmerName}</p>
                      <div className="flex items-center space-x-4 mt-1">
                        <div className="flex items-center space-x-1">
                          <MapPin className="w-3 h-3 text-gray-400" />
                          <span className="text-xs text-gray-600">{sample.location}</span>
                        </div>
                        <div className="flex items-center space-x-1">
                          <Calendar className="w-3 h-3 text-gray-400" />
                          <span className="text-xs text-gray-600">{sample.collectionDate}</span>
                        </div>
                        <div className="flex items-center space-x-1">
                          <span className="text-xs text-gray-600">Agent: {sample.agentName}</span>
                        </div>
                      </div>
                    </div>
                  </div>

                  <div className="flex items-center space-x-6">
                    {sample.status === 'completed' ? (
                      <>
                        <div className="text-center">
                          <p className={`text-lg font-semibold ${phCategory?.color}`}>{sample.ph}</p>
                          <p className="text-xs text-textSecondary">pH Level</p>
                          <p className={`text-xs ${phCategory?.color}`}>{phCategory?.label}</p>
                        </div>
                        <div className="text-center">
                          <p className="text-lg font-semibold text-textPrimary">{sample.nitrogen}</p>
                          <p className="text-xs text-textSecondary">N (ppm)</p>
                        </div>
                        <div className="text-center">
                          <p className="text-lg font-semibold text-textPrimary">{sample.phosphorus}</p>
                          <p className="text-xs text-textSecondary">P (ppm)</p>
                        </div>
                        <div className="text-center">
                          <p className="text-lg font-semibold text-textPrimary">{sample.potassium}</p>
                          <p className="text-xs text-textSecondary">K (ppm)</p>
                        </div>
                        <div className="text-center">
                          <p className="text-lg font-semibold text-textPrimary">{sample.organicMatter}%</p>
                          <p className="text-xs text-textSecondary">Organic Matter</p>
                        </div>
                      </>
                    ) : (
                      <div className="text-center px-8">
                        <p className="text-sm text-gray-500">Analysis pending</p>
                        <p className="text-xs text-gray-400 mt-1">
                          {sample.status === 'analyzing' ? 'In laboratory' : 'Awaiting processing'}
                        </p>
                      </div>
                    )}
                    
                    <div className="text-center">
                      <span className={`badge ${getStatusColor(sample.status)}`}>
                        {sample.status}
                      </span>
                    </div>
                  </div>

                  <div className="flex space-x-2">
                    <button className="btn-secondary btn-sm">View Report</button>
                    {sample.status === 'completed' && (
                      <button className="btn-primary btn-sm">Send Results</button>
                    )}
                  </div>
                </div>
              );
            })
          )}
        </div>
      </ChartCard>

      {/* Analysis Summary */}
      <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
        <div className="bg-white p-6 rounded-lg border border-gray-200">
          <div className="flex items-center justify-between mb-4">
            <h3 className="font-semibold text-textPrimary">Nutrient Levels</h3>
            <TestTube className="w-5 h-5 text-gray-400" />
          </div>
          <div className="space-y-3">
            <div className="flex justify-between items-center">
              <span className="text-sm text-textSecondary">Nitrogen (avg)</span>
              <span className="text-sm font-medium text-blue-600">42.3 ppm</span>
            </div>
            <div className="flex justify-between items-center">
              <span className="text-sm text-textSecondary">Phosphorus (avg)</span>
              <span className="text-sm font-medium text-green-600">31.8 ppm</span>
            </div>
            <div className="flex justify-between items-center">
              <span className="text-sm text-textSecondary">Potassium (avg)</span>
              <span className="text-sm font-medium text-yellow-600">78.5 ppm</span>
            </div>
          </div>
        </div>

        <div className="bg-white p-6 rounded-lg border border-gray-200">
          <div className="flex items-center justify-between mb-4">
            <h3 className="font-semibold text-textPrimary">Processing Pipeline</h3>
            <Clock className="w-5 h-5 text-gray-400" />
          </div>
          <div className="space-y-3">
            <div className="flex justify-between items-center">
              <span className="text-sm text-textSecondary">Collected Today</span>
              <span className="text-sm font-medium text-blue-600">89 samples</span>
            </div>
            <div className="flex justify-between items-center">
              <span className="text-sm text-textSecondary">In Analysis</span>
              <span className="text-sm font-medium text-yellow-600">156 samples</span>
            </div>
            <div className="flex justify-between items-center">
              <span className="text-sm text-textSecondary">Results Ready</span>
              <span className="text-sm font-medium text-green-600">67 samples</span>
            </div>
          </div>
        </div>

        <div className="bg-white p-6 rounded-lg border border-gray-200">
          <div className="flex items-center justify-between mb-4">
            <h3 className="font-semibold text-textPrimary">Quality Metrics</h3>
            <CheckCircle className="w-5 h-5 text-gray-400" />
          </div>
          <div className="space-y-3">
            <div className="flex justify-between items-center">
              <span className="text-sm text-textSecondary">Analysis Accuracy</span>
              <span className="text-sm font-medium text-green-600">98.7%</span>
            </div>
            <div className="flex justify-between items-center">
              <span className="text-sm text-textSecondary">Avg Processing Time</span>
              <span className="text-sm font-medium text-blue-600">2.8 days</span>
            </div>
            <div className="flex justify-between items-center">
              <span className="text-sm text-textSecondary">Sample Integrity</span>
              <span className="text-sm font-medium text-green-600">99.2%</span>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default SoilSampling; 