import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/theme/app_theme.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  String _selectedFarm = 'All Farms';
  String _selectedReportType = 'Soil Analysis';
  String _selectedPeriod = 'Last 30 Days';

  final List<String> _farms = [
    'All Farms',
    'Farm A - Maize Field',
    'Farm B - Rice Field',
    'Farm C - Vegetable Garden',
  ];

  final List<String> _reportTypes = [
    'Soil Analysis',
    'Crop Performance',
    'Weather Impact',
    'Pest Management',
    'Financial Report',
    'Equipment Status',
  ];

  final List<String> _periods = [
    'Last 7 Days',
    'Last 30 Days',
    'Last 3 Months',
    'Last 6 Months',
    'Last Year',
  ];

  final List<Map<String, dynamic>> _recentReports = [
    {
      'title': 'Soil Analysis Report',
      'farm': 'Farm A - Maize Field',
      'date': '2024-01-15',
      'status': 'Completed',
      'type': 'Soil Analysis',
      'trend': 'Improving',
    },
    {
      'title': 'Crop Performance Report',
      'farm': 'Farm B - Rice Field',
      'date': '2024-01-10',
      'status': 'Completed',
      'type': 'Crop Performance',
      'trend': 'Stable',
    },
    {
      'title': 'Weather Impact Analysis',
      'farm': 'Farm C - Vegetable Garden',
      'date': '2024-01-08',
      'status': 'In Progress',
      'type': 'Weather Impact',
      'trend': 'Declining',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryGreen,
        foregroundColor: Colors.white,
        title: Text('Reports', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Quick Stats
            _buildQuickStats(),
            const SizedBox(height: 24),
            
            // Report Generator
            _buildReportGenerator(),
            const SizedBox(height: 24),
            
            // Recent Reports
            _buildRecentReports(),
            const SizedBox(height: 24),
            
            // Soil Data Section
            _buildSoilDataSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickStats() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowLight,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Quick Overview', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600)),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildStatCard('Total Reports', '24', Icons.assessment, AppTheme.primaryGreen),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard('Active Farms', '3', Icons.agriculture, AppTheme.secondaryBlue),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard('Pending', '2', Icons.schedule, Colors.orange),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(value, style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w600, color: color)),
          Text(title, style: GoogleFonts.poppins(fontSize: 12, color: AppTheme.textSecondary)),
        ],
      ),
    );
  }

  Widget _buildReportGenerator() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowLight,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Generate Report', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600)),
          const SizedBox(height: 16),
          
          // Farm Selection
          Text('Select Farm', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: _selectedFarm,
            decoration: InputDecoration(
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            items: _farms.map((farm) => DropdownMenuItem(value: farm, child: Text(farm))).toList(),
            onChanged: (value) => setState(() => _selectedFarm = value!),
          ),
          const SizedBox(height: 16),
          
          // Report Type Selection
          Text('Report Type', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: _selectedReportType,
            decoration: InputDecoration(
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            items: _reportTypes.map((type) => DropdownMenuItem(value: type, child: Text(type))).toList(),
            onChanged: (value) => setState(() => _selectedReportType = value!),
          ),
          const SizedBox(height: 16),
          
          // Period Selection
          Text('Time Period', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: _selectedPeriod,
            decoration: InputDecoration(
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            items: _periods.map((period) => DropdownMenuItem(value: period, child: Text(period))).toList(),
            onChanged: (value) => setState(() => _selectedPeriod = value!),
          ),
          const SizedBox(height: 20),
          
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _generateReport,
              icon: const Icon(Icons.file_download),
              label: Text('Generate Report', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryGreen,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentReports() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowLight,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Recent Reports', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600)),
          const SizedBox(height: 16),
          ..._recentReports.map((report) => _buildReportCard(report)),
        ],
      ),
    );
  }

  Widget _buildReportCard(Map<String, dynamic> report) {
    Color statusColor = report['status'] == 'Completed' ? Colors.green : Colors.orange;
    Color trendColor = report['trend'] == 'Improving' ? Colors.green : 
                      report['trend'] == 'Stable' ? Colors.blue : Colors.red;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.primaryGreen.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(Icons.assessment, color: AppTheme.primaryGreen, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(report['title'], style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                Text(report['farm'], style: GoogleFonts.poppins(fontSize: 12, color: AppTheme.textSecondary)),
                Text(report['date'], style: GoogleFonts.poppins(fontSize: 12, color: AppTheme.textTertiary)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(report['status'], style: GoogleFonts.poppins(fontSize: 10, color: statusColor)),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: trendColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(report['trend'], style: GoogleFonts.poppins(fontSize: 10, color: trendColor)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSoilDataSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowLight,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Soil Data Analysis', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600)),
          const SizedBox(height: 16),
          
          // Soil Parameters
          _buildSoilParameter('pH Level', '6.8', 'Optimal', Colors.green),
          _buildSoilParameter('Nitrogen (N)', '45 kg/ha', 'Low', Colors.orange),
          _buildSoilParameter('Phosphorus (P)', '28 kg/ha', 'Medium', Colors.yellow),
          _buildSoilParameter('Potassium (K)', '180 kg/ha', 'High', Colors.green),
          _buildSoilParameter('Organic Matter', '3.2%', 'Good', Colors.green),
          _buildSoilParameter('Moisture', '65%', 'Optimal', Colors.green),
          
          const SizedBox(height: 16),
          
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _viewDetailedSoilReport,
              icon: const Icon(Icons.analytics),
              label: Text('View More', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.secondaryBlue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSoilParameter(String parameter, String value, String status, Color statusColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(parameter, style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
          Row(
            children: [
              Text(value, style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(status, style: GoogleFonts.poppins(fontSize: 10, color: statusColor)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _generateReport() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Generating ${_selectedReportType} report for ${_selectedFarm}...'),
        backgroundColor: AppTheme.primaryGreen,
      ),
    );
  }

  void _viewDetailedSoilReport() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.9,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Comprehensive Farm Analysis', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600)),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDetailedSection('General Climate Trends', 'Favorable', 'Temperature: 24-28°C, Rainfall: 1200mm/year', 'Climate conditions are optimal for crop growth with consistent rainfall patterns.'),
                      _buildDetailedSection('Topography', 'Gentle Slopes', 'Elevation: 800-1200m, Slope: 5-15%', 'Land is suitable for mechanized farming with good drainage.'),
                      _buildDetailedSection('Local Socioeconomic Factors', 'Stable', 'Population: 15,000, Income: \$2,500/year', 'Strong local market with growing demand for agricultural products.'),
                      _buildDetailedSection('Market Intelligence', 'Growing', 'Demand: +15%, Price: +8%', 'Market shows positive trends with increasing demand for organic products.'),
                      _buildDetailedSection('Risks Assessment', 'Low-Medium', 'Weather: Low, Market: Medium, Pest: Low', 'Overall risk level is manageable with proper planning.'),
                      _buildDetailedSection('Soil Analysis', 'Good', 'pH: 6.8, Nutrients: Balanced', 'Soil quality is excellent for most crops with good nutrient levels.'),
                      _buildDetailedSection('Water Availability', 'Adequate', 'Irrigation: Available, Quality: Good', 'Sufficient water resources for year-round farming.'),
                      _buildDetailedSection('Infrastructure', 'Developing', 'Roads: Good, Storage: Adequate', 'Basic infrastructure supports agricultural activities.'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailedSection(String title, String value, String unit, String recommendation) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(value, style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w700, color: AppTheme.primaryGreen)),
              const SizedBox(width: 8),
              Flexible(
                child: Text(unit, style: GoogleFonts.poppins(fontSize: 14, color: AppTheme.textSecondary)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(recommendation, style: GoogleFonts.poppins(fontSize: 14, color: AppTheme.textSecondary), maxLines: 3, overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }
} 