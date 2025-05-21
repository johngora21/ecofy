import { Check, Leaf, Map, BarChart, CloudRain } from "lucide-react";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";

export function FeaturesSection() {
  const features = [
    {
      title: "Comprehensive Farm Mapping",
      description: "Precisely define farm boundaries, assess topography, and evaluate land features using GPS mapping for effective resource planning.",
      icon: <Map className="h-8 w-8 text-shamba-green" />,
    },
    {
      title: "Soil Analysis",
      description: "Measure key soil parameters. Tailored recommendations from these soil insights support crop selection and optimized irrigation.",
      icon: <Leaf className="h-8 w-8 text-shamba-green" />,
    },
    {
      title: "Real-Time Monitoring",
      description: "Continuous feedback on soil health, climate conditions, and crop health with satellite and IoT data for broader insights.",
      icon: <CloudRain className="h-8 w-8 text-shamba-green" />,
    },
    {
      title: "Market Intelligence",
      description: "Analyze price trends across markets and predict demand fluctuations to optimize harvest timing for higher profitability.",
      icon: <BarChart className="h-8 w-8 text-shamba-green" />,
    },
    {
      title: "Climate Predictions",
      description: "Early warnings for pests, diseases, and extreme weather events. Forecast climate impact on crop health and yield.",
      icon: <Check className="h-8 w-8 text-shamba-green" />,
    },
  ];

  return (
    <section id="features" className="relative py-24 md:py-32 bg-gradient-to-b from-shamba-sand to-white overflow-hidden">
      {/* Modern decorative elements */}
      <div className="absolute inset-0 bg-grid-white/10 [mask-image:linear-gradient(0deg,white,rgba(255,255,255,0.6))]"></div>
      <div className="absolute top-0 right-0 w-1/3 h-1/3 bg-shamba-green/5 rounded-full blur-3xl transform translate-x-1/2 -translate-y-1/2"></div>
      <div className="absolute bottom-0 left-0 w-1/4 h-1/4 bg-shamba-blue/5 rounded-full blur-3xl transform -translate-x-1/2 translate-y-1/2"></div>
      
      <div className="container mx-auto px-4 relative">
        <div className="grid grid-cols-12 gap-8 items-start">
          {/* Left content - spans 4 columns on large screens */}
          <div className="col-span-12 lg:col-span-4 lg:sticky lg:top-24">
            <div className="space-y-6">
              <div className="inline-flex items-center gap-2 rounded-full px-4 py-1.5 bg-shamba-green/10 text-shamba-green text-sm font-medium">
                <span className="w-2 h-2 rounded-full bg-shamba-green animate-pulse"></span>
                Farm Management
              </div>
              <h2 className="text-4xl md:text-5xl font-bold text-gray-900">
                Smart Solutions for{" "}
                <span className="relative inline-block">
                  <span className="relative z-10 text-shamba-green">Modern Farming</span>
                  <span className="absolute bottom-2 left-0 w-full h-3 bg-shamba-green/20 -rotate-1"></span>
                </span>
              </h2>
              <p className="text-xl text-gray-600 leading-relaxed">
                Ecofy collects and analyzes data via AI technology, satellite, and market intelligence, providing actionable recommendations and informed decisions for every farmer.
              </p>
            </div>
          </div>
          
          {/* Right content - spans 8 columns on large screens */}
          <div className="col-span-12 lg:col-span-8">
            <div className="grid grid-cols-1 md:grid-cols-2 gap-8">
              {features.map((feature, index) => (
                <Card 
                  key={index} 
                  className="group relative overflow-hidden border-none bg-white/50 backdrop-blur-sm shadow-lg hover:shadow-xl transition-all duration-500 hover:-translate-y-1"
                >
                  <div className="absolute inset-0 bg-gradient-to-br from-shamba-green/5 to-shamba-blue/5 opacity-0 group-hover:opacity-100 transition-opacity duration-500"></div>
                  <CardHeader className="pb-2">
                    <div className="mb-6 p-3 rounded-xl bg-shamba-green/10 w-fit group-hover:scale-110 transition-transform duration-500">
                      {feature.icon}
                    </div>
                    <CardTitle className="text-2xl font-bold text-gray-900 group-hover:text-shamba-green transition-colors duration-300">
                      {feature.title}
                    </CardTitle>
                  </CardHeader>
                  <CardContent>
                    <p className="text-gray-600 leading-relaxed group-hover:text-gray-700 transition-colors duration-300">
                      {feature.description}
                    </p>
                  </CardContent>
                </Card>
              ))}
            </div>
          </div>
        </div>
      </div>
    </section>
  );
}
