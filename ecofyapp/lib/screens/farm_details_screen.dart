import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/theme/app_theme.dart';

class FarmDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> farm;

  const FarmDetailsScreen({super.key, required this.farm});

  @override
  State<FarmDetailsScreen> createState() => _FarmDetailsScreenState();
}

class _FarmDetailsScreenState extends State<FarmDetailsScreen> {
  int _selectedTabIndex = 0;

  final List<String> _tabs = [
    'Overview',
    'Resources',
    'Risks',
    'Recommendations',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.farm['name'] ?? 'Farm Details',
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
      body: Column(
        children: [
          // Farm Header Card
          Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppTheme.primaryGreen, AppTheme.successGreen],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryGreen.withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Icon(
                        Icons.agriculture,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.farm['name'] ?? 'Farm Name',
                            style: GoogleFonts.poppins(
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Icon(
                                Icons.location_on,
                                color: Colors.white.withOpacity(0.8),
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  widget.farm['location'] ?? 'Location',
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    color: Colors.white.withOpacity(0.9),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                Icons.calendar_today,
                                color: Colors.white.withOpacity(0.8),
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Established: ${DateTime.now().year - 2}',
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: Colors.white.withOpacity(0.8),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    _buildStatCard('Size', widget.farm['size'] ?? '0 acres', Icons.area_chart),
                    const SizedBox(width: 12),
                    _buildStatCard('Crops', '${(widget.farm['crop_history'] as List?)?.length ?? 0} types', Icons.eco),
                    const SizedBox(width: 12),
                    _buildStatCard('Status', 'Active', Icons.check_circle),
                  ],
                ),
              ],
            ),
          ),

