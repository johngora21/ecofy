import { useState, useEffect } from "react";
import { Link, useLocation } from "react-router-dom";
import { Menu, X, ExternalLink } from "lucide-react";
import { Button } from "@/components/ui/button";
import { cn } from "@/lib/utils";

const navigation = [
  { name: "Home", href: "/" },
  { name: "About", href: "/about" },
  { name: "Features", href: "/features" },
  { name: "Marketplace", href: "/marketplace" },
  { name: "Expert Support", href: "/expert-support" },
  { name: "Financial", href: "/financial" },
  { name: "Technology", href: "/technology" },
  { name: "Impact", href: "/impact" },
  { 
    name: "EcofyApp", 
    href: "https://ecofyapp.netlify.app",
    external: true 
  },
];

export function Navbar() {
  const [isOpen, setIsOpen] = useState(false);
  const location = useLocation();

  // Close mobile menu when route changes
  useEffect(() => {
    setIsOpen(false);
  }, [location]);

  return (
    <nav className="bg-white/80 backdrop-blur-md border-b border-gray-200 sticky top-0 z-50">
      <div className="container mx-auto px-4">
        <div className="flex justify-between items-center h-16">
          {/* Logo */}
          <Link to="/" className="flex items-center space-x-2">
            <span className="text-2xl font-bold text-shamba-green">Ecofy</span>
          </Link>

          {/* Desktop Navigation */}
          <div className="hidden md:flex items-center space-x-8">
            {navigation.map((item) => (
              item.external ? (
                <a
                  key={item.name}
                  href={item.href}
                  target="_blank"
                  rel="noopener noreferrer"
                  className="text-sm font-medium text-gray-600 hover:text-shamba-green transition-colors flex items-center gap-1"
                >
                  {item.name}
                  <ExternalLink className="h-4 w-4" />
                </a>
              ) : (
                <Link
                  key={item.name}
                  to={item.href}
                  className={cn(
                    "text-sm font-medium transition-colors hover:text-shamba-green",
                    location.pathname === item.href
                      ? "text-shamba-green"
                      : "text-gray-600"
                  )}
                >
                  {item.name}
                </Link>
              )
            ))}
            <Button className="bg-shamba-green hover:bg-shamba-green-dark text-white">
              Get Started
            </Button>
          </div>

          {/* Mobile menu button */}
          <div className="md:hidden">
            <button
              onClick={() => setIsOpen(!isOpen)}
              className="text-gray-600 hover:text-gray-900"
            >
              {isOpen ? (
                <X className="h-6 w-6" />
              ) : (
                <Menu className="h-6 w-6" />
              )}
            </button>
          </div>
        </div>
      </div>

      {/* Mobile menu */}
      {isOpen && (
        <div className="md:hidden bg-white py-2">
          <div className="container mx-auto px-4">
            <div className="flex flex-col space-y-2">
              {navigation.map((item) => (
                item.external ? (
                  <a
                    key={item.name}
                    href={item.href}
                    target="_blank"
                    rel="noopener noreferrer"
                    className="text-base font-medium py-2 text-gray-600 hover:text-shamba-green transition-colors flex items-center gap-1"
                  >
                    {item.name}
                    <ExternalLink className="h-4 w-4" />
                  </a>
                ) : (
                  <Link
                    key={item.name}
                    to={item.href}
                    className={cn(
                      "text-base font-medium py-2 transition-colors",
                      location.pathname === item.href
                        ? "text-shamba-green"
                        : "text-gray-600 hover:text-shamba-green"
                    )}
                  >
                    {item.name}
                  </Link>
                )
              ))}
              <Button className="bg-shamba-green hover:bg-shamba-green-dark text-white mt-4">
                Get Started
              </Button>
            </div>
          </div>
        </div>
      )}
    </nav>
  );
}
