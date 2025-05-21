import { Button } from "@/components/ui/button";
import { ArrowRight } from "lucide-react";

export function HeroSection() {
  return (
    <section className="relative min-h-screen flex items-center overflow-hidden bg-gradient-to-br from-shamba-green/5 via-shamba-cream to-shamba-sand">
      {/* Modern decorative elements */}
      <div className="absolute inset-0 bg-grid-white/10 [mask-image:linear-gradient(0deg,white,rgba(255,255,255,0.6))]"></div>
      <div className="absolute top-0 right-0 w-1/3 h-1/3 bg-shamba-green/10 rounded-full blur-3xl transform translate-x-1/2 -translate-y-1/2"></div>
      <div className="absolute bottom-0 left-0 w-1/4 h-1/4 bg-shamba-blue/10 rounded-full blur-3xl transform -translate-x-1/2 translate-y-1/2"></div>
      
      <div className="container mx-auto px-4 py-12 md:py-20 lg:py-24 relative">
        <div className="grid grid-cols-12 gap-8 items-center">
          {/* Left content - spans 7 columns on large screens */}
          <div className="col-span-12 lg:col-span-7 space-y-8 lg:pr-12">
            <div className="inline-flex items-center gap-2 rounded-full px-4 py-1.5 bg-shamba-green/10 text-shamba-green text-sm font-medium">
              <span className="w-2 h-2 rounded-full bg-shamba-green animate-pulse"></span>
              Sustainable Agriculture Platform
            </div>
            <h1 className="text-5xl md:text-6xl lg:text-7xl font-bold text-gray-900 leading-[1.1]">
              Smart Climate Solutions for{" "}
              <span className="relative inline-block">
                <span className="relative z-10 text-shamba-green">Sustainable</span>
                <span className="absolute bottom-2 left-0 w-full h-3 bg-shamba-green/20 -rotate-1"></span>
              </span>{" "}
              Agriculture
            </h1>
            <p className="text-xl text-gray-600 max-w-xl leading-relaxed">
              Empowering smallholder farmers in Sub-Saharan Africa with AI-driven tools for climate-resilient and profitable farming practices – proudly by Ecofy.
            </p>
            <div className="flex flex-col sm:flex-row gap-4">
              <Button className="group bg-shamba-green hover:bg-shamba-green-dark text-white px-8 py-6 rounded-full shadow-lg shadow-shamba-green/20 transition-all hover:shadow-xl hover:shadow-shamba-green/30">
                <span className="flex items-center gap-2">
                  Learn More
                  <ArrowRight className="w-4 h-4 group-hover:translate-x-1 transition-transform" />
                </span>
              </Button>
              <Button variant="outline" className="border-shamba-green text-shamba-green hover:bg-shamba-green/10 px-8 py-6 rounded-full">
                Contact Us
              </Button>
            </div>
          </div>
          
          {/* Right content - spans 5 columns on large screens */}
          <div className="col-span-12 lg:col-span-5 relative">
            <div className="relative aspect-square max-w-lg mx-auto">
              {/* Decorative elements */}
              <div className="absolute -inset-4 bg-gradient-to-r from-shamba-green/20 to-shamba-blue/20 rounded-full blur-2xl"></div>
              <div className="absolute inset-0 bg-gradient-to-br from-shamba-green/10 to-shamba-blue/10 rounded-full animate-pulse"></div>
              
              {/* Main image container */}
              <div className="relative w-full h-full rounded-full overflow-hidden shadow-2xl border-4 border-white/80 backdrop-blur-sm">
                <img 
                  src="/lovable-uploads/3d7a769d-a6df-4024-a4d9-9b291724c7fa.png"
                  alt="Ecofy Smart Agriculture"
                  className="object-cover w-full h-full transform hover:scale-105 transition-transform duration-700"
                />
              </div>
              
              {/* Floating stats */}
              <div className="absolute -right-4 top-1/4 bg-white/80 backdrop-blur-sm p-4 rounded-2xl shadow-lg border border-white/20 transform -translate-y-1/2">
                <div className="text-sm text-gray-600">Farmers Empowered</div>
                <div className="text-2xl font-bold text-shamba-green">10,000+</div>
              </div>
              <div className="absolute -left-4 bottom-1/4 bg-white/80 backdrop-blur-sm p-4 rounded-2xl shadow-lg border border-white/20 transform translate-y-1/2">
                <div className="text-sm text-gray-600">Success Rate</div>
                <div className="text-2xl font-bold text-shamba-green">98%</div>
              </div>
            </div>
          </div>
        </div>
      </div>
      
      <div className="absolute bottom-0 left-0 right-0 h-32 bg-gradient-to-t from-white to-transparent"></div>
    </section>
  );
}

