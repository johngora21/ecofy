import React from 'react';
import { BarChart3, TrendingUp, PieChart, Activity } from 'lucide-react';
import { AreaChart, Area, XAxis, YAxis, CartesianGrid, ResponsiveContainer, BarChart, Bar, PieChart as RechartsPieChart, Pie, Cell } from 'recharts';
import MetricCard from '../components/MetricCard';
import ChartCard from '../components/ChartCard';

const Analytics = () => {
  const usageData = [
    { name: 'Jan', users: 1200, messages: 4800 },
    { name: 'Feb', users: 1450, messages: 5200 },
    { name: 'Mar', users: 1680, messages: 6100 },
    { name: 'Apr', users: 1890, messages: 6800 },
    { name: 'May', users: 2100, messages: 7500 },
    { name: 'Jun', users: 2350, messages: 8200 }
  ];

  const languageData = [
    { name: 'Swahili', value: 65, color: '#22c55e' },
    { name: 'English', value: 35, color: '#3b82f6' }
  ];

  return (
    <div className="space-y-6">
      <h1 className="text-3xl font-bold text-textPrimary">Analytics</h1>
      
      <div className="grid grid-cols-1 md:grid-cols-4 gap-6">
        <MetricCard
          title="Total Sessions"
          value="15,420"
          change="+12.5% vs last month"
          icon={Activity}
          color="primary"
          trend="positive"
        />
        <MetricCard
          title="Avg Session Time"
          value="3.2 min"
          change="+0.4 min improved"
          icon={TrendingUp}
          color="success"
          trend="positive"
        />
        <MetricCard
          title="User Retention"
          value="78.3%"
          change="+5.1% this month"
          icon={BarChart3}
          color="info"
          trend="positive"
        />
        <MetricCard
          title="AI Accuracy"
          value="94.7%"
          change="+1.3% improved"
          icon={PieChart}
          color="secondary"
          trend="positive"
        />
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
        <ChartCard title="User Growth" description="Monthly active users and messages">
          <ResponsiveContainer width="100%" height={300}>
            <AreaChart data={usageData}>
              <CartesianGrid strokeDasharray="3 3" />
              <XAxis dataKey="name" />
              <YAxis />
              <Area type="monotone" dataKey="users" stackId="1" stroke="#22c55e" fill="#22c55e" />
              <Area type="monotone" dataKey="messages" stackId="1" stroke="#3b82f6" fill="#3b82f6" />
            </AreaChart>
          </ResponsiveContainer>
        </ChartCard>

        <ChartCard title="Language Usage" description="Preferred communication language">
          <ResponsiveContainer width="100%" height={300}>
            <RechartsPieChart>
              <Pie
                data={languageData}
                cx="50%"
                cy="50%"
                outerRadius={80}
                dataKey="value"
                label={({ name, value }) => `${name}: ${value}%`}
              >
                {languageData.map((entry, index) => (
                  <Cell key={`cell-${index}`} fill={entry.color} />
                ))}
              </Pie>
            </RechartsPieChart>
          </ResponsiveContainer>
        </ChartCard>
      </div>
    </div>
  );
};

export default Analytics; 