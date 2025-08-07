import React from 'react';
import MetricCard from '../components/MetricCard';
import ChartCard from '../components/ChartCard';
import { Users, ShoppingCart, MapPin, TrendingUp } from 'lucide-react';

const Dashboard = () => {
  return (
    <div className="space-y-6">
      {/* Metrics */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
        <MetricCard
          title="Total Users"
          value="1,890"
          change="+12%"
          changeType="positive"
          icon={Users}
        />
        <MetricCard
          title="Orders Processed"
          value="2,456"
          change="+8%"
          changeType="positive"
          icon={ShoppingCart}
        />
        <MetricCard
          title="Farms Registered"
          value="1,234"
          change="+15%"
          changeType="positive"
          icon={MapPin}
        />
        <MetricCard
          title="Revenue Generated"
          value="TSh 45.2M"
          change="+23%"
          changeType="positive"
          icon={TrendingUp}
        />
      </div>

      {/* Recent Activity */}
      <ChartCard title="Recent Activity">
        <div className="space-y-4">
          <div className="flex items-center justify-between p-4 bg-gray-50 rounded-lg">
            <div className="flex items-center space-x-3">
              <div className="w-8 h-8 bg-green-100 rounded-full flex items-center justify-center">
                <Users className="w-4 h-4 text-green-600" />
              </div>
              <div>
                <p className="text-sm font-medium text-gray-900">New user registered</p>
                <p className="text-xs text-gray-500">John Doe joined the platform</p>
              </div>
            </div>
            <span className="text-xs text-gray-500">2 minutes ago</span>
          </div>

          <div className="flex items-center justify-between p-4 bg-gray-50 rounded-lg">
            <div className="flex items-center space-x-3">
              <div className="w-8 h-8 bg-blue-100 rounded-full flex items-center justify-center">
                <ShoppingCart className="w-4 h-4 text-blue-600" />
              </div>
              <div>
                <p className="text-sm font-medium text-gray-900">New order received</p>
                <p className="text-xs text-gray-500">Order #1234 for maize</p>
              </div>
            </div>
            <span className="text-xs text-gray-500">5 minutes ago</span>
          </div>

          <div className="flex items-center justify-between p-4 bg-gray-50 rounded-lg">
            <div className="flex items-center space-x-3">
              <div className="w-8 h-8 bg-yellow-100 rounded-full flex items-center justify-center">
                <MapPin className="w-4 h-4 text-yellow-600" />
              </div>
              <div>
                <p className="text-sm font-medium text-gray-900">Farm registered</p>
                <p className="text-xs text-gray-500">Green Valley Farm added</p>
              </div>
            </div>
            <span className="text-xs text-gray-500">10 minutes ago</span>
          </div>
        </div>
      </ChartCard>
    </div>
  );
};

export default Dashboard; 