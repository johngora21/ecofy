import React from 'react';
import { Settings as SettingsIcon, Bell, Shield, Database, Globe } from 'lucide-react';
import ChartCard from '../components/ChartCard';

const Settings = () => {
  return (
    <div className="space-y-6">
      <h1 className="text-3xl font-bold text-textPrimary">Settings</h1>
      
      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
        <ChartCard title="AI Model Configuration" description="Configure OpenAI GPT settings">
          <div className="space-y-4">
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-2">Current Model</label>
              <select className="input-field">
                <option>gpt-4o-fine-tuned-v2.3</option>
                <option>gpt-4o</option>
                <option>gpt-4o-mini</option>
              </select>
            </div>
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-2">Temperature</label>
              <input type="range" min="0" max="1" step="0.1" defaultValue="0.7" className="w-full" />
              <div className="flex justify-between text-xs text-gray-500">
                <span>Conservative</span>
                <span>0.7</span>
                <span>Creative</span>
              </div>
            </div>
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-2">Max Tokens</label>
              <input type="number" defaultValue="1500" className="input-field" />
            </div>
          </div>
        </ChartCard>

        <ChartCard title="Voice Training Settings" description="Tanzanian accent configuration">
          <div className="space-y-4">
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-2">Voice Model</label>
              <select className="input-field">
                <option>Tanzanian Swahili v1.2</option>
                <option>Standard Swahili</option>
                <option>English (Tanzanian)</option>
              </select>
            </div>
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-2">Voice Speed</label>
              <input type="range" min="0.5" max="2" step="0.1" defaultValue="1" className="w-full" />
              <div className="flex justify-between text-xs text-gray-500">
                <span>Slow</span>
                <span>1.0x</span>
                <span>Fast</span>
              </div>
            </div>
            <div className="flex items-center justify-between">
              <span className="text-sm font-medium text-gray-700">Auto Voice Training</span>
              <input type="checkbox" defaultChecked className="toggle" />
            </div>
          </div>
        </ChartCard>

        <ChartCard title="WhatsApp Configuration" description="Beem Africa API settings">
          <div className="space-y-4">
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-2">API Key</label>
              <input type="password" placeholder="••••••••" className="input-field" />
            </div>
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-2">Secret Key</label>
              <input type="password" placeholder="••••••••" className="input-field" />
            </div>
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-2">From Number</label>
              <input type="text" placeholder="+255 XXX XXX XXX" className="input-field" />
            </div>
            <button className="btn-primary">Test Connection</button>
          </div>
        </ChartCard>

        <ChartCard title="Notification Settings" description="Configure alerts and notifications">
          <div className="space-y-4">
            {[
              { label: "New Training Data", checked: true },
              { label: "Model Training Complete", checked: true },
              { label: "WhatsApp Message Alerts", checked: false },
              { label: "System Health Alerts", checked: true },
              { label: "User Feedback Notifications", checked: false }
            ].map((setting, index) => (
              <div key={index} className="flex items-center justify-between">
                <span className="text-sm font-medium text-gray-700">{setting.label}</span>
                <input type="checkbox" defaultChecked={setting.checked} className="toggle" />
              </div>
            ))}
          </div>
        </ChartCard>
      </div>

      <div className="flex justify-end space-x-4">
        <button className="btn-secondary">Reset to Defaults</button>
        <button className="btn-primary">Save Settings</button>
      </div>
    </div>
  );
};

export default Settings; 