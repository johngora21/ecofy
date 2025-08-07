import React, { useState } from 'react';
import { Bell, Plus, Edit, Trash2, Send, MessageSquare } from 'lucide-react';
import MetricCard from '../components/MetricCard';
import ChartCard from '../components/ChartCard';

const initialNotifications = [
  { id: 1, message: 'Welcome to Ecofy!', date: '2025-08-01', status: 'Sent' },
  { id: 2, message: 'Order #1234 has been shipped.', date: '2025-08-02', status: 'Sent' },
];

const Notifications = () => {
  const [notifications, setNotifications] = useState(initialNotifications);
  const [newMessage, setNewMessage] = useState('');

  const handleSend = () => {
    if (newMessage.trim()) {
      setNotifications([
        { id: Date.now(), message: newMessage, date: new Date().toISOString().slice(0, 10), status: 'Sent' },
        ...notifications,
      ]);
      setNewMessage('');
    }
  };

  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <h1 className="text-3xl font-bold text-textPrimary">Notifications</h1>
        <div className="flex space-x-3">
          <button className="btn-secondary flex items-center space-x-2">
            <MessageSquare className="w-4 h-4" />
            <span>Templates</span>
          </button>
          <button className="btn-primary flex items-center space-x-2">
            <Send className="w-4 h-4" />
            <span>Send Notification</span>
          </button>
        </div>
      </div>

      {/* Notification Stats */}
      <div className="grid grid-cols-1 md:grid-cols-4 gap-6">
        <MetricCard
          title="Total Sent"
          value="8,924"
          change="+324 today"
          icon={Bell}
          color="primary"
          trend="positive"
        />
        <MetricCard
          title="Active Users"
          value="2,156"
          change="+89 this week"
          icon={MessageSquare}
          color="success"
          trend="positive"
        />
        <MetricCard
          title="Response Rate"
          value="96.7%"
          change="+2.1% improved"
          icon={Bell}
          color="info"
          trend="positive"
        />
        <MetricCard
          title="Avg Response Time"
          value="1.2s"
          change="AI response speed"
          icon={Bell}
          color="secondary"
          trend="neutral"
        />
      </div>

      {/* Send New Notification */}
      <ChartCard title="Send New Notification" className="h-auto">
        <div className="space-y-4">
          <div>
            <label className="block text-sm font-medium text-textPrimary mb-2">Message</label>
            <textarea
              value={newMessage}
              onChange={e => setNewMessage(e.target.value)}
              placeholder="Enter your notification message..."
              className="input-field h-24 resize-none"
            />
          </div>
          <div className="flex justify-end">
            <button 
              onClick={handleSend}
              className="btn-primary flex items-center space-x-2"
              disabled={!newMessage.trim()}
            >
              <Send className="w-4 h-4" />
              <span>Send</span>
            </button>
          </div>
        </div>
      </ChartCard>

      {/* Notifications History */}
      <ChartCard title="Recent Notifications" className="h-auto">
        <div className="space-y-4">
          {notifications.map((notification) => (
            <div key={notification.id} className="flex items-center justify-between p-4 bg-gray-50 rounded-lg">
              <div className="flex-1">
                <p className="text-sm font-medium text-textPrimary">{notification.message}</p>
                <p className="text-xs text-textSecondary">{notification.date}</p>
              </div>
              <div className="flex items-center space-x-2">
                <span className="badge badge-success">{notification.status}</span>
                <button className="btn-ghost p-1">
                  <Edit className="w-4 h-4" />
                </button>
                <button className="btn-ghost p-1 text-error hover:text-error-600">
                  <Trash2 className="w-4 h-4" />
                </button>
              </div>
            </div>
          ))}
        </div>
      </ChartCard>
    </div>
  );
};

export default Notifications; 