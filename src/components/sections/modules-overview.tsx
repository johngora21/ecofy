
import { Store, Users, PiggyBank } from "lucide-react";

export function ModulesOverviewSection() {
  return (
    <section id="modules" className="bg-white py-16 md:py-24">
      <div className="container mx-auto px-4">
        <div className="text-center mb-14">
          <h2 className="text-3xl md:text-4xl font-bold text-shamba-green-dark">
            Discover More Ecofy Modules
          </h2>
          <div className="w-20 h-1 bg-shamba-green mx-auto mt-4 mb-6"></div>
          <p className="max-w-3xl mx-auto text-lg text-gray-700">
            Beyond farm management, Ecofy provides end-to-end digital solutions empowering smallholder farmers at every step.
          </p>
        </div>
        <div className="grid grid-cols-1 md:grid-cols-3 gap-10">
          {/* Marketplace Module */}
          <div className="bg-white rounded-lg shadow-lg hover:shadow-xl p-8 border-t-4 border-shamba-green overflow-hidden flex flex-col">
            <div className="flex items-center mb-4 gap-3">
              <Store className="text-shamba-green w-8 h-8" />
              <h3 className="font-bold text-xl text-shamba-green-dark">Marketplace Module</h3>
            </div>
            <ul className="text-gray-700 text-sm space-y-2">
              <li>
                <span className="font-semibold">Crop Selling Platform:</span> Direct connection with buyers and wholesalers, real-time market price information, transparent pricing, secure payment, and quality verification.
              </li>
              <li>
                <span className="font-semibold">Input Purchase:</span> Buy seeds, fertilizers, and pesticides with price comparisons, reviews, and access to bulk discounts.
              </li>
              <li>
                <span className="font-semibold">Transportation & Logistics:</span> Book freight, track shipments, find storage, and get packaging/transport guidelines.
              </li>
            </ul>
          </div>
          {/* Expert Support Module */}
          <div className="bg-white rounded-lg shadow-lg hover:shadow-xl p-8 border-t-4 border-shamba-green overflow-hidden flex flex-col">
            <div className="flex items-center mb-4 gap-3">
              <Users className="text-shamba-green w-8 h-8" />
              <h3 className="font-bold text-xl text-shamba-green-dark">Expert Support (Forum) Module</h3>
            </div>
            <ul className="text-gray-700 text-sm space-y-2">
              <li>
                <span className="font-semibold">Community Forum:</span> Join location-based discussion threads, get advice in your regional dialect, and ask questions anonymously.
              </li>
              <li>
                <span className="font-semibold">Expert Consultation:</span> Chat or video call agricultural experts, resolve queries, and receive crop-specific guidance.
              </li>
              <li>
                <span className="font-semibold">Knowledge Base & Training:</span> Access agricultural articles, tutorials, government scheme info, plus live and recorded learning sessions.
              </li>
            </ul>
          </div>
          {/* Financial Solutions Module */}
          <div className="bg-white rounded-lg shadow-lg hover:shadow-xl p-8 border-t-4 border-shamba-green overflow-hidden flex flex-col">
            <div className="flex items-center mb-4 gap-3">
              <PiggyBank className="text-shamba-green w-8 h-8" />
              <h3 className="font-bold text-xl text-shamba-green-dark">Financial Solutions Module</h3>
            </div>
            <ul className="text-gray-700 text-sm space-y-2">
              <li>
                <span className="font-semibold">Loan Management:</span> Compare agricultural loans, check eligibility, apply, and track applications.
              </li>
              <li>
                <span className="font-semibold">Insurance Services:</span> Explore crop insurance, calculate premiums, get risk assessments, and file claims easily.
              </li>
              <li>
                <span className="font-semibold">Investments & Subsidies:</span> Manage farm investments, forecast revenue, and stay updated on government subsidies.
              </li>
            </ul>
          </div>
        </div>
      </div>
    </section>
  );
}
