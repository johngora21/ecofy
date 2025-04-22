import { Button } from "@/components/ui/button";

export function AboutSection() {
  return (
    <section id="about" className="bg-white py-16 md:py-24">
      <div className="container mx-auto px-4">
        <div className="text-center mb-16">
          <h2 className="text-3xl md:text-4xl font-bold text-shamba-green-dark">About Ecofy</h2>
          <div className="w-20 h-1 bg-shamba-green mx-auto mt-4 mb-6"></div>
          <p className="max-w-3xl mx-auto text-lg text-gray-700">
            Our mission is to empower smallholder farmers with precision farming tools for climate-resilient, sustainable, and profitable agriculture.
          </p>
        </div>

        {/* Vision & Mission */}
        <div className="grid grid-cols-1 md:grid-cols-2 gap-12 mb-12">
          <div className="bg-shamba-green/10 rounded-lg p-8 shadow">
            <h3 className="text-xl font-bold text-shamba-green-dark mb-4">Our Vision</h3>
            <p>
              To lead Africa’s agricultural transformation through smart, sustainable, and climate-resilient solutions – ensuring every farmer prospers and ecosystems thrive.
            </p>
          </div>
          <div className="bg-shamba-green/10 rounded-lg p-8 shadow">
            <h3 className="text-xl font-bold text-shamba-green-dark mb-4">Our Mission</h3>
            <p>
              To empower smallholder farmers with cutting-edge technologies, detailed soil insights, and actionable climate data – fostering growth, food security, and sustainability.
            </p>
          </div>
        </div>
        
        <div className="grid grid-cols-1 md:grid-cols-2 gap-16 items-center">
          <div>
            <img 
              src="/lovable-uploads/436bbce1-74f2-40ed-ab14-e97441355a8c.png"
              alt="Ecofy team monitoring crops"
              className="rounded-lg shadow-xl"
            />
          </div>
          <div>
            <h3 className="text-2xl font-bold text-shamba-green-dark mb-6">Our Objectives</h3>
            <ul className="space-y-4">
              <li className="flex">
                <div className="flex-shrink-0 h-6 w-6 rounded-full bg-shamba-green flex items-center justify-center mr-3 mt-1">
                  <span className="text-white text-sm font-bold">1</span>
                </div>
                <p className="text-gray-700">
                  Empower smallholder farmers with precision farming tools through real-time monitoring and GPS mapping.
                </p>
              </li>
              <li className="flex">
                <div className="flex-shrink-0 h-6 w-6 rounded-full bg-shamba-green flex items-center justify-center mr-3 mt-1">
                  <span className="text-white text-sm font-bold">2</span>
                </div>
                <p className="text-gray-700">
                  Analyze comprehensive soil parameters.
                  <span className="font-semibold"> Texture, Structure, Porosity, Drainage, Water-Holding Capacity, pH Level, Organic Matter Content, Cation Exchange Capacity (CEC), Salinity, Nutrient Levels (macronutrients), Slope, Soil Depth, Erosion Susceptibility, Temperature, Moisture Content.</span>
                </p>
              </li>
              <li className="flex">
                <div className="flex-shrink-0 h-6 w-6 rounded-full bg-shamba-green flex items-center justify-center mr-3 mt-1">
                  <span className="text-white text-sm font-bold">3</span>
                </div>
                <p className="text-gray-700">
                  Integrate local agricultural history with market trends for informed crop and sale decisions.
                </p>
              </li>
              <li className="flex">
                <div className="flex-shrink-0 h-6 w-6 rounded-full bg-shamba-green flex items-center justify-center mr-3 mt-1">
                  <span className="text-white text-sm font-bold">4</span>
                </div>
                <p className="text-gray-700">
                  Enhance adaptability to climate risks using predictive models and early warning systems.
                </p>
              </li>
              <li className="flex">
                <div className="flex-shrink-0 h-6 w-6 rounded-full bg-shamba-green flex items-center justify-center mr-3 mt-1">
                  <span className="text-white text-sm font-bold">5</span>
                </div>
                <p className="text-gray-700">
                  Promote sustainability by optimizing resource usage and minimizing waste.
                </p>
              </li>
            </ul>
            <Button className="mt-8 bg-shamba-green hover:bg-shamba-green-dark text-white">
              Learn More About Our Mission
            </Button>
          </div>
        </div>
      </div>
    </section>
  );
}
