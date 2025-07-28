import React from 'react';
import type { MarketFilters } from './types';

interface RegionalTabProps {
  filters: MarketFilters;
}

const RegionalTab: React.FC<RegionalTabProps> = ({ filters }) => {
  return (
    <div className="flex items-center justify-center py-16">
      <div className="text-center">
        <div className="text-gray-400 text-6xl mb-4">🗺️</div>
        <h3 className="text-lg font-medium text-gray-900 mb-2">No regional data available</h3>
        <p className="text-gray-500">Regional price data will be loaded from the backend API</p>
      </div>
    </div>
  );
};

export default RegionalTab;
  // Mock data for regional prices
  const regionalData: RegionalPrice[] = [
    { region: 'Arusha', price: 1207, change: -8, supply: 120, demand: 110 },
    { region: 'Dar es Salaam', price: 1387, change: -7, supply: 60, demand: 120 },
    { region: 'Dodoma', price: 1544, change: -5, supply: 80, demand: 85 },
    { region: 'Mbeya', price: 1210, change: -10, supply: 150, demand: 130 },
    { region: 'Morogoro', price: 1248, change: -2, supply: 90, demand: 95 },
    { region: 'Mwanza', price: 1343, change: -6, supply: 100, demand: 90 },
  ];

  const getChangeColor = (change: number) => {
    if (change > 0) return 'text-green-600';
    if (change < 0) return 'text-red-600';
    return 'text-gray-600';
  };

  const getChangePrefix = (change: number) => {
    if (change > 0) return '+';
    return '';
  };

  const maxSupply = Math.max(...regionalData.map(d => d.supply));
  const maxDemand = Math.max(...regionalData.map(d => d.demand));
  const maxValue = Math.max(maxSupply, maxDemand);

  return (
    <div className="space-y-6">
      {/* Header */}
      <div>
        <h2 className="text-xl font-semibold text-green-600 mb-2">
          Regional Supply and Demand for {filters.product || 'Maize'}
        </h2>
        <p className="text-gray-600 text-sm">
          Compare prices and market dynamics across different regions
        </p>
      </div>

      {/* Supply and Demand Chart */}
      <div className="bg-white border border-gray-200 rounded-lg p-6">
        <div className="h-80 mb-4">
          <svg width="100%" height="100%" viewBox="0 0 800 300">
            {/* Chart background */}
            <rect width="100%" height="100%" fill="white" />
            
            {/* Grid lines */}
            {[0, 1, 2, 3, 4].map(i => (
              <line
                key={i}
                x1="80"
                y1={40 + i * 50}
                x2="720"
                y2={40 + i * 50}
                stroke="#f3f4f6"
                strokeWidth="1"
              />
            ))}

            {/* Bars */}
            {regionalData.map((data, i) => {
            //   const barWidth = 60;
              const barSpacing = 100;
              const x = 100 + i * barSpacing;
              
              const supplyHeight = (data.supply / maxValue) * 200;
              const demandHeight = (data.demand / maxValue) * 200;
              
              return (
                <g key={i}>
                  {/* Supply bar */}
                  <rect
                    x={x - 15}
                    y={240 - supplyHeight}
                    width="25"
                    height={supplyHeight}
                    fill="#10b981"
                    rx="2"
                  />
                  {/* Demand bar */}
                  <rect
                    x={x + 15}
                    y={240 - demandHeight}
                    width="25"
                    height={demandHeight}
                    fill="#34d399"
                    rx="2"
                  />
                  {/* Region label */}
                  <text
                    x={x}
                    y="265"
                    textAnchor="middle"
                    className="text-xs fill-gray-600"
                  >
                    {data.region}
                  </text>
                  {/* Highlight selected region */}
                  {data.region === filters.location && (
                    <rect
                      x={x - 35}
                      y={240 - Math.max(supplyHeight, demandHeight) - 10}
                      width="70"
                      height={Math.max(supplyHeight, demandHeight) + 40}
                      fill="none"
                      stroke="#10b981"
                      strokeWidth="2"
                      rx="4"
                      strokeDasharray="4,4"
                    />
                  )}
                </g>
              );
            })}

            {/* Y-axis labels */}
            {[160, 120, 80, 40, 0].map((value, i) => (
              <text
                key={i}
                x="70"
                y={40 + i * 50}
                textAnchor="end"
                className="text-xs fill-gray-500"
                dominantBaseline="middle"
              >
                {value}
              </text>
            ))}
          </svg>
        </div>

        {/* Legend */}
        <div className="flex items-center justify-center space-x-6 text-sm">
          <div className="flex items-center">
            <div className="w-4 h-3 bg-green-500 mr-2 rounded"></div>
            <span className="text-gray-600">Supply (tons)</span>
          </div>
          <div className="flex items-center">
            <div className="w-4 h-3 bg-green-400 mr-2 rounded"></div>
            <span className="text-gray-600">Demand (tons)</span>
          </div>
        </div>
      </div>

      {/* Market Intelligence */}
      <div className="bg-green-50 border border-green-200 rounded-lg p-4">
        <h4 className="font-semibold text-green-800 mb-2">Market Intelligence</h4>
        <p className="text-sm text-green-700">
          Analysis shows that Dar es Salaam has the highest demand-supply gap for {filters.product || 'Maize'}, offering potential market opportunities. Mbeya currently has the highest supply, which may lead to lower prices in that region.
        </p>
      </div>

      {/* Regional Price Comparison */}
      <div>
        <h3 className="text-lg font-semibold text-gray-900 mb-4">Regional Price Comparison</h3>
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
          {regionalData.map((region, index) => (
            <div 
              key={index} 
              className={`bg-white border rounded-lg p-4 ${
                region.region === filters.location 
                  ? 'border-green-500 bg-green-50' 
                  : 'border-gray-200'
              }`}
            >
              <h4 className="font-semibold text-gray-900 mb-2">{region.region}</h4>
              <div className="space-y-2">
                <div className="flex justify-between items-center">
                  <span className="text-sm text-gray-600">Price</span>
                  <span className="font-bold text-lg">
                    {region.price.toLocaleString()} TZS/kg
                  </span>
                </div>
                <div className="flex justify-between items-center">
                  <span className="text-sm text-gray-600">Change</span>
                  <span className={`text-sm font-medium ${getChangeColor(region.change)}`}>
                    {getChangePrefix(region.change)}{region.change}%
                  </span>
                </div>
                <div className="flex justify-between items-center">
                  <span className="text-sm text-gray-600">Supply</span>
                  <span className="text-sm">{region.supply} tons</span>
                </div>
                <div className="flex justify-between items-center">
                  <span className="text-sm text-gray-600">Demand</span>
                  <span className="text-sm">{region.demand} tons</span>
                </div>
                <button className="w-full mt-3 text-green-600 text-sm font-medium hover:text-green-700">
                  View Details →
                </button>
              </div>
            </div>
          ))}
        </div>
      </div>
    </div>
  );
};

export default RegionalTab;
                  View Details →
                </button>
              </div>
            </div>
          ))}
        </div>
      </div>
    </div>
  );
};

export default RegionalTab;