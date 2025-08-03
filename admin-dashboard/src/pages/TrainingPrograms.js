import React, { useState, useEffect } from 'react';
import { Plus, BookOpen, Users, Calendar, Award, Clock, CheckCircle, AlertCircle } from 'lucide-react';
import { BarChart, Bar, XAxis, YAxis, CartesianGrid, ResponsiveContainer, PieChart, Pie, Cell } from 'recharts';
import MetricCard from '../components/MetricCard';
import ChartCard from '../components/ChartCard';

const TrainingPrograms = () => {
  const [programs, setPrograms] = useState([]);
  const [loading, setLoading] = useState(true);

  const programData = [
    {
      id: 1,
      name: "Climate-Smart Agriculture",
      description: "Training on sustainable farming practices for climate resilience",
      duration: "2 weeks",
      status: "active",
      enrolled: 245,
      completed: 189,
      completionRate: 77,
      trainer: "Dr. Sarah Mwema",
      startDate: "2025-01-15",
      modules: 8,
      certification: true
    },
    {
      id: 2,
      name: "Soil Health Management",
      description: "Understanding soil composition and health monitoring techniques",
      duration: "10 days",
      status: "active",
      enrolled: 156,
      completed: 134,
      completionRate: 86,
      trainer: "Prof. John Kibwana",
      startDate: "2025-01-20",
      modules: 6,
      certification: true
    },
    {
      id: 3,
      name: "Pest Control & Disease Management",
      description: "Integrated pest management using sustainable methods",
      duration: "1 week",
      status: "completed",
      enrolled: 89,
      completed: 82,
      completionRate: 92,
      trainer: "Dr. Grace Temba",
      startDate: "2025-01-05",
      modules: 5,
      certification: false
    },
    {
      id: 4,
      name: "Market Linkage & Value Addition",
      description: "Connecting farmers to markets and adding value to crops",
      duration: "3 weeks",
      status: "planning",
      enrolled: 0,
      completed: 0,
      completionRate: 0,
      trainer: "Ms. Mary Nyong",
      startDate: "2025-02-01",
      modules: 12,
      certification: true
    }
  ];

  const completionData = [
    { month: 'Oct', completed: 145, target: 150 },
    { month: 'Nov', completed: 178, target: 180 },
    { month: 'Dec', completed: 203, target: 200 },
    { month: 'Jan', completed: 189, target: 220 }
  ];

  const categoryData = [
    { name: 'Climate Adaptation', value: 35, color: '#22c55e' },
    { name: 'Soil Management', value: 25, color: '#3b82f6' },
    { name: 'Pest Control', value: 20, color: '#f59e0b' },
    { name: 'Market Access', value: 20, color: '#ef4444' }
  ];

  useEffect(() => {
    setTimeout(() => {
      setPrograms(programData);
      setLoading(false);
    }, 1000);
  }, []);

  const getStatusColor = (status) => {
    switch (status) {
      case 'active': return 'badge-green';
      case 'completed': return 'badge-blue';
      case 'planning': return 'badge-yellow';
      case 'paused': return 'badge-red';
      default: return 'badge-gray';
    }
  };

  const getStatusIcon = (status) => {
    switch (status) {
      case 'active': return CheckCircle;
      case 'completed': return Award;
      case 'planning': return Clock;
      case 'paused': return AlertCircle;
      default: return Clock;
    }
  };

  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <h1 className="text-3xl font-bold text-textPrimary">Training Programs</h1>
        <div className="flex space-x-3">
          <button className="btn-secondary flex items-center space-x-2">
            <Calendar className="w-4 h-4" />
            <span>Schedule</span>
          </button>
          <button className="btn-primary flex items-center space-x-2">
            <Plus className="w-4 h-4" />
            <span>New Program</span>
          </button>
        </div>
      </div>

      {/* Program Stats */}
      <div className="grid grid-cols-1 md:grid-cols-4 gap-6">
        <MetricCard
          title="Active Programs"
          value="12"
          change="+3 this month"
          icon={BookOpen}
          color="primary"
          trend="positive"
        />
        <MetricCard
          title="Total Enrolled"
          value="2,340"
          change="8 regions"
          icon={Users}
          color="success"
          trend="positive"
        />
        <MetricCard
          title="Completion Rate"
          value="84.7%"
          change="+5.2% improved"
          icon={Award}
          color="info"
          trend="positive"
        />
        <MetricCard
          title="Certified Farmers"
          value="1,980"
          change="This quarter"
          icon={CheckCircle}
          color="secondary"
          trend="positive"
        />
      </div>

      {/* Charts */}
      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
        <ChartCard title="Monthly Completion Trends" description="Training completion vs targets">
          <ResponsiveContainer width="100%" height={250}>
            <BarChart data={completionData}>
              <CartesianGrid strokeDasharray="3 3" />
              <XAxis dataKey="month" />
              <YAxis />
              <Bar dataKey="completed" fill="#22c55e" />
              <Bar dataKey="target" fill="#e5e7eb" />
            </BarChart>
          </ResponsiveContainer>
        </ChartCard>

        <ChartCard title="Program Categories" description="Distribution of training focus areas">
          <ResponsiveContainer width="100%" height={250}>
            <PieChart>
              <Pie
                data={categoryData}
                cx="50%"
                cy="50%"
                innerRadius={60}
                outerRadius={100}
                dataKey="value"
              >
                {categoryData.map((entry, index) => (
                  <Cell key={`cell-${index}`} fill={entry.color} />
                ))}
              </Pie>
            </PieChart>
          </ResponsiveContainer>
          <div className="mt-4 grid grid-cols-2 gap-2">
            {categoryData.map((item, index) => (
              <div key={index} className="flex items-center space-x-2">
                <div className="w-3 h-3 rounded-full" style={{ backgroundColor: item.color }}></div>
                <span className="text-xs text-gray-600">{item.name}</span>
              </div>
            ))}
          </div>
        </ChartCard>
      </div>

      {/* Programs List */}
      <ChartCard title="Training Programs Directory" description="Manage farmer education and certification programs">
        <div className="space-y-4">
          {loading ? (
            <div className="text-center py-8">Loading programs...</div>
          ) : (
            programs.map((program) => {
              const StatusIcon = getStatusIcon(program.status);
              return (
                <div key={program.id} className="flex items-center justify-between p-4 bg-white border border-gray-200 rounded-lg hover:shadow-md transition-shadow">
                  <div className="flex items-center space-x-4">
                    <div className={`w-12 h-12 rounded-full flex items-center justify-center ${
                      program.status === 'active' ? 'bg-green-100 text-green-600' :
                      program.status === 'completed' ? 'bg-blue-100 text-blue-600' :
                      program.status === 'planning' ? 'bg-yellow-100 text-yellow-600' :
                      'bg-gray-100 text-gray-600'
                    }`}>
                      <StatusIcon className="w-6 h-6" />
                    </div>
                    <div>
                      <h3 className="font-semibold text-textPrimary">{program.name}</h3>
                      <p className="text-sm text-textSecondary mb-1">{program.description}</p>
                      <div className="flex items-center space-x-4 text-xs text-gray-500">
                        <span>👨‍🏫 {program.trainer}</span>
                        <span>📅 {program.startDate}</span>
                        <span>⏱️ {program.duration}</span>
                        <span>📚 {program.modules} modules</span>
                      </div>
                    </div>
                  </div>

                  <div className="flex items-center space-x-6">
                    <div className="text-center">
                      <p className="text-lg font-semibold text-textPrimary">{program.enrolled}</p>
                      <p className="text-xs text-textSecondary">Enrolled</p>
                    </div>
                    <div className="text-center">
                      <p className="text-lg font-semibold text-textPrimary">{program.completed}</p>
                      <p className="text-xs text-textSecondary">Completed</p>
                    </div>
                    <div className="text-center">
                      <p className="text-lg font-semibold text-success">{program.completionRate}%</p>
                      <p className="text-xs text-textSecondary">Success Rate</p>
                    </div>
                    <div className="text-center">
                      <span className={`badge ${getStatusColor(program.status)}`}>
                        {program.status}
                      </span>
                      {program.certification && (
                        <div className="flex items-center mt-1">
                          <Award className="w-3 h-3 text-yellow-500 mr-1" />
                          <span className="text-xs text-yellow-600">Certified</span>
                        </div>
                      )}
                    </div>
                  </div>

                  <div className="flex space-x-2">
                    <button className="btn-secondary btn-sm">Edit</button>
                    <button className="btn-primary btn-sm">View Details</button>
                  </div>
                </div>
              );
            })
          )}
        </div>
      </ChartCard>
    </div>
  );
};

export default TrainingPrograms; 