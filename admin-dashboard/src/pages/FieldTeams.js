import React, { useState, useEffect } from 'react';
import { Plus, MapPin, UserCheck, Phone, Calendar, Activity, Clock, Target } from 'lucide-react';
import { apiService } from '../services/api';
import MetricCard from '../components/MetricCard';
import ChartCard from '../components/ChartCard';

const FieldTeams = () => {
  const [teams, setTeams] = useState([]);
  const [loading, setLoading] = useState(true);

  const teamData = [
    {
      id: 1,
      name: "James Mwangi",
      role: "Lead Trainer",
      region: "Dodoma",
      phone: "+255 789 123 456",
      status: "active",
      farmersAssigned: 145,
      trainingSessions: 23,
      lastActivity: "2 hours ago",
      performance: 94,
      specialization: "Crop Management"
    },
    {
      id: 2,
      name: "Grace Njoki",
      role: "Field Coordinator",
      region: "Mwanza",
      phone: "+255 756 789 012",
      status: "active",
      farmersAssigned: 89,
      trainingSessions: 18,
      lastActivity: "5 hours ago",
      performance: 91,
      specialization: "Soil Health"
    },
    {
      id: 3,
      name: "David Kiprotich",
      role: "Trainer",
      region: "Arusha",
      phone: "+255 712 345 678",
      status: "training",
      farmersAssigned: 67,
      trainingSessions: 15,
      lastActivity: "1 day ago",
      performance: 88,
      specialization: "Pest Control"
    },
    {
      id: 4,
      name: "Mary Wanjiku",
      role: "Regional Supervisor",
      region: "Mbeya",
      phone: "+255 741 852 963",
      status: "active",
      farmersAssigned: 203,
      trainingSessions: 31,
      lastActivity: "30 min ago",
      performance: 96,
      specialization: "Market Linkage"
    }
  ];

  useEffect(() => {
    setTimeout(() => {
      setTeams(teamData);
      setLoading(false);
    }, 1000);
  }, []);

  const getStatusColor = (status) => {
    switch (status) {
      case 'active': return 'badge-green';
      case 'training': return 'badge-yellow';
      case 'offline': return 'badge-red';
      default: return 'badge-gray';
    }
  };

  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <h1 className="text-3xl font-bold text-textPrimary">Field Teams Management</h1>
        <div className="flex space-x-3">
          <button className="btn-secondary flex items-center space-x-2">
            <MapPin className="w-4 h-4" />
            <span>View Map</span>
          </button>
          <button className="btn-primary flex items-center space-x-2">
            <Plus className="w-4 h-4" />
            <span>Add Team Member</span>
          </button>
        </div>
      </div>

      {/* Team Stats */}
      <div className="grid grid-cols-1 md:grid-cols-4 gap-6">
        <MetricCard
          title="Active Teams"
          value="18"
          change="+2 this month"
          icon={UserCheck}
          color="primary"
          trend="positive"
        />
        <MetricCard
          title="Total Trainers"
          value="45"
          change="8 regions covered"
          icon={UserCheck}
          color="success"
          trend="positive"
        />
        <MetricCard
          title="Farmers Reached"
          value="2,340"
          change="This month"
          icon={Target}
          color="info"
          trend="positive"
        />
        <MetricCard
          title="Avg Performance"
          value="92.3%"
          change="+2.1% improved"
          icon={Activity}
          color="secondary"
          trend="positive"
        />
      </div>

      {/* Team List */}
      <ChartCard title="Field Team Directory" description="Manage your agricultural trainers and field coordinators">
        <div className="space-y-4">
          {loading ? (
            <div className="text-center py-8">Loading field teams...</div>
          ) : (
            teams.map((member) => (
              <div key={member.id} className="flex items-center justify-between p-4 bg-white border border-gray-200 rounded-lg hover:shadow-md transition-shadow">
                <div className="flex items-center space-x-4">
                  <div className="w-12 h-12 bg-primary/10 rounded-full flex items-center justify-center">
                    <UserCheck className="w-6 h-6 text-primary" />
                  </div>
                  <div>
                    <h3 className="font-semibold text-textPrimary">{member.name}</h3>
                    <p className="text-sm text-textSecondary">{member.role}</p>
                    <div className="flex items-center space-x-4 mt-1">
                      <div className="flex items-center space-x-1">
                        <MapPin className="w-3 h-3 text-gray-400" />
                        <span className="text-xs text-gray-600">{member.region}</span>
                      </div>
                      <div className="flex items-center space-x-1">
                        <Phone className="w-3 h-3 text-gray-400" />
                        <span className="text-xs text-gray-600">{member.phone}</span>
                      </div>
                    </div>
                  </div>
                </div>

                <div className="flex items-center space-x-6">
                  <div className="text-center">
                    <p className="text-lg font-semibold text-textPrimary">{member.farmersAssigned}</p>
                    <p className="text-xs text-textSecondary">Farmers</p>
                  </div>
                  <div className="text-center">
                    <p className="text-lg font-semibold text-textPrimary">{member.trainingSessions}</p>
                    <p className="text-xs text-textSecondary">Sessions</p>
                  </div>
                  <div className="text-center">
                    <p className="text-lg font-semibold text-success">{member.performance}%</p>
                    <p className="text-xs text-textSecondary">Performance</p>
                  </div>
                  <div className="text-center">
                    <span className={`badge ${getStatusColor(member.status)}`}>
                      {member.status}
                    </span>
                    <p className="text-xs text-textSecondary mt-1">{member.lastActivity}</p>
                  </div>
                  <div className="text-center">
                    <p className="text-sm font-medium text-textPrimary">{member.specialization}</p>
                    <p className="text-xs text-textSecondary">Specialization</p>
                  </div>
                </div>

                <div className="flex space-x-2">
                  <button className="btn-secondary btn-sm">View Details</button>
                  <button className="btn-primary btn-sm">Assign Task</button>
                </div>
              </div>
            ))
          )}
        </div>
      </ChartCard>

      {/* Regional Distribution */}
      <ChartCard title="Regional Team Distribution" description="Team allocation across Tanzania">
        <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
          {[
            { region: "Dodoma", teams: 4, farmers: 1200, status: "optimal" },
            { region: "Mwanza", teams: 3, farmers: 890, status: "good" },
            { region: "Arusha", teams: 2, farmers: 750, status: "needs_support" },
            { region: "Mbeya", teams: 3, farmers: 980, status: "good" },
            { region: "Iringa", teams: 2, farmers: 620, status: "adequate" },
            { region: "Tabora", teams: 2, farmers: 580, status: "adequate" },
            { region: "Rukwa", teams: 1, farmers: 340, status: "needs_support" },
            { region: "Ruvuma", teams: 1, farmers: 390, status: "needs_support" }
          ].map((region, index) => (
            <div key={index} className="p-4 bg-white border border-gray-200 rounded-lg">
              <div className="flex items-center justify-between mb-2">
                <h4 className="font-semibold text-textPrimary">{region.region}</h4>
                <span className={`badge ${
                  region.status === 'optimal' ? 'badge-green' :
                  region.status === 'good' ? 'badge-blue' :
                  region.status === 'adequate' ? 'badge-yellow' :
                  'badge-red'
                }`}>
                  {region.status.replace('_', ' ')}
                </span>
              </div>
              <div className="space-y-1">
                <div className="flex justify-between text-sm">
                  <span className="text-textSecondary">Teams:</span>
                  <span className="font-medium">{region.teams}</span>
                </div>
                <div className="flex justify-between text-sm">
                  <span className="text-textSecondary">Farmers:</span>
                  <span className="font-medium">{region.farmers}</span>
                </div>
                <div className="flex justify-between text-sm">
                  <span className="text-textSecondary">Ratio:</span>
                  <span className="font-medium">{Math.round(region.farmers / region.teams)}/team</span>
                </div>
              </div>
            </div>
          ))}
        </div>
      </ChartCard>
    </div>
  );
};

export default FieldTeams; 