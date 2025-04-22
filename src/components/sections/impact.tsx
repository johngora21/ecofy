import { 
  BarChart3, 
  Droplets, 
  ThermometerSun, 
  TrendingUp, 
  Sprout 
} from "lucide-react";

export function ImpactSection() {
  const impactMetrics = [
    {
      title: "Farm Productivity",
      description: "Yield improvements through precision farming techniques",
      icon: <TrendingUp className="h-10 w-10 text-shamba-green" />,
      stats: "+30%",
    },
    {
      title: "Resource Efficiency",
      description: "Reduced water, fertilizer, and pesticide usage",
      icon: <Droplets className="h-10 w-10 text-shamba-green" />,
      stats: "-25%",
    },
    {
      title: "Climate Resilience",
      description: "Increased adoption of early warnings for extreme weather",
      icon: <ThermometerSun className="h-10 w-10 text-shamba-green" />,
      stats: "+40%",
    },
    {
      title: "Market Integration",
      description: "Farmer revenue growth through better crop decisions",
      icon: <BarChart3 className="h-10 w-10 text-shamba-green" />,
      stats: "+20%",
    },
    {
      title: "Environmental Impact",
      description: "Reduced emissions and improved biodiversity",
      icon: <Sprout className="h-10 w-10 text-shamba-green" />,
      stats: "-15%",
    },
  ];

  return (
    <section id="impact" className="bg-shamba-earth py-16 md:py-24 text-white">
      <div className="container mx-auto px-4">
        <div className="text-center mb-16">
          <h2 className="text-3xl md:text-4xl font-bold">
            Our Impact
          </h2>
          <div className="w-20 h-1 bg-white mx-auto mt-4 mb-6"></div>
          <p className="max-w-3xl mx-auto text-lg text-gray-100">
            Ecofy is making a measurable difference in sustainable agriculture, climate resilience, and farmer livelihoods.
          </p>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
          {impactMetrics.map((impact, index) => (
            <div 
              key={index}
              className="bg-white/10 backdrop-blur-sm rounded-lg p-6 text-center hover:bg-white/20 transition-colors"
            >
              <div className="bg-white/10 rounded-full w-20 h-20 flex items-center justify-center mx-auto mb-4">
                {impact.icon}
              </div>
              <h3 className="text-xl font-bold mb-2">{impact.title}</h3>
              <div className="text-3xl font-bold text-white mb-2">{impact.stats}</div>
              <p className="text-gray-200">{impact.description}</p>
            </div>
          ))}
        </div>

        <div className="mt-16 text-center">
          <h3 className="text-2xl font-bold mb-6">Alignment with Global Goals</h3>
          <div className="grid grid-cols-1 md:grid-cols-3 gap-6 max-w-3xl mx-auto">
            <div className="bg-white/10 backdrop-blur-sm rounded-lg p-6 hover:bg-white/20 transition-colors">
              <h4 className="font-bold mb-2">SDG 2</h4>
              <p>Zero Hunger – Enhance food security with innovative farming solutions</p>
            </div>
            <div className="bg-white/10 backdrop-blur-sm rounded-lg p-6 hover:bg-white/20 transition-colors">
              <h4 className="font-bold mb-2">SDG 13</h4>
              <p>Climate Action – Equip farmers to adapt to climate risks</p>
            </div>
            <div className="bg-white/10 backdrop-blur-sm rounded-lg p-6 hover:bg-white/20 transition-colors">
              <h4 className="font-bold mb-2">SDG 15</h4>
              <p>Life on Land – Promote sustainable and efficient land management</p>
            </div>
          </div>
        </div>
      </div>
    </section>
  );
}
