import React, { useState, useEffect } from 'react';
import { MessageSquare, Send, Users, CheckCircle, Clock, AlertTriangle } from 'lucide-react';
import { apiService } from '../services/api';
import MetricCard from '../components/MetricCard';
import ChartCard from '../components/ChartCard';

const WhatsAppMonitor = () => {
  const [whatsappStats, setWhatsappStats] = useState(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    fetchWhatsappStats();
  }, []);

  const fetchWhatsappStats = async () => {
    try {
      setLoading(true);
      const stats = await apiService.getWhatsAppStats();
      setWhatsappStats(stats);
    } catch (error) {
      console.error('Error fetching WhatsApp stats:', error);
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <h1 className="text-3xl font-bold text-textPrimary">WhatsApp Monitor</h1>
        <div className="flex space-x-3">
          <button className="btn-secondary flex items-center space-x-2">
            <MessageSquare className="w-4 h-4" />
            <span>Templates</span>
          </button>
          <button className="btn-primary flex items-center space-x-2">
            <Send className="w-4 h-4" />
            <span>Send Message</span>
          </button>
        </div>
      </div>

      {/* WhatsApp Stats */}
      <div className="grid grid-cols-1 md:grid-cols-4 gap-6">
        <MetricCard
          title="Total Messages"
          value="8,924"
          change="+324 today"
          icon={MessageSquare}
          color="primary"
          trend="positive"
        />
        <MetricCard
          title="Active Users"
          value="2,156"
          change="+89 this week"
          icon={Users}
          color="success"
          trend="positive"
        />
        <MetricCard
          title="Response Rate"
          value="96.7%"
          change="+2.1% improved"
          icon={CheckCircle}
          color="info"
          trend="positive"
        />
        <MetricCard
          title="Avg Response Time"
          value="1.2s"
          change="AI response speed"
          icon={Clock}
          color="secondary"
          trend="neutral"
        />
      </div>

      {/* Recent Messages */}
      <ChartCard title="Recent WhatsApp Conversations" description="Live message monitoring">
        <div className="space-y-4">
          {[
            { user: "+255 789 123 456", message: "Habari, nina tatizo na mahindi yangu", status: "delivered", time: "2 min ago" },
            { user: "+255 756 789 012", message: "What's the best fertilizer for tomatoes?", status: "read", time: "5 min ago" },
            { user: "+255 712 345 678", message: "Je, ni wakati gani bora wa kupanda mchele?", status: "delivered", time: "8 min ago" },
            { user: "+255 741 852 963", message: "My crops are showing yellow leaves", status: "read", time: "12 min ago" }
          ].map((msg, index) => (
            <div key={index} className="flex items-start space-x-4 p-4 border border-gray-200 rounded-lg">
              <div className="w-10 h-10 bg-primary/10 rounded-full flex items-center justify-center">
                <MessageSquare className="w-5 h-5 text-primary" />
              </div>
              <div className="flex-1">
                <div className="flex items-center justify-between">
                  <span className="font-medium text-sm">{msg.user}</span>
                  <span className="text-xs text-gray-500">{msg.time}</span>
                </div>
                <p className="text-sm text-gray-700 mt-1">{msg.message}</p>
                <div className="flex items-center space-x-2 mt-2">
                  <span className={`badge ${msg.status === 'read' ? 'badge-green' : 'badge-blue'}`}>
                    {msg.status}
                  </span>
                  <span className="text-xs text-gray-500">AI responded</span>
                </div>
              </div>
            </div>
          ))}
        </div>
      </ChartCard>

      {/* Template Management */}
      <ChartCard title="WhatsApp Templates" description="Manage approved message templates">
        <div className="overflow-x-auto">
          <table className="min-w-full divide-y divide-gray-200">
            <thead className="bg-gray-50">
              <tr>
                <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                  Template Name
                </th>
                <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                  Category
                </th>
                <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                  Status
                </th>
                <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                  Usage
                </th>
                <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                  Actions
                </th>
              </tr>
            </thead>
            <tbody className="bg-white divide-y divide-gray-200">
              <tr>
                <td className="px-6 py-4 text-sm text-gray-900">Farming Welcome</td>
                <td className="px-6 py-4 text-sm text-gray-900">UTILITY</td>
                <td className="px-6 py-4 text-sm text-gray-900">
                  <span className="badge badge-green">Approved</span>
                </td>
                <td className="px-6 py-4 text-sm text-gray-900">1,234 sent</td>
                <td className="px-6 py-4 text-sm text-gray-900">
                  <button className="btn-secondary btn-sm">Edit</button>
                </td>
              </tr>
              <tr>
                <td className="px-6 py-4 text-sm text-gray-900">Crop Alert</td>
                <td className="px-6 py-4 text-sm text-gray-900">MARKETING</td>
                <td className="px-6 py-4 text-sm text-gray-900">
                  <span className="badge badge-yellow">Pending</span>
                </td>
                <td className="px-6 py-4 text-sm text-gray-900">0 sent</td>
                <td className="px-6 py-4 text-sm text-gray-900">
                  <button className="btn-secondary btn-sm">Review</button>
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </ChartCard>
    </div>
  );
};

export default WhatsAppMonitor; 