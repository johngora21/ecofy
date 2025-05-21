import { Navbar } from "@/components/ui/navbar";
import { Footer } from "@/components/ui/footer";
import { AboutSection } from "@/components/sections/about";

const About = () => {
  return (
    <div className="min-h-screen flex flex-col">
      <Navbar />
      <main className="flex-grow">
        <AboutSection />
      </main>
      <Footer />
    </div>
  );
};

export default About; 