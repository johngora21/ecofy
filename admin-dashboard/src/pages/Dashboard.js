import React, { useState, useEffect } from 'react';
import {
  Users,
  Truck,
  ShoppingCart,
  TrendingUp,
  MessageSquare,
  Brain,
  Mic,
  Bell,
  DollarSign,
  Package,
  MapPin,
  Calendar,
  Activity,
  AlertTriangle,
  CheckCircle,
  Clock,
  Smartphone,
  Wifi,
  UserCheck,
  GraduationCap,
  TestTube,
  Globe,
  Zap,
  Target
} from 'lucide-react';
import { 
  AreaChart, Area, XAxis, YAxis, CartesianGrid, ResponsiveContainer, 
  BarChart, Bar, PieChart, Pie, Cell, LineChart, Line 
} from 'recharts';
import { apiService } from '../services/api';
import MetricCard from '../components/MetricCard';
import ChartCard from '../components/ChartCard';

const Dashboard = () => {
  const [dashboardData, setDashboardData] = useState(null);
  const [loading, setLoading] = useState(true);

  // Sample comprehensive data for EcoFy operations
  const sampleData = {
    // Core Platform Metrics
    overview: {
      totalUsers: 45280,
      activeFarms: 12750,
      totalOrders: 8640,
      monthlyRevenue: 284500,
      aiInteractions: 156780,
      systemUptime: 99.7
    },

    // Field Operations
    fieldOperations: {
      activeFieldTeams: 18,
      trainersDeployed: 45,
      farmersTrainedThisMonth: 2340,
      regionsActive: 8,
      trainingProgramsActive: 12,
      averageTrainingScore: 8.7,
      agentsActive: 124,
      soilSamplesCollected: 3420
    },

    // IoT & Hardware
    iotMetrics: {
      devicesActive: 1240,
      kitsDistributed: 2850,
      deviceUptime: 94.2,
      dataPointsCollected: 89450,
      batteryAverageLevel: 78,
      maintenanceRequired: 23,
      coverageAreaKm2: 15680,
      soilReadingsToday: 445
    },

    // Communication Systems
    communication: {
      whatsappMessages: 8924,
      smsDelivered: 15670,
      responseRate: 96.7,
      averageResponseTime: 1.2,
      languagePreference: { swahili: 65, english: 35 },
      offlineUsers: 2340
    },

    // Financial & Business
    business: {
      subscriptionRevenue: 125000,
      iotSales: 89000,
      marketplaceCommissions: 45000,
      logisticsRevenue: 25500,
      partnerPayouts: 67000,
      profitMargin: 34.5
    }
  };

  const regionData = [
    { name: 'Dodoma', teams: 4, devices: 245, farmers: 1200, coverage: 98 },
    { name: 'Mwanza', teams: 3, devices: 189, farmers: 890, coverage: 94 },
    { name: 'Arusha', teams: 2, devices: 167, farmers: 750, coverage: 91 },
    { name: 'Mbeya', teams: 3, devices: 198, farmers: 980, coverage: 96 },
    { name: 'Iringa', teams: 2, devices: 156, farmers: 620, coverage: 89 },
    { name: 'Tabora', teams: 2, devices: 143, farmers: 580, coverage: 87 },
    { name: 'Rukwa', teams: 1, devices: 89, farmers: 340, coverage: 82 },
    { name: 'Ruvuma', teams: 1, devices: 92, farmers: 390, coverage: 85 }
  ];

  const iotPerformanceData = [
    { name: 'Mon', devices: 1180, readings: 4200, uptime: 95 },
    { name: 'Tue', devices: 1195, readings: 4350, uptime: 94 },
    { name: 'Wed', devices: 1210, readings: 4100, uptime: 96 },
    { name: 'Thu', devices: 1225, readings: 4500, uptime: 93 },
    { name: 'Fri', devices: 1240, readings: 4650, uptime: 94 },
    { name: 'Sat', devices: 1235, readings: 4200, uptime: 95 },
    { name: 'Sun', devices: 1240, readings: 3800, uptime: 97 }
  ];

  useEffect(() => {
    // Simulate API call
    setTimeout(() => {
      setDashboardData(sampleData);
      setLoading(false);
    }, 1000);
  }, []);

  if (loading) {
    return <div className="flex items-center justify-center h-64">Loading dashboard...</div>;
  }

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-3xl font-bold text-textPrimary">EcoFy Operations Dashboard</h1>
          <p className="text-textSecondary mt-1">Comprehensive platform monitoring for Sub-Saharan Africa</p>
        </div>
        <div className="flex space-x-3">
          <button className="btn-secondary flex items-center space-x-2">
            <Globe className="w-4 h-4" />
            <span>Regional View</span>
          </button>
          <button className="btn-primary flex items-center space-x-2">
            <Target className="w-4 h-4" />
            <span>Deploy Team</span>
          </button>
        </div>
      </div>

      {/* Core Platform Metrics */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 xl:grid-cols-6 gap-4">
        <MetricCard
          title="Total Users"
          value={dashboardData?.overview?.totalUsers?.toLocaleString() || '0'}
          change="+12.3% this month"
          icon={Users}
          color="primary"
          trend="positive"
        />
        <MetricCard
          title="Active Farms"
          value={dashboardData?.overview?.activeFarms?.toLocaleString() || '0'}
          change={`${dashboardData?.fieldOperations?.regionsActive || 0} regions`}
          icon={Truck}
          color="success"
          trend="positive"
        />
        <MetricCard
          title="IoT Devices"
          value={dashboardData?.iotMetrics?.devicesActive?.toLocaleString() || '0'}
          change={`${dashboardData?.iotMetrics?.deviceUptime || 0}% uptime`}
          icon={Wifi}
          color="info"
          trend="positive"
        />
        <MetricCard
          title="Field Teams"
          value={dashboardData?.fieldOperations?.activeFieldTeams?.toString() || '0'}
          change={`${dashboardData?.fieldOperations?.trainersDeployed || 0} trainers`}
          icon={UserCheck}
          color="secondary"
          trend="positive"
        />
        <MetricCard
          title="Monthly Revenue"
          value={`$${(dashboardData?.overview?.monthlyRevenue || 0).toLocaleString()}`}
          change="+18.2% vs last month"
          icon={DollarSign}
          color="success"
          trend="positive"
        />
        <MetricCard
          title="AI Interactions"
          value={dashboardData?.overview?.aiInteractions?.toLocaleString() || '0'}
          change={`${dashboardData?.communication?.responseRate || 0}% success rate`}
          icon={Brain}
          color="primary"
          trend="positive"
        />
      </div>

      {/* Field Operations Section */}
      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
        <ChartCard title="Regional Coverage" description="Field teams and IoT device distribution">
          <div className="space-y-3">
            {regionData.map((region, index) => (
              <div key={index} className="flex items-center justify-between p-3 bg-gray-50 rounded-lg">
                <div className="flex items-center space-x-3">
                  <MapPin className="w-4 h-4 text-primary" />
                  <div>
                    <p className="font-medium text-sm">{region.name}</p>
                    <p className="text-xs text-gray-500">{region.farmers} farmers • {region.devices} devices</p>
                  </div>
                </div>
                <div className="flex items-center space-x-3">
                  <div className="flex items-center space-x-1">
                    <UserCheck className="w-3 h-3 text-secondary" />
                    <span className="text-xs font-medium">{region.teams}</span>
                  </div>
                  <div className="text-right">
                    <p className="text-sm font-medium text-success">{region.coverage}%</p>
                    <p className="text-xs text-gray-500">coverage</p>
                  </div>
                </div>
              </div>
            ))}
          </div>
        </ChartCard>

        <ChartCard title="IoT Performance" description="Device activity and data collection">
          <ResponsiveContainer width="100%" height={250}>
            <AreaChart data={iotPerformanceData}>
              <CartesianGrid strokeDasharray="3 3" />
              <XAxis dataKey="name" />
              <YAxis />
              <Area type="monotone" dataKey="devices" stackId="1" stroke="#22c55e" fill="#22c55e" fillOpacity={0.6} />
              <Area type="monotone" dataKey="readings" stackId="2" stroke="#3b82f6" fill="#3b82f6" fillOpacity={0.6} />
            </AreaChart>
          </ResponsiveContainer>
        </ChartCard>
      </div>

      {/* Training & Education */}
      <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
        <MetricCard
          title="Farmers Trained"
          value={dashboardData?.fieldOperations?.farmersTrainedThisMonth?.toLocaleString() || '0'}
          change="This month"
          icon={GraduationCap}
          color="info"
          trend="positive"
        />
        <MetricCard
          title="Training Score"
          value={`${dashboardData?.fieldOperations?.averageTrainingScore || 0}/10`}
          change="+0.4 improved"
          icon={Target}
          color="success"
          trend="positive"
        />
        <MetricCard
          title="Soil Samples"
          value={dashboardData?.fieldOperations?.soilSamplesCollected?.toLocaleString() || '0'}
          change="This month"
          icon={TestTube}
          color="warning"
          trend="positive"
        />
      </div>

      {/* Real-time Activity Feed */}
      <ChartCard title="Live Activity Feed" description="Real-time operations across the platform">
        <div className="space-y-3 max-h-64 overflow-y-auto">
          {[
            { time: "2 min ago", event: "New IoT kit deployed in Dodoma region", type: "iot", icon: Wifi },
            { time: "5 min ago", event: "Field team completed training session - 45 farmers", type: "training", icon: GraduationCap },
            { time: "8 min ago", event: "Soil analysis completed for 12 farms in Mwanza", type: "analysis", icon: TestTube },
            { time: "12 min ago", event: "WhatsApp bot responded to 23 farmer queries", type: "ai", icon: Brain },
            { time: "15 min ago", event: "Regional agent collected 8 soil samples in Arusha", type: "agent", icon: UserCheck },
            { time: "18 min ago", event: "IoT device maintenance scheduled in Iringa", type: "maintenance", icon: AlertTriangle },
            { time: "22 min ago", event: "Training program launched in Tabora region", type: "program", icon: Zap },
            { time: "25 min ago", event: "Market price update sent to 1,240 farmers", type: "market", icon: TrendingUp }
          ].map((activity, index) => (
            <div key={index} className="flex items-start space-x-3 p-3 bg-white rounded-lg border border-gray-100">
              <div className={`w-8 h-8 rounded-full flex items-center justify-center ${
                activity.type === 'iot' ? 'bg-blue-100 text-blue-600' :
                activity.type === 'training' ? 'bg-green-100 text-green-600' :
                activity.type === 'analysis' ? 'bg-yellow-100 text-yellow-600' :
                activity.type === 'ai' ? 'bg-purple-100 text-purple-600' :
                activity.type === 'agent' ? 'bg-indigo-100 text-indigo-600' :
                activity.type === 'maintenance' ? 'bg-red-100 text-red-600' :
                activity.type === 'program' ? 'bg-orange-100 text-orange-600' :
                'bg-gray-100 text-gray-600'
              }`}>
                <activity.icon className="w-4 h-4" />
              </div>
              <div className="flex-1">
                <p className="text-sm text-textPrimary">{activity.event}</p>
                <p className="text-xs text-textSecondary">{activity.time}</p>
              </div>
            </div>
          ))}
        </div>
      </ChartCard>
    </div>
  );
};

export default Dashboard; 