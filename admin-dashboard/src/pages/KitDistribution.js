import React, { useState, useEffect } from 'react';
import { Plus, Package, Truck, MapPin, Calendar, CheckCircle, Clock, AlertTriangle, DollarSign } from 'lucide-react';
import { BarChart, Bar, XAxis, YAxis, CartesianGrid, ResponsiveContainer, LineChart, Line, PieChart, Pie, Cell } from 'recharts';
import MetricCard from '../components/MetricCard';
import ChartCard from '../components/ChartCard';

const KitDistribution = () => {
  const [distributions, setDistributions] = useState([]);
  const [inventory, setInventory] = useState([]);
  const [loading, setLoading] = useState(true);

  const distributionData = [
    {
      id: "DIST-2025-001",
      batchId: "BATCH-KIT-045",
      destination: "Dodoma Regional Center",
      coordinator: "James Mwangi",
      kitsRequested: 50,
      kitsShipped: 50,
      status: "delivered",
      shipDate: "2025-01-20",
      deliveryDate: "2025-01-23",
      trackingNumber: "TZ-ECO-789456",
      cost: 2500000
    },
    {
      id: "DIST-2025-002", 
      batchId: "BATCH-KIT-046",
      destination: "Mwanza Training Hub",
      coordinator: "Amina Hassan",
      kitsRequested: 35,
      kitsShipped: 35,
      status: "in_transit",
      shipDate: "2025-01-25",
      deliveryDate: null,
      trackingNumber: "TZ-ECO-789457",
      cost: 1750000
    },
    {
      id: "DIST-2025-003",
      batchId: "BATCH-KIT-047", 
      destination: "Arusha Field Office",
      coordinator: "Jackson Mwalimu",
      kitsRequested: 25,
      kitsShipped: 0,
      status: "pending",
      shipDate: null,
      deliveryDate: null,
      trackingNumber: null,
      cost: 1250000
    }
  ];

  const inventoryData = [
    {
      id: "INV-001",
      kitType: "EcoFy Soil Kit v2.1",
      totalStock: 450,
      available: 285,
      reserved: 85,
      inTransit: 45,
      defective: 35,
      unitCost: 50000,
      lastRestocked: "2025-01-15"
    },
    {
      id: "INV-002", 
      kitType: "EcoFy Weather Station",
      totalStock: 120,
      available: 67,
      reserved: 25,
      inTransit: 15,
      defective: 13,
      unitCost: 125000,
      lastRestocked: "2025-01-10"
    },
    {
      id: "INV-003",
      kitType: "EcoFy Crop Monitor",
      totalStock: 200,
      available: 134,
      reserved: 40,
      inTransit: 20,
      defective: 6,
      unitCost: 75000,
      lastRestocked: "2025-01-18"
    }
  ];

  const monthlyDistribution = [
    { month: 'Sep', distributed: 185, requested: 210 },
    { month: 'Oct', distributed: 220, requested: 245 },
    { month: 'Nov', distributed: 198, requested: 215 },
    { month: 'Dec', distributed: 275, requested: 290 },
    { month: 'Jan', distributed: 110, requested: 165 }
  ];

  const regionDistribution = [
    { region: 'Dodoma', value: 28, color: '#22c55e' },
    { region: 'Mwanza', value: 22, color: '#3b82f6' },
    { region: 'Arusha', value: 18, color: '#f59e0b' },
    { region: 'Iringa', value: 16, color: '#ef4444' },
    { region: 'Others', value: 16, color: '#8b5cf6' }
  ];

  useEffect(() => {
    setTimeout(() => {
      setDistributions(distributionData);
      setInventory(inventoryData);
      setLoading(false);
    }, 1000);
  }, []);

  const getStatusColor = (status) => {
    switch (status) {
      case 'delivered': return 'badge-green';
      case 'in_transit': return 'badge-blue';
      case 'pending': return 'badge-yellow';
      case 'cancelled': return 'badge-red';
      default: return 'badge-gray';
    }
  };

  const getStatusIcon = (status) => {
    switch (status) {
      case 'delivered': return CheckCircle;
      case 'in_transit': return Truck;
      case 'pending': return Clock;
      case 'cancelled': return AlertTriangle;
      default: return Package;
    }
  };

  const formatCurrency = (amount) => {
    return `TSh ${(amount / 1000000).toFixed(1)}M`;
  };

  const getStockStatus = (available, total) => {
    const percentage = (available / total) * 100;
    if (percentage > 50) return { color: 'text-green-600', label: 'Good' };
    if (percentage > 20) return { color: 'text-yellow-600', label: 'Low' };
    return { color: 'text-red-600', label: 'Critical' };
  };

  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <h1 className="text-3xl font-bold text-textPrimary">Kit Distribution</h1>
        <div className="flex space-x-3">
          <button className="btn-secondary flex items-center space-x-2">
            <Package className="w-4 h-4" />
            <span>Manage Inventory</span>
          </button>
          <button className="btn-primary flex items-center space-x-2">
            <Plus className="w-4 h-4" />
            <span>New Distribution</span>
          </button>
        </div>
      </div>

      {/* Distribution Stats */}
      <div className="grid grid-cols-1 md:grid-cols-4 gap-6">
        <MetricCard
          title="Total Kits in Stock"
          value="770"
          change="3 kit types"
          icon={Package}
          color="primary"
          trend="positive"
        />
        <MetricCard
          title="Kits Distributed"
          value="110"
          change="This month"
          icon={Truck}
          color="success"
          trend="positive"
        />
        <MetricCard
          title="Active Distributions"
          value="12"
          change="In transit"
          icon={MapPin}
          color="info"
          trend="positive"
        />
        <MetricCard
          title="Distribution Value"
          value="TSh 5.5M"
          change="This month"
          icon={DollarSign}
          color="secondary"
          trend="positive"
        />
      </div>

      {/* Distribution Charts */}
      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
        <ChartCard title="Monthly Distribution Trends" description="Kit requests vs actual distributions">
          <ResponsiveContainer width="100%" height={250}>
            <LineChart data={monthlyDistribution}>
              <CartesianGrid strokeDasharray="3 3" />
              <XAxis dataKey="month" />
              <YAxis />
              <Line type="monotone" dataKey="requested" stroke="#3b82f6" strokeWidth={2} name="Requested" />
              <Line type="monotone" dataKey="distributed" stroke="#22c55e" strokeWidth={2} name="Distributed" />
            </LineChart>
          </ResponsiveContainer>
        </ChartCard>

        <ChartCard title="Regional Distribution" description="Kit distribution by region">
          <ResponsiveContainer width="100%" height={250}>
            <PieChart>
              <Pie
                data={regionDistribution}
                cx="50%"
                cy="50%"
                innerRadius={60}
                outerRadius={100}
                dataKey="value"
              >
                {regionDistribution.map((entry, index) => (
                  <Cell key={`cell-${index}`} fill={entry.color} />
                ))}
              </Pie>
            </PieChart>
          </ResponsiveContainer>
          <div className="mt-4 grid grid-cols-3 gap-2">
            {regionDistribution.map((item, index) => (
              <div key={index} className="flex items-center space-x-2">
                <div className="w-3 h-3 rounded-full" style={{ backgroundColor: item.color }}></div>
                <span className="text-xs text-gray-600">{item.region} ({item.value}%)</span>
              </div>
            ))}
          </div>
        </ChartCard>
      </div>

      {/* Inventory Overview */}
      <ChartCard title="Inventory Status" description="Current stock levels and kit availability">
        <div className="space-y-4">
          {inventory.map((item) => {
            const stockStatus = getStockStatus(item.available, item.totalStock);
            return (
              <div key={item.id} className="flex items-center justify-between p-4 bg-white border border-gray-200 rounded-lg hover:shadow-md transition-shadow">
                <div className="flex items-center space-x-4">
                  <div className="w-12 h-12 rounded-lg bg-gradient-to-r from-blue-400 to-green-500 flex items-center justify-center">
                    <Package className="w-6 h-6 text-white" />
                  </div>
                  <div>
                    <h3 className="font-semibold text-textPrimary">{item.kitType}</h3>
                    <p className="text-sm text-textSecondary">Last restocked: {item.lastRestocked}</p>
                    <p className="text-xs text-gray-500">Unit Cost: TSh {item.unitCost.toLocaleString()}</p>
                  </div>
                </div>

                <div className="flex items-center space-x-6">
                  <div className="text-center">
                    <p className="text-lg font-semibold text-textPrimary">{item.totalStock}</p>
                    <p className="text-xs text-textSecondary">Total</p>
                  </div>
                  <div className="text-center">
                    <p className={`text-lg font-semibold ${stockStatus.color}`}>{item.available}</p>
                    <p className="text-xs text-textSecondary">Available</p>
                    <p className={`text-xs ${stockStatus.color}`}>{stockStatus.label}</p>
                  </div>
                  <div className="text-center">
                    <p className="text-lg font-semibold text-blue-600">{item.reserved}</p>
                    <p className="text-xs text-textSecondary">Reserved</p>
                  </div>
                  <div className="text-center">
                    <p className="text-lg font-semibold text-yellow-600">{item.inTransit}</p>
                    <p className="text-xs text-textSecondary">In Transit</p>
                  </div>
                  <div className="text-center">
                    <p className="text-lg font-semibold text-red-600">{item.defective}</p>
                    <p className="text-xs text-textSecondary">Defective</p>
                  </div>
                </div>

                <div className="flex space-x-2">
                  <button className="btn-secondary btn-sm">Restock</button>
                  <button className="btn-primary btn-sm">Distribute</button>
                </div>
              </div>
            );
          })}
        </div>
      </ChartCard>

      {/* Active Distributions */}
      <ChartCard title="Active Distributions" description="Current and recent distribution activities">
        <div className="space-y-4">
          {loading ? (
            <div className="text-center py-8">Loading distributions...</div>
          ) : (
            distributions.map((dist) => {
              const StatusIcon = getStatusIcon(dist.status);
              return (
                <div key={dist.id} className="flex items-center justify-between p-4 bg-white border border-gray-200 rounded-lg hover:shadow-md transition-shadow">
                  <div className="flex items-center space-x-4">
                    <div className={`w-12 h-12 rounded-full flex items-center justify-center ${
                      dist.status === 'delivered' ? 'bg-green-100 text-green-600' :
                      dist.status === 'in_transit' ? 'bg-blue-100 text-blue-600' :
                      dist.status === 'pending' ? 'bg-yellow-100 text-yellow-600' :
                      'bg-gray-100 text-gray-600'
                    }`}>
                      <StatusIcon className="w-6 h-6" />
                    </div>
                    <div>
                      <h3 className="font-semibold text-textPrimary">{dist.id}</h3>
                      <p className="text-sm text-textSecondary">{dist.destination}</p>
                      <div className="flex items-center space-x-4 mt-1">
                        <div className="flex items-center space-x-1">
                          <Package className="w-3 h-3 text-gray-400" />
                          <span className="text-xs text-gray-600">{dist.batchId}</span>
                        </div>
                        <div className="flex items-center space-x-1">
                          <MapPin className="w-3 h-3 text-gray-400" />
                          <span className="text-xs text-gray-600">{dist.coordinator}</span>
                        </div>
                        {dist.trackingNumber && (
                          <div className="flex items-center space-x-1">
                            <Truck className="w-3 h-3 text-gray-400" />
                            <span className="text-xs text-gray-600">{dist.trackingNumber}</span>
                          </div>
                        )}
                      </div>
                    </div>
                  </div>

                  <div className="flex items-center space-x-6">
                    <div className="text-center">
                      <p className="text-lg font-semibold text-textPrimary">{dist.kitsRequested}</p>
                      <p className="text-xs text-textSecondary">Requested</p>
                    </div>
                    <div className="text-center">
                      <p className="text-lg font-semibold text-success">{dist.kitsShipped}</p>
                      <p className="text-xs text-textSecondary">Shipped</p>
                    </div>
                    <div className="text-center">
                      <p className="text-lg font-semibold text-primary">{formatCurrency(dist.cost)}</p>
                      <p className="text-xs text-textSecondary">Value</p>
                    </div>
                    <div className="text-center">
                      <p className="text-sm text-textSecondary">
                        {dist.shipDate || 'Not shipped'}
                      </p>
                      <p className="text-xs text-textSecondary">Ship Date</p>
                    </div>
                    <div className="text-center">
                      <span className={`badge ${getStatusColor(dist.status)}`}>
                        {dist.status.replace('_', ' ')}
                      </span>
                    </div>
                  </div>

                  <div className="flex space-x-2">
                    <button className="btn-secondary btn-sm">Track</button>
                    <button className="btn-primary btn-sm">View Details</button>
                  </div>
                </div>
              );
            })
          )}
        </div>
      </ChartCard>

      {/* Quick Actions Summary */}
      <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
        <div className="bg-white p-6 rounded-lg border border-gray-200">
          <div className="flex items-center justify-between mb-4">
            <h3 className="font-semibold text-textPrimary">Low Stock Alerts</h3>
            <AlertTriangle className="w-5 h-5 text-yellow-500" />
          </div>
          <div className="space-y-3">
            <div className="flex justify-between items-center">
              <span className="text-sm text-textSecondary">Weather Stations</span>
              <span className="text-sm font-medium text-yellow-600">Low (67 left)</span>
            </div>
            <div className="flex justify-between items-center">
              <span className="text-sm text-textSecondary">Soil Kits</span>
              <span className="text-sm font-medium text-green-600">Good (285 left)</span>
            </div>
            <div className="flex justify-between items-center">
              <span className="text-sm text-textSecondary">Crop Monitors</span>
              <span className="text-sm font-medium text-green-600">Good (134 left)</span>
            </div>
          </div>
        </div>

        <div className="bg-white p-6 rounded-lg border border-gray-200">
          <div className="flex items-center justify-between mb-4">
            <h3 className="font-semibold text-textPrimary">Distribution Queue</h3>
            <Clock className="w-5 h-5 text-gray-400" />
          </div>
          <div className="space-y-3">
            <div className="flex justify-between items-center">
              <span className="text-sm text-textSecondary">Pending Requests</span>
              <span className="text-sm font-medium text-yellow-600">5 batches</span>
            </div>
            <div className="flex justify-between items-center">
              <span className="text-sm text-textSecondary">In Transit</span>
              <span className="text-sm font-medium text-blue-600">3 batches</span>
            </div>
            <div className="flex justify-between items-center">
              <span className="text-sm text-textSecondary">This Week</span>
              <span className="text-sm font-medium text-green-600">8 deliveries</span>
            </div>
          </div>
        </div>

        <div className="bg-white p-6 rounded-lg border border-gray-200">
          <div className="flex items-center justify-between mb-4">
            <h3 className="font-semibold text-textPrimary">Cost Analysis</h3>
            <DollarSign className="w-5 h-5 text-gray-400" />
          </div>
          <div className="space-y-3">
            <div className="flex justify-between items-center">
              <span className="text-sm text-textSecondary">Total Inventory Value</span>
              <span className="text-sm font-medium text-blue-600">TSh 61.5M</span>
            </div>
            <div className="flex justify-between items-center">
              <span className="text-sm text-textSecondary">Monthly Distribution</span>
              <span className="text-sm font-medium text-green-600">TSh 5.5M</span>
            </div>
            <div className="flex justify-between items-center">
              <span className="text-sm text-textSecondary">Avg Cost per Kit</span>
              <span className="text-sm font-medium text-purple-600">TSh 83.3K</span>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default KitDistribution; 