import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/theme/app_theme.dart';
import 'ai_chatbot_screen.dart';
import 'market_page.dart';
import 'soil_page.dart';
import 'climate_page.dart';
import 'seeds_page.dart';
import 'risks_page.dart';
import 'regions_page.dart';
import '../data/tanzania_crops.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String selectedCrop = 'Maize';
  int selectedSectionIndex = 0;

  final List<String> crops = TanzaniaCrops.getCropNames();
  final List<Map<String, dynamic>> sections = const [
    {'title': 'Market', 'icon': Icons.trending_up, 'color': AppTheme.primaryGreen},
    {'title': 'Soil', 'icon': Icons.eco, 'color': AppTheme.primaryGreen},
    {'title': 'Climate', 'icon': Icons.wb_sunny, 'color': AppTheme.primaryGreen},
    {'title': 'Seeds', 'icon': Icons.grass, 'color': AppTheme.primaryGreen},
    {'title': 'Risks', 'icon': Icons.warning, 'color': AppTheme.primaryGreen},
    {'title': 'Regions', 'icon': Icons.location_on, 'color': AppTheme.primaryGreen},
  ];

  Widget _buildSectionButton(BuildContext context, Map<String, dynamic> section, int index) {
    final isSelected = selectedSectionIndex == index;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedSectionIndex = index;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(right: 8.0),
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        decoration: BoxDecoration(
          color: isSelected ? section['color'] : Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(
            color: isSelected ? section['color'] : AppTheme.borderLight,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              section['icon'],
              size: 16,
              color: isSelected ? Colors.white : section['color'],
            ),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                section['title'],
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? Colors.white : AppTheme.textPrimary,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionContent() {
    switch (selectedSectionIndex) {
      case 0:
        return MarketPage(selectedCrop: selectedCrop);
      case 1:
        return SoilPage(selectedCrop: selectedCrop);
      case 2:
        return ClimatePage(selectedCrop: selectedCrop);
      case 3:
        return SeedsPage(selectedCrop: selectedCrop);
      case 4:
        return RisksPage(selectedCrop: selectedCrop);
      case 5:
        return RegionsPage(selectedCrop: selectedCrop);
      default:
        return MarketPage(selectedCrop: selectedCrop);
  }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      floatingActionButton: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppTheme.primaryGreen, AppTheme.successGreen],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primaryGreen.withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AIChatbotScreen(),
              ),
            );
          },
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: const Icon(
            Icons.chat_bubble_outline,
            color: Colors.white,
            size: 28,
          ),
        ),
      ),
      body: Container(
        color: AppTheme.backgroundLight,
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
                boxShadow: const [
                  BoxShadow(
                    color: AppTheme.shadowLight,
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Ads Card
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(bottom: 20),
                    height: 200,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppTheme.primaryGreen, AppTheme.successGreen],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.primaryGreen.withValues(alpha: 0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Stack(
                        children: [
                          // Placeholder for poster image
                          Container(
                            width: double.infinity,
                            height: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.1),
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.image,
                                color: Colors.white,
                                size: 48,
                              ),
                            ),
                          ),
                          // Overlay for better text visibility
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.black.withValues(alpha: 0.3),
                                ],
                              ),
                            ),
                          ),
                          // Content overlay
                          Positioned(
                            bottom: 16,
                            left: 16,
                            right: 16,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: AppTheme.primaryGreen,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    'NEW',
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Premium Farming Solutions',
                                  style: GoogleFonts.poppins(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Tap to explore',
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    color: Colors.white.withValues(alpha: 0.9),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  // Crop Selection Row
                  Row(
                children: [
                  const Spacer(),
                  Container(
                    width: 180,
                    height: 45,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: Colors.grey.shade300, width: 1),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedCrop,
                        isExpanded: true,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        hint: Text(
                          'Select crop',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        icon: Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.grey.shade600,
                          size: 18,
                        ),
                        items: crops.map((String crop) {
                          return DropdownMenuItem<String>(
                            value: crop,
                            child: Text(
                              crop,
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            setState(() {
                              selectedCrop = newValue;
                            });
                          }
                        },
                      ),
                    ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    // Navigation Buttons
                    SizedBox(
                      height: 40,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: sections.length,
                        itemBuilder: (context, index) {
                          return _buildSectionButton(context, sections[index], index);
                        },
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    // Section Content
                    Expanded(
                      child: _buildSectionContent(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 