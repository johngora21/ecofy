import React, { useState, useEffect } from 'react';
import { Activity, TrendingUp, Wifi, Battery, Thermometer, Droplets, Zap, AlertCircle } from 'lucide-react';
import { LineChart, Line, XAxis, YAxis, CartesianGrid, ResponsiveContainer, AreaChart, Area, BarChart, Bar, ScatterChart, Scatter } from 'recharts';
import MetricCard from '../components/MetricCard';
import ChartCard from '../components/ChartCard';

const DeviceAnalytics = () => {
  const [analytics, setAnalytics] = useState({});
  const [loading, setLoading] = useState(true);

  const performanceData = [
    { hour: '00:00', uptime: 98.5, readings: 145, errors: 2 },
    { hour: '04:00', uptime: 97.8, readings: 138, errors: 3 },
    { hour: '08:00', uptime: 99.2, readings: 167, errors: 1 },
    { hour: '12:00', uptime: 98.9, readings: 189, errors: 2 },
    { hour: '16:00', uptime: 99.1, readings: 178, errors: 1 },
    { hour: '20:00', uptime: 98.7, readings: 156, errors: 2 }
  ];

  const sensorData = [
    { time: '6AM', temperature: 22.5, humidity: 65, soilMoisture: 45, ph: 6.8 },
    { time: '9AM', temperature: 26.3, humidity: 58, soilMoisture: 42, ph: 6.9 },
    { time: '12PM', temperature: 31.2, humidity: 52, soilMoisture: 38, ph: 7.0 },
    { time: '3PM', temperature: 33.8, humidity: 48, soilMoisture: 35, ph: 7.1 },
    { time: '6PM', temperature: 29.1, humidity: 55, soilMoisture: 40, ph: 6.9 },
    { time: '9PM', temperature: 24.7, humidity: 62, soilMoisture: 43, ph: 6.8 }
  ];

  const batteryTrends = [
    { day: 'Mon', avgBattery: 87, criticalDevices: 5 },
    { day: 'Tue', avgBattery: 85, criticalDevices: 8 },
    { day: 'Wed', avgBattery: 83, criticalDevices: 12 },
    { day: 'Thu', avgBattery: 81, criticalDevices: 15 },
    { day: 'Fri', avgBattery: 79, criticalDevices: 18 },
    { day: 'Sat', avgBattery: 77, criticalDevices: 22 },
    { day: 'Sun', avgBattery: 85, criticalDevices: 14 }
  ];

  const deviceDistribution = [
    { region: 'Dodoma', devices: 245, avgUptime: 98.2, alerts: 12 },
    { region: 'Mwanza', devices: 189, avgUptime: 97.8, alerts: 15 },
    { region: 'Arusha', devices: 156, avgUptime: 99.1, alerts: 8 },
    { region: 'Iringa', devices: 134, avgUptime: 98.5, alerts: 10 },
    { region: 'Mbeya', devices: 167, avgUptime: 97.9, alerts: 14 }
  ];

  const alertFrequency = [
    { type: 'Battery Low', count: 45, severity: 'warning' },
    { type: 'Connection Lost', count: 23, severity: 'critical' },
    { type: 'Sensor Malfunction', count: 18, severity: 'critical' },
    { type: 'Data Anomaly', count: 32, severity: 'info' },
    { type: 'Calibration Required', count: 12, severity: 'warning' }
  ];

  useEffect(() => {
    setTimeout(() => {
      setAnalytics({
        totalDevices: 891,
        activeDevices: 847,
        avgUptime: 98.3,
        totalReadings: 45678,
        dataAccuracy: 97.8,
        energyEfficiency: 92.5
      });
      setLoading(false);
    }, 1000);
  }, []);

  const getSeverityColor = (severity) => {
    switch (severity) {
      case 'critical': return 'text-red-600';
      case 'warning': return 'text-yellow-600';
      case 'info': return 'text-blue-600';
      default: return 'text-gray-600';
    }
  };

  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <h1 className="text-3xl font-bold text-textPrimary">Device Analytics</h1>
        <div className="flex space-x-3">
          <button className="btn-secondary flex items-center space-x-2">
            <Activity className="w-4 h-4" />
            <span>Real-time Monitor</span>
          </button>
          <button className="btn-primary flex items-center space-x-2">
            <TrendingUp className="w-4 h-4" />
            <span>Generate Report</span>
          </button>
        </div>
      </div>

      {/* Analytics Overview */}
      <div className="grid grid-cols-1 md:grid-cols-4 gap-6">
        <MetricCard
          title="Total Devices"
          value="891"
          change="847 active"
          icon={Wifi}
          color="primary"
          trend="positive"
        />
        <MetricCard
          title="System Uptime"
          value="98.3%"
          change="+1.2% this week"
          icon={Activity}
          color="success"
          trend="positive"
        />
        <MetricCard
          title="Data Accuracy"
          value="97.8%"
          change="High quality"
          icon={TrendingUp}
          color="info"
          trend="positive"
        />
        <MetricCard
          title="Energy Efficiency"
          value="92.5%"
          change="Optimized"
          icon={Zap}
          color="secondary"
          trend="positive"
        />
      </div>

      {/* Performance Charts */}
      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
        <ChartCard title="Device Performance Trends" description="24-hour uptime and reading patterns">
          <ResponsiveContainer width="100%" height={250}>
            <AreaChart data={performanceData}>
              <CartesianGrid strokeDasharray="3 3" />
              <XAxis dataKey="hour" />
              <YAxis />
              <Area type="monotone" dataKey="uptime" stackId="1" stroke="#22c55e" fill="#22c55e" fillOpacity={0.6} />
              <Area type="monotone" dataKey="readings" stackId="2" stroke="#3b82f6" fill="#3b82f6" fillOpacity={0.6} />
            </AreaChart>
          </ResponsiveContainer>
        </ChartCard>

        <ChartCard title="Battery Health Trends" description="Weekly battery performance and critical alerts">
          <ResponsiveContainer width="100%" height={250}>
            <LineChart data={batteryTrends}>
              <CartesianGrid strokeDasharray="3 3" />
              <XAxis dataKey="day" />
              <YAxis />
              <Line type="monotone" dataKey="avgBattery" stroke="#22c55e" strokeWidth={2} name="Avg Battery %" />
              <Line type="monotone" dataKey="criticalDevices" stroke="#ef4444" strokeWidth={2} name="Critical Devices" />
            </LineChart>
          </ResponsiveContainer>
        </ChartCard>
      </div>

      {/* Sensor Data Analysis */}
      <ChartCard title="Sensor Data Patterns" description="Daily environmental measurements across all devices">
        <ResponsiveContainer width="100%" height={300}>
          <LineChart data={sensorData}>
            <CartesianGrid strokeDasharray="3 3" />
            <XAxis dataKey="time" />
            <YAxis />
            <Line type="monotone" dataKey="temperature" stroke="#ef4444" strokeWidth={2} name="Temperature (°C)" />
            <Line type="monotone" dataKey="humidity" stroke="#3b82f6" strokeWidth={2} name="Humidity (%)" />
            <Line type="monotone" dataKey="soilMoisture" stroke="#22c55e" strokeWidth={2} name="Soil Moisture (%)" />
            <Line type="monotone" dataKey="ph" stroke="#f59e0b" strokeWidth={2} name="pH Level" />
          </LineChart>
        </ResponsiveContainer>
      </ChartCard>

      {/* Regional Performance */}
      <ChartCard title="Regional Device Performance" description="Device distribution and performance by region">
        <div className="space-y-4">
          {deviceDistribution.map((region, index) => (
            <div key={index} className="flex items-center justify-between p-4 bg-white border border-gray-200 rounded-lg hover:shadow-md transition-shadow">
              <div className="flex items-center space-x-4">
                <div className="w-12 h-12 rounded-lg bg-gradient-to-r from-purple-400 to-pink-500 flex items-center justify-center">
                  <Wifi className="w-6 h-6 text-white" />
                </div>
                <div>
                  <h3 className="font-semibold text-textPrimary">{region.region}</h3>
                  <p className="text-sm text-textSecondary">{region.devices} active devices</p>
                </div>
              </div>

              <div className="flex items-center space-x-8">
                <div className="text-center">
                  <p className="text-lg font-semibold text-success">{region.avgUptime}%</p>
                  <p className="text-xs text-textSecondary">Avg Uptime</p>
                </div>
                <div className="text-center">
                  <p className="text-lg font-semibold text-primary">{region.devices}</p>
                  <p className="text-xs text-textSecondary">Devices</p>
                </div>
                <div className="text-center">
                  <p className={`text-lg font-semibold ${region.alerts > 15 ? 'text-red-600' : region.alerts > 10 ? 'text-yellow-600' : 'text-green-600'}`}>
                    {region.alerts}
                  </p>
                  <p className="text-xs text-textSecondary">Active Alerts</p>
                </div>
              </div>

              <div className="flex space-x-2">
                <button className="btn-secondary btn-sm">View Details</button>
                <button className="btn-primary btn-sm">Manage</button>
              </div>
            </div>
          ))}
        </div>
      </ChartCard>

      {/* Alert Analysis */}
      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
        <ChartCard title="Alert Frequency Analysis" description="Most common device alerts and their severity">
          <div className="space-y-3">
            {alertFrequency.map((alert, index) => (
              <div key={index} className="flex items-center justify-between p-3 bg-gray-50 rounded-lg">
                <div className="flex items-center space-x-3">
                  <AlertCircle className={`w-4 h-4 ${getSeverityColor(alert.severity)}`} />
                  <div>
                    <p className="font-medium text-sm">{alert.type}</p>
                    <p className={`text-xs ${getSeverityColor(alert.severity)}`}>{alert.severity}</p>
                  </div>
                </div>
                <div className="text-right">
                  <p className="text-lg font-semibold text-textPrimary">{alert.count}</p>
                  <p className="text-xs text-textSecondary">occurrences</p>
                </div>
              </div>
            ))}
          </div>
        </ChartCard>

        <ChartCard title="Performance Metrics" description="Key performance indicators and system health">
          <div className="space-y-4">
            <div className="flex items-center justify-between">
              <div className="flex items-center space-x-2">
                <Activity className="w-4 h-4 text-green-600" />
                <span className="text-sm text-textSecondary">Network Connectivity</span>
              </div>
              <div className="text-right">
                <span className="text-lg font-semibold text-green-600">99.2%</span>
                <p className="text-xs text-textSecondary">Excellent</p>
              </div>
            </div>
            
            <div className="flex items-center justify-between">
              <div className="flex items-center space-x-2">
                <Battery className="w-4 h-4 text-yellow-600" />
                <span className="text-sm text-textSecondary">Battery Health</span>
              </div>
              <div className="text-right">
                <span className="text-lg font-semibold text-yellow-600">82.7%</span>
                <p className="text-xs text-textSecondary">Good</p>
              </div>
            </div>
            
            <div className="flex items-center justify-between">
              <div className="flex items-center space-x-2">
                <Thermometer className="w-4 h-4 text-blue-600" />
                <span className="text-sm text-textSecondary">Sensor Accuracy</span>
              </div>
              <div className="text-right">
                <span className="text-lg font-semibold text-blue-600">97.8%</span>
                <p className="text-xs text-textSecondary">High</p>
              </div>
            </div>
            
            <div className="flex items-center justify-between">
              <div className="flex items-center space-x-2">
                <Droplets className="w-4 h-4 text-purple-600" />
                <span className="text-sm text-textSecondary">Data Completeness</span>
              </div>
              <div className="text-right">
                <span className="text-lg font-semibold text-purple-600">96.4%</span>
                <p className="text-xs text-textSecondary">Very Good</p>
              </div>
            </div>

            <div className="flex items-center justify-between">
              <div className="flex items-center space-x-2">
                <Zap className="w-4 h-4 text-orange-600" />
                <span className="text-sm text-textSecondary">Power Efficiency</span>
              </div>
              <div className="text-right">
                <span className="text-lg font-semibold text-orange-600">92.5%</span>
                <p className="text-xs text-textSecondary">Optimized</p>
              </div>
            </div>
          </div>
        </ChartCard>
      </div>

      {/* Summary Cards */}
      <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
        <div className="bg-white p-6 rounded-lg border border-gray-200">
          <div className="flex items-center justify-between mb-4">
            <h3 className="font-semibold text-textPrimary">Data Quality</h3>
            <TrendingUp className="w-5 h-5 text-green-500" />
          </div>
          <div className="space-y-3">
            <div className="flex justify-between items-center">
              <span className="text-sm text-textSecondary">Valid Readings</span>
              <span className="text-sm font-medium text-green-600">97.8%</span>
            </div>
            <div className="flex justify-between items-center">
              <span className="text-sm text-textSecondary">Missing Data Points</span>
              <span className="text-sm font-medium text-yellow-600">2.1%</span>
            </div>
            <div className="flex justify-between items-center">
              <span className="text-sm text-textSecondary">Corrupted Readings</span>
              <span className="text-sm font-medium text-red-600">0.1%</span>
            </div>
          </div>
        </div>

        <div className="bg-white p-6 rounded-lg border border-gray-200">
          <div className="flex items-center justify-between mb-4">
            <h3 className="font-semibold text-textPrimary">Maintenance Schedule</h3>
            <Activity className="w-5 h-5 text-blue-500" />
          </div>
          <div className="space-y-3">
            <div className="flex justify-between items-center">
              <span className="text-sm text-textSecondary">Due This Week</span>
              <span className="text-sm font-medium text-yellow-600">23 devices</span>
            </div>
            <div className="flex justify-between items-center">
              <span className="text-sm text-textSecondary">Overdue</span>
              <span className="text-sm font-medium text-red-600">7 devices</span>
            </div>
            <div className="flex justify-between items-center">
              <span className="text-sm text-textSecondary">Recently Serviced</span>
              <span className="text-sm font-medium text-green-600">156 devices</span>
            </div>
          </div>
        </div>

        <div className="bg-white p-6 rounded-lg border border-gray-200">
          <div className="flex items-center justify-between mb-4">
            <h3 className="font-semibold text-textPrimary">Cost Analysis</h3>
            <Zap className="w-5 h-5 text-purple-500" />
          </div>
          <div className="space-y-3">
            <div className="flex justify-between items-center">
              <span className="text-sm text-textSecondary">Monthly Operations</span>
              <span className="text-sm font-medium text-blue-600">TSh 2.8M</span>
            </div>
            <div className="flex justify-between items-center">
              <span className="text-sm text-textSecondary">Maintenance Costs</span>
              <span className="text-sm font-medium text-yellow-600">TSh 1.2M</span>
            </div>
            <div className="flex justify-between items-center">
              <span className="text-sm text-textSecondary">Cost per Reading</span>
              <span className="text-sm font-medium text-green-600">TSh 87</span>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default DeviceAnalytics; 