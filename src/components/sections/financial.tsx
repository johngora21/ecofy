
import { Percent, Shield, FileText, BarChart } from "lucide-react";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";

export function FinancialSection() {
  const features = [
    {
      title: "Loan Management",
      description: "Agricultural loan comparisons, pre-qualification checks, application submission, interest rate comparison, and loan tracking dashboard.",
      icon: <Percent className="h-8 w-8 text-shamba-green" />,
    },
    {
      title: "Insurance Services",
      description: "Crop insurance options, premium calculators, risk assessment tools, claim filing assistance, and historical yield data integration.",
      icon: <Shield className="h-8 w-8 text-shamba-green" />,
    },
    {
      title: "Investment Tracking",
      description: "Investment portfolio management, crop yield prediction, market trend analysis, financial health indicators, and revenue forecasting.",
      icon: <BarChart className="h-8 w-8 text-shamba-green" />,
    },
    {
      title: "Government Subsidy Information",
      description: "Subsidy eligibility checker, application guidance, scheme details, notification of new schemes, and application status tracking.",
      icon: <FileText className="h-8 w-8 text-shamba-green" />,
    },
  ];

  return (
    <section id="financial" className="bg-white py-16 md:py-24">
      <div className="container mx-auto px-4">
        <div className="text-center mb-16">
          <h2 className="text-3xl md:text-4xl font-bold text-shamba-green-dark">
            Financial Solutions Module
          </h2>
          <div className="w-20 h-1 bg-shamba-green mx-auto mt-4 mb-6"></div>
          <p className="max-w-3xl mx-auto text-lg text-gray-700">
            Access financial tools, insurance, and investment tracking to strengthen your farm's economic sustainability.
          </p>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-8">
          {features.map((feature, index) => (
            <Card key={index} className="border-none shadow-md hover:shadow-lg transition-shadow">
              <CardHeader className="pb-2">
                <div className="mb-4">{feature.icon}</div>
                <CardTitle className="text-xl text-shamba-green-dark">{feature.title}</CardTitle>
              </CardHeader>
              <CardContent>
                <p className="text-gray-700">{feature.description}</p>
              </CardContent>
            </Card>
          ))}
        </div>
      </div>
    </section>
  );
}
