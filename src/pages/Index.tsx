import { useEffect } from "react";
import { useLocation } from "react-router-dom";
import { Navbar } from "@/components/ui/navbar";
import { Footer } from "@/components/ui/footer";
import { HeroSection } from "@/components/sections/hero";
import { AboutSection } from "@/components/sections/about";
import { FeaturesSection } from "@/components/sections/features";
import { MarketplaceSection } from "@/components/sections/marketplace";
import { ExpertSupportSection } from "@/components/sections/expert-support";
import { FinancialSection } from "@/components/sections/financial";
import { TechnologySection } from "@/components/sections/technology";
import { ImpactSection } from "@/components/sections/impact";
import { TestimonialsSection } from "@/components/sections/testimonials";
import { ModulesOverviewSection } from "@/components/sections/modules-overview";
import { MarketTrendsSection } from "@/components/sections/market-trends";

const Index = () => {
  const location = useLocation();

  useEffect(() => {
    // Handle hash-based navigation
    if (location.hash) {
      const element = document.querySelector(location.hash);
      if (element) {
        element.scrollIntoView({ behavior: "smooth" });
      }
    } else {
      // Scroll to top when no hash
      window.scrollTo(0, 0);
    }
  }, [location]);

  return (
    <div className="min-h-screen flex flex-col">
      <Navbar />
      <main>
        <HeroSection />
        <AboutSection />
        <TestimonialsSection />
        <FeaturesSection />
        {/* Market trends section between features and modules overview */}
        <MarketTrendsSection />
        {/* Modules Overview section added below features, above details for each */}
        <ModulesOverviewSection />
        <MarketplaceSection />
        <ExpertSupportSection />
        <FinancialSection />
        <TechnologySection />
        <ImpactSection />
      </main>
      <Footer />
    </div>
  );
};

export default Index;
