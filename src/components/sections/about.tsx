import React from 'react';
import { Rocket } from "lucide-react";

export function AboutSection() {
  const title = "About Ecofy";
  const subtitle = "Ecofy is dedicated to transforming agriculture in Sub-Saharan Africa by providing farmers and agribusinesses with the tools and insights they need to thrive.";
  const features = [
    {
      title: "Our Vision",
      description: "To be the leading catalyst for sustainable agricultural development in Sub-Saharan Africa, empowering communities through technology and knowledge.",
      icon: <Rocket className="h-6 w-6 text-shamba-green" />,
    },
    {
      title: "Our Mission",
      description: "To deliver actionable insights and innovative solutions that enhance agricultural productivity, profitability, and sustainability for farmers and agribusinesses.",
      icon: <Rocket className="h-6 w-6 text-shamba-green" />,
    },
  ];

  const objectives = [
    "Empower farmers and agribusinesses with transparent information.",
    "Support accurate, timely, and actionable recommendations.",
    "Enable better planning, productivity, and profitability through intelligent insights.",
    "Drive growth and resilience for communities in Sub-Saharan Africa."
  ];

  return (
    <section id="about" className="bg-shamba-sand py-16 md:py-24">
      <div className="container mx-auto px-4">
        <div className="text-center mb-16">
          <h2 className="text-3xl md:text-4xl font-bold text-shamba-green-dark">
            {title}
          </h2>
          <div className="w-20 h-1 bg-shamba-green mx-auto mt-4 mb-6"></div>
          <p className="max-w-3xl mx-auto text-lg text-gray-700">
            {subtitle}
          </p>
        </div>
        <div className="grid grid-cols-1 md:grid-cols-2 gap-8 mb-16">
          {features.map((feature, index) => (
            <div key={index} className="flex items-start">
              <div className="mr-4">{feature.icon}</div>
              <div>
                <h3 className="text-xl font-bold text-shamba-green-dark mb-2">{feature.title}</h3>
                <p className="text-gray-700">{feature.description}</p>
              </div>
            </div>
          ))}
        </div>
        <div className="text-center">
          <h3 className="text-2xl font-bold text-shamba-green-dark mb-4">Our Objectives</h3>
          <ul className="list-disc list-inside text-lg text-gray-700 max-w-md mx-auto">
            {objectives.map((objective, index) => (
              <li key={index} className="mb-2">{objective}</li>
            ))}
          </ul>
        </div>
      </div>
    </section>
  );
}
