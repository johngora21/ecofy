class Crop {
  final String name;
  final String scientificName;
  final String category;
  final String description;

  Crop({
    required this.name,
    required this.scientificName,
    required this.category,
    required this.description,
  });
}

class TanzaniaCrops {
  static final List<Crop> crops = [
    Crop(
      name: "Maize",
      scientificName: "Zea mays",
      category: "Cereals",
      description: "Staple food crop widely grown across Tanzania",
    ),
    Crop(
      name: "Rice",
      scientificName: "Oryza sativa",
      category: "Cereals",
      description: "Important food crop, especially in irrigated areas",
    ),
    Crop(
      name: "Beans",
      scientificName: "Phaseolus vulgaris",
      category: "Legumes",
      description: "Protein-rich legume crop",
    ),
    Crop(
      name: "Wheat",
      scientificName: "Triticum aestivum",
      category: "Cereals",
      description: "Cereal crop grown in cooler highland areas",
    ),
    Crop(
      name: "Sorghum",
      scientificName: "Sorghum bicolor",
      category: "Cereals",
      description: "Drought-tolerant cereal crop",
    ),
    Crop(
      name: "Millet",
      scientificName: "Pennisetum glaucum",
      category: "Cereals",
      description: "Drought-resistant cereal crop",
    ),
    Crop(
      name: "Irish Potato",
      scientificName: "Solanum tuberosum",
      category: "Tubers",
      description: "Important tuber crop grown in highlands",
    ),
    Crop(
      name: "Sweet Potato",
      scientificName: "Ipomoea batatas",
      category: "Tubers",
      description: "Nutritious tuber crop",
    ),
    Crop(
      name: "Cassava",
      scientificName: "Manihot esculenta",
      category: "Tubers",
      description: "Drought-tolerant root crop",
    ),
    Crop(
      name: "Yam",
      scientificName: "Dioscorea spp.",
      category: "Tubers",
      description: "Traditional tuber crop",
    ),
    Crop(
      name: "Tomato",
      scientificName: "Solanum lycopersicum",
      category: "Vegetables",
      description: "Popular vegetable crop",
    ),
    Crop(
      name: "Onion",
      scientificName: "Allium cepa",
      category: "Vegetables",
      description: "Important vegetable crop",
    ),
    Crop(
      name: "Carrot",
      scientificName: "Daucus carota",
      category: "Vegetables",
      description: "Root vegetable crop",
    ),
    Crop(
      name: "Cabbage",
      scientificName: "Brassica oleracea",
      category: "Vegetables",
      description: "Leafy vegetable crop",
    ),
    Crop(
      name: "Lettuce",
      scientificName: "Lactuca sativa",
      category: "Vegetables",
      description: "Leafy salad vegetable",
    ),
    Crop(
      name: "Watermelon",
      scientificName: "Citrullus lanatus",
      category: "Fruits",
      description: "Popular fruit crop",
    ),
    Crop(
      name: "Pineapple",
      scientificName: "Ananas comosus",
      category: "Fruits",
      description: "Tropical fruit crop",
    ),
    Crop(
      name: "Banana",
      scientificName: "Musa spp.",
      category: "Fruits",
      description: "Important fruit and food crop",
    ),
    Crop(
      name: "Tea",
      scientificName: "Camellia sinensis",
      category: "Cash Crops",
      description: "Important cash crop for export",
    ),
    Crop(
      name: "Coffee",
      scientificName: "Coffea arabica",
      category: "Cash Crops",
      description: "Major export cash crop",
    ),
    Crop(
      name: "Cotton",
      scientificName: "Gossypium hirsutum",
      category: "Cash Crops",
      description: "Fiber crop for textile industry",
    ),
    Crop(
      name: "Tobacco",
      scientificName: "Nicotiana tabacum",
      category: "Cash Crops",
      description: "Commercial crop for export",
    ),
    Crop(
      name: "Vanilla",
      scientificName: "Vanilla planifolia",
      category: "Cash Crops",
      description: "High-value spice crop",
    ),
    Crop(
      name: "Ginger",
      scientificName: "Zingiber officinale",
      category: "Spices",
      description: "Spice crop with medicinal properties",
    ),
  ];

  // Get all crop names
  static List<String> getCropNames() {
    return crops.map((crop) => crop.name).toList();
  }

  // Get crops by category
  static List<String> getCropsByCategory(String category) {
    return crops
        .where((crop) => crop.category == category)
        .map((crop) => crop.name)
        .toList();
  }

  // Get all categories
  static List<String> getCategories() {
    return crops.map((crop) => crop.category).toSet().toList();
  }

  // Get crop details by name
  static Crop? getCropByName(String name) {
    try {
      return crops.firstWhere((crop) => crop.name == name);
    } catch (e) {
      return null;
    }
  }

  // Get crops by scientific name
  static List<String> getCropsByScientificName(String scientificName) {
    return crops
        .where((crop) => crop.scientificName == scientificName)
        .map((crop) => crop.name)
        .toList();
  }
} 