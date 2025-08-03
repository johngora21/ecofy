import React, { useState, useEffect } from 'react';
import { Mic, Play, Pause, Volume2, Download, Upload } from 'lucide-react';
import { apiService } from '../services/api';
import MetricCard from '../components/MetricCard';
import ChartCard from '../components/ChartCard';

const VoiceTraining = () => {
  const [voiceStats, setVoiceStats] = useState(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    fetchVoiceStats();
  }, []);

  const fetchVoiceStats = async () => {
    try {
      setLoading(true);
      const stats = await apiService.getVoiceTrainingStats();
      setVoiceStats(stats);
    } catch (error) {
      console.error('Error fetching voice stats:', error);
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <h1 className="text-3xl font-bold text-textPrimary">Voice Training</h1>
        <div className="flex space-x-3">
          <button className="btn-secondary flex items-center space-x-2">
            <Upload className="w-4 h-4" />
            <span>Upload Samples</span>
          </button>
          <button className="btn-primary flex items-center space-x-2">
            <Mic className="w-4 h-4" />
            <span>Record Sample</span>
          </button>
        </div>
      </div>

      {/* Voice Training Stats */}
      <div className="grid grid-cols-1 md:grid-cols-4 gap-6">
        <MetricCard
          title="Voice Samples"
          value="1,247"
          change="+42 this week"
          icon={Mic}
          color="primary"
          trend="positive"
        />
        <MetricCard
          title="Tanzanian Accent"
          value="892"
          change="71% of samples"
          icon={Volume2}
          color="success"
          trend="positive"
        />
        <MetricCard
          title="Quality Score"
          value="8.7/10"
          change="+0.3 improved"
          icon={Volume2}
          color="info"
          trend="positive"
        />
        <MetricCard
          title="Training Hours"
          value="34.2h"
          change="Audio duration"
          icon={Mic}
          color="secondary"
          trend="neutral"
        />
      </div>

      {/* Current Voice Model */}
      <ChartCard title="Voice Model Status" description="Tanzanian Swahili accent training progress">
        <div className="space-y-4">
          <div className="flex items-center justify-between">
            <div className="flex items-center space-x-3">
              <div className="w-3 h-3 bg-green-500 rounded-full"></div>
              <span className="font-medium">Tanzanian Swahili Voice Model v1.2</span>
            </div>
            <span className="badge badge-green">Active</span>
          </div>
          
          <div className="grid grid-cols-3 gap-4">
            <div className="text-center">
              <p className="text-2xl font-bold text-primary">94.2%</p>
              <p className="text-sm text-gray-600">Accent Accuracy</p>
            </div>
            <div className="text-center">
              <p className="text-2xl font-bold text-secondary">1,247</p>
              <p className="text-sm text-gray-600">Training Samples</p>
            </div>
            <div className="text-center">
              <p className="text-2xl font-bold text-info">8.7/10</p>
              <p className="text-sm text-gray-600">Quality Score</p>
            </div>
          </div>

          <div className="mt-4">
            <h4 className="font-medium mb-2">Sample Voice Output</h4>
            <div className="flex items-center space-x-4 p-4 bg-gray-50 rounded-lg">
              <button className="flex items-center justify-center w-10 h-10 bg-primary text-white rounded-full">
                <Play className="w-4 h-4" />
              </button>
              <div className="flex-1">
                <div className="text-sm text-gray-600">Latest Tanzanian accent sample</div>
                <div className="text-xs text-gray-500">"Habari za asubuhi, mkulima. Ni wakati mzuri wa kupanda mahindi..."</div>
              </div>
              <button className="btn-secondary btn-sm">
                <Download className="w-4 h-4" />
              </button>
            </div>
          </div>
        </div>
      </ChartCard>

      {/* Recent Voice Samples */}
      <ChartCard title="Recent Voice Samples" description="Latest farmer voice notes for training">
        <div className="space-y-4">
          {[1, 2, 3, 4].map((sample) => (
            <div key={sample} className="flex items-center space-x-4 p-4 border border-gray-200 rounded-lg">
              <button className="flex items-center justify-center w-8 h-8 bg-gray-200 text-gray-600 rounded-full">
                <Play className="w-3 h-3" />
              </button>
              <div className="flex-1">
                <div className="text-sm font-medium">Farmer #{sample}024</div>
                <div className="text-xs text-gray-500">
                  Quality: {8 + sample}/10 • Duration: 2{sample}s • Accent: Tanzanian
                </div>
              </div>
              <div className="flex items-center space-x-2">
                <span className="badge badge-green">Approved</span>
                <button className="btn-secondary btn-sm">Use for Training</button>
              </div>
            </div>
          ))}
        </div>
      </ChartCard>
    </div>
  );
};

export default VoiceTraining; 