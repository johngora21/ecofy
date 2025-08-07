import React, { useState, useEffect } from 'react';
import MetricCard from '../components/MetricCard';
import ChartCard from '../components/ChartCard';
import { MessageSquare, Send, Users, CheckCircle } from 'lucide-react';
import apiService from '../services/api_service';

const Messages = () => {
  const [selectedGroup, setSelectedGroup] = useState('');
  const [messageText, setMessageText] = useState('');
  const [showUserSelect, setShowUserSelect] = useState(false);
  const [searchUser, setSearchUser] = useState('');
  const [selectedUsers, setSelectedUsers] = useState([]);
  const [allUsers, setAllUsers] = useState([]);
  const [userGroups, setUserGroups] = useState([]);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');

  // Fetch users from backend using API service
  const fetchUsers = async () => {
    try {
      setLoading(true);
      const data = await apiService.getUsers();
      setAllUsers(data.items || []);
      
      // Group users by role
      const groups = {};
      data.items?.forEach(user => {
        if (!groups[user.role]) {
          groups[user.role] = [];
        }
        groups[user.role].push(user);
      });
      
      // Create user groups for dropdown
      const groupList = Object.keys(groups).map(role => ({
        id: role,
        name: getRoleDisplayName(role),
        count: groups[role].length
      }));
      
      setUserGroups(groupList);
    } catch (err) {
      console.error('Error fetching users:', err);
      setError('Failed to load users');
    } finally {
      setLoading(false);
    }
  };

  // Get display name for role
  const getRoleDisplayName = (role) => {
    const roleNames = {
      'farmer': 'Farmers',
      'buyer': 'Agripreneurs', 
      'supplier': 'Suppliers',
      'admin': 'Admins'
    };
    return roleNames[role] || role;
  };

  // Load users on component mount
  useEffect(() => {
    fetchUsers();
  }, []);

  // Filter users by selected group
  const groupUsers = selectedGroup ? allUsers.filter(u => u.role === selectedGroup) : [];
  const filteredGroupUsers = groupUsers.filter(u => 
    u.full_name?.toLowerCase().includes(searchUser.toLowerCase()) ||
    u.email?.toLowerCase().includes(searchUser.toLowerCase())
  );

  const handleUserToggle = (userId) => {
    setSelectedUsers(prev =>
      prev.includes(userId) ? prev.filter(id => id !== userId) : [...prev, userId]
    );
  };

  const handleSend = async () => {
    try {
      setLoading(true);
      
      // Determine recipients
      let recipients = [];
      if (showUserSelect && selectedUsers.length > 0) {
        // Send to specific selected users
        recipients = selectedUsers;
      } else if (selectedGroup) {
        // Send to all users in the group
        recipients = groupUsers.map(user => user._id);
      }
      
      // Send message using API service
      await apiService.sendBulkSMS(recipients, messageText);
      
      alert(`Message sent to ${recipients.length} recipients!`);
      
      // Reset form
      setMessageText('');
      setSelectedUsers([]);
      setShowUserSelect(false);
    } catch (err) {
      console.error('Error sending message:', err);
      setError('Failed to send message');
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="space-y-6">
      {/* Metrics */}
      <div className="grid grid-cols-1 md:grid-cols-4 gap-6">
        <MetricCard title="Total Messages" value="1,234" icon={MessageSquare} />
        <MetricCard title="Sent Today" value="56" icon={Send} />
        <MetricCard title="Delivered" value="1,200" icon={CheckCircle} />
        <MetricCard title="User Groups" value={userGroups.length} icon={Users} />
      </div>

      <ChartCard title="Send Bulk SMS">
        <div className="space-y-4">
          {error && (
            <div className="bg-red-50 border border-red-200 text-red-700 px-4 py-3 rounded">
              {error}
            </div>
          )}

          {/* User Group Selection */}
          <div className="flex flex-col md:flex-row md:items-center gap-4">
            <select
              value={selectedGroup}
              onChange={e => {
                setSelectedGroup(e.target.value);
                setSelectedUsers([]);
                setShowUserSelect(false);
              }}
              className="w-full md:w-64 px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-green-500"
              disabled={loading}
            >
              <option value="">Select User Group</option>
              {userGroups.map(group => (
                <option key={group.id} value={group.id}>
                  {group.name} ({group.count})
                </option>
              ))}
            </select>
            {selectedGroup && (
              <button
                type="button"
                className="btn-outline px-4 py-2 text-sm rounded border border-green-500 text-green-700 hover:bg-green-50"
                onClick={() => setShowUserSelect(v => !v)}
                disabled={loading}
              >
                {showUserSelect ? 'Hide User List' : 'Select Users from Group'}
              </button>
            )}
          </div>

          {/* User Multi-Select Modal/Dropdown */}
          {showUserSelect && selectedGroup && (
            <div className="bg-gray-50 border border-gray-200 rounded-lg p-4 mb-2 max-w-lg">
              <div className="mb-2">
                <input
                  type="text"
                  placeholder="Search users..."
                  value={searchUser}
                  onChange={e => setSearchUser(e.target.value)}
                  className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-green-500"
                />
              </div>
              <div className="max-h-40 overflow-y-auto">
                {loading ? (
                  <div className="text-gray-500 text-sm">Loading users...</div>
                ) : filteredGroupUsers.length === 0 ? (
                  <div className="text-gray-400 text-sm">No users found.</div>
                ) : (
                  filteredGroupUsers.map(user => (
                    <label key={user._id} className="flex items-center py-1 cursor-pointer">
                      <input
                        type="checkbox"
                        checked={selectedUsers.includes(user._id)}
                        onChange={() => handleUserToggle(user._id)}
                        className="mr-2"
                      />
                      <span>{user.full_name || user.email}</span>
                    </label>
                  ))
                )}
              </div>
            </div>
          )}

          {/* Message Input */}
          <textarea
            value={messageText}
            onChange={e => setMessageText(e.target.value)}
            rows={4}
            placeholder="Type your message here..."
            className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-green-500"
            disabled={loading}
          />

          {/* Send Button */}
          <div className="flex justify-end">
            <button
              className="btn-primary flex items-center gap-2 px-6 py-2"
              disabled={
                loading ||
                !selectedGroup ||
                (showUserSelect && selectedUsers.length === 0) ||
                !messageText.trim()
              }
              onClick={handleSend}
            >
              <Send className="w-4 h-4" />
              {loading ? 'Sending...' : 'Send Message'}
            </button>
          </div>
        </div>
      </ChartCard>

      {/* Recent Messages List (mock) */}
      <ChartCard title="Recent Messages">
        <ul className="divide-y divide-gray-100">
          <li className="py-2 flex justify-between items-center">
            <span>"Fertilizer prices updated for August."</span>
            <span className="text-xs text-gray-400">Sent to Farmers</span>
          </li>
          <li className="py-2 flex justify-between items-center">
            <span>"New market insights available."</span>
            <span className="text-xs text-gray-400">Sent to Agripreneurs</span>
          </li>
          <li className="py-2 flex justify-between items-center">
            <span>"System maintenance scheduled."</span>
            <span className="text-xs text-gray-400">Sent to All Users</span>
          </li>
        </ul>
      </ChartCard>
    </div>
  );
};

export default Messages; 