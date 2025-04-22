
import { Link } from "react-router-dom";

export function Footer() {
  return (
    <footer className="bg-shamba-green-dark text-white">
      <div className="container mx-auto px-4 py-12">
        <div className="grid grid-cols-1 md:grid-cols-3 gap-8">
          <div>
            <Link to="/" className="text-2xl font-bold">Shamba Hub</Link>
            <p className="mt-4 text-sm leading-6 text-gray-200">
              Empowering smallholder farmers with AI-driven tools for sustainable agriculture and climate resilience.
            </p>
          </div>
          
          <div>
            <h3 className="text-lg font-semibold">Quick Links</h3>
            <ul className="mt-4 space-y-2">
              <li>
                <a href="#about" className="text-gray-200 hover:text-white">About Us</a>
              </li>
              <li>
                <a href="#features" className="text-gray-200 hover:text-white">Our Features</a>
              </li>
              <li>
                <a href="#technology" className="text-gray-200 hover:text-white">Technology</a>
              </li>
              <li>
                <a href="#impact" className="text-gray-200 hover:text-white">Impact</a>
              </li>
            </ul>
          </div>
          
          <div>
            <h3 className="text-lg font-semibold">Contact</h3>
            <ul className="mt-4 space-y-2">
              <li className="flex items-start">
                <span className="text-gray-200">Email:</span>
                <a href="mailto:info@shambahub.com" className="ml-2 text-gray-200 hover:text-white">
                  info@shambahub.com
                </a>
              </li>
              <li className="flex items-start">
                <span className="text-gray-200">Phone:</span>
                <span className="ml-2 text-gray-200">+254 700 000000</span>
              </li>
            </ul>
          </div>
        </div>
        
        <div className="mt-12 pt-8 border-t border-gray-600 flex flex-col md:flex-row justify-between items-center">
          <p className="text-sm text-gray-300">
            &copy; {new Date().getFullYear()} Shamba Hub. All rights reserved.
          </p>
          <div className="mt-4 md:mt-0">
            <ul className="flex space-x-6">
              <li>
                <a href="#" className="text-gray-300 hover:text-white">
                  Privacy Policy
                </a>
              </li>
              <li>
                <a href="#" className="text-gray-300 hover:text-white">
                  Terms of Service
                </a>
              </li>
            </ul>
          </div>
        </div>
      </div>
    </footer>
  );
}
