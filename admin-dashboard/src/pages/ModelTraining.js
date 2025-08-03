import React, { useState, useEffect } from 'react';
import { Play, Pause, RotateCcw, Settings, Brain, CheckCircle, Clock, AlertTriangle } from 'lucide-react';
import { apiService } from '../services/api';
import MetricCard from '../components/MetricCard';
import ChartCard from '../components/ChartCard';

const ModelTraining = () => {
  const [trainingJobs, setTrainingJobs] = useState([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    fetchTrainingJobs();
  }, []);

  const fetchTrainingJobs = async () => {
    try {
      setLoading(true);
      const jobs = await apiService.getTrainingJobs();
      setTrainingJobs(jobs);
    } catch (error) {
      console.error('Error fetching training jobs:', error);
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <h1 className="text-3xl font-bold text-textPrimary">Model Training</h1>
        <div className="flex space-x-3">
          <button className="btn-secondary flex items-center space-x-2">
            <Settings className="w-4 h-4" />
            <span>Configure</span>
          </button>
          <button className="btn-primary flex items-center space-x-2">
            <Play className="w-4 h-4" />
            <span>Start Training</span>
          </button>
        </div>
      </div>

      {/* Training Stats */}
      <div className="grid grid-cols-1 md:grid-cols-4 gap-6">
        <MetricCard
          title="Active Training"
          value="1"
          change="In progress"
          icon={Brain}
          color="info"
          trend="neutral"
        />
        <MetricCard
          title="Completed Jobs"
          value="24"
          change="+3 this month"
          icon={CheckCircle}
          color="success"
          trend="positive"
        />
        <MetricCard
          title="Model Accuracy"
          value="94.2%"
          change="+1.2% improved"
          icon={Brain}
          color="primary"
          trend="positive"
        />
        <MetricCard
          title="Training Time"
          value="2.5h"
          change="Average duration"
          icon={Clock}
          color="secondary"
          trend="neutral"
        />
      </div>

      {/* Current Training Job */}
      <ChartCard title="Current Training Job" description="Monitor active model training">
        <div className="space-y-4">
          <div className="flex items-center justify-between">
            <div className="flex items-center space-x-3">
              <div className="w-3 h-3 bg-blue-500 rounded-full animate-pulse"></div>
              <span className="font-medium">GPT-4o Fine-tuning - Agricultural Data v2.3</span>
            </div>
            <span className="badge badge-blue">Training</span>
          </div>
          
          <div className="space-y-2">
            <div className="flex justify-between text-sm">
              <span>Progress</span>
              <span>67%</span>
            </div>
            <div className="w-full bg-gray-200 rounded-full h-2">
              <div className="bg-blue-600 h-2 rounded-full" style={{ width: '67%' }}></div>
            </div>
          </div>

          <div className="grid grid-cols-3 gap-4 mt-4">
            <div className="text-center">
              <p className="text-2xl font-bold text-primary">15,240</p>
              <p className="text-sm text-gray-600">Training Examples</p>
            </div>
            <div className="text-center">
              <p className="text-2xl font-bold text-secondary">2.1h</p>
              <p className="text-sm text-gray-600">Elapsed Time</p>
            </div>
            <div className="text-center">
              <p className="text-2xl font-bold text-info">0.8h</p>
              <p className="text-sm text-gray-600">Remaining</p>
            </div>
          </div>
        </div>
      </ChartCard>

      {/* Training History */}
      <ChartCard title="Training History" description="Previous training jobs and results">
        <div className="overflow-x-auto">
          <table className="min-w-full divide-y divide-gray-200">
            <thead className="bg-gray-50">
              <tr>
                <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                  Job Name
                </th>
                <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                  Status
                </th>
                <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                  Accuracy
                </th>
                <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                  Duration
                </th>
                <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                  Started
                </th>
                <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                  Actions
                </th>
              </tr>
            </thead>
            <tbody className="bg-white divide-y divide-gray-200">
              <tr>
                <td className="px-6 py-4 text-sm text-gray-900">
                  Agricultural Data v2.2
                </td>
                <td className="px-6 py-4 text-sm text-gray-900">
                  <span className="badge badge-green">Completed</span>
                </td>
                <td className="px-6 py-4 text-sm text-gray-900">93.8%</td>
                <td className="px-6 py-4 text-sm text-gray-900">2h 15m</td>
                <td className="px-6 py-4 text-sm text-gray-900">2 days ago</td>
                <td className="px-6 py-4 text-sm text-gray-900">
                  <button className="btn-secondary btn-sm">Deploy</button>
                </td>
              </tr>
              <tr>
                <td className="px-6 py-4 text-sm text-gray-900">
                  Agricultural Data v2.1
                </td>
                <td className="px-6 py-4 text-sm text-gray-900">
                  <span className="badge badge-green">Completed</span>
                </td>
                <td className="px-6 py-4 text-sm text-gray-900">92.1%</td>
                <td className="px-6 py-4 text-sm text-gray-900">1h 58m</td>
                <td className="px-6 py-4 text-sm text-gray-900">1 week ago</td>
                <td className="px-6 py-4 text-sm text-gray-900">
                  <button className="btn-secondary btn-sm">View</button>
                </td>
              </tr>
              <tr>
                <td className="px-6 py-4 text-sm text-gray-900">
                  Agricultural Data v2.0
                </td>
                <td className="px-6 py-4 text-sm text-gray-900">
                  <span className="badge badge-red">Failed</span>
                </td>
                <td className="px-6 py-4 text-sm text-gray-900">-</td>
                <td className="px-6 py-4 text-sm text-gray-900">45m</td>
                <td className="px-6 py-4 text-sm text-gray-900">2 weeks ago</td>
                <td className="px-6 py-4 text-sm text-gray-900">
                  <button className="btn-secondary btn-sm">Retry</button>
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </ChartCard>
    </div>
  );
};

export default ModelTraining; 