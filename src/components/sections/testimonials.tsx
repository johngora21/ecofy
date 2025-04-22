
import { MessageSquareText } from "lucide-react";

const previews = [
  {
    name: "Asha from Mbeya",
    text: "Ecofy's tools helped me understand my soil and choose better crops. I've seen my harvests improve each season.",
    photo: "/lovable-uploads/3d7a769d-a6df-4024-a4d9-9b291724c7fa.png"
  },
  {
    name: "John from Morogoro",
    text: "Getting soil data from my phone makes farming smarter. The advice from Ecofy changed how my family farms.",
    photo: "/lovable-uploads/436bbce1-74f2-40ed-ab14-e97441355a8c.png"
  },
  {
    name: "Mama Rehema from Iringa",
    text: "With Ecofy, I know when and how to water my crops. The weather alerts save my farm every rainy season!",
    photo: "/lovable-uploads/7b9b1a70-0947-4909-8752-2614cc542da1.png"
  }
];

export function TestimonialsSection() {
  return (
    <section className="bg-shamba-green/10 py-16 md:py-24" id="testimonials">
      <div className="container mx-auto px-4">
        <div className="text-center mb-12">
          <h2 className="text-3xl md:text-4xl font-bold text-shamba-green-dark">What Farmers Say</h2>
          <div className="w-20 h-1 bg-shamba-green mx-auto mt-4 mb-6"></div>
          <p className="max-w-2xl mx-auto text-lg text-gray-700">
            Hear from real Ecofy users in Tanzanian villages.
          </p>
        </div>
        <div className="grid grid-cols-1 md:grid-cols-3 gap-10">
          {previews.map((pv, idx) => (
            <div key={idx} className="bg-white rounded-lg shadow-lg p-8 flex flex-col items-center text-center hover:shadow-xl transition hover-scale animate-fade-in">
              <img src={pv.photo} alt={pv.name} className="w-24 h-24 rounded-full object-cover mb-4 shadow" />
              <MessageSquareText className="text-shamba-green w-8 h-8 mb-2"/>
              <p className="text-gray-700 mb-4">"{pv.text}"</p>
              <span className="font-bold text-shamba-green-dark">{pv.name}</span>
            </div>
          ))}
        </div>
      </div>
    </section>
  );
}
