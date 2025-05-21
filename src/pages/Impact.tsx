import { Navbar } from "@/components/ui/navbar";
import { Footer } from "@/components/ui/footer";
import { ImpactSection } from "@/components/sections/impact";

const Impact = () => {
  return (
    <div className="min-h-screen flex flex-col">
      <Navbar />
      <main className="flex-grow">
        <ImpactSection />
      </main>
      <Footer />
    </div>
  );
};

export default Impact; 