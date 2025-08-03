import React from 'react';
import { BrowserRouter as Router, Routes, Route } from 'react-router-dom';
import { Toaster } from 'react-hot-toast';
import Layout from './components/Layout';
import Dashboard from './pages/Dashboard';
import TrainingData from './pages/TrainingData';
import ModelTraining from './pages/ModelTraining';
import VoiceTraining from './pages/VoiceTraining';
import WhatsAppMonitor from './pages/WhatsAppMonitor';
import UserFeedback from './pages/UserFeedback';
import Analytics from './pages/Analytics';
import Settings from './pages/Settings';
import FieldTeams from './pages/FieldTeams';
import IoTDevices from './pages/IoTDevices';
import TrainingPrograms from './pages/TrainingPrograms';
import RegionalAgents from './pages/RegionalAgents';
import SoilSampling from './pages/SoilSampling';
import MarketplaceManagement from './pages/MarketplaceManagement';
import UserManagement from './pages/UserManagement';
import KitDistribution from './pages/KitDistribution';
import DeviceAnalytics from './pages/DeviceAnalytics';
import FieldCoverage from './pages/FieldCoverage';

function App() {
  return (
    <Router>
      <div className="App">
        <Layout>
          <Routes>
            <Route path="/" element={<Dashboard />} />
            
            {/* AI & Training Routes */}
            <Route path="/training-data" element={<TrainingData />} />
            <Route path="/model-training" element={<ModelTraining />} />
            <Route path="/voice-training" element={<VoiceTraining />} />
            <Route path="/user-feedback" element={<UserFeedback />} />
            
            {/* Field Operations Routes */}
            <Route path="/field-teams" element={<FieldTeams />} />
            <Route path="/training-programs" element={<TrainingPrograms />} />
            <Route path="/regional-agents" element={<RegionalAgents />} />
            <Route path="/soil-sampling" element={<SoilSampling />} />
            
            {/* IoT & Hardware Routes */}
            <Route path="/iot-devices" element={<IoTDevices />} />
            <Route path="/kit-distribution" element={<KitDistribution />} />
            <Route path="/device-analytics" element={<DeviceAnalytics />} />
            <Route path="/field-coverage" element={<FieldCoverage />} />
            
            {/* Communication Routes */}
            <Route path="/whatsapp-monitor" element={<WhatsAppMonitor />} />
            <Route path="/sms-gateway" element={<div className="p-8 text-center"><h2 className="text-2xl font-bold text-gray-600">SMS Gateway - Coming Soon</h2><p className="text-gray-500 mt-2">Monitor SMS delivery and manage offline communication</p></div>} />
            
            {/* Marketplace & Users Routes */}
            <Route path="/marketplace-management" element={<MarketplaceManagement />} />
            <Route path="/user-management" element={<UserManagement />} />
            
            {/* System Routes */}
            <Route path="/analytics" element={<Analytics />} />
            <Route path="/settings" element={<Settings />} />
          </Routes>
        </Layout>
        <Toaster position="top-right" />
      </div>
    </Router>
  );
}

export default App; 