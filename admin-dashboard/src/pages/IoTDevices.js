import React, { useState, useEffect } from 'react';
import { Plus, Wifi, Battery, MapPin, Activity, AlertTriangle, CheckCircle, Settings, Zap } from 'lucide-react';
import { LineChart, Line, XAxis, YAxis, CartesianGrid, ResponsiveContainer, BarChart, Bar } from 'recharts';
// import { apiService } from '../services/api';
import MetricCard from '../components/MetricCard';
import ChartCard from '../components/ChartCard';

const IoTDevices = () => {
  const [devices, setDevices] = useState([]);
  const [loading, setLoading] = useState(true);

  const deviceData = [
    {
      id: "ECO-001",
      name: "Kit Dodoma-Central-01",
      location: "Dodoma Central",
      gps: "-6.1722, 35.7414",
      status: "active",
      batteryLevel: 85,
      lastReading: "5 min ago",
      readingsToday: 24,
      soilPH: 6.8,
      moisture: 45,
      temperature: 28.5,
      assignedFarmer: "John Mwema",
      farmSize: "2.5 acres"
    },
    {
      id: "ECO-002",
      name: "Kit Mwanza-Lake-02",
      location: "Mwanza Lakeside",
      gps: "-2.5164, 32.9175",
      status: "active",
      batteryLevel: 92,
      lastReading: "12 min ago",
      readingsToday: 18,
      soilPH: 7.2,
      moisture: 38,
      temperature: 31.2,
      assignedFarmer: "Grace Nyong",
      farmSize: "1.8 acres"
    },
    {
      id: "ECO-003",
      name: "Kit Arusha-Highland-03",
      location: "Arusha Highlands",
      gps: "-3.3869, 36.6830",
      status: "low_battery",
      batteryLevel: 15,
      lastReading: "2 hours ago",
      readingsToday: 8,
      soilPH: 6.5,
      moisture: 52,
      temperature: 24.8,
      assignedFarmer: "David Kisia",
      farmSize: "3.2 acres"
    },
    {
      id: "ECO-004",
      name: "Kit Mbeya-South-04",
      location: "Mbeya Southern",
      gps: "-8.9094, 33.4607",
      status: "maintenance",
      batteryLevel: 0,
      lastReading: "3 days ago",
      readingsToday: 0,
      soilPH: null,
      moisture: null,
      temperature: null,
      assignedFarmer: "Mary Temba",
      farmSize: "4.1 acres"
    }
  ];

  const performanceData = [
    { time: '00:00', readings: 120, uptime: 98 },
    { time: '04:00', readings: 85, uptime: 97 },
    { time: '08:00', readings: 340, uptime: 99 },
    { time: '12:00', readings: 450, uptime: 96 },
    { time: '16:00', readings: 380, uptime: 98 },
    { time: '20:00', readings: 290, uptime: 97 },
    { time: '24:00', readings: 180, uptime: 99 }
  ];

  const getStatusColor = (status) => {
    switch (status) {
      case 'active': return 'badge-green';
      case 'low_battery': return 'badge-yellow';
      case 'maintenance': return 'badge-red';
      case 'offline': return 'badge-gray';
      default: return 'badge-gray';
    }
  };

  const getBatteryColor = (level) => {
    if (level > 60) return 'text-green-600';
    if (level > 30) return 'text-yellow-600';
    return 'text-red-600';
  };

  useEffect(() => {
    setTimeout(() => {
      setDevices(deviceData);
      setLoading(false);
    }, 1000);
  }, [deviceData]);

  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <h1 className="text-3xl font-bold text-textPrimary">IoT Device Management</h1>
        <div className="flex space-x-3">
          <button className="btn-secondary flex items-center space-x-2">
            <MapPin className="w-4 h-4" />
            <span>Device Map</span>
          </button>
          <button className="btn-primary flex items-center space-x-2">
            <Plus className="w-4 h-4" />
            <span>Deploy Kit</span>
          </button>
        </div>
      </div>

      {/* IoT Stats */}
      <div className="grid grid-cols-1 md:grid-cols-4 gap-6">
        <MetricCard
          title="Active Devices"
          value="1,240"
          change="+45 this week"
          icon={Wifi}
          color="primary"
          trend="positive"
        />
        <MetricCard
          title="Uptime"
          value="94.2%"
          change="Above target"
          icon={Activity}
          color="success"
          trend="positive"
        />
        <MetricCard
          title="Data Points"
          value="89,450"
          change="Today: 4,520"
          icon={Zap}
          color="info"
          trend="positive"
        />
        <MetricCard
          title="Maintenance"
          value="23"
          change="Requires attention"
          icon={AlertTriangle}
          color="warning"
          trend="neutral"
        />
      </div>

      {/* Device Performance */}
      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
        <ChartCard title="Daily Performance" description="Device readings and uptime over 24 hours">
          <ResponsiveContainer width="100%" height={250}>
            <LineChart data={performanceData}>
              <CartesianGrid strokeDasharray="3 3" />
              <XAxis dataKey="time" />
              <YAxis />
              <Line type="monotone" dataKey="readings" stroke="#22c55e" strokeWidth={2} />
              <Line type="monotone" dataKey="uptime" stroke="#3b82f6" strokeWidth={2} />
            </LineChart>
          </ResponsiveContainer>
        </ChartCard>

        <ChartCard title="Regional Distribution" description="Device deployment by region">
          <ResponsiveContainer width="100%" height={250}>
            <BarChart data={[
              { region: 'Dodoma', devices: 245, active: 230 },
              { region: 'Mwanza', devices: 189, active: 178 },
              { region: 'Arusha', devices: 167, active: 152 },
              { region: 'Mbeya', devices: 198, active: 186 },
              { region: 'Iringa', devices: 156, active: 142 },
              { region: 'Others', devices: 285, active: 268 }
            ]}>
              <CartesianGrid strokeDasharray="3 3" />
              <XAxis dataKey="region" />
              <YAxis />
              <Bar dataKey="devices" fill="#e5e7eb" />
              <Bar dataKey="active" fill="#22c55e" />
            </BarChart>
          </ResponsiveContainer>
        </ChartCard>
      </div>

      {/* Device List */}
      <ChartCard title="Device Directory" description="Monitor and manage your EcoFy IoT soil testing kits">
        <div className="space-y-4">
          {loading ? (
            <div className="text-center py-8">Loading devices...</div>
          ) : (
            devices.map((device) => (
              <div key={device.id} className="flex items-center justify-between p-4 bg-white border border-gray-200 rounded-lg hover:shadow-md transition-shadow">
                <div className="flex items-center space-x-4">
                  <div className={`w-12 h-12 rounded-full flex items-center justify-center ${
                    device.status === 'active' ? 'bg-green-100 text-green-600' :
                    device.status === 'low_battery' ? 'bg-yellow-100 text-yellow-600' :
                    device.status === 'maintenance' ? 'bg-red-100 text-red-600' :
                    'bg-gray-100 text-gray-600'
                  }`}>
                    <Wifi className="w-6 h-6" />
                  </div>
                  <div>
                    <h3 className="font-semibold text-textPrimary">{device.name}</h3>
                    <p className="text-sm text-textSecondary">ID: {device.id}</p>
                    <div className="flex items-center space-x-4 mt-1">
                      <div className="flex items-center space-x-1">
                        <MapPin className="w-3 h-3 text-gray-400" />
                        <span className="text-xs text-gray-600">{device.location}</span>
                      </div>
                      <div className="flex items-center space-x-1">
                        <Battery className={`w-3 h-3 ${getBatteryColor(device.batteryLevel)}`} />
                        <span className={`text-xs ${getBatteryColor(device.batteryLevel)}`}>{device.batteryLevel}%</span>
                      </div>
                    </div>
                  </div>
                </div>

                <div className="flex items-center space-x-6">
                  <div className="text-center">
                    <p className="text-lg font-semibold text-textPrimary">{device.readingsToday}</p>
                    <p className="text-xs text-textSecondary">Readings Today</p>
                  </div>
                  <div className="text-center">
                    {device.soilPH ? (
                      <>
                        <p className="text-lg font-semibold text-textPrimary">{device.soilPH}</p>
                        <p className="text-xs text-textSecondary">Soil pH</p>
                      </>
                    ) : (
                      <>
                        <p className="text-lg font-semibold text-gray-400">--</p>
                        <p className="text-xs text-textSecondary">No Data</p>
                      </>
                    )}
                  </div>
                  <div className="text-center">
                    {device.moisture ? (
                      <>
                        <p className="text-lg font-semibold text-textPrimary">{device.moisture}%</p>
                        <p className="text-xs text-textSecondary">Moisture</p>
                      </>
                    ) : (
                      <>
                        <p className="text-lg font-semibold text-gray-400">--</p>
                        <p className="text-xs text-textSecondary">No Data</p>
                      </>
                    )}
                  </div>
                  <div className="text-center">
                    <span className={`badge ${getStatusColor(device.status)}`}>
                      {device.status.replace('_', ' ')}
                    </span>
                    <p className="text-xs text-textSecondary mt-1">{device.lastReading}</p>
                  </div>
                  <div className="text-center">
                    <p className="text-sm font-medium text-textPrimary">{device.assignedFarmer}</p>
                    <p className="text-xs text-textSecondary">{device.farmSize}</p>
                  </div>
                </div>

                <div className="flex space-x-2">
                  <button className="btn-secondary btn-sm">
                    <Settings className="w-4 h-4" />
                  </button>
                  <button className="btn-primary btn-sm">View Data</button>
                </div>
              </div>
            ))
          )}
        </div>
      </ChartCard>

      {/* Device Health Summary */}
      <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
        <div className="bg-white p-6 rounded-lg border border-gray-200">
          <div className="flex items-center justify-between mb-4">
            <h3 className="font-semibold text-textPrimary">Battery Status</h3>
            <Battery className="w-5 h-5 text-gray-400" />
          </div>
          <div className="space-y-3">
                         <div className="flex justify-between items-center">
               <span className="text-sm text-textSecondary">Good (&gt;60%)</span>
               <span className="text-sm font-medium text-green-600">892 devices</span>
             </div>
            <div className="flex justify-between items-center">
              <span className="text-sm text-textSecondary">Low (30-60%)</span>
              <span className="text-sm font-medium text-yellow-600">234 devices</span>
            </div>
                         <div className="flex justify-between items-center">
               <span className="text-sm text-textSecondary">Critical (&lt;30%)</span>
               <span className="text-sm font-medium text-red-600">114 devices</span>
             </div>
          </div>
        </div>

        <div className="bg-white p-6 rounded-lg border border-gray-200">
          <div className="flex items-center justify-between mb-4">
            <h3 className="font-semibold text-textPrimary">Data Quality</h3>
            <CheckCircle className="w-5 h-5 text-gray-400" />
          </div>
          <div className="space-y-3">
            <div className="flex justify-between items-center">
              <span className="text-sm text-textSecondary">Excellent</span>
              <span className="text-sm font-medium text-green-600">1,045 devices</span>
            </div>
            <div className="flex justify-between items-center">
              <span className="text-sm text-textSecondary">Good</span>
              <span className="text-sm font-medium text-blue-600">156 devices</span>
            </div>
            <div className="flex justify-between items-center">
              <span className="text-sm text-textSecondary">Needs Calibration</span>
              <span className="text-sm font-medium text-yellow-600">39 devices</span>
            </div>
          </div>
        </div>

        <div className="bg-white p-6 rounded-lg border border-gray-200">
          <div className="flex items-center justify-between mb-4">
            <h3 className="font-semibold text-textPrimary">Maintenance Schedule</h3>
            <AlertTriangle className="w-5 h-5 text-gray-400" />
          </div>
          <div className="space-y-3">
            <div className="flex justify-between items-center">
              <span className="text-sm text-textSecondary">Due This Week</span>
              <span className="text-sm font-medium text-red-600">23 devices</span>
            </div>
            <div className="flex justify-between items-center">
              <span className="text-sm text-textSecondary">Due Next Week</span>
              <span className="text-sm font-medium text-yellow-600">67 devices</span>
            </div>
            <div className="flex justify-between items-center">
              <span className="text-sm text-textSecondary">Up to Date</span>
              <span className="text-sm font-medium text-green-600">1,150 devices</span>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default IoTDevices; 