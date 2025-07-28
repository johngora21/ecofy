import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/theme/app_theme.dart';

class SoilPage extends StatelessWidget {
  final String selectedCrop;

  const SoilPage({super.key, required this.selectedCrop});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Soil Health Overview Section
          _buildSectionCard(
            title: 'Soil Health Overview',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoRow('Soil Type', 'Loamy soil'),
                _buildInfoRow('pH Level', '6.2 (Slightly acidic)'),
                _buildInfoRow('Organic Matter', '2.8% (Good)'),
                _buildInfoRow('Drainage', 'Well-drained'),
                _buildInfoRow('Soil Depth', '120cm (Deep)'),
                _buildInfoRow('Texture', 'Medium texture'),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // NPK Analysis Section
          _buildSectionCard(
            title: 'NPK Analysis',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildNutrientCard('Nitrogen (N)', 'Low', '15 kg/ha', Colors.red, 'Needs supplementation'),
                _buildNutrientCard('Phosphorus (P)', 'Medium', '25 kg/ha', Colors.orange, 'Adequate for growth'),
                _buildNutrientCard('Potassium (K)', 'High', '180 kg/ha', Colors.green, 'Sufficient levels'),
                const SizedBox(height: 12),
                Text(
                  'Nutrient Recommendations:',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primaryGreen,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '• Apply nitrogen fertilizer (NPK 23:23:0)\n'
                  '• Consider organic manure for nitrogen\n'
                  '• Phosphorus levels are adequate\n'
                  '• Potassium levels are optimal',
                  style: GoogleFonts.poppins(fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // pH & Salinity Section
          _buildSectionCard(
            title: 'pH & Salinity Analysis',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildPhCard('Soil pH', '6.2', 'Optimal for maize', Colors.green),
                _buildPhCard('Salinity (EC)', '0.8 dS/m', 'Low salinity', Colors.green),
                _buildPhCard('Alkalinity', 'Low', 'No issues', Colors.green),
                const SizedBox(height: 12),
                Text(
                  'pH Management:',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primaryGreen,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '• pH 6.2 is optimal for maize growth\n'
                  '• No lime application needed\n'
                  '• Low salinity ensures good root development\n'
                  '• Soil is well-suited for maize cultivation',
                  style: GoogleFonts.poppins(fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Soil Recommendations Section
          _buildSectionCard(
            title: 'Soil Management Recommendations',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildRecommendationCard(
                  'Fertilization Strategy',
                  'Apply NPK 23:23:0 at planting',
                  Icons.eco,
                  Colors.green,
                ),
                _buildRecommendationCard(
                  'Organic Matter',
                  'Add compost or manure to improve structure',
                  Icons.grass,
                  Colors.orange,
                ),
                _buildRecommendationCard(
                  'Soil Testing',
                  'Test soil every 2-3 years',
                  Icons.science,
                  Colors.blue,
                ),
                _buildRecommendationCard(
                  'Crop Rotation',
                  'Rotate with legumes to improve nitrogen',
                  Icons.refresh,
                  Colors.purple,
                ),
                _buildRecommendationCard(
                  'Conservation',
                  'Practice minimum tillage to preserve structure',
                  Icons.agriculture,
                  Colors.teal,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Soil Properties Section
          _buildSectionCard(
            title: 'Detailed Soil Properties',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildPropertyRow('Clay Content', '25%'),
                _buildPropertyRow('Silt Content', '35%'),
                _buildPropertyRow('Sand Content', '40%'),
                _buildPropertyRow('Bulk Density', '1.4 g/cm³'),
                _buildPropertyRow('Porosity', '45%'),
                _buildPropertyRow('Water Holding Capacity', 'Good'),
                const SizedBox(height: 12),
                Text(
                  'Soil Structure Analysis:',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primaryGreen,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '• Well-balanced texture with good drainage\n'
                  '• Adequate water holding capacity\n'
                  '• Good root penetration potential\n'
                  '• Suitable for mechanized farming',
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

  Widget _buildNutrientCard(String nutrient, String level, String amount, Color color, String note) {
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
                nutrient,
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
                  level,
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
            amount,
            style: GoogleFonts.poppins(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
          Text(
            note,
            style: GoogleFonts.poppins(
              fontSize: 10,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhCard(String parameter, String value, String status, Color color) {
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

  Widget _buildRecommendationCard(String title, String description, IconData icon, Color color) {
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

  Widget _buildPropertyRow(String property, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            property,
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