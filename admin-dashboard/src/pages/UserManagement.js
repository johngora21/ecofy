import React, { useState, useEffect } from 'react';
import { Plus, Users, User, Shield, Calendar, MapPin, Phone, Mail, Activity } from 'lucide-react';
import { AreaChart, Area, XAxis, YAxis, CartesianGrid, ResponsiveContainer, BarChart, Bar } from 'recharts';
import MetricCard from '../components/MetricCard';
import ChartCard from '../components/ChartCard';

const UserManagement = () => {
  const [users, setUsers] = useState([]);
  const [loading, setLoading] = useState(true);

  const userData = [
    {
      id: "USR-001",
      name: "John Mwema",
      email: "john.mwema@gmail.com",
      phone: "+255 789 123 456",
      role: "farmer",
      region: "Dodoma",
      joinDate: "2024-03-15",
      lastActive: "2 hours ago",
      farmsCount: 3,
      ordersCount: 12,
      status: "active",
      verified: true
    },
    {
      id: "USR-002",
      name: "Grace Nyong",
      email: "grace.nyong@yahoo.com",
      phone: "+255 756 234 567",
      role: "farmer",
      region: "Mwanza",
      joinDate: "2024-02-20",
      lastActive: "1 day ago",
      farmsCount: 2,
      ordersCount: 8,
      status: "active",
      verified: true
    },
    {
      id: "USR-003",
      name: "David Kisia",
      email: "d.kisia@hotmail.com",
      phone: "+255 712 789 012",
      role: "extension_officer",
      region: "Arusha",
      joinDate: "2024-01-10",
      lastActive: "30 min ago",
      farmsCount: 0,
      ordersCount: 0,
      status: "active",
      verified: true
    },
    {
      id: "USR-004",
      name: "AgriCorp Tanzania",
      email: "info@agricorp.co.tz",
      phone: "+255 741 345 678",
      role: "seller",
      region: "Dar es Salaam",
      joinDate: "2023-11-08",
      lastActive: "5 hours ago",
      farmsCount: 0,
      ordersCount: 156,
      status: "active",
      verified: true
    },
    {
      id: "USR-005",
      name: "Mary Temba",
      email: "mary.temba@gmail.com",
      phone: "+255 698 456 789",
      role: "farmer",
      region: "Mbeya",
      joinDate: "2024-04-22",
      lastActive: "3 days ago",
      farmsCount: 1,
      ordersCount: 3,
      status: "inactive",
      verified: false
    }
  ];

  const userGrowthData = [
    { month: 'Aug', farmers: 1450, sellers: 45, officers: 23 },
    { month: 'Sep', farmers: 1678, sellers: 52, officers: 28 },
    { month: 'Oct', farmers: 1890, sellers: 61, officers: 31 },
    { month: 'Nov', farmers: 2145, sellers: 73, officers: 35 },
    { month: 'Dec', farmers: 2389, sellers: 89, officers: 42 },
    { month: 'Jan', farmers: 2567, sellers: 98, officers: 45 }
  ];

  const activityData = [
    { day: 'Mon', active: 1234, new: 45 },
    { day: 'Tue', active: 1456, new: 67 },
    { day: 'Wed', active: 1389, new: 52 },
    { day: 'Thu', active: 1567, new: 78 },
    { day: 'Fri', active: 1678, new: 89 },
    { day: 'Sat', active: 1234, new: 34 },
    { day: 'Sun', active: 1123, new: 28 }
  ];

  useEffect(() => {
    setTimeout(() => {
      setUsers(userData);
      setLoading(false);
    }, 1000);
  }, []);

  const getStatusColor = (status) => {
    switch (status) {
      case 'active': return 'badge-green';
      case 'inactive': return 'badge-gray';
      case 'suspended': return 'badge-red';
      case 'pending': return 'badge-yellow';
      default: return 'badge-gray';
    }
  };

  const getRoleColor = (role) => {
    switch (role) {
      case 'farmer': return 'bg-green-100 text-green-600';
      case 'seller': return 'bg-blue-100 text-blue-600';
      case 'extension_officer': return 'bg-purple-100 text-purple-600';
      case 'admin': return 'bg-red-100 text-red-600';
      default: return 'bg-gray-100 text-gray-600';
    }
  };

  const getRoleIcon = (role) => {
    switch (role) {
      case 'farmer': return User;
      case 'seller': return Users;
      case 'extension_officer': return Shield;
      case 'admin': return Shield;
      default: return User;
    }
  };

  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <h1 className="text-3xl font-bold text-textPrimary">User Management</h1>
        <div className="flex space-x-3">
          <button className="btn-secondary flex items-center space-x-2">
            <Activity className="w-4 h-4" />
            <span>User Analytics</span>
          </button>
          <button className="btn-primary flex items-center space-x-2">
            <Plus className="w-4 h-4" />
            <span>Add User</span>
          </button>
        </div>
      </div>

      {/* User Stats */}
      <div className="grid grid-cols-1 md:grid-cols-4 gap-6">
        <MetricCard
          title="Total Users"
          value="2,710"
          change="+89 this week"
          icon={Users}
          color="primary"
          trend="positive"
        />
        <MetricCard
          title="Active Farmers"
          value="2,567"
          change="94.7% of total"
          icon={User}
          color="success"
          trend="positive"
        />
        <MetricCard
          title="Verified Users"
          value="2,456"
          change="90.6% verified"
          icon={Shield}
          color="info"
          trend="positive"
        />
        <MetricCard
          title="New This Month"
          value="342"
          change="+23% growth"
          icon={Calendar}
          color="secondary"
          trend="positive"
        />
      </div>

      {/* User Growth Charts */}
      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
        <ChartCard title="User Growth by Type" description="Monthly registration trends by user role">
          <ResponsiveContainer width="100%" height={250}>
            <AreaChart data={userGrowthData}>
              <CartesianGrid strokeDasharray="3 3" />
              <XAxis dataKey="month" />
              <YAxis />
              <Area type="monotone" dataKey="farmers" stackId="1" stroke="#22c55e" fill="#22c55e" fillOpacity={0.6} />
              <Area type="monotone" dataKey="sellers" stackId="1" stroke="#3b82f6" fill="#3b82f6" fillOpacity={0.6} />
              <Area type="monotone" dataKey="officers" stackId="1" stroke="#8b5cf6" fill="#8b5cf6" fillOpacity={0.6} />
            </AreaChart>
          </ResponsiveContainer>
        </ChartCard>

        <ChartCard title="Daily Activity" description="Active users and new registrations">
          <ResponsiveContainer width="100%" height={250}>
            <BarChart data={activityData}>
              <CartesianGrid strokeDasharray="3 3" />
              <XAxis dataKey="day" />
              <YAxis />
              <Bar dataKey="active" fill="#22c55e" />
              <Bar dataKey="new" fill="#3b82f6" />
            </BarChart>
          </ResponsiveContainer>
        </ChartCard>
      </div>

      {/* Users List */}
      <ChartCard title="User Directory" description="Manage platform users and their access permissions">
        <div className="space-y-4">
          {loading ? (
            <div className="text-center py-8">Loading users...</div>
          ) : (
            users.map((user) => {
              const RoleIcon = getRoleIcon(user.role);
              return (
                <div key={user.id} className="flex items-center justify-between p-4 bg-white border border-gray-200 rounded-lg hover:shadow-md transition-shadow">
                  <div className="flex items-center space-x-4">
                    <div className={`w-12 h-12 rounded-full flex items-center justify-center ${getRoleColor(user.role)}`}>
                      <RoleIcon className="w-6 h-6" />
                    </div>
                    <div>
                      <div className="flex items-center space-x-2">
                        <h3 className="font-semibold text-textPrimary">{user.name}</h3>
                        {user.verified && (
                          <div className="w-4 h-4 bg-blue-500 rounded-full flex items-center justify-center">
                            <span className="text-white text-xs">✓</span>
                          </div>
                        )}
                      </div>
                      <p className="text-sm text-textSecondary capitalize">{user.role.replace('_', ' ')}</p>
                      <div className="flex items-center space-x-4 mt-1">
                        <div className="flex items-center space-x-1">
                          <Mail className="w-3 h-3 text-gray-400" />
                          <span className="text-xs text-gray-600">{user.email}</span>
                        </div>
                        <div className="flex items-center space-x-1">
                          <Phone className="w-3 h-3 text-gray-400" />
                          <span className="text-xs text-gray-600">{user.phone}</span>
                        </div>
                        <div className="flex items-center space-x-1">
                          <MapPin className="w-3 h-3 text-gray-400" />
                          <span className="text-xs text-gray-600">{user.region}</span>
                        </div>
                      </div>
                    </div>
                  </div>

                  <div className="flex items-center space-x-6">
                    <div className="text-center">
                      <p className="text-lg font-semibold text-textPrimary">{user.farmsCount}</p>
                      <p className="text-xs text-textSecondary">Farms</p>
                    </div>
                    <div className="text-center">
                      <p className="text-lg font-semibold text-textPrimary">{user.ordersCount}</p>
                      <p className="text-xs text-textSecondary">Orders</p>
                    </div>
                    <div className="text-center">
                      <p className="text-sm text-textSecondary">{user.joinDate}</p>
                      <p className="text-xs text-textSecondary">Joined</p>
                    </div>
                    <div className="text-center">
                      <p className="text-sm text-textSecondary">{user.lastActive}</p>
                      <p className="text-xs text-textSecondary">Last Active</p>
                    </div>
                    <div className="text-center">
                      <span className={`badge ${getStatusColor(user.status)}`}>
                        {user.status}
                      </span>
                    </div>
                  </div>

                  <div className="flex space-x-2">
                    <button className="btn-secondary btn-sm">View Profile</button>
                    <button className="btn-primary btn-sm">Edit User</button>
                  </div>
                </div>
              );
            })
          )}
        </div>
      </ChartCard>

      {/* User Analytics Summary */}
      <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
        <div className="bg-white p-6 rounded-lg border border-gray-200">
          <div className="flex items-center justify-between mb-4">
            <h3 className="font-semibold text-textPrimary">User Distribution</h3>
            <Users className="w-5 h-5 text-gray-400" />
          </div>
          <div className="space-y-3">
            <div className="flex justify-between items-center">
              <span className="text-sm text-textSecondary">Farmers</span>
              <span className="text-sm font-medium text-green-600">2,567 (94.7%)</span>
            </div>
            <div className="flex justify-between items-center">
              <span className="text-sm text-textSecondary">Sellers</span>
              <span className="text-sm font-medium text-blue-600">98 (3.6%)</span>
            </div>
            <div className="flex justify-between items-center">
              <span className="text-sm text-textSecondary">Extension Officers</span>
              <span className="text-sm font-medium text-purple-600">45 (1.7%)</span>
            </div>
          </div>
        </div>

        <div className="bg-white p-6 rounded-lg border border-gray-200">
          <div className="flex items-center justify-between mb-4">
            <h3 className="font-semibold text-textPrimary">Regional Distribution</h3>
            <MapPin className="w-5 h-5 text-gray-400" />
          </div>
          <div className="space-y-3">
            <div className="flex justify-between items-center">
              <span className="text-sm text-textSecondary">Dodoma</span>
              <span className="text-sm font-medium text-blue-600">456 users</span>
            </div>
            <div className="flex justify-between items-center">
              <span className="text-sm text-textSecondary">Mwanza</span>
              <span className="text-sm font-medium text-green-600">389 users</span>
            </div>
            <div className="flex justify-between items-center">
              <span className="text-sm text-textSecondary">Arusha</span>
              <span className="text-sm font-medium text-yellow-600">312 users</span>
            </div>
          </div>
        </div>

        <div className="bg-white p-6 rounded-lg border border-gray-200">
          <div className="flex items-center justify-between mb-4">
            <h3 className="font-semibold text-textPrimary">Engagement Metrics</h3>
            <Activity className="w-5 h-5 text-gray-400" />
          </div>
          <div className="space-y-3">
            <div className="flex justify-between items-center">
              <span className="text-sm text-textSecondary">Daily Active Users</span>
              <span className="text-sm font-medium text-green-600">1,456</span>
            </div>
            <div className="flex justify-between items-center">
              <span className="text-sm text-textSecondary">Weekly Active Users</span>
              <span className="text-sm font-medium text-blue-600">2,134</span>
            </div>
            <div className="flex justify-between items-center">
              <span className="text-sm text-textSecondary">User Retention Rate</span>
              <span className="text-sm font-medium text-purple-600">87.3%</span>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default UserManagement; 