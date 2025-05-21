import { Navbar } from "@/components/ui/navbar";
import { Footer } from "@/components/ui/footer";
import { MarketplaceSection } from "@/components/sections/marketplace";

const Marketplace = () => {
  return (
    <div className="min-h-screen flex flex-col">
      <Navbar />
      <main className="flex-grow">
        <MarketplaceSection />
      </main>
      <Footer />
    </div>
  );
};

export default Marketplace; 