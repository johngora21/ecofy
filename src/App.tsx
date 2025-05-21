import { BrowserRouter as Router, Routes, Route } from "react-router-dom";
import Index from "@/pages/Index";
import About from "@/pages/About";
import Features from "@/pages/Features";
import Marketplace from "@/pages/Marketplace";
import ExpertSupport from "@/pages/ExpertSupport";
import Financial from "@/pages/Financial";
import Technology from "@/pages/Technology";
import Impact from "@/pages/Impact";
import NotFound from "@/pages/NotFound";

function App() {
  return (
    <Router>
      <Routes>
        <Route path="/" element={<Index />} />
        <Route path="/about" element={<About />} />
        <Route path="/features" element={<Features />} />
        <Route path="/marketplace" element={<Marketplace />} />
        <Route path="/expert-support" element={<ExpertSupport />} />
        <Route path="/financial" element={<Financial />} />
        <Route path="/technology" element={<Technology />} />
        <Route path="/impact" element={<Impact />} />
        <Route path="*" element={<NotFound />} />
      </Routes>
    </Router>
  );
}

export default App;
