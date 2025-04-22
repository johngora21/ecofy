
import { ChartBar, ChartLine, TrendingUp } from "lucide-react";

export function MarketTrendsSection() {
  return (
    <section id="market-trends" className="bg-shamba-green/10 py-16 md:py-24">
      <div className="container mx-auto px-4">
        <div className="text-center mb-12">
          <h2 className="text-3xl md:text-4xl font-bold text-shamba-green-dark">Market Price Trends & Decision Impact</h2>
          <div className="w-20 h-1 bg-shamba-green mx-auto mt-4 mb-6"></div>
          <p className="max-w-2xl mx-auto text-lg text-gray-700">
            Understanding market price dynamics is vital for every farmer and agribusiness in Sub-Saharan Africa.
            Ecofy provides deep insights into <b>historical</b>, <b>real-time</b>, and <b>future</b> market price trends,
            empowering smarter, data-driven decisions for when to plant, harvest, store, and sell.
          </p>
        </div>
        <div className="grid grid-cols-1 md:grid-cols-3 gap-10 mb-8">
          {/* Historical Market Trends */}
          <div className="bg-white rounded-lg p-8 shadow hover:shadow-lg flex flex-col items-center text-center">
            <ChartBar className="text-shamba-green w-10 h-10 mb-3"/>
            <h3 className="text-xl font-bold text-shamba-green-dark mb-2">Historical Trends</h3>
            <p className="mb-4 text-gray-700">
              Analyze years of market price history and crop production to spot winning patterns,
              anticipate seasonal highs and lows, and choose what to plant for maximum returns.
            </p>
            <img
              src="/lovable-uploads/333c4193-7a8d-4b83-941e-72f487a4825a.png"
              alt="Historical Maize Production"
              className="w-full rounded shadow mb-3"
            />
            <img
              src="/lovable-uploads/599fdeb9-2d03-4ccd-b251-05df3141f9e7.png"
              alt="Multi-country maize price history"
              className="w-full rounded shadow"
            />
            <span className="block text-xs text-gray-500 mt-2">Compare output (blue bars) and pricing (lines) to time your investments.</span>
          </div>
          {/* Real-Time Market Data */}
          <div className="bg-white rounded-lg p-8 shadow hover:shadow-lg flex flex-col items-center text-center">
            <TrendingUp className="text-shamba-green w-10 h-10 mb-3"/>
            <h3 className="text-xl font-bold text-shamba-green-dark mb-2">Real-Time Prices</h3>
            <p className="mb-4 text-gray-700">
              Get instant wholesale price updates across multiple commodities and locations.
              Know the best moments to sell and compare returns at a glance.
            </p>
            <img
              src="/lovable-uploads/2284ebe4-0d7a-4902-a858-a2616f839dee.png"
              alt="Recent wholesale food prices"
              className="w-full rounded shadow"
            />
            <span className="block text-xs text-gray-500 mt-2">Real-time price signals help maximize profit at sale time.</span>
          </div>
          {/* Predictive Analytics */}
          <div className="bg-white rounded-lg p-8 shadow hover:shadow-lg flex flex-col items-center text-center">
            <ChartLine className="text-shamba-green w-10 h-10 mb-3"/>
            <h3 className="text-xl font-bold text-shamba-green-dark mb-2">Future Market Predictions</h3>
            <p className="mb-4 text-gray-700">
              AI-powered models analyze historical and real-time data to forecast coming price trends — allowing farmers to plan storage, sales, and next season’s crops with confidence.
            </p>
            <img
              src="/lovable-uploads/c035ab19-8f98-4c13-b68c-cd35096db0cc.png"
              alt="Market trend predictions"
              className="w-full rounded shadow mb-3"
            />
            <img
              src="/lovable-uploads/8a4ad9e9-11dc-4ecc-a0ee-6517c60ea0a1.png"
              alt="Regional future price projections"
              className="w-full rounded shadow"
            />
            <span className="block text-xs text-gray-500 mt-2">Plan your harvest and marketing with confidence.</span>
          </div>
        </div>
        <div className="text-center max-w-2xl mx-auto text-lg text-gray-800">
          <h4 className="font-semibold text-shamba-green-dark mb-2">
            Why does this matter?
          </h4>
          <p>
            By combining market intelligence from history, real-time updates, and future forecasts, Ecofy enables smarter planting, selling, and storage decisions. 
            This helps farmers and agribusinessmen across Sub-Saharan Africa optimize profits and reduce risks in an ever-changing marketplace.
          </p>
        </div>
      </div>
    </section>
  );
}
