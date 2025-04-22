
import { ShoppingCart, TruckIcon, Store } from "lucide-react";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";

export function MarketplaceSection() {
  const features = [
    {
      title: "Crop Selling Platform",
      description: "Direct connection with buyers and wholesalers, real-time market price information, transparent pricing mechanisms, secure transaction processing, and quality verification system.",
      icon: <Store className="h-8 w-8 text-shamba-green" />,
    },
    {
      title: "Input Purchase",
      description: "Seeds, fertilizers, pesticides marketplace with comparison of product prices, quality ratings and reviews, direct purchasing options, and bulk order discounts.",
      icon: <ShoppingCart className="h-8 w-8 text-shamba-green" />,
    },
    {
      title: "Transportation and Logistics",
      description: "Freight and transportation booking, shipment tracking, storage facility listings, cold storage availability, and packaging and transportation guidelines.",
      icon: <TruckIcon className="h-8 w-8 text-shamba-green" />,
    },
  ];

  return (
    <section id="marketplace" className="bg-white py-16 md:py-24">
      <div className="container mx-auto px-4">
        <div className="text-center mb-16">
          <h2 className="text-3xl md:text-4xl font-bold text-shamba-green-dark">
            Marketplace Module
          </h2>
          <div className="w-20 h-1 bg-shamba-green mx-auto mt-4 mb-6"></div>
          <p className="max-w-3xl mx-auto text-lg text-gray-700">
            Connect farmers directly to markets, suppliers, and logistics services through our integrated marketplace platform.
          </p>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-3 gap-8">
          {features.map((feature, index) => (
            <Card key={index} className="border-none shadow-md hover:shadow-lg transition-shadow">
              <CardHeader className="pb-2">
                <div className="mb-4">{feature.icon}</div>
                <CardTitle className="text-xl text-shamba-green-dark">{feature.title}</CardTitle>
              </CardHeader>
              <CardContent>
                <p className="text-gray-700">{feature.description}</p>
              </CardContent>
            </Card>
          ))}
        </div>
      </div>
    </section>
  );
}
