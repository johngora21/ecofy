import { MessageSquare, BookOpen, Calendar, Users } from "lucide-react";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";

export function ExpertSupportSection() {
  const features = [
    {
      title: "Community Forum",
      description: "Topic-based discussion threads, expert-moderated conversations, location-based farming advice, language support for regional dialects, and anonymous query submission.",
      icon: <Users className="h-8 w-8 text-shamba-green" />,
    },
    {
      title: "Expert Consultation",
      description: "Direct chat with agricultural experts, video consultation scheduling, text-based query resolution, technical problem-solving, and crop-specific guidance.",
      icon: <MessageSquare className="h-8 w-8 text-shamba-green" />,
    },
    {
      title: "Knowledge Base",
      description: "Comprehensive agricultural articles, video tutorials, best practices library, research paper summaries, and government scheme information.",
      icon: <BookOpen className="h-8 w-8 text-shamba-green" />,
    },
    {
      title: "Training and Webinars",
      description: "Live online workshops, recorded training sessions, skill development courses, certification programs, and interactive learning modules.",
      icon: <Calendar className="h-8 w-8 text-shamba-green" />,
    },
  ];

  return (
    <section id="expert-support" className="bg-shamba-green/10 py-8 md:py-16">
      <div className="container mx-auto px-4">
        <div className="text-center mb-8 md:mb-16">
          <h2 className="text-2xl md:text-4xl font-bold text-shamba-green-dark">
            Expert Support Module
          </h2>
          <div className="w-20 h-1 bg-shamba-green mx-auto mt-3 md:mt-4 mb-4 md:mb-6"></div>
          <p className="max-w-3xl mx-auto text-base md:text-lg text-gray-700">
            Access expert knowledge, community discussions, and specialized agricultural training to improve farming practices.
          </p>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 md:gap-8">
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
