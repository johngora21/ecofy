import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/theme/app_theme.dart';

class RegionsPage extends StatelessWidget {
  final String selectedCrop;

  const RegionsPage({super.key, required this.selectedCrop});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Area Suitability Overview Section
          _buildSectionCard(
            title: 'Area Suitability Overview',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSuitabilityCard('Highly Suitable', '60% of Kenya', 'Optimal conditions', Icons.star, Colors.green),
                _buildSuitabilityCard('Moderately Suitable', '30% of Kenya', 'Good conditions', Icons.check_circle, Colors.orange),
                _buildSuitabilityCard('Less Suitable', '10% of Kenya', 'Challenging conditions', Icons.warning, Colors.red),
                const SizedBox(height: 12),
                Text(
                  'Suitability Factors:',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primaryGreen,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '• Climate conditions (temperature, rainfall)\n'
                  '• Soil type and fertility\n'
                  '• Altitude and topography\n'
                  '• Market access and infrastructure',
                  style: GoogleFonts.poppins(fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Top Recommended Regions Section
          _buildSectionCard(
            title: 'Top Recommended Regions',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildRegionCard(
                  'Trans Nzoia County',
                  'North Rift',
                  'High yield potential',
                  'Excellent soil and climate',
                  Icons.location_on,
                  Colors.green,
                ),
                _buildRegionCard(
                  'Uasin Gishu County',
                  'North Rift',
                  'Large scale farming',
                  'Good infrastructure',
                  Icons.agriculture,
                  Colors.green,
                ),
                _buildRegionCard(
                  'Nakuru County',
                  'Rift Valley',
                  'Mixed farming',
                  'Favorable conditions',
                  Icons.eco,
                  Colors.blue,
                ),
                _buildRegionCard(
                  'Bungoma County',
                  'Western Kenya',
                  'Small scale farming',
                  'Good rainfall pattern',
                  Icons.water_drop,
                  Colors.orange,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Regional Analysis Section
          _buildSectionCard(
            title: 'Detailed Regional Analysis',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildRegionalAnalysisCard(
                  'North Rift Region',
                  'Trans Nzoia, Uasin Gishu',
                  'High suitability',
                  'Large scale commercial farming',
                  Colors.green,
                ),
                _buildRegionalAnalysisCard(
                  'Central Rift Region',
                  'Nakuru, Laikipia',
                  'Medium to high suitability',
                  'Mixed farming systems',
                  Colors.blue,
                ),
                _buildRegionalAnalysisCard(
                  'Western Region',
                  'Bungoma, Kakamega',
                  'Medium suitability',
                  'Small scale farming',
                  Colors.orange,
                ),
                _buildRegionalAnalysisCard(
                  'Eastern Region',
                  'Machakos, Kitui',
                  'Low to medium suitability',
                  'Drought-prone areas',
                  Colors.red,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Climate Zones Section
          _buildSectionCard(
            title: 'Climate Zone Analysis',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildClimateZoneCard('Highland Zone', '1500-2500m', 'Optimal for maize', 'Cool temperatures', Colors.green),
                _buildClimateZoneCard('Mid-altitude Zone', '1000-1500m', 'Good for maize', 'Moderate temperatures', Colors.blue),
                _buildClimateZoneCard('Lowland Zone', '500-1000m', 'Challenging', 'Hot and dry', Colors.orange),
                _buildClimateZoneCard('Coastal Zone', '0-500m', 'Not suitable', 'High humidity', Colors.red),
                const SizedBox(height: 12),
                Text(
                  'Altitude Considerations:',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primaryGreen,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '• Maize grows best at 1000-2000m altitude\n'
                  '• Higher altitudes have cooler temperatures\n'
                  '• Lower altitudes may be too hot\n'
                  '• Consider local climate variations',
                  style: GoogleFonts.poppins(fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Soil Zones Section
          _buildSectionCard(
            title: 'Soil Zone Analysis',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSoilZoneCard('Volcanic Soils', 'Rift Valley', 'Highly fertile', 'Excellent for maize', Colors.green),
                _buildSoilZoneCard('Red Soils', 'Western Kenya', 'Moderately fertile', 'Good for maize', Colors.blue),
                _buildSoilZoneCard('Sandy Soils', 'Coastal areas', 'Low fertility', 'Poor for maize', Colors.red),
                _buildSoilZoneCard('Clay Soils', 'Various regions', 'Variable fertility', 'Depends on management', Colors.orange),
                const SizedBox(height: 12),
                Text(
                  'Soil Considerations:',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primaryGreen,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '• Volcanic soils are most suitable\n'
                  '• Well-drained soils preferred\n'
                  '• pH 6.0-7.0 is optimal\n'
                  '• Organic matter content important',
                  style: GoogleFonts.poppins(fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Market Access Section
          _buildSectionCard(
            title: 'Market Access Analysis',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildMarketAccessCard('Nairobi Metro', 'Excellent access', 'High demand', 'Premium prices', Colors.green),
                _buildMarketAccessCard('Major Towns', 'Good access', 'Steady demand', 'Competitive prices', Colors.blue),
                _buildMarketAccessCard('Rural Areas', 'Limited access', 'Local demand', 'Lower prices', Colors.orange),
                _buildMarketAccessCard('Remote Areas', 'Poor access', 'Limited demand', 'Transport costs', Colors.red),
                const SizedBox(height: 12),
                Text(
                  'Market Considerations:',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primaryGreen,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '• Proximity to markets affects profitability\n'
                  '• Transport costs impact net returns\n'
                  '• Urban areas offer better prices\n'
                  '• Consider storage facilities',
                  style: GoogleFonts.poppins(fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Infrastructure Section
          _buildSectionCard(
            title: 'Infrastructure Analysis',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfrastructureCard(
                  'Road Network',
                  'Good in major regions',
                  'Affects transport costs',
                  Icons.directions_car,
                  Colors.blue,
                ),
                _buildInfrastructureCard(
                  'Storage Facilities',
                  'Available in major towns',
                  'Reduces post-harvest losses',
                  Icons.warehouse,
                  Colors.green,
                ),
                _buildInfrastructureCard(
                  'Processing Plants',
                  'Limited availability',
                  'Adds value to produce',
                  Icons.factory,
                  Colors.orange,
                ),
                _buildInfrastructureCard(
                  'Extension Services',
                  'Available in most areas',
                  'Provides technical support',
                  Icons.school,
                  Colors.purple,
                ),
                _buildInfrastructureCard(
                  'Financial Services',
                  'Accessible in urban areas',
                  'Supports investment',
                  Icons.account_balance,
                  Colors.teal,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppTheme.primaryGreen,
            ),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _buildSuitabilityCard(String level, String coverage, String description, IconData icon, Color color) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  level,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
                Text(
                  coverage,
                  style: GoogleFonts.poppins(
                    fontSize: 10,
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  description,
                  style: GoogleFonts.poppins(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRegionCard(String county, String region, String advantage, String description, IconData icon, Color color) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  county,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
                Text(
                  region,
                  style: GoogleFonts.poppins(
                    fontSize: 10,
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  advantage,
                  style: GoogleFonts.poppins(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  description,
                  style: GoogleFonts.poppins(
                    fontSize: 10,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRegionalAnalysisCard(String region, String counties, String suitability, String farming, Color color) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                region,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  suitability,
                  style: GoogleFonts.poppins(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            counties,
            style: GoogleFonts.poppins(
              fontSize: 10,
              color: Colors.grey[600],
            ),
          ),
          Text(
            farming,
            style: GoogleFonts.poppins(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClimateZoneCard(String zone, String altitude, String suitability, String description, Color color) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                zone,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                altitude,
                style: GoogleFonts.poppins(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            suitability,
            style: GoogleFonts.poppins(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
          Text(
            description,
            style: GoogleFonts.poppins(
              fontSize: 10,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSoilZoneCard(String soilType, String location, String fertility, String suitability, Color color) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                soilType,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                location,
                style: GoogleFonts.poppins(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            fertility,
            style: GoogleFonts.poppins(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
          Text(
            suitability,
            style: GoogleFonts.poppins(
              fontSize: 10,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMarketAccessCard(String area, String access, String demand, String prices, Color color) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                area,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                access,
                style: GoogleFonts.poppins(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            demand,
            style: GoogleFonts.poppins(
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            prices,
            style: GoogleFonts.poppins(
              fontSize: 10,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfrastructureCard(String infrastructure, String status, String impact, IconData icon, Color color) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  infrastructure,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
                Text(
                  status,
                  style: GoogleFonts.poppins(
                    fontSize: 10,
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  impact,
                  style: GoogleFonts.poppins(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
} 