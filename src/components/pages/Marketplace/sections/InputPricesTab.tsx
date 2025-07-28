import React from 'react';
import type { MarketFilters } from './types';

interface InputPricesTabProps {
  filters: MarketFilters;
}

const InputPricesTab: React.FC<InputPricesTabProps> = ({ filters }) => {
  return (
    <div className="flex items-center justify-center py-16">
      <div className="text-center">
        <div className="text-gray-400 text-6xl mb-4">💰</div>
        <h3 className="text-lg font-medium text-gray-900 mb-2">No input price data available</h3>
        <p className="text-gray-500">Input price data will be loaded from the backend API</p>
      </div>
    </div>
  );
};

export default InputPricesTab;
  // Mock data for input prices
  const inputPrices: InputPrice[] = [
    { type: 'NPK Fertilizer', price: 75000, unit: '50kg bag', change: 5, location: filters.location },
    { type: 'Urea', price: 65000, unit: '50kg bag', change: -2, location: filters.location },
    { type: 'DAP', price: 85000, unit: '50kg bag', change: 0, location: filters.location },
    { type: 'Maize Seeds (Hybrid)', price: 12000, unit: '2kg pack', change: 13, location: filters.location },
    { type: 'Pesticide (General)', price: 15000, unit: '1L bottle', change: 11, location: filters.location },
    { type: 'Herbicide', price: 18000, unit: '1L bottle', change: 12, location: filters.location },
  ];

  const getChangeColor = (change: number) => {
    if (change > 0) return 'bg-green-100 text-green-800';
    if (change < 0) return 'bg-red-100 text-red-800';
    return 'bg-gray-100 text-gray-800';
  };

  const getChangePrefix = (change: number) => {
    if (change > 0) return '+';
    if (change < 0) return '';
    return '';
  };

  const getChangeText = (change: number) => {
    if (change === 0) return 'Stable';
    return `${getChangePrefix(change)}${change}%`;
  };

  return (
    <div className="space-y-6">
      {/* Header */}
      <div>
        <h2 className="text-xl font-semibold text-green-600 mb-2">
          Agricultural Input Prices - {filters.location}
        </h2>
        <p className="text-gray-600 text-sm">
          Current prices for agricultural inputs in your selected region
        </p>
      </div>

      {/* Input Prices Table */}
      <div className="bg-white border border-gray-200 rounded-lg overflow-hidden">
        <div className="overflow-x-auto">
          <table className="w-full">
            <thead className="bg-gray-50">
              <tr>
                <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                  Input Type
                </th>
                <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                  Price (TZS)
                </th>
                <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                  Unit
                </th>
                <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                  Change
                </th>
                <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                  Location
                </th>
              </tr>
            </thead>
            <tbody className="bg-white divide-y divide-gray-200">
              {inputPrices.map((input, index) => (
                <tr key={index} className="hover:bg-gray-50">
                  <td className="px-6 py-4 whitespace-nowrap">
                    <div className="text-sm font-medium text-gray-900">{input.type}</div>
                  </td>
                  <td className="px-6 py-4 whitespace-nowrap">
                    <div className="text-sm text-gray-900">{input.price.toLocaleString()}</div>
                  </td>
                  <td className="px-6 py-4 whitespace-nowrap">
                    <div className="text-sm text-gray-900">{input.unit}</div>
                  </td>
                  <td className="px-6 py-4 whitespace-nowrap">
                    <span className={`inline-flex px-2 py-1 text-xs font-semibold rounded-full ${getChangeColor(input.change)}`}>
                      {getChangeText(input.change)}
                    </span>
                  </td>
                  <td className="px-6 py-4 whitespace-nowrap">
                    <div className="text-sm text-gray-900">{input.location}</div>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </div>

      {/* Price Trends Insight */}
      <div className="bg-blue-50 border border-blue-200 rounded-lg p-4">
        <h4 className="font-semibold text-blue-800 mb-2">Input Price Trends</h4>
        <p className="text-sm text-blue-700">
          Fertilizer prices have stabilized after a 5% decrease over the last month. Consider making purchases now as prices are expected to rise slightly as the planting season approaches.
        </p>
      </div>

      {/* Cost Calculator */}
      <div className="bg-white border border-gray-200 rounded-lg p-6">
        <h3 className="font-semibold text-gray-900 mb-4">Input Cost Calculator</h3>
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-2">
              Farm Size (acres)
            </label>
            <input
              type="number"
              className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-green-500"
              placeholder="Enter farm size"
            />
          </div>
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-2">
              Crop Type
            </label>
            <select className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-green-500">
              <option value="maize">Maize</option>
              <option value="rice">Rice</option>
              <option value="beans">Beans</option>
            </select>
          </div>
          <div className="flex items-end">
            <button className="w-full bg-green-600 text-white px-4 py-2 rounded-md hover:bg-green-700 transition-colors">
              Calculate Cost
            </button>
          </div>
        </div>
      </div>
    </div>
  );
};

export default InputPricesTab;
          <div className="flex items-end">
            <button className="w-full bg-green-600 text-white px-4 py-2 rounded-md hover:bg-green-700 transition-colors">
              Calculate Cost
            </button>
          </div>
        </div>
      </div>
    </div>
  );
};

export default InputPricesTab;