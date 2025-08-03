import React, { useState, useEffect } from 'react';
import { Plus, MapPin, User, Phone, Calendar, Package, TrendingUp, Clock } from 'lucide-react';
import { LineChart, Line, XAxis, YAxis, CartesianGrid, ResponsiveContainer, AreaChart, Area } from 'recharts';
import MetricCard from '../components/MetricCard';
import ChartCard from '../components/ChartCard';

const RegionalAgents = () => {
  const [agents, setAgents] = useState([]);
  const [loading, setLoading] = useState(true);

  const agentData = [
    {
      id: 1,
      name: "Peter Makena",
      region: "Dodoma",
      phone: "+255 789 456 123",
      status: "active",
      samplesCollected: 145,
      farmsVisited: 89,
      lastActivity: "2 hours ago",
      performance: 94,
      joinDate: "2024-03-15",
      earnings: 2840000 // TSh
    },
    {
      id: 2,
      name: "Amina Hassan",
      region: "Mwanza",
      phone: "+255 756 234 567",
      status: "active",
      samplesCollected: 178,
      farmsVisited: 112,
      lastActivity: "1 hour ago",
      performance: 97,
      joinDate: "2024-02-20",
      earnings: 3560000
    },
    {
      id: 3,
      name: "Jackson Mwalimu",
      region: "Arusha",
      phone: "+255 712 789 012",
      status: "collecting",
      samplesCollected: 98,
      farmsVisited: 67,
      lastActivity: "30 min ago",
      performance: 88,
      joinDate: "2024-04-10",
      earnings: 1960000
    },
    {
      id: 4,
      name: "Grace Mbwana",
      region: "Mbeya",
      phone: "+255 741 345 678",
      status: "offline",
      samplesCollected: 203,
      farmsVisited: 134,
      lastActivity: "2 days ago",
      performance: 96,
      joinDate: "2024-01-08",
      earnings: 4060000
    }
  ];

  const performanceData = [
    { week: 'W1', samples: 145, farms: 89 },
    { week: 'W2', samples: 167, farms: 102 },
    { week: 'W3', samples: 189, farms: 118 },
    { week: 'W4', samples: 203, farms: 134 }
  ];

  const regionalData = [
    { region: 'Dodoma', agents: 12, samples: 1450, coverage: 85 },
    { region: 'Mwanza', agents: 8, samples: 1120, coverage: 78 },
    { region: 'Arusha', agents: 6, samples: 890, coverage: 72 },
    { region: 'Mbeya', agents: 10, samples: 1340, coverage: 88 },
    { region: 'Iringa', agents: 7, samples: 780, coverage: 65 },
    { region: 'Others', agents: 15, samples: 1620, coverage: 74 }
  ];

  useEffect(() => {
    setTimeout(() => {
      setAgents(agentData);
      setLoading(false);
    }, 1000);
  }, []);

  const getStatusColor = (status) => {
    switch (status) {
      case 'active': return 'badge-green';
      case 'collecting': return 'badge-blue';
      case 'offline': return 'badge-red';
      case 'training': return 'badge-yellow';
      default: return 'badge-gray';
    }
  };

  const formatCurrency = (amount) => {
    return `TSh ${(amount / 1000000).toFixed(1)}M`;
  };

  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <h1 className="text-3xl font-bold text-textPrimary">Regional Agents</h1>
        <div className="flex space-x-3">
          <button className="btn-secondary flex items-center space-x-2">
            <MapPin className="w-4 h-4" />
            <span>Agent Map</span>
          </button>
          <button className="btn-primary flex items-center space-x-2">
            <Plus className="w-4 h-4" />
            <span>Add Agent</span>
          </button>
        </div>
      </div>

      {/* Agent Stats */}
      <div className="grid grid-cols-1 md:grid-cols-4 gap-6">
        <MetricCard
          title="Active Agents"
          value="124"
          change="+8 this month"
          icon={User}
          color="primary"
          trend="positive"
        />
        <MetricCard
          title="Samples Collected"
          value="3,420"
          change="This month"
          icon={Package}
          color="success"
          trend="positive"
        />
        <MetricCard
          title="Avg Performance"
          value="91.2%"
          change="+3.4% improved"
          icon={TrendingUp}
          color="info"
          trend="positive"
        />
        <MetricCard
          title="Coverage Area"
          value="15,680 km²"
          change="8 regions"
          icon={MapPin}
          color="secondary"
          trend="positive"
        />
      </div>

      {/* Performance Charts */}
      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
        <ChartCard title="Weekly Performance" description="Sample collection and farm visits">
          <ResponsiveContainer width="100%" height={250}>
            <AreaChart data={performanceData}>
              <CartesianGrid strokeDasharray="3 3" />
              <XAxis dataKey="week" />
              <YAxis />
              <Area type="monotone" dataKey="samples" stackId="1" stroke="#22c55e" fill="#22c55e" fillOpacity={0.6} />
              <Area type="monotone" dataKey="farms" stackId="2" stroke="#3b82f6" fill="#3b82f6" fillOpacity={0.6} />
            </AreaChart>
          </ResponsiveContainer>
        </ChartCard>

        <ChartCard title="Regional Coverage" description="Agent distribution and coverage metrics">
          <div className="space-y-3">
            {regionalData.map((region, index) => (
              <div key={index} className="flex items-center justify-between p-3 bg-gray-50 rounded-lg">
                <div className="flex items-center space-x-3">
                  <MapPin className="w-4 h-4 text-primary" />
                  <div>
                    <p className="font-medium text-sm">{region.region}</p>
                    <p className="text-xs text-gray-500">{region.agents} agents • {region.samples} samples</p>
                  </div>
                </div>
                <div className="text-right">
                  <p className="text-sm font-medium text-success">{region.coverage}%</p>
                  <p className="text-xs text-gray-500">coverage</p>
                </div>
              </div>
            ))}
          </div>
        </ChartCard>
      </div>

      {/* Agents List */}
      <ChartCard title="Agent Directory" description="Monitor and coordinate regional soil sampling agents">
        <div className="space-y-4">
          {loading ? (
            <div className="text-center py-8">Loading agents...</div>
          ) : (
            agents.map((agent) => (
              <div key={agent.id} className="flex items-center justify-between p-4 bg-white border border-gray-200 rounded-lg hover:shadow-md transition-shadow">
                <div className="flex items-center space-x-4">
                  <div className={`w-12 h-12 rounded-full flex items-center justify-center ${
                    agent.status === 'active' ? 'bg-green-100 text-green-600' :
                    agent.status === 'collecting' ? 'bg-blue-100 text-blue-600' :
                    agent.status === 'offline' ? 'bg-red-100 text-red-600' :
                    'bg-gray-100 text-gray-600'
                  }`}>
                    <User className="w-6 h-6" />
                  </div>
                  <div>
                    <h3 className="font-semibold text-textPrimary">{agent.name}</h3>
                    <p className="text-sm text-textSecondary">Regional Agent</p>
                    <div className="flex items-center space-x-4 mt-1">
                      <div className="flex items-center space-x-1">
                        <MapPin className="w-3 h-3 text-gray-400" />
                        <span className="text-xs text-gray-600">{agent.region}</span>
                      </div>
                      <div className="flex items-center space-x-1">
                        <Phone className="w-3 h-3 text-gray-400" />
                        <span className="text-xs text-gray-600">{agent.phone}</span>
                      </div>
                      <div className="flex items-center space-x-1">
                        <Calendar className="w-3 h-3 text-gray-400" />
                        <span className="text-xs text-gray-600">Since {agent.joinDate}</span>
                      </div>
                    </div>
                  </div>
                </div>

                <div className="flex items-center space-x-6">
                  <div className="text-center">
                    <p className="text-lg font-semibold text-textPrimary">{agent.samplesCollected}</p>
                    <p className="text-xs text-textSecondary">Samples</p>
                  </div>
                  <div className="text-center">
                    <p className="text-lg font-semibold text-textPrimary">{agent.farmsVisited}</p>
                    <p className="text-xs text-textSecondary">Farms</p>
                  </div>
                  <div className="text-center">
                    <p className="text-lg font-semibold text-success">{agent.performance}%</p>
                    <p className="text-xs text-textSecondary">Performance</p>
                  </div>
                  <div className="text-center">
                    <p className="text-lg font-semibold text-primary">{formatCurrency(agent.earnings)}</p>
                    <p className="text-xs text-textSecondary">Earnings</p>
                  </div>
                  <div className="text-center">
                    <span className={`badge ${getStatusColor(agent.status)}`}>
                      {agent.status}
                    </span>
                    <p className="text-xs text-textSecondary mt-1">{agent.lastActivity}</p>
                  </div>
                </div>

                <div className="flex space-x-2">
                  <button className="btn-secondary btn-sm">Contact</button>
                  <button className="btn-primary btn-sm">View Profile</button>
                </div>
              </div>
            ))
          )}
        </div>
      </ChartCard>

      {/* Quick Actions */}
      <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
        <div className="bg-white p-6 rounded-lg border border-gray-200">
          <div className="flex items-center justify-between mb-4">
            <h3 className="font-semibold text-textPrimary">Payment Summary</h3>
            <Package className="w-5 h-5 text-gray-400" />
          </div>
          <div className="space-y-3">
            <div className="flex justify-between items-center">
              <span className="text-sm text-textSecondary">Pending Payments</span>
              <span className="text-sm font-medium text-yellow-600">TSh 4.2M</span>
            </div>
            <div className="flex justify-between items-center">
              <span className="text-sm text-textSecondary">Paid This Month</span>
              <span className="text-sm font-medium text-green-600">TSh 12.8M</span>
            </div>
            <div className="flex justify-between items-center">
              <span className="text-sm text-textSecondary">Average per Agent</span>
              <span className="text-sm font-medium text-blue-600">TSh 2.9M</span>
            </div>
          </div>
        </div>

        <div className="bg-white p-6 rounded-lg border border-gray-200">
          <div className="flex items-center justify-between mb-4">
            <h3 className="font-semibold text-textPrimary">Collection Status</h3>
            <Clock className="w-5 h-5 text-gray-400" />
          </div>
          <div className="space-y-3">
            <div className="flex justify-between items-center">
              <span className="text-sm text-textSecondary">Currently Collecting</span>
              <span className="text-sm font-medium text-blue-600">23 agents</span>
            </div>
            <div className="flex justify-between items-center">
              <span className="text-sm text-textSecondary">Available</span>
              <span className="text-sm font-medium text-green-600">89 agents</span>
            </div>
            <div className="flex justify-between items-center">
              <span className="text-sm text-textSecondary">Offline</span>
              <span className="text-sm font-medium text-red-600">12 agents</span>
            </div>
          </div>
        </div>

        <div className="bg-white p-6 rounded-lg border border-gray-200">
          <div className="flex items-center justify-between mb-4">
            <h3 className="font-semibold text-textPrimary">Target Progress</h3>
            <TrendingUp className="w-5 h-5 text-gray-400" />
          </div>
          <div className="space-y-3">
            <div className="flex justify-between items-center">
              <span className="text-sm text-textSecondary">Monthly Target</span>
              <span className="text-sm font-medium text-gray-600">5,000 samples</span>
            </div>
            <div className="flex justify-between items-center">
              <span className="text-sm text-textSecondary">Current Progress</span>
              <span className="text-sm font-medium text-blue-600">3,420 samples</span>
            </div>
            <div className="flex justify-between items-center">
              <span className="text-sm text-textSecondary">Completion</span>
              <span className="text-sm font-medium text-green-600">68.4%</span>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default RegionalAgents; 