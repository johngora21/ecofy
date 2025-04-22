
import { Separator } from "@/components/ui/separator";
import { 
  Wifi, 
  Globe, 
  CloudRain, 
  BrainCircuit, 
  Cloud 
} from "lucide-react";

export function TechnologySection() {
  const techAreas = [
    {
      title: "IoT and Sensors",
      description: "Advanced sensors collect real-time data on soil texture, structure, porosity, drainage, water-holding capacity, pH, organic matter, CEC, salinity, nutrient levels, slope, soil depth, erosion susceptibility, temperature, and moisture. Data is used for continuous monitoring and accurate recommendations.",
      icon: <Wifi className="h-10 w-10 text-shamba-blue" />,
    },
    {
      title: "GPS and Satellite",
      description: "Generate detailed geospatial farm maps for tailored planning while analyzing climate risks and regional environmental changes through advanced satellite and remote sensing. Soil and environmental data can be acquired via satellite as well.",
      icon: <Globe className="h-10 w-10 text-shamba-blue" />,
    },
    {
      title: "AI and Machine Learning",
      description: "Our sophisticated models handle crop forecasting, soil analysis, market price trend modeling, and predictive tools for climate adaptation.",
      icon: <BrainCircuit className="h-10 w-10 text-shamba-blue" />,
    },
    {
      title: "Cloud Computing",
      description: "Scalable data processing manages inputs from sensors, GPS, and satellites, providing real-time dashboards for farmers to access insights seamlessly.",
      icon: <Cloud className="h-10 w-10 text-shamba-blue" />,
    },
  ];

  return (
    <section id="technology" className="bg-white py-16 md:py-24">
      <div className="container mx-auto px-4">
        <div className="text-center mb-16">
          <h2 className="text-3xl md:text-4xl font-bold text-shamba-green-dark">
            Our Technology
          </h2>
          <div className="w-20 h-1 bg-shamba-green mx-auto mt-4 mb-6"></div>
          <p className="max-w-3xl mx-auto text-lg text-gray-700">
            Ecofy integrates cutting-edge technology to provide actionable insights and recommendations for smallholder farmers.
          </p>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-2 gap-16 items-center">
          <div className="order-2 md:order-1">
            <div className="space-y-10">
              {techAreas.map((tech, index) => (
                <div key={index}>
                  <div className="flex items-start">
                    <div className="flex-shrink-0 mr-4">
                      {tech.icon}
                    </div>
                    <div>
                      <h3 className="text-xl font-semibold text-shamba-blue-dark mb-2">
                        {tech.title}
                      </h3>
                      <p className="text-gray-700">{tech.description}</p>
                    </div>
                  </div>
                  {index < techAreas.length - 1 && (
                    <Separator className="my-6 bg-gray-200" />
                  )}
                </div>
              ))}
            </div>
          </div>
          
          <div className="order-1 md:order-2">
            <div className="relative">
              <div className="absolute -top-6 -left-6 w-64 h-64 bg-shamba-blue/10 rounded-full"></div>
              <img
                src="/lovable-uploads/1e845b4b-d4ca-423e-92b0-3071fd44cdcf.png"
                alt="Farmer using technology in the field"
                className="relative rounded-lg shadow-xl border-4 border-white"
              />
              <div className="absolute -bottom-6 -right-6 w-32 h-32 bg-shamba-green/10 rounded-full"></div>
            </div>
          </div>
        </div>
      </div>
    </section>
  );
}
