
import { ChartLine, ChartBar, TrendingUp, TrendingDown } from "lucide-react";

export function MarketTrendsSection() {
  return (
    <section id="market-trends" className="bg-shamba-green/10 py-16 md:py-24">
      <div className="container mx-auto px-4">
        <div className="text-center mb-12">
          <h2 className="text-3xl md:text-4xl font-bold text-shamba-green-dark">Market Price Trends & Insights</h2>
          <div className="w-20 h-1 bg-shamba-green mx-auto mt-4 mb-6"></div>
          <p className="max-w-2xl mx-auto text-lg text-gray-700">
            Ecofy provides comprehensive historical, real-time, and predictive market price data. This empowers farmers and agribusinesses in Sub-Saharan Africa to make informed planting, selling, and investment decisions.
          </p>
        </div>
        <div className="grid grid-cols-1 md:grid-cols-3 gap-10 mb-8">
          {/* Historical Market Trends */}
          <div className="bg-white rounded-lg p-8 shadow hover:shadow-lg flex flex-col items-center text-center">
            <ChartBar className="text-shamba-green w-10 h-10 mb-3"/>
            <h3 className="text-xl font-bold text-shamba-green-dark mb-2">Historical Trends</h3>
            <p className="mb-4 text-gray-700">
              Explore past market price data to spot seasonal patterns and choose profitable crops.
            </p>
            <img src="/lovable-uploads/sample-market-historical.png" alt="Sample market historical chart" className="w-full rounded shadow" />
          </div>
          {/* Real-Time Market Data */}
          <div className="bg-white rounded-lg p-8 shadow hover:shadow-lg flex flex-col items-center text-center">
            <TrendingUp className="text-shamba-green w-10 h-10 mb-3"/>
            <h3 className="text-xl font-bold text-shamba-green-dark mb-2">Real-Time Prices</h3>
            <p className="mb-4 text-gray-700">
              Get up-to-the-minute prices from various marketplaces to maximize your profits at the point of sale.
            </p>
            <img src="/lovable-uploads/sample-market-realtime.png" alt="Sample real-time price update" className="w-full rounded shadow" />
          </div>
          {/* Predictive Analytics */}
          <div className="bg-white rounded-lg p-8 shadow hover:shadow-lg flex flex-col items-center text-center">
            <ChartLine className="text-shamba-green w-10 h-10 mb-3"/>
            <h3 className="text-xl font-bold text-shamba-green-dark mb-2">Future Market Predictions</h3>
            <p className="mb-4 text-gray-700">
              AI-powered models forecast future price trends, helping farmers plan harvests and storage for optimal returns.
            </p>
            <img src="/lovable-uploads/sample-market-predictive.png" alt="Sample market price prediction" className="w-full rounded shadow" />
          </div>
        </div>
        <div className="text-center max-w-2xl mx-auto text-lg text-gray-800">
          <p>
            By combining these insights, Ecofy enables wise decision-making for planting, harvesting, selling, and storage—making a real difference for farmers and agribusinesses across the region.
          </p>
        </div>
      </div>
    </section>
  );
}
