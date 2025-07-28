import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/theme/app_theme.dart';

class SeedsPage extends StatelessWidget {
  final String selectedCrop;

  const SeedsPage({super.key, required this.selectedCrop});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Seed Varieties Section
          _buildSectionCard(
            title: 'Available Seed Varieties',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSeedCard(
                  'H614',
                  'High yielding hybrid',
                  '120-140 days',
                  '25kg/ha',
                  Icons.star,
                  Colors.green,
                ),
                _buildSeedCard(
                  'H6213',
                  'Drought tolerant',
                  '110-130 days',
                  '20kg/ha',
                  Icons.water_drop,
                  Colors.blue,
                ),
                _buildSeedCard(
                  'H6212',
                  'Early maturing',
                  '90-110 days',
                  '22kg/ha',
                  Icons.schedule,
                  Colors.orange,
                ),
                _buildSeedCard(
                  'H6210',
                  'Disease resistant',
                  '115-135 days',
                  '24kg/ha',
                  Icons.shield,
                  Colors.purple,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Seed Prices Section
          _buildSectionCard(
            title: 'Seed Prices & Availability',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildPriceCard('H614', 'KES 2,500', 'In stock', Colors.green),
                _buildPriceCard('H6213', 'KES 2,800', 'Limited stock', Colors.orange),
                _buildPriceCard('H6212', 'KES 2,200', 'In stock', Colors.green),
                _buildPriceCard('H6210', 'KES 2,600', 'In stock', Colors.green),
                const SizedBox(height: 12),
                Text(
                  'Price Analysis:',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primaryGreen,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '• Prices range from KES 2,200 to KES 2,800\n'
                  '• H6213 is premium due to drought tolerance\n'
                  '• H6212 offers best value for early harvest\n'
                  '• All varieties are readily available',
                  style: GoogleFonts.poppins(fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Germination & Quality Section
          _buildSectionCard(
            title: 'Germination & Quality',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildQualityCard('Germination Rate', '85-95%', 'Excellent', Colors.green),
                _buildQualityCard('Purity', '99.5%', 'High quality', Colors.green),
                _buildQualityCard('Moisture Content', '12%', 'Optimal', Colors.green),
                _buildQualityCard('Vigor', 'High', 'Strong seedlings', Colors.green),
                const SizedBox(height: 12),
                Text(
                  'Quality Standards:',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primaryGreen,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '• All seeds meet international standards\n'
                  '• Certified by Kenya Plant Health Inspectorate\n'
                  '• Proper storage conditions maintained\n'
                  '• Quality guaranteed by suppliers',
                  style: GoogleFonts.poppins(fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Selection Guide Section
          _buildSectionCard(
            title: 'Seed Selection Guide',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildGuideCard(
                  'High Rainfall Areas',
                  'Choose H614 for maximum yield',
                  Icons.wb_sunny,
                  Colors.blue,
                ),
                _buildGuideCard(
                  'Drought Prone Areas',
                  'Select H6213 for drought tolerance',
                  Icons.water_drop,
                  Colors.orange,
                ),
                _buildGuideCard(
                  'Early Market',
                  'Use H6212 for early harvest',
                  Icons.schedule,
                  Colors.green,
                ),
                _buildGuideCard(
                  'Disease Prone Areas',
                  'Prefer H6210 for disease resistance',
                  Icons.shield,
                  Colors.purple,
                ),
                _buildGuideCard(
                  'Organic Farming',
                  'Consider certified organic seeds',
                  Icons.eco,
                  Colors.teal,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Planting Recommendations Section
          _buildSectionCard(
            title: 'Planting Recommendations',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildRecommendationCard(
                  'Seed Rate',
                  '25kg/ha for optimal plant population',
                  Icons.scale,
                  Colors.green,
                ),
                _buildRecommendationCard(
                  'Planting Depth',
                  '2-3cm for proper germination',
                  Icons.height,
                  Colors.blue,
                ),
                _buildRecommendationCard(
                  'Spacing',
                  '75cm x 25cm for good yield',
                  Icons.grid_on,
                  Colors.orange,
                ),
                _buildRecommendationCard(
                  'Pre-treatment',
                  'Treat with fungicide before planting',
                  Icons.science,
                  Colors.purple,
                ),
                _buildRecommendationCard(
                  'Storage',
                  'Keep in cool, dry place',
                  Icons.warehouse,
                  Colors.teal,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Supplier Information Section
          _buildSectionCard(
            title: 'Supplier Information',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSupplierCard('Kenya Seed Company', 'Official distributor', 'Nairobi', Icons.business, Colors.green),
                _buildSupplierCard('Western Seed Company', 'Regional supplier', 'Kakamega', Icons.location_on, Colors.blue),
                _buildSupplierCard('Pioneer Seeds', 'International brand', 'Nakuru', Icons.star, Colors.orange),
                _buildSupplierCard('Local Agro-dealers', 'Convenient access', 'Various', Icons.store, Colors.purple),
                const SizedBox(height: 12),
                Text(
                  'Purchase Tips:',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primaryGreen,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '• Buy from certified dealers only\n'
                  '• Check seed certification labels\n'
                  '• Verify expiry dates before purchase\n'
                  '• Store properly after purchase',
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

  Widget _buildSeedCard(String variety, String description, String maturity, String seedRate, IconData icon, Color color) {
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
                  variety,
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
                Row(
                  children: [
                    Text(
                      'Maturity: $maturity',
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Rate: $seedRate',
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceCard(String variety, String price, String status, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            variety,
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                price,
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

  Widget _buildQualityCard(String parameter, String value, String status, Color color) {
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

  Widget _buildGuideCard(String condition, String recommendation, IconData icon, Color color) {
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
                  condition,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
                Text(
                  recommendation,
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

  Widget _buildSupplierCard(String name, String type, String location, IconData icon, Color color) {
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
                  name,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
                Text(
                  type,
                  style: GoogleFonts.poppins(
                    fontSize: 10,
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  location,
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