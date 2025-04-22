import { Navbar } from "@/components/ui/navbar";
import { Footer } from "@/components/ui/footer";
import { HeroSection } from "@/components/sections/hero";
import { AboutSection } from "@/components/sections/about";
import { FeaturesSection } from "@/components/sections/features";
import { TechnologySection } from "@/components/sections/technology";
import { ImpactSection } from "@/components/sections/impact";

const Index = () => {
  return (
    <div className="min-h-screen flex flex-col">
      <Navbar />
      <main>
        <HeroSection />
        <AboutSection />
        <FeaturesSection />
        <TechnologySection />
        <ImpactSection />
      </main>
      <Footer />
    </div>
  );
};

export default Index;
