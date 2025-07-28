class District {
  final String name;

  District({required this.name});
}

class Region {
  final String name;
  final List<District> districts;

  Region({required this.name, required this.districts});
}

class TanzaniaRegions {
  static final List<Region> regions = [
    Region(
      name: "Arusha",
      districts: [
        District(name: "Arusha City"),
        District(name: "Arusha Rural"),
        District(name: "Karatu"),
        District(name: "Longido"),
        District(name: "Meru"),
        District(name: "Monduli"),
        District(name: "Ngorongoro"),
      ],
    ),
    Region(
      name: "Dar es Salaam",
      districts: [
        District(name: "Ilala"),
        District(name: "Kigamboni"),
        District(name: "Kinondoni"),
        District(name: "Temeke"),
        District(name: "Ubungo"),
      ],
    ),
    Region(
      name: "Dodoma",
      districts: [
        District(name: "Bahi"),
        District(name: "Chamwino"),
        District(name: "Chemba"),
        District(name: "Dodoma City"),
        District(name: "Kondoa Rural"),
        District(name: "Kondoa Town"),
        District(name: "Kongwa"),
        District(name: "Mpwapwa"),
      ],
    ),
    Region(
      name: "Geita",
      districts: [
        District(name: "Bukombe"),
        District(name: "Chato"),
        District(name: "Geita Rural"),
        District(name: "Geita Town"),
        District(name: "Mbogwe"),
        District(name: "Nyang'hwale"),
      ],
    ),
    Region(
      name: "Iringa",
      districts: [
        District(name: "Iringa Municipal"),
        District(name: "Iringa Rural"),
        District(name: "Kilolo"),
        District(name: "Mafinga Town"),
        District(name: "Mufindi"),
      ],
    ),
    Region(
      name: "Kagera",
      districts: [
        District(name: "Biharamulo"),
        District(name: "Bukoba Municipal"),
        District(name: "Bukoba Rural"),
        District(name: "Karagwe"),
        District(name: "Kyerwa"),
        District(name: "Missenyi"),
        District(name: "Muleba"),
        District(name: "Ngara"),
      ],
    ),
    Region(
      name: "Katavi",
      districts: [
        District(name: "Mlele"),
        District(name: "Mpanda Municipal"),
        District(name: "Mpimbwe"),
        District(name: "Nsimbo"),
        District(name: "Tanganyika"),
      ],
    ),
    Region(
      name: "Kigoma",
      districts: [
        District(name: "Buhigwe"),
        District(name: "Kakonko"),
        District(name: "Kasulu Rural"),
        District(name: "Kasulu Town"),
        District(name: "Kibondo"),
        District(name: "Kigoma Municipal"),
        District(name: "Kigoma Rural"),
        District(name: "Uvinza"),
      ],
    ),
    Region(
      name: "Kilimanjaro",
      districts: [
        District(name: "Hai"),
        District(name: "Moshi Municipal"),
        District(name: "Moshi Rural"),
        District(name: "Mwanga"),
        District(name: "Rombo"),
        District(name: "Same"),
        District(name: "Siha"),
      ],
    ),
    Region(
      name: "Lindi",
      districts: [
        District(name: "Kilwa"),
        District(name: "Lindi Municipal"),
        District(name: "Liwale"),
        District(name: "Mtama"),
        District(name: "Nachingwea"),
        District(name: "Ruangwa"),
      ],
    ),
    Region(
      name: "Manyara",
      districts: [
        District(name: "Babati Rural"),
        District(name: "Babati Town"),
        District(name: "Hanang"),
        District(name: "Kiteto"),
        District(name: "Mbulu Rural"),
        District(name: "Mbulu Town"),
        District(name: "Simanjiro"),
      ],
    ),
    Region(
      name: "Mara",
      districts: [
        District(name: "Bunda Rural"),
        District(name: "Bunda Town"),
        District(name: "Butiama"),
        District(name: "Musoma Municipal"),
        District(name: "Musoma Rural"),
        District(name: "Rorya"),
        District(name: "Serengeti"),
        District(name: "Tarime Rural"),
        District(name: "Tarime Town"),
      ],
    ),
    Region(
      name: "Mbeya",
      districts: [
        District(name: "Busekelo"),
        District(name: "Chunya"),
        District(name: "Kyela"),
        District(name: "Mbarali"),
        District(name: "Mbeya City"),
        District(name: "Mbeya Rural"),
        District(name: "Rungwe"),
      ],
    ),
    Region(
      name: "Morogoro",
      districts: [
        District(name: "Gairo"),
        District(name: "Ifakara Town"),
        District(name: "Kilosa"),
        District(name: "Malinyi"),
        District(name: "Mlimba"),
        District(name: "Morogoro Municipal"),
        District(name: "Morogoro Rural"),
        District(name: "Mvomero"),
        District(name: "Ulanga"),
      ],
    ),
    Region(
      name: "Mtwara",
      districts: [
        District(name: "Masasi Rural"),
        District(name: "Masasi Town"),
        District(name: "Mtwara Municipal"),
        District(name: "Mtwara Rural"),
        District(name: "Nanyamba Town"),
        District(name: "Nanyumbu"),
        District(name: "Newala Rural"),
        District(name: "Newala Town"),
        District(name: "Tandahimba"),
      ],
    ),
    Region(
      name: "Mwanza",
      districts: [
        District(name: "Buchosa"),
        District(name: "Ilemela Municipal"),
        District(name: "Kwimba"),
        District(name: "Magu"),
        District(name: "Misungwi"),
        District(name: "Mwanza City"),
        District(name: "Sengerema"),
        District(name: "Ukerewe"),
      ],
    ),
    Region(
      name: "Njombe",
      districts: [
        District(name: "Ludewa"),
        District(name: "Makambako Town"),
        District(name: "Makete"),
        District(name: "Njombe Rural"),
        District(name: "Njombe Town"),
        District(name: "Wanging'ombe"),
      ],
    ),
    Region(
      name: "Pwani",
      districts: [
        District(name: "Bagamoyo"),
        District(name: "Chalinze"),
        District(name: "Kibaha"),
        District(name: "Kibaha Town"),
        District(name: "Kibiti"),
        District(name: "Kisarawe"),
        District(name: "Mafia"),
        District(name: "Mkuranga"),
        District(name: "Rufiji"),
      ],
    ),
    Region(
      name: "Rukwa",
      districts: [
        District(name: "Kalambo"),
        District(name: "Nkasi"),
        District(name: "Sumbawanga Municipal"),
        District(name: "Sumbawanga Rural"),
      ],
    ),
    Region(
      name: "Ruvuma",
      districts: [
        District(name: "Madaba"),
        District(name: "Mbinga Rural"),
        District(name: "Mbinga Town"),
        District(name: "Namtumbo"),
        District(name: "Nyasa"),
        District(name: "Songea Municipal"),
        District(name: "Songea Rural"),
        District(name: "Tunduru"),
      ],
    ),
    Region(
      name: "Shinyanga",
      districts: [
        District(name: "Kahama Municipality"),
        District(name: "Kishapu"),
        District(name: "Msalala"),
        District(name: "Shinyanga Municipal"),
        District(name: "Shinyanga Rural"),
        District(name: "Ushetu"),
      ],
    ),
    Region(
      name: "Simiyu",
      districts: [
        District(name: "Bariadi Rural"),
        District(name: "Bariadi Town"),
        District(name: "Busega"),
        District(name: "Itilima"),
        District(name: "Maswa"),
        District(name: "Meatu"),
      ],
    ),
    Region(
      name: "Singida",
      districts: [
        District(name: "Ikungi"),
        District(name: "Iramba"),
        District(name: "Itigi"),
        District(name: "Manyoni"),
        District(name: "Mkalama"),
        District(name: "Singida Municipal"),
        District(name: "Singida Rural"),
      ],
    ),
    Region(
      name: "Songwe",
      districts: [
        District(name: "Ileje"),
        District(name: "Mbozi"),
        District(name: "Momba"),
        District(name: "Songwe"),
        District(name: "Tunduma Town"),
      ],
    ),
    Region(
      name: "Tabora",
      districts: [
        District(name: "Igunga"),
        District(name: "Kaliua"),
        District(name: "Nzega Rural"),
        District(name: "Nzega Town"),
        District(name: "Sikonge"),
        District(name: "Tabora Municipal"),
        District(name: "Urambo"),
        District(name: "Uyui"),
      ],
    ),
    Region(
      name: "Tanga",
      districts: [
        District(name: "Bumbuli"),
        District(name: "Handeni Rural"),
        District(name: "Handeni Town"),
        District(name: "Kilindi"),
        District(name: "Korogwe Rural"),
        District(name: "Korogwe Town"),
        District(name: "Lushoto"),
        District(name: "Mkinga"),
        District(name: "Muheza"),
        District(name: "Pangani"),
        District(name: "Tanga City"),
      ],
    ),
    Region(
      name: "Zanzibar Central/South",
      districts: [
        District(name: "Kati"),
        District(name: "Kusini"),
      ],
    ),
    Region(
      name: "Zanzibar North",
      districts: [
        District(name: "Kaskazini A"),
        District(name: "Kaskazini B"),
      ],
    ),
    Region(
      name: "Zanzibar Urban/West",
      districts: [
        District(name: "Magharibi A"),
        District(name: "Magharibi B"),
        District(name: "Mjini"),
      ],
    ),
  ];

  // Get all region names
  static List<String> getRegionNames() {
    return regions.map((region) => region.name).toList();
  }

  // Get all district names
  static List<String> getAllDistrictNames() {
    List<String> allDistricts = [];
    for (var region in regions) {
      allDistricts.addAll(region.districts.map((district) => district.name));
    }
    return allDistricts;
  }

  // Get districts for a specific region
  static List<String> getDistrictNames(String regionName) {
    final region = regions.firstWhere(
      (region) => region.name == regionName,
      orElse: () => Region(name: '', districts: []),
    );
    return region.districts.map((district) => district.name).toList();
  }
} 