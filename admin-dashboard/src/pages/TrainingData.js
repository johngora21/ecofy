import React, { useState, useEffect } from 'react';
import { Plus, Upload, Download, Edit, Trash2, Database } from 'lucide-react';
import { apiService } from '../services/api';
import MetricCard from '../components/MetricCard';
import ChartCard from '../components/ChartCard';

const TrainingData = () => {
  const [trainingData, setTrainingData] = useState([]);
  const [loading, setLoading] = useState(true);
  const [showAddModal, setShowAddModal] = useState(false);

  useEffect(() => {
    fetchTrainingData();
  }, []);

  const fetchTrainingData = async () => {
    try {
      setLoading(true);
      const data = await apiService.getTrainingData();
      setTrainingData(data);
    } catch (error) {
      console.error('Error fetching training data:', error);
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <h1 className="text-3xl font-bold text-textPrimary">Training Data Management</h1>
        <div className="flex space-x-3">
          <button className="btn-secondary flex items-center space-x-2">
            <Upload className="w-4 h-4" />
            <span>Upload Excel</span>
          </button>
          <button className="btn-primary flex items-center space-x-2">
            <Plus className="w-4 h-4" />
            <span>Add Data</span>
          </button>
        </div>
      </div>

      {/* Stats */}
      <div className="grid grid-cols-1 md:grid-cols-4 gap-6">
        <MetricCard
          title="Total Records"
          value="12,450"
          change="+235 this week"
          icon={Database}
          color="primary"
          trend="positive"
        />
        <MetricCard
          title="English Records"
          value="7,200"
          change="58% of total"
          icon={Database}
          color="secondary"
          trend="neutral"
        />
        <MetricCard
          title="Swahili Records"
          value="5,250"
          change="42% of total"
          icon={Database}
          color="info"
          trend="positive"
        />
        <MetricCard
          title="Pending Review"
          value="125"
          change="Needs attention"
          icon={Database}
          color="warning"
          trend="neutral"
        />
      </div>

      {/* Training Data Table */}
      <ChartCard title="Training Data Records" description="Manage AI training datasets">
        <div className="overflow-x-auto">
          <table className="min-w-full divide-y divide-gray-200">
            <thead className="bg-gray-50">
              <tr>
                <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                  Question
                </th>
                <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                  Answer
                </th>
                <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                  Language
                </th>
                <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                  Category
                </th>
                <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                  Actions
                </th>
              </tr>
            </thead>
            <tbody className="bg-white divide-y divide-gray-200">
              {loading ? (
                <tr>
                  <td colSpan="5" className="px-6 py-4 text-center text-gray-500">
                    Loading training data...
                  </td>
                </tr>
              ) : (
                <>
                  <tr>
                    <td className="px-6 py-4 text-sm text-gray-900">
                      What is the best time to plant maize in Tanzania?
                    </td>
                    <td className="px-6 py-4 text-sm text-gray-900">
                      Plant maize during the main rainy season (November-May)...
                    </td>
                    <td className="px-6 py-4 text-sm text-gray-900">
                      <span className="badge badge-blue">English</span>
                    </td>
                    <td className="px-6 py-4 text-sm text-gray-900">
                      <span className="badge badge-green">Crops</span>
                    </td>
                    <td className="px-6 py-4 text-sm text-gray-900">
                      <div className="flex space-x-2">
                        <button className="p-2 text-blue-600 hover:bg-blue-100 rounded">
                          <Edit className="w-4 h-4" />
                        </button>
                        <button className="p-2 text-red-600 hover:bg-red-100 rounded">
                          <Trash2 className="w-4 h-4" />
                        </button>
                      </div>
                    </td>
                  </tr>
                  <tr>
                    <td className="px-6 py-4 text-sm text-gray-900">
                      Ni wakati gani bora wa kupanda mahindi Tanzania?
                    </td>
                    <td className="px-6 py-4 text-sm text-gray-900">
                      Panda mahindi wakati wa mvua kuu (Novemba-Mei)...
                    </td>
                    <td className="px-6 py-4 text-sm text-gray-900">
                      <span className="badge badge-yellow">Swahili</span>
                    </td>
                    <td className="px-6 py-4 text-sm text-gray-900">
                      <span className="badge badge-green">Mazao</span>
                    </td>
                    <td className="px-6 py-4 text-sm text-gray-900">
                      <div className="flex space-x-2">
                        <button className="p-2 text-blue-600 hover:bg-blue-100 rounded">
                          <Edit className="w-4 h-4" />
                        </button>
                        <button className="p-2 text-red-600 hover:bg-red-100 rounded">
                          <Trash2 className="w-4 h-4" />
                        </button>
                      </div>
                    </td>
                  </tr>
                </>
              )}
            </tbody>
          </table>
        </div>
      </ChartCard>
    </div>
  );
};

export default TrainingData; 