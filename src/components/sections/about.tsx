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
    <section id="about" className="bg-shamba-sand py-8 md:py-16">
      <div className="container mx-auto px-4">
        <div className="text-center mb-8 md:mb-16">
          <h2 className="text-2xl md:text-4xl font-bold text-shamba-green-dark">
            {title}
          </h2>
          <div className="w-20 h-1 bg-shamba-green mx-auto mt-3 md:mt-4 mb-4 md:mb-6"></div>
          <p className="max-w-3xl mx-auto text-base md:text-lg text-gray-700">
            {subtitle}
          </p>
        </div>
        <div className="max-w-3xl mx-auto space-y-8 md:space-y-12">
          {features.map((feature, index) => (
            <div key={index} className="flex items-start">
              <div className="mr-4">{feature.icon}</div>
              <div>
                <h3 className="text-xl font-bold text-shamba-green-dark mb-2">{feature.title}</h3>
                <p className="text-gray-700">{feature.description}</p>
              </div>
            </div>
          ))}
          <div className="flex items-start">
            <div className="mr-4"><Rocket className="h-6 w-6 text-shamba-green" /></div>
            <div>
              <h3 className="text-xl font-bold text-shamba-green-dark mb-2">Our Objectives</h3>
              <ul className="list-disc list-inside text-gray-700">
                {objectives.map((objective, index) => (
                  <li key={index} className="mb-2">{objective}</li>
                ))}
              </ul>
            </div>
          </div>
        </div>
      </div>
    </section>
  );
}
