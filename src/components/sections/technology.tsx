import { 
  BarChart3, 
  Droplets, 
  ThermometerSun, 
  TrendingUp, 
  Sprout 
} from "lucide-react";

export function TechnologySection() {
  const technologyFeatures = [
    {
      title: "Real-time Monitoring",
      description: "Continuous data collection for informed decision-making",
    },
    {
      title: "Predictive Analytics",
      description: "AI-driven insights for proactive climate risk management",
    },
    {
      title: "GPS Mapping",
      description: "Precise field mapping for optimized resource allocation",
    },
    {
      title: "Mobile Accessibility",
      description: "User-friendly app for on-the-go data access",
    },
  ];

  return (
    <section id="technology" className="bg-white py-16 md:py-24">
      <div className="container mx-auto px-4">
        <div className="text-center mb-16">
          <h2 className="text-3xl md:text-4xl font-bold text-shamba-green-dark">
            Technology & Data Collection
          </h2>
          <div className="w-20 h-1 bg-shamba-green mx-auto mt-4 mb-6"></div>
          <p className="max-w-3xl mx-auto text-lg text-gray-700">
            Ecofy leverages state-of-the-art IoT sensors and satellite data to deliver real-time, actionable insights to farmers.
          </p>
        </div>
        <div className="grid grid-cols-1 md:grid-cols-2 gap-16 items-center">
          <div>
            <img
              src="/lovable-uploads/7b9b1a70-0947-4909-8752-2614cc542da1.png"
              alt="Ecofy IoT or Satellite Data Collection"
              className="rounded-lg shadow-xl border-4 border-white"
            />
          </div>
          <div>
            <ul className="space-y-4">
              <li className="flex items-start">
                <span className="h-6 w-6 rounded-full bg-shamba-green text-white flex items-center justify-center mr-3 mt-1">
                  1
                </span>
                <div>
                  <span className="font-bold">IoT Sensors:</span> High-precision sensors for soil, moisture, and climate conditions.
                </div>
              </li>
              <li className="flex items-start">
                <span className="h-6 w-6 rounded-full bg-shamba-green text-white flex items-center justify-center mr-3 mt-1">
                  2
                </span>
                <div>
                  <span className="font-bold">Satellite Technologies:</span> Remote monitoring and analytics for large-scale land coverage.
                </div>
              </li>
            </ul>
          </div>
        </div>
      </div>
    </section>
  );
}
