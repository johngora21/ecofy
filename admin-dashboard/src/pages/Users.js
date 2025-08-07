import React, { useState, useEffect } from 'react';
import { Users, Plus, Edit, Trash2, Search, Filter, Download, Shield } from 'lucide-react';
import MetricCard from '../components/MetricCard';
import ChartCard from '../components/ChartCard';

const UsersPage = () => {
  const [users, setUsers] = useState([]);
  const [search, setSearch] = useState('');
  const [selectedRole, setSelectedRole] = useState('farmer');
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');
  const [statistics, setStatistics] = useState({
    totalUsers: 0,
    activeUsers: 0,
    verifiedUsers: 0,
    newThisMonth: 0
  });

  // Fetch users from backend
  const fetchUsers = async (role = 'farmer') => {
    try {
      setLoading(true);
      const response = await fetch(`http://localhost:8000/api/v1/users/admin/all?role=${role}`, {
        headers: {
          'Authorization': `Bearer ${localStorage.getItem('token')}`,
          'Content-Type': 'application/json'
        }
      });
      
      if (!response.ok) {
        throw new Error('Failed to fetch users');
      }
      
      const data = await response.json();
      setUsers(data.items || []);
    } catch (err) {
      console.error('Error fetching users:', err);
      setError('Failed to load users');
    } finally {
      setLoading(false);
    }
  };

  // Fetch user statistics
  const fetchStatistics = async () => {
    try {
      const response = await fetch('http://localhost:8000/api/v1/users/admin/statistics', {
        headers: {
          'Authorization': `Bearer ${localStorage.getItem('token')}`,
          'Content-Type': 'application/json'
        }
      });
      
      if (!response.ok) {
        throw new Error('Failed to fetch statistics');
      }
      
      const data = await response.json();
      setStatistics({
        totalUsers: data.total_users || 0,
        activeUsers: data.active_users || 0,
        verifiedUsers: data.by_role?.farmers || 0,
        newThisMonth: data.by_role?.buyers || 0
      });
    } catch (err) {
      console.error('Error fetching statistics:', err);
    }
  };

  // Load users and statistics on component mount
  useEffect(() => {
    fetchUsers(selectedRole);
    fetchStatistics();
  }, [selectedRole]);

  const filteredUsers = users.filter(user =>
    user.full_name?.toLowerCase().includes(search.toLowerCase()) ||
    user.email?.toLowerCase().includes(search.toLowerCase())
  );

  const getRoleDisplayName = (role) => {
    const roleNames = {
      'farmer': 'Farmer',
      'buyer': 'Agripreneur', 
      'supplier': 'Supplier',
      'admin': 'Admin'
    };
    return roleNames[role] || role;
  };

  const handleRoleChange = (role) => {
    setSelectedRole(role);
    setSearch('');
  };

  return (
    <div className="space-y-4">
      {error && (
        <div className="bg-red-50 border border-red-200 text-red-700 px-4 py-3 rounded">
          {error}
        </div>
      )}

      {/* User Stats */}
      <div className="grid grid-cols-1 md:grid-cols-4 gap-4">
        <MetricCard
          title="Total Users"
          value={statistics.totalUsers.toLocaleString()}
          change="+89 this month"
          icon={Users}
          color="primary"
          trend="positive"
        />
        <MetricCard
          title="Active Users"
          value={statistics.activeUsers.toLocaleString()}
          change="92.9% active"
          icon={Users}
          color="success"
          trend="positive"
        />
        <MetricCard
          title="Verified Users"
          value={statistics.verifiedUsers.toLocaleString()}
          change="88.8% verified"
          icon={Shield}
          color="info"
          trend="positive"
        />
        <MetricCard
          title="New This Month"
          value={statistics.newThisMonth.toLocaleString()}
          change="+12.4% growth"
          icon={Users}
          color="secondary"
          trend="positive"
        />
      </div>

      {/* Role Filter */}
      <div className="flex space-x-2 mb-4">
        {['farmer', 'buyer', 'supplier', 'admin'].map(role => (
          <button
            key={role}
            onClick={() => handleRoleChange(role)}
            className={`px-4 py-2 rounded-md text-sm font-medium ${
              selectedRole === role
                ? 'bg-green-500 text-white'
                : 'bg-gray-100 text-gray-700 hover:bg-gray-200'
            }`}
          >
            {getRoleDisplayName(role)}s
          </button>
        ))}
      </div>

      {/* Search */}
      <div className="flex space-x-3">
        <div className="flex-1">
          <div className="relative">
            <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 text-textSecondary w-3 h-3" />
            <input
              type="text"
              placeholder="Search users..."
              value={search}
              onChange={e => setSearch(e.target.value)}
              className="input-field pl-9 text-sm"
            />
          </div>
        </div>
        <button className="btn-outline flex items-center space-x-1 text-sm px-3 py-1.5">
          <Filter className="w-3 h-3" />
          <span>Filter</span>
        </button>
      </div>

      {/* Users Table */}
      <ChartCard title="User List" className="h-auto">
        <div className="overflow-x-auto">
          {loading ? (
            <div className="text-center py-8 text-gray-500">Loading users...</div>
          ) : (
            <table className="data-table text-sm">
              <thead>
                <tr>
                  <th>Name</th>
                  <th>Email</th>
                  <th>Role</th>
                  <th>Status</th>
                  <th>Actions</th>
                </tr>
              </thead>
              <tbody>
                {filteredUsers.map((user) => (
                  <tr key={user._id}>
                    <td className="font-medium text-textPrimary">{user.full_name || 'N/A'}</td>
                    <td className="text-textSecondary">{user.email}</td>
                    <td className="text-textSecondary">{getRoleDisplayName(user.role)}</td>
                    <td>
                      <span className={`badge badge-success text-xs ${
                        user.is_active ? 'badge-success' : 'badge-error'
                      }`}>
                        {user.is_active ? 'Active' : 'Inactive'}
                      </span>
                    </td>
                    <td>
                      <div className="flex space-x-1">
                        <button className="btn-ghost p-0.5">
                          <Edit className="w-3 h-3" />
                        </button>
                        <button className="btn-ghost p-0.5 text-error hover:text-error-600">
                          <Trash2 className="w-3 h-3" />
                        </button>
                      </div>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          )}
          {!loading && filteredUsers.length === 0 && (
            <div className="text-center py-8 text-gray-500">No users found</div>
          )}
        </div>
      </ChartCard>
    </div>
  );
};

export default UsersPage; 