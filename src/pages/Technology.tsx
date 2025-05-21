import { Navbar } from "@/components/ui/navbar";
import { Footer } from "@/components/ui/footer";
import { TechnologySection } from "@/components/sections/technology";

const Technology = () => {
  return (
    <div className="min-h-screen flex flex-col">
      <Navbar />
      <main className="flex-grow">
        <TechnologySection />
      </main>
      <Footer />
    </div>
  );
};

export default Technology; 