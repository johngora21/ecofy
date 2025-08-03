import React from 'react';

const ChartCard = ({ 
  title, 
  description, 
  children, 
  className = '',
  actions = null 
}) => {
  return (
    <div className={`ecofy-card ${className}`}>
      <div className="flex items-start justify-between mb-6">
        <div className="flex-1">
          <h3 className="text-lg font-semibold text-textPrimary mb-1">{title}</h3>
          {description && (
            <p className="text-sm text-textSecondary">{description}</p>
          )}
        </div>
        {actions && (
          <div className="flex items-center space-x-2">
            {actions}
          </div>
        )}
      </div>
      <div className="chart-container">
        {children}
      </div>
    </div>
  );
};

export default ChartCard; 