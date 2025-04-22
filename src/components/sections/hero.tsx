
import { Button } from "@/components/ui/button";

export function HeroSection() {
  return (
    <section className="relative overflow-hidden bg-gradient-to-r from-shamba-cream to-white">
      <div className="container mx-auto px-4 py-16 md:py-24 lg:py-32">
        <div className="grid grid-cols-1 md:grid-cols-2 gap-12 items-center">
          <div className="order-2 md:order-1">
            <h1 className="text-4xl md:text-5xl lg:text-6xl font-bold text-shamba-green-dark leading-tight">
              Smart Climate Solutions for Sustainable Agriculture
            </h1>
            <p className="mt-6 text-lg md:text-xl text-gray-700 max-w-lg">
              Empowering smallholder farmers in Sub-Saharan Africa with AI-driven tools for climate-resilient farming practices.
            </p>
            <div className="mt-8 flex flex-col sm:flex-row gap-4">
              <Button className="bg-shamba-green hover:bg-shamba-green-dark text-white px-8 py-3 rounded-md">
                Learn More
              </Button>
              <Button variant="outline" className="border-shamba-green text-shamba-green hover:bg-shamba-green/10 px-8 py-3 rounded-md">
                Contact Us
              </Button>
            </div>
          </div>
          <div className="order-1 md:order-2 flex justify-center">
            <div className="relative w-full max-w-md">
              <div className="aspect-w-16 aspect-h-9 overflow-hidden rounded-lg shadow-xl">
                <img 
                  src="https://images.unsplash.com/photo-1605810230434-7631ac76ec81?auto=format&fit=crop&q=80&w=1200"
                  alt="Farmers using technology in the field"
                  className="object-cover w-full h-full"
                />
              </div>
            </div>
          </div>
        </div>
      </div>
      <div className="absolute bottom-0 left-0 right-0 h-24 bg-gradient-to-t from-white to-transparent"></div>
    </section>
  );
}
