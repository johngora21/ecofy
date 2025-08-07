import React from 'react';
import { Settings, Shield, Database, Globe, Bell, User } from 'lucide-react';
import MetricCard from '../components/MetricCard';
import ChartCard from '../components/ChartCard';

const SettingsPage = () => {
  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <h1 className="text-3xl font-bold text-textPrimary">Settings</h1>
        <div className="flex space-x-3">
          <button className="btn-secondary flex items-center space-x-2">
            <Database className="w-4 h-4" />
            <span>Backup Data</span>
          </button>
          <button className="btn-primary flex items-center space-x-2">
            <Settings className="w-4 h-4" />
            <span>Save Changes</span>
          </button>
        </div>
      </div>

      {/* System Stats */}
      <div className="grid grid-cols-1 md:grid-cols-4 gap-6">
        <MetricCard
          title="System Uptime"
          value="99.9%"
          change="Last 30 days"
          icon={Settings}
          color="primary"
          trend="positive"
        />
        <MetricCard
          title="Database Size"
          value="2.4 GB"
          change="+0.2 GB this week"
          icon={Database}
          color="info"
          trend="neutral"
        />
        <MetricCard
          title="Active Users"
          value="1,890"
          change="Currently online"
          icon={User}
          color="success"
          trend="positive"
        />
        <MetricCard
          title="API Calls"
          value="45.2K"
          change="Today's requests"
          icon={Globe}
          color="secondary"
          trend="positive"
        />
      </div>

      {/* Settings Sections */}
      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
        <ChartCard title="App Configuration" className="h-auto">
          <div className="space-y-4">
            <div>
              <label className="block text-sm font-medium text-textPrimary mb-2">App Name</label>
              <input type="text" defaultValue="Ecofy Admin" className="input-field" />
            </div>
            <div>
              <label className="block text-sm font-medium text-textPrimary mb-2">API Base URL</label>
              <input type="text" defaultValue="https://api.ecofy.com" className="input-field" />
            </div>
            <div>
              <label className="block text-sm font-medium text-textPrimary mb-2">Environment</label>
              <select className="input-field">
                <option>Production</option>
                <option>Staging</option>
                <option>Development</option>
              </select>
            </div>
            <div className="flex items-center space-x-2">
              <input type="checkbox" id="maintenance" className="rounded" />
              <label htmlFor="maintenance" className="text-sm text-textPrimary">Maintenance Mode</label>
            </div>
          </div>
        </ChartCard>

        <ChartCard title="Admin Settings" className="h-auto">
          <div className="space-y-4">
            <div>
              <label className="block text-sm font-medium text-textPrimary mb-2">Admin Email</label>
              <input type="email" defaultValue="admin@ecofy.com" className="input-field" />
            </div>
            <div>
              <label className="block text-sm font-medium text-textPrimary mb-2">Notification Email</label>
              <input type="email" defaultValue="notifications@ecofy.com" className="input-field" />
            </div>
            <div>
              <label className="block text-sm font-medium text-textPrimary mb-2">Default Language</label>
              <select className="input-field">
                <option>English</option>
                <option>Swahili</option>
              </select>
            </div>
            <div className="flex items-center space-x-2">
              <input type="checkbox" id="notifications" className="rounded" defaultChecked />
              <label htmlFor="notifications" className="text-sm text-textPrimary">Enable Notifications</label>
            </div>
          </div>
        </ChartCard>
      </div>

      {/* Security Settings */}
      <ChartCard title="Security Settings" className="h-auto">
        <div className="space-y-4">
          <div className="flex items-center justify-between p-4 bg-gray-50 rounded-lg">
            <div>
              <h3 className="font-semibold text-textPrimary">Two-Factor Authentication</h3>
              <p className="text-sm text-textSecondary">Enhance account security</p>
            </div>
            <button className="btn-outline">Enable</button>
          </div>
          <div className="flex items-center justify-between p-4 bg-gray-50 rounded-lg">
            <div>
              <h3 className="font-semibold text-textPrimary">API Key Management</h3>
              <p className="text-sm text-textSecondary">Manage API access keys</p>
            </div>
            <button className="btn-outline">Manage</button>
          </div>
          <div className="flex items-center justify-between p-4 bg-gray-50 rounded-lg">
            <div>
              <h3 className="font-semibold text-textPrimary">Data Backup</h3>
              <p className="text-sm text-textSecondary">Schedule automatic backups</p>
            </div>
            <button className="btn-outline">Configure</button>
          </div>
        </div>
      </ChartCard>
    </div>
  );
};

export default SettingsPage; 