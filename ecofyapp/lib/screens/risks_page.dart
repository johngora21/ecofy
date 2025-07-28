import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/theme/app_theme.dart';

class RisksPage extends StatelessWidget {
  final String selectedCrop;

  const RisksPage({super.key, required this.selectedCrop});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Risk Overview Section
          _buildSectionCard(
            title: 'Risk Assessment Overview',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildRiskCard('Drought Risk', 'Medium', 'Moderate impact', Icons.water_drop, Colors.orange),
                _buildRiskCard('Pest Risk', 'High', 'Significant threat', Icons.bug_report, Colors.red),
                _buildRiskCard('Disease Risk', 'Medium', 'Moderate threat', Icons.healing, Colors.orange),
                _buildRiskCard('Market Risk', 'Low', 'Stable prices', Icons.trending_up, Colors.green),
                _buildRiskCard('Climate Risk', 'Low', 'Favorable conditions', Icons.wb_sunny, Colors.green),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Drought Risk Section
          _buildSectionCard(
            title: 'Drought Risk Analysis',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildRiskDetailCard('Risk Level', 'Medium', 'Occasional dry spells', Colors.orange),
                _buildRiskDetailCard('Impact Period', 'Jan-Feb, Jun-Sep', 'Critical growth stages', Colors.red),
                _buildRiskDetailCard('Water Availability', 'Moderate', 'Irrigation needed', Colors.orange),
                _buildRiskDetailCard('Crop Tolerance', 'Good', 'Drought-resistant varieties', Colors.green),
                const SizedBox(height: 12),
                Text(
                  'Mitigation Strategies:',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primaryGreen,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '• Plant drought-tolerant varieties (H6213)\n'
                  '• Implement irrigation systems\n'
                  '• Use mulching to retain moisture\n'
                  '• Time planting to avoid dry periods',
                  style: GoogleFonts.poppins(fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Pest Risk Section
          _buildSectionCard(
            title: 'Pest Risk Analysis',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildPestCard('Stalk Borer', 'High', 'Major pest', 'Apply systemic insecticides', Colors.red),
                _buildPestCard('Armyworm', 'Medium', 'Occasional outbreaks', 'Monitor and spray', Colors.orange),
                _buildPestCard('Aphids', 'Low', 'Minor pest', 'Natural predators', Colors.green),
                _buildPestCard('Stem Borer', 'Medium', 'Moderate damage', 'Crop rotation', Colors.orange),
                const SizedBox(height: 12),
                Text(
                  'Pest Management:',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primaryGreen,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '• Regular field monitoring\n'
                  '• Integrated pest management (IPM)\n'
                  '• Use resistant varieties\n'
                  '• Biological control methods',
                  style: GoogleFonts.poppins(fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Disease Risk Section
          _buildSectionCard(
            title: 'Disease Risk Analysis',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDiseaseCard('Maize Lethal Necrosis', 'High', 'Viral disease', 'Use resistant varieties', Colors.red),
                _buildDiseaseCard('Northern Leaf Blight', 'Medium', 'Fungal disease', 'Fungicide application', Colors.orange),
                _buildDiseaseCard('Rust', 'Low', 'Minor fungal', 'Good air circulation', Colors.green),
                _buildDiseaseCard('Smut', 'Low', 'Sporadic occurrence', 'Seed treatment', Colors.green),
                const SizedBox(height: 12),
                Text(
                  'Disease Prevention:',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primaryGreen,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '• Plant disease-resistant varieties\n'
                  '• Practice crop rotation\n'
                  '• Maintain field hygiene\n'
                  '• Timely fungicide application',
                  style: GoogleFonts.poppins(fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Market Risk Section
          _buildSectionCard(
            title: 'Market Risk Analysis',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildMarketRiskCard('Price Volatility', 'Low', 'Stable market', Colors.green),
                _buildMarketRiskCard('Demand Fluctuation', 'Low', 'Consistent demand', Colors.green),
                _buildMarketRiskCard('Supply Competition', 'Medium', 'Moderate competition', Colors.orange),
                _buildMarketRiskCard('Export Market', 'Low', 'Limited exports', Colors.green),
                const SizedBox(height: 12),
                Text(
                  'Market Strategies:',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primaryGreen,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '• Diversify market outlets\n'
                  '• Build long-term contracts\n'
                  '• Monitor price trends\n'
                  '• Improve product quality',
                  style: GoogleFonts.poppins(fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Climate Risk Section
          _buildSectionCard(
            title: 'Climate Risk Analysis',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildClimateRiskCard('Temperature Extremes', 'Low', 'Stable temperatures', Colors.green),
                _buildClimateRiskCard('Rainfall Variability', 'Medium', 'Some unpredictability', Colors.orange),
                _buildClimateRiskCard('Wind Damage', 'Low', 'Minimal wind risk', Colors.green),
                _buildClimateRiskCard('Frost Risk', 'None', 'No frost occurrence', Colors.green),
                const SizedBox(height: 12),
                Text(
                  'Climate Adaptation:',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primaryGreen,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '• Monitor weather forecasts\n'
                  '• Adjust planting dates\n'
                  '• Use climate-smart practices\n'
                  '• Implement water conservation',
                  style: GoogleFonts.poppins(fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Risk Mitigation Section
          _buildSectionCard(
            title: 'Comprehensive Risk Mitigation',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildMitigationCard(
                  'Insurance Coverage',
                  'Consider crop insurance for major risks',
                  Icons.security,
                  Colors.blue,
                ),
                _buildMitigationCard(
                  'Diversification',
                  'Grow multiple crops to spread risk',
                  Icons.grid_on,
                  Colors.green,
                ),
                _buildMitigationCard(
                  'Technology Adoption',
                  'Use modern farming technologies',
                  Icons.phone_android,
                  Colors.orange,
                ),
                _buildMitigationCard(
                  'Expert Consultation',
                  'Seek advice from agricultural experts',
                  Icons.people,
                  Colors.purple,
                ),
                _buildMitigationCard(
                  'Monitoring Systems',
                  'Implement regular monitoring',
                  Icons.monitor,
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

  Widget _buildRiskCard(String risk, String level, String impact, IconData icon, Color color) {
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
                  risk,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
                Text(
                  impact,
                  style: GoogleFonts.poppins(
                    fontSize: 10,
                    color: Colors.grey[600],
                  ),
                ),
              ],
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
    );
  }

  Widget _buildRiskDetailCard(String parameter, String value, String note, Color color) {
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
                note,
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

  Widget _buildPestCard(String pest, String risk, String description, String solution, Color color) {
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
                pest,
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
                  risk,
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
            description,
            style: GoogleFonts.poppins(
              fontSize: 10,
              color: Colors.grey[600],
            ),
          ),
          Text(
            solution,
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

  Widget _buildDiseaseCard(String disease, String risk, String description, String solution, Color color) {
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
                disease,
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
                  risk,
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
            description,
            style: GoogleFonts.poppins(
              fontSize: 10,
              color: Colors.grey[600],
            ),
          ),
          Text(
            solution,
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

  Widget _buildMarketRiskCard(String risk, String level, String description, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            risk,
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
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
                description,
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

  Widget _buildClimateRiskCard(String risk, String level, String description, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            risk,
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
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
                description,
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

  Widget _buildMitigationCard(String title, String description, IconData icon, Color color) {
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
} 