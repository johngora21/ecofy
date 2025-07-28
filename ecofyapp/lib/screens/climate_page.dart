import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/theme/app_theme.dart';

class ClimatePage extends StatelessWidget {
  final String selectedCrop;

  const ClimatePage({super.key, required this.selectedCrop});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Climate Overview Section
          _buildSectionCard(
            title: 'Climate Overview',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoRow('Climate Type', 'Tropical Savannah'),
                _buildInfoRow('Temperature Range', '20-30°C'),
                _buildInfoRow('Rainfall Pattern', 'Bimodal (March-May, Oct-Dec)'),
                _buildInfoRow('Humidity', '60-80%'),
                _buildInfoRow('Sunshine Hours', '6-8 hours daily'),
                _buildInfoRow('Wind Speed', 'Light to moderate'),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Temperature Analysis Section
          _buildSectionCard(
            title: 'Temperature Analysis',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTempCard('Minimum Temp', '18°C', 'Optimal for growth', Colors.blue),
                _buildTempCard('Maximum Temp', '32°C', 'Within tolerance', Colors.orange),
                _buildTempCard('Average Temp', '25°C', 'Ideal for maize', Colors.green),
                _buildTempCard('Night Temp', '15°C', 'Good for respiration', Colors.purple),
                const SizedBox(height: 12),
                Text(
                  'Temperature Management:',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primaryGreen,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '• Optimal temperature range for maize: 20-30°C\n'
                  '• Temperatures are within ideal range\n'
                  '• No extreme temperature stress expected\n'
                  '• Good diurnal temperature variation',
                  style: GoogleFonts.poppins(fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Rainfall Analysis Section
          _buildSectionCard(
            title: 'Rainfall Analysis',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildRainfallCard('Annual Rainfall', '1200mm', 'Adequate', Colors.green),
                _buildRainfallCard('Growing Season', '800mm', 'Sufficient', Colors.green),
                _buildRainfallCard('Distribution', 'Bimodal', 'Good pattern', Colors.blue),
                _buildRainfallCard('Dry Spells', 'Minimal', 'Low risk', Colors.green),
                const SizedBox(height: 12),
                Text(
                  'Rainfall Management:',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primaryGreen,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '• Bimodal rainfall pattern suits maize\n'
                  '• Adequate rainfall for crop development\n'
                  '• Consider irrigation during dry spells\n'
                  '• Plan planting around rainfall peaks',
                  style: GoogleFonts.poppins(fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Growing Seasons Section
          _buildSectionCard(
            title: 'Growing Seasons',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSeasonCard(
                  'Long Rains (March-May)',
                  'Primary growing season',
                  'Optimal conditions',
                  Icons.wb_sunny,
                  Colors.orange,
                ),
                _buildSeasonCard(
                  'Short Rains (Oct-Dec)',
                  'Secondary growing season',
                  'Good for late crops',
                  Icons.cloud,
                  Colors.blue,
                ),
                _buildSeasonCard(
                  'Dry Season (Jan-Feb)',
                  'Harvest and preparation',
                  'Plan for next season',
                  Icons.agriculture,
                  Colors.grey,
                ),
                _buildSeasonCard(
                  'Dry Season (Jun-Sep)',
                  'Storage and marketing',
                  'Focus on post-harvest',
                  Icons.warehouse,
                  Colors.purple,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Climate Management Section
          _buildSectionCard(
            title: 'Climate Management Strategies',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildStrategyCard(
                  'Irrigation Planning',
                  'Supplement rainfall during dry spells',
                  Icons.water_drop,
                  Colors.blue,
                ),
                _buildStrategyCard(
                  'Planting Timing',
                  'Align with rainfall patterns',
                  Icons.calendar_today,
                  Colors.green,
                ),
                _buildStrategyCard(
                  'Crop Protection',
                  'Protect from extreme weather',
                  Icons.shield,
                  Colors.orange,
                ),
                _buildStrategyCard(
                  'Soil Moisture',
                  'Maintain optimal soil moisture',
                  Icons.eco,
                  Colors.teal,
                ),
                _buildStrategyCard(
                  'Harvest Timing',
                  'Avoid harvesting during rains',
                  Icons.schedule,
                  Colors.purple,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Climate Parameters Section
          _buildSectionCard(
            title: 'Detailed Climate Parameters',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildParameterRow('Relative Humidity', '70%'),
                _buildParameterRow('Evaporation Rate', '4mm/day'),
                _buildParameterRow('Solar Radiation', '18 MJ/m²/day'),
                _buildParameterRow('Frost Risk', 'None'),
                _buildParameterRow('Heat Stress', 'Low risk'),
                _buildParameterRow('Wind Erosion', 'Minimal'),
                const SizedBox(height: 12),
                Text(
                  'Climate Suitability:',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primaryGreen,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '• Climate is highly suitable for maize\n'
                  '• No major climate constraints\n'
                  '• Good growing conditions year-round\n'
                  '• Favorable for high yields',
                  style: GoogleFonts.poppins(fontSize: 12),
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

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppTheme.primaryGreen,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTempCard(String temp, String value, String status, Color color) {
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            temp,
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value,
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
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRainfallCard(String parameter, String value, String status, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            parameter,
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value,
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
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSeasonCard(String season, String description, String status, IconData icon, Color color) {
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
                  season,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
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
                Text(
                  status,
                  style: GoogleFonts.poppins(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStrategyCard(String title, String description, IconData icon, Color color) {
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
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
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
          ),
        ],
      ),
    );
  }

  Widget _buildParameterRow(String parameter, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            parameter,
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppTheme.primaryGreen,
            ),
          ),
        ],
      ),
    );
  }
} 