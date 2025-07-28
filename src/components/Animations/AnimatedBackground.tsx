import { animationCrops } from '../../data/animationData';

const AnimatedBackground = () => {
  return (
    <div className="absolute inset-0 overflow-hidden">
      {/* Gradient Background */}
      <div className="absolute inset-0 bg-gradient-to-br from-emerald-400 via-green-500 to-teal-600"></div>
      
      {/* Animated Pattern Overlay */}
      <div className="absolute inset-0 opacity-10">
        <div className="absolute inset-0 bg-[url('data:image/svg+xml,%3Csvg width=\'60\' height=\'60\' viewBox=\'0 0 60 60\' xmlns=\'http://www.w3.org/2000/svg\'%3E%3Cg fill=\'none\' fill-rule=\'evenodd\'%3E%3Cg fill=\'%23ffffff\' fill-opacity=\'0.1\'%3E%3Ccircle cx=\'30\' cy=\'30\' r=\'2\'/%3E%3C/g%3E%3C/g%3E%3C/svg%3E')] animate-pulse"></div>
      </div>

      {/* Floating Crop Icons with Messages */}
      {animationCrops.map((crop, index) => {
        const IconComponent = crop.icon;
        return (
          <div
            key={index}
            className="absolute animate-bounce"
            style={{
              left: crop.x,
              top: crop.y,
              animationDelay: crop.delay,
              animationDuration: '6s'
            }}
          >
            <div className="group relative">
              <div className="bg-white/20 backdrop-blur-sm rounded-full p-4 shadow-lg transform hover:scale-110 transition-all duration-300">
                <IconComponent className="w-8 h-8 text-white" />
              </div>
              <div className="absolute left-1/2 -translate-x-1/2 top-full mt-2 opacity-0 group-hover:opacity-100 transition-opacity duration-300">
                <div className="bg-white/90 backdrop-blur-sm rounded-lg px-3 py-2 shadow-lg whitespace-nowrap relative">
                  <p className="text-sm font-medium text-green-800">{crop.message}</p>
                  <div className="absolute -top-1 left-1/2 -translate-x-1/2 w-2 h-2 bg-white/90 rotate-45"></div>
                </div>
              </div>
            </div>
          </div>
        );
      })}

      {/* Floating Particles */}
      <div className="absolute inset-0">
        {[...Array(20)].map((_, i) => (
          <div
            key={i}
            className="absolute w-2 h-2 bg-white/30 rounded-full animate-ping"
            style={{
              left: `${Math.random() * 100}%`,
              top: `${Math.random() * 100}%`,
              animationDelay: `${Math.random() * 5}s`,
              animationDuration: `${3 + Math.random() * 2}s`
            }}
          ></div>
        ))}
      </div>
    </div>
  );
};

export default AnimatedBackground;
