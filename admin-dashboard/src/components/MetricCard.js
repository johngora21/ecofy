import React from 'react';
import { TrendingUp, TrendingDown, Minus } from 'lucide-react';

const MetricCard = ({ 
  title, 
  value, 
  change, 
  icon: Icon, 
  color = 'primary', 
  trend = 'neutral',
  className = ''
}) => {
  const colorClasses = {
    primary: 'bg-primary/10 text-primary border-primary/20',
    secondary: 'bg-secondary/10 text-secondary border-secondary/20',
    success: 'bg-success/10 text-success border-success/20',
    warning: 'bg-warning/10 text-warning border-warning/20',
    error: 'bg-error/10 text-error border-error/20',
    info: 'bg-info/10 text-info border-info/20'
  };

  const trendIcons = {
    positive: TrendingUp,
    negative: TrendingDown,
    neutral: Minus
  };

  const trendColors = {
    positive: 'text-success',
    negative: 'text-error',
    neutral: 'text-textSecondary'
  };

  const TrendIcon = trendIcons[trend];

  return (
    <div className={`ecofy-card hover:shadow-md transition-shadow duration-300 ${className}`}>
      <div className="flex items-start justify-between">
        <div className="flex-1">
          <p className="text-sm font-medium text-textSecondary mb-1">{title}</p>
          <p className="text-2xl font-bold text-textPrimary mb-2">{value}</p>
          <div className="flex items-center space-x-1">
            <TrendIcon className={`w-3 h-3 ${trendColors[trend]}`} />
            <span className={`text-xs ${trendColors[trend]}`}>{change}</span>
          </div>
        </div>
        <div className={`p-3 rounded-lg border ${colorClasses[color]}`}>
          <Icon className="w-5 h-5" />
        </div>
      </div>
    </div>
  );
};

export default MetricCard; 