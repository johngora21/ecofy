import React from 'react';
import { BarChart3, TrendingUp, Download, FileText, Activity, PieChart } from 'lucide-react';
import MetricCard from '../components/MetricCard';
import ChartCard from '../components/ChartCard';

const Reports = () => {
  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <h1 className="text-3xl font-bold text-textPrimary">Reports & Analytics</h1>
        <div className="flex space-x-3">
          <button className="btn-secondary flex items-center space-x-2">
            <FileText className="w-4 h-4" />
            <span>Generate Report</span>
          </button>
          <button className="btn-primary flex items-center space-x-2">
            <Download className="w-4 h-4" />
            <span>Export Data</span>
          </button>
        </div>
      </div>

      {/* Analytics Overview */}
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

      {/* Charts */}
      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
        <ChartCard title="Farm Growth" className="h-80">
          <div className="w-full h-64 flex items-center justify-center text-gray-400">
            <div className="text-center">
              <BarChart3 className="w-12 h-12 mx-auto mb-4" />
              <p>Chart Placeholder</p>
              <p className="text-sm">Farm growth over time</p>
            </div>
          </div>
        </ChartCard>

        <ChartCard title="User Activity" className="h-80">
          <div className="w-full h-64 flex items-center justify-center text-gray-400">
            <div className="text-center">
              <Activity className="w-12 h-12 mx-auto mb-4" />
              <p>Chart Placeholder</p>
              <p className="text-sm">User activity patterns</p>
            </div>
          </div>
        </ChartCard>
      </div>

      {/* Report Types */}
      <ChartCard title="Available Reports" className="h-auto">
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
          <div className="ecofy-card hover:shadow-medium transition-all duration-200 cursor-pointer">
            <BarChart3 className="w-8 h-8 mb-3 text-primary-500" />
            <h3 className="font-semibold text-textPrimary mb-2">Farm Analytics</h3>
            <p className="text-sm text-textSecondary">Comprehensive farm performance metrics</p>
          </div>
          <div className="ecofy-card hover:shadow-medium transition-all duration-200 cursor-pointer">
            <TrendingUp className="w-8 h-8 mb-3 text-success-500" />
            <h3 className="font-semibold text-textPrimary mb-2">User Growth</h3>
            <p className="text-sm text-textSecondary">User acquisition and retention data</p>
          </div>
          <div className="ecofy-card hover:shadow-medium transition-all duration-200 cursor-pointer">
            <PieChart className="w-8 h-8 mb-3 text-info-500" />
            <h3 className="font-semibold text-textPrimary mb-2">Market Analysis</h3>
            <p className="text-sm text-textSecondary">Market trends and product performance</p>
          </div>
          <div className="ecofy-card hover:shadow-medium transition-all duration-200 cursor-pointer">
            <Activity className="w-8 h-8 mb-3 text-warning-500" />
            <h3 className="font-semibold text-textPrimary mb-2">System Health</h3>
            <p className="text-sm text-textSecondary">Platform performance and uptime</p>
          </div>
          <div className="ecofy-card hover:shadow-medium transition-all duration-200 cursor-pointer">
            <FileText className="w-8 h-8 mb-3 text-secondary-500" />
            <h3 className="font-semibold text-textPrimary mb-2">Financial Report</h3>
            <p className="text-sm text-textSecondary">Revenue and transaction analysis</p>
          </div>
          <div className="ecofy-card hover:shadow-medium transition-all duration-200 cursor-pointer">
            <Download className="w-8 h-8 mb-3 text-error-500" />
            <h3 className="font-semibold text-textPrimary mb-2">Export Data</h3>
            <p className="text-sm text-textSecondary">Export all data for external analysis</p>
          </div>
        </div>
      </ChartCard>
    </div>
  );
};

export default Reports; 