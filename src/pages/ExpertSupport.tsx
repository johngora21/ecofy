import { Navbar } from "@/components/ui/navbar";
import { Footer } from "@/components/ui/footer";
import { ExpertSupportSection } from "@/components/sections/expert-support";

const ExpertSupport = () => {
  return (
    <div className="min-h-screen flex flex-col">
      <Navbar />
      <main className="flex-grow">
        <ExpertSupportSection />
      </main>
      <Footer />
    </div>
  );
};

export default ExpertSupport; 