import { Navbar } from "@/components/ui/navbar";
import { Footer } from "@/components/ui/footer";
import { FinancialSection } from "@/components/sections/financial";

const Financial = () => {
  return (
    <div className="min-h-screen flex flex-col">
      <Navbar />
      <main className="flex-grow">
        <FinancialSection />
      </main>
      <Footer />
    </div>
  );
};

export default Financial; 