          // Tab Navigation
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              children: _tabs.asMap().entries.map((entry) {
                final index = entry.key;
                final tab = entry.value;
                final isSelected = _selectedTabIndex == index;
                
                return Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedTabIndex = index;
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 4),
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? AppTheme.primaryGreen : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        tab,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: isSelected ? Colors.white : AppTheme.textSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          // Tab Content
          Expanded(
            child: _buildTabContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: Colors.white, size: 20),
          const SizedBox(height: 6),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 11,
              color: Colors.white.withOpacity(0.8),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildTabContent() {
    switch (_selectedTabIndex) {
      case 0:
        return _buildOverviewTab();
      case 1:
        return _buildResourcesTab();
      case 2:
        return _buildRisksTab();
      case 3:
        return _buildRecommendationsTab();
      default:
        return _buildOverviewTab();
    }
  }

  Widget _buildOverviewTab() {
    // Extract soil parameters from farm data
    final soilParams = widget.farm['soil_params'] as Map<String, dynamic>? ?? {};
    final cropHistory = widget.farm['crop_history'] as List? ?? [];
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionCard(
            'Farm Information',
            Icons.info,
            [
              _buildInfoRow('Location', widget.farm['location'] ?? 'N/A'),
              _buildInfoRow('Size', widget.farm['size'] ?? 'N/A'),
              _buildInfoRow('Topography', widget.farm['topography'] ?? 'N/A'),
              _buildInfoRow('Farm ID', widget.farm['id'] ?? 'N/A'),
            ],
          ),
          const SizedBox(height: 20),
          _buildSectionCard(
            'Crop History',
            Icons.eco,
            cropHistory.isNotEmpty 
              ? cropHistory.map((crop) => 
                  _buildCropHistoryRow(crop)
                ).toList()
              : [_buildInfoRow('No crop history', 'Available')],
          ),
          const SizedBox(height: 20),
          _buildSectionCard(
            'Soil Analysis',
            Icons.science,
            [
              _buildInfoRow('Moisture', soilParams['moisture'] ?? 'N/A'),
              _buildInfoRow('Organic Carbon', soilParams['organic_carbon'] ?? 'N/A'),
              _buildInfoRow('Soil Texture', soilParams['texture'] ?? 'N/A'),
              _buildInfoRow('pH Level', soilParams['ph'] ?? 'N/A'),
              _buildInfoRow('EC', soilParams['ec'] ?? 'N/A'),
              _buildInfoRow('Salinity', soilParams['salinity'] ?? 'N/A'),
              _buildInfoRow('Water Holding', soilParams['water_holding'] ?? 'N/A'),
              _buildInfoRow('Organic Matter', soilParams['organic_matter'] ?? 'N/A'),
              _buildInfoRow('NPK', soilParams['npk'] ?? 'N/A'),
            ],
          ),
          const SizedBox(height: 20),
          _buildSectionCard(
            'Climate Data',
            Icons.wb_sunny,
            [
              _buildInfoRow('Climate Zone', 'Tropical'),
              _buildInfoRow('Annual Rainfall', '1200mm'),
              _buildInfoRow('Average Temperature', '24°C'),
              _buildInfoRow('Seasonal Pattern', 'Bimodal'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildResourcesTab() {
    final location = widget.farm['location'] ?? 'Unknown';
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildResourceCard(
            'Labor Allocation',
            'Current: 2-3 workers\nRecommended: 4-5 workers\nSeasonal workers needed during harvest',
            Icons.people,
            AppTheme.primaryGreen,
          ),
          const SizedBox(height: 16),
          _buildResourceCard(
            'Equipment & Tools',
            'Tractor: Available\nIrrigation System: ${location == 'Dar es Salaam' ? 'Drip irrigation' : 'Sprinkler system'}\nStorage Facilities: Available\nSoil Testing Kit: Available',
            Icons.build,
            AppTheme.secondaryBlue,
          ),
          const SizedBox(height: 16),
          _buildResourceCard(
            'Financial Resources',
            'Budget: TSh 2,500,000\nSpent: TSh 1,800,000\nRemaining: TSh 700,000\nCredit Available: TSh 1,000,000',
            Icons.account_balance_wallet,
            AppTheme.warningYellow,
          ),
          const SizedBox(height: 16),
          _buildResourceCard(
            'Time Management',
            'Planting Season: Oct-Dec\nHarvesting: Mar-May\nCrop Rotation: Every 2 years\nMaintenance: Weekly',
            Icons.schedule,
            AppTheme.successGreen,
          ),
          const SizedBox(height: 16),
          _buildResourceCard(
            'Water Resources',
            'Rainfall: 800-1200mm annually\nIrrigation: ${location == 'Kilimanjaro' ? 'Highland streams' : location == 'Dar es Salaam' ? 'Coastal wells' : 'River water'}\nStorage: 50,000L capacity',
            Icons.water_drop,
            AppTheme.secondaryBlue,
          ),
        ],
      ),
    );
  }

  Widget _buildRisksTab() {
    final location = widget.farm['location'] ?? 'Unknown';
    final soilParams = widget.farm['soil_params'] as Map<String, dynamic>? ?? {};
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildRiskCard(
            'Weather Risk',
            'High',
            Icons.cloud,
            AppTheme.warningYellow,
            'Unpredictable rainfall patterns in ${location}. Drought risk during dry season (June-September).',
          ),
          const SizedBox(height: 16),
          _buildRiskCard(
            'Pest & Disease Risk',
            'Medium',
            Icons.bug_report,
            AppTheme.errorRed,
            'Fall Armyworm threat to maize crops. Regular monitoring required.',
          ),
          const SizedBox(height: 16),
          _buildRiskCard(
            'Market Risk',
            'Low',
            Icons.trending_down,
            AppTheme.primaryGreen,
            'Stable market prices for ${location} region. Good demand for staple crops.',
          ),
          const SizedBox(height: 16),
          _buildRiskCard(
            'Soil Degradation',
            soilParams['organic_matter'] == 'Low' ? 'High' : 'Medium',
            Icons.terrain,
            AppTheme.warningYellow,
            'Soil erosion risk due to ${widget.farm['topography'] ?? 'slope'}. Organic matter levels: ${soilParams['organic_matter'] ?? 'Unknown'}.',
          ),
          const SizedBox(height: 16),
          _buildRiskCard(
            'Water Scarcity',
            location == 'Dodoma' ? 'High' : 'Medium',
            Icons.water_drop,
            AppTheme.errorRed,
            'Water availability varies by season. ${location == 'Dodoma' ? 'Critical in semi-arid region' : 'Manageable with proper irrigation'}.',
          ),
          const SizedBox(height: 16),
          _buildRiskCard(
            'Climate Change',
            'Medium',
            Icons.wb_sunny,
            AppTheme.warningYellow,
            'Increasing temperatures and changing rainfall patterns affecting crop cycles.',
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendationsTab() {
    final location = widget.farm['location'] ?? 'Unknown';
    final soilParams = widget.farm['soil_params'] as Map<String, dynamic>? ?? {};
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildRecommendationCard(
            'Irrigation System',
            'Install drip irrigation to optimize water usage and reduce water waste',
            Icons.water_drop,
            AppTheme.secondaryBlue,
          ),
          const SizedBox(height: 16),
          _buildRecommendationCard(
            'Crop Rotation',
            'Implement crop rotation to improve soil health and reduce pest pressure',
            Icons.rotate_right,
            AppTheme.primaryGreen,
          ),
          const SizedBox(height: 16),
          _buildRecommendationCard(
            'Pest Management',
            'Apply integrated pest management techniques and regular monitoring',
            Icons.shield,
            AppTheme.warningYellow,
          ),
          const SizedBox(height: 16),
          _buildRecommendationCard(
            'Soil Conservation',
            'Plant cover crops to prevent soil erosion and improve organic matter',
            Icons.eco,
            AppTheme.successGreen,
          ),
          const SizedBox(height: 16),
          _buildRecommendationCard(
            'Fertilizer Management',
            'Use organic fertilizers to improve ${soilParams['organic_matter'] == 'Low' ? 'low' : 'medium'} organic matter levels',
            Icons.grass,
            AppTheme.primaryGreen,
          ),
          const SizedBox(height: 16),
          _buildRecommendationCard(
            'Market Diversification',
            'Explore high-value crops for ${location} region to increase profitability',
            Icons.trending_up,
            AppTheme.secondaryBlue,
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard(String title, IconData icon, List<Widget> children) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.borderLight),
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowLight,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppTheme.primaryGreen, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppTheme.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: AppTheme.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCropHistoryRow(Map<String, dynamic> crop) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              crop['crop'] ?? 'Unknown',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppTheme.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Season: ${crop['season'] ?? 'N/A'}',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: AppTheme.textPrimary,
                  ),
                ),
                Text(
                  'Yield: ${crop['yield_amount'] ?? 'N/A'}',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: AppTheme.primaryGreen,
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

  Widget _buildRiskCard(String title, String level, IconData icon, Color color, String description) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowLight,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  level,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendationCard(String title, String description, IconData icon, Color color) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowLight,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResourceCard(String title, String details, IconData icon, Color color) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowLight,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            details,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

 