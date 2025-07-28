import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/theme/app_theme.dart';

class ClimateTypeScreen extends StatefulWidget {
  final String selectedCrop;

  const ClimateTypeScreen({super.key, required this.selectedCrop});

  @override
  State<ClimateTypeScreen> createState() => _ClimateTypeScreenState();
}

class _ClimateTypeScreenState extends State<ClimateTypeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Climate Analysis - ${widget.selectedCrop}',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimary,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Climate Overview
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppTheme.warningYellow, AppTheme.primaryGreen],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.warningYellow.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.wb_sunny, color: Colors.white, size: 24),
                      const SizedBox(width: 12),
                      Text(
                        'Climate Zone',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Tropical',
                    style: GoogleFonts.poppins(
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'Ideal for ${widget.selectedCrop} cultivation',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            
            // Climate Parameters
            Text(
              'Climate Parameters',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            
            Row(
              children: [
                Expanded(
                  child: _buildClimateCard(
                    'Avg Temperature',
                    '26°C',
                    'Annual',
                    Icons.thermostat,
                    AppTheme.warningYellow,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildClimateCard(
                    'Rainfall',
                    '1200mm',
                    'Annual',
                    Icons.water_drop,
                    AppTheme.secondaryBlue,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            
            Row(
              children: [
                Expanded(
                  child: _buildClimateCard(
                    'Growing Season',
                    '8 months',
                    'Duration',
                    Icons.calendar_today,
                    AppTheme.successGreen,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildClimateCard(
                    'Humidity',
                    '75%',
                    'Average',
                    Icons.opacity,
                    AppTheme.primaryGreen,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            
            // Seasonal Patterns
            Text(
              'Seasonal Patterns',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppTheme.borderLight),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '• Plant during March-April for optimal growth',
                    style: GoogleFonts.poppins(fontSize: 14, color: AppTheme.textSecondary),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '• Harvest period: July-September',
                    style: GoogleFonts.poppins(fontSize: 14, color: AppTheme.textSecondary),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '• Irrigation needed during dry spells (Jan-Mar)',
                    style: GoogleFonts.poppins(fontSize: 14, color: AppTheme.textSecondary),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '• Monitor rainfall patterns for optimal timing',
                    style: GoogleFonts.poppins(fontSize: 14, color: AppTheme.textSecondary),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            
            // Climate Recommendations
            Text(
              'Climate Management',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppTheme.borderLight),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '• Implement irrigation systems for dry periods',
                    style: GoogleFonts.poppins(fontSize: 14, color: AppTheme.textSecondary),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '• Use shade nets during extreme heat',
                    style: GoogleFonts.poppins(fontSize: 14, color: AppTheme.textSecondary),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '• Monitor weather forecasts for planning',
                    style: GoogleFonts.poppins(fontSize: 14, color: AppTheme.textSecondary),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '• Consider climate-smart farming practices',
                    style: GoogleFonts.poppins(fontSize: 14, color: AppTheme.textSecondary),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildClimateCard(String title, String value, String subtitle, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.borderLight),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 8),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
          Text(
            subtitle,
            style: GoogleFonts.poppins(
              fontSize: 10,
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
} 