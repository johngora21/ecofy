
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
      description: "Measure key soil parameters via IoT sensors or satellite. Tailored recommendations from soil insights support crop selection and optimized irrigation.",
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
    <section id="features" className="bg-shamba-cream py-16 md:py-24">
      <div className="container mx-auto px-4">
        <div className="text-center mb-16">
          <h2 className="text-3xl md:text-4xl font-bold text-shamba-green-dark">
            Farm Management Module
          </h2>
          <div className="w-20 h-1 bg-shamba-green mx-auto mt-4 mb-6"></div>
          <p className="max-w-3xl mx-auto text-lg text-gray-700">
            Ecofy collects and analyzes agricultural data using AI technology, satellite data, and market intelligence to provide actionable recommendations for every farmer.
          </p>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
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
