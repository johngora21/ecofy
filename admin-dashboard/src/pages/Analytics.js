import React, { useState } from 'react';
import MetricCard from '../components/MetricCard';
import ChartCard from '../components/ChartCard';
import { TrendingUp, Users, ShoppingCart, DollarSign } from 'lucide-react';

const Analytics = () => {
  const [timeRange, setTimeRange] = useState('30d');

  const analyticsData = {
    revenue: {
      total: 'TSh 45.2M',
      change: '+23%',
      trend: 'up'
    },
    users: {
      total: '1,890',
      change: '+12%',
      trend: 'up'
    },
    orders: {
      total: '2,456',
      change: '+18%',
      trend: 'up'
    },
    farms: {
      total: '1,234',
      change: '+15%',
      trend: 'up'
    }
  };

  return (
    <div className="space-y-6">
      {/* Time Range Filter */}
      <div className="flex justify-between items-center">
        <div className="flex space-x-2">
          <button
            onClick={() => setTimeRange('7d')}
            className={`px-3 py-1 text-sm rounded-md ${
              timeRange === '7d' 
                ? 'bg-green-600 text-white' 
                : 'bg-gray-200 text-gray-700 hover:bg-gray-300'
            }`}
          >
            7 Days
          </button>
          <button
            onClick={() => setTimeRange('30d')}
            className={`px-3 py-1 text-sm rounded-md ${
              timeRange === '30d' 
                ? 'bg-green-600 text-white' 
                : 'bg-gray-200 text-gray-700 hover:bg-gray-300'
            }`}
          >
            30 Days
          </button>
          <button
            onClick={() => setTimeRange('90d')}
            className={`px-3 py-1 text-sm rounded-md ${
              timeRange === '90d' 
                ? 'bg-green-600 text-white' 
                : 'bg-gray-200 text-gray-700 hover:bg-gray-300'
            }`}
          >
            90 Days
          </button>
        </div>
      </div>

      {/* Key Metrics */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
        <MetricCard
          title="Total Revenue"
          value={analyticsData.revenue.total}
          change={analyticsData.revenue.change}
          changeType="positive"
          icon={DollarSign}
        />
        <MetricCard
          title="Active Users"
          value={analyticsData.users.total}
          change={analyticsData.users.change}
          changeType="positive"
          icon={Users}
        />
        <MetricCard
          title="Orders Processed"
          value={analyticsData.orders.total}
          change={analyticsData.orders.change}
          changeType="positive"
          icon={ShoppingCart}
        />
        <MetricCard
          title="Farms Registered"
          value={analyticsData.farms.total}
          change={analyticsData.farms.change}
          changeType="positive"
          icon={TrendingUp}
        />
      </div>

      {/* Analytics Charts */}
      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
        {/* Revenue Analytics */}
        <ChartCard title="Revenue Analytics">
          <div className="space-y-4">
            <div className="flex items-center justify-between">
              <h3 className="text-sm font-medium text-gray-900">Revenue Trend</h3>
              <span className="text-xs text-gray-500">Last {timeRange}</span>
            </div>
            
            {/* Simple Revenue Chart */}
            <div className="space-y-2">
              {[45, 52, 48, 61, 55, 67, 72, 68, 75, 82, 78, 85].map((value, index) => (
                <div key={index} className="flex items-center space-x-2">
                  <span className="text-xs text-gray-500 w-8">M{index + 1}</span>
                  <div className="flex-1 bg-gray-200 rounded-full h-2">
                    <div 
                      className="bg-green-500 h-2 rounded-full" 
                      style={{ width: `${value}%` }}
                    ></div>
                  </div>
                  <span className="text-xs text-gray-700 w-12">TSh {value}K</span>
                </div>
              ))}
            </div>
          </div>
        </ChartCard>

        {/* User Engagement */}
        <ChartCard title="User Engagement">
          <div className="space-y-4">
            <div className="flex items-center justify-between">
              <h3 className="text-sm font-medium text-gray-900">User Activity</h3>
              <span className="text-xs text-gray-500">Last {timeRange}</span>
            </div>
            
            <div className="space-y-3">
              <div className="flex items-center justify-between">
                <span className="text-sm text-gray-600">Daily Active Users</span>
                <span className="text-sm font-medium text-gray-900">1,234</span>
              </div>
              <div className="flex items-center justify-between">
                <span className="text-sm text-gray-600">Weekly Active Users</span>
                <span className="text-sm font-medium text-gray-900">1,567</span>
              </div>
              <div className="flex items-center justify-between">
                <span className="text-sm text-gray-600">Monthly Active Users</span>
                <span className="text-sm font-medium text-gray-900">1,890</span>
              </div>
              <div className="flex items-center justify-between">
                <span className="text-sm text-gray-600">Session Duration</span>
                <span className="text-sm font-medium text-gray-900">12.5 min</span>
              </div>
            </div>
          </div>
        </ChartCard>
      </div>

      {/* Farm Insights */}
      <ChartCard title="Farm Insights">
        <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
          <div className="bg-blue-50 rounded-lg p-4">
            <h4 className="text-sm font-medium text-blue-900 mb-2">Top Regions</h4>
            <div className="space-y-2">
              <div className="flex justify-between text-xs">
                <span>Arusha</span>
                <span className="font-medium">456 farms</span>
              </div>
              <div className="flex justify-between text-xs">
                <span>Kilimanjaro</span>
                <span className="font-medium">342 farms</span>
              </div>
              <div className="flex justify-between text-xs">
                <span>Morogoro</span>
                <span className="font-medium">298 farms</span>
              </div>
            </div>
          </div>

          <div className="bg-green-50 rounded-lg p-4">
            <h4 className="text-sm font-medium text-green-900 mb-2">Popular Crops</h4>
            <div className="space-y-2">
              <div className="flex justify-between text-xs">
                <span>Maize</span>
                <span className="font-medium">45%</span>
              </div>
              <div className="flex justify-between text-xs">
                <span>Rice</span>
                <span className="font-medium">28%</span>
              </div>
              <div className="flex justify-between text-xs">
                <span>Beans</span>
                <span className="font-medium">18%</span>
              </div>
            </div>
          </div>

          <div className="bg-yellow-50 rounded-lg p-4">
            <h4 className="text-sm font-medium text-yellow-900 mb-2">Growth Rate</h4>
            <div className="space-y-2">
              <div className="flex justify-between text-xs">
                <span>New Farms</span>
                <span className="font-medium text-green-600">+15%</span>
              </div>
              <div className="flex justify-between text-xs">
                <span>Active Users</span>
                <span className="font-medium text-green-600">+12%</span>
              </div>
              <div className="flex justify-between text-xs">
                <span>Revenue</span>
                <span className="font-medium text-green-600">+23%</span>
              </div>
            </div>
          </div>
        </div>
      </ChartCard>
    </div>
  );
};

export default Analytics; 