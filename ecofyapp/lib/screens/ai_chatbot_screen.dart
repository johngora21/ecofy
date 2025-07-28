import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/theme/app_theme.dart';

class AIChatbotScreen extends StatefulWidget {
  const AIChatbotScreen({super.key});

  @override
  State<AIChatbotScreen> createState() => _AIChatbotScreenState();
}

class _AIChatbotScreenState extends State<AIChatbotScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];
  bool _isTyping = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Add welcome message
    _messages.add({
      'text': 'Hello! I\'m your AI farming assistant. I can help you analyze plant diseases and nutrient deficiencies. You can:\n\n• Take a photo of your plant\n• Describe the symptoms\n• Ask farming questions',
      'isUser': false,
      'timestamp': DateTime.now(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFECE5DD), // WhatsApp background color
      appBar: AppBar(
        backgroundColor: AppTheme.primaryGreen,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.psychology,
                color: AppTheme.primaryGreen,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'AI Farming Assistant',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Online',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
        ],
      ),
      body: Column(
        children: [
          // Chat messages
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return _buildMessageBubble(message);
              },
            ),
          ),
          
          // Typing indicator
          if (_isTyping)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 16,
                          height: 16,
                          child: const CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryGreen),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'AI is typing...',
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
            ),
          
          // Input area
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0F0F0),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _messageController,
                            decoration: InputDecoration(
                              hintText: 'Type a message...',
                              hintStyle: GoogleFonts.poppins(
                                fontSize: 14,
                                color: AppTheme.textSecondary,
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 12,
                              ),
                            ),
                            maxLines: null,
                          ),
                        ),
                        // Gallery icon
                        IconButton(
                          onPressed: _pickImage,
                          icon: const Icon(
                            Icons.attach_file,
                            color: AppTheme.primaryGreen,
                            size: 24,
                          ),
                        ),
                        // Camera icon
                        IconButton(
                          onPressed: _takePhoto,
                          icon: const Icon(
                            Icons.camera_alt,
                            color: AppTheme.primaryGreen,
                            size: 24,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryGreen,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: IconButton(
                    onPressed: _sendMessage,
                    icon: const Icon(
                      Icons.send,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(Map<String, dynamic> message) {
    final isUser = message['isUser'] as bool;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isUser) ...[
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppTheme.primaryGreen,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.psychology,
                color: Colors.white,
                size: 16,
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: isUser ? AppTheme.primaryGreen : Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message['text'] as String,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: isUser ? Colors.white : AppTheme.textPrimary,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatTime(message['timestamp'] as DateTime),
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      color: isUser ? Colors.white.withOpacity(0.7) : AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isUser) ...[
            const SizedBox(width: 8),
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppTheme.secondaryBlue,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.person,
                color: Colors.white,
                size: 16,
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  void _sendMessage() {
    final message = _messageController.text.trim();
    if (message.isEmpty) return;

    // Add user message
    setState(() {
      _messages.add({
        'text': message,
        'isUser': true,
        'timestamp': DateTime.now(),
      });
      _isTyping = true;
    });

    _messageController.clear();
    _scrollToBottom();

    // Simulate AI response
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isTyping = false;
        _messages.add({
          'text': _generateAIResponse(message),
          'isUser': false,
          'timestamp': DateTime.now(),
        });
      });
      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  String _generateAIResponse(String userMessage) {
    final message = userMessage.toLowerCase();
    
    // Plant Disease & Health Analysis
    if (message.contains('yellow') || message.contains('leaves')) {
      return 'Based on your description of yellow leaves, this could be:\n\n• Nitrogen deficiency\n• Iron deficiency\n• Overwatering\n\nI recommend:\n1. Check soil pH\n2. Apply balanced fertilizer\n3. Ensure proper drainage\n\nWould you like to take a photo for more accurate analysis?';
    } else if (message.contains('spots') || message.contains('disease')) {
      return 'Plant spots can indicate various diseases:\n\n• Fungal infections\n• Bacterial diseases\n• Pest damage\n\nTo help diagnose:\n1. Take a clear photo\n2. Note the pattern\n3. Check affected areas\n\nI can analyze photos for precise identification!';
    } else if (message.contains('fertilizer') || message.contains('nutrient')) {
      return 'For nutrient management:\n\n• Test soil pH first\n• Use balanced NPK fertilizer\n• Apply organic matter\n• Monitor plant response\n\nWhat crop are you growing? I can provide specific recommendations.';
    
    // Weather & Climate
    } else if (message.contains('weather') || message.contains('rain') || message.contains('drought')) {
      return 'Weather management tips:\n\n• Monitor local weather forecasts\n• Implement irrigation systems\n• Use drought-resistant crops\n• Mulch to retain moisture\n• Consider crop insurance\n\nHow is the weather affecting your current crops?';
    
    // Pest Management
    } else if (message.contains('pest') || message.contains('insect') || message.contains('bug')) {
      return 'Pest management strategies:\n\n• Identify the pest first\n• Use integrated pest management (IPM)\n• Consider natural predators\n• Rotate crops\n• Use resistant varieties\n\nWhat type of pest are you dealing with?';
    
    // Market & Pricing
    } else if (message.contains('market') || message.contains('price') || message.contains('sell')) {
      return 'Market insights:\n\n• Check current market prices\n• Monitor demand trends\n• Consider storage options\n• Plan harvest timing\n• Network with buyers\n\nWhat crop are you looking to sell?';
    
    // Soil Management
    } else if (message.contains('soil') || message.contains('ph') || message.contains('erosion')) {
      return 'Soil health tips:\n\n• Test soil regularly\n• Maintain pH 6.0-7.0\n• Add organic matter\n• Prevent erosion\n• Practice crop rotation\n\nWhen was your last soil test?';
    
    // Equipment & Technology
    } else if (message.contains('equipment') || message.contains('machine') || message.contains('tractor')) {
      return 'Equipment advice:\n\n• Regular maintenance schedule\n• Check for local rentals\n• Consider precision farming tools\n• GPS guidance systems\n• Automated irrigation\n\nWhat equipment do you need help with?';
    
    // Financial Management
    } else if (message.contains('money') || message.contains('cost') || message.contains('budget') || message.contains('loan')) {
      return 'Financial planning:\n\n• Track all expenses\n• Plan for seasonal costs\n• Consider crop insurance\n• Explore government programs\n• Monitor profit margins\n\nWhat financial aspect concerns you?';
    
    // Crop Selection
    } else if (message.contains('crop') || message.contains('plant') || message.contains('grow')) {
      return 'Crop selection tips:\n\n• Consider local climate\n• Check market demand\n• Assess soil conditions\n• Plan crop rotation\n• Calculate profitability\n\nWhat factors are important for your farm?';
    
    // Water Management
    } else if (message.contains('water') || message.contains('irrigation') || message.contains('drainage')) {
      return 'Water management:\n\n• Implement efficient irrigation\n• Monitor soil moisture\n• Prevent waterlogging\n• Use drip irrigation\n• Harvest rainwater\n\nHow do you currently manage water?';
    
    // General Farming Tips
    } else if (message.contains('tip') || message.contains('advice') || message.contains('help')) {
      return 'General farming tips:\n\n• Keep detailed records\n• Plan ahead for seasons\n• Network with other farmers\n• Stay updated on new techniques\n• Monitor your crops regularly\n\nWhat specific area do you need help with?';
    
    // Default Response
    } else {
      return 'I\'m your AI farming assistant! I can help with:\n\n🌱 Plant disease analysis\n🌤️ Weather management\n🐛 Pest control\n💰 Market insights\n🌾 Soil health\n🚜 Equipment advice\n💵 Financial planning\n🌿 Crop selection\n💧 Water management\n\nJust describe your issue or ask a question!';
    }
  }

  void _takePhoto() {
    // TODO: Implement camera functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Camera functionality coming soon!',
          style: GoogleFonts.poppins(),
        ),
        backgroundColor: AppTheme.primaryGreen,
      ),
    );
  }

  void _pickImage() {
    // TODO: Implement image picker functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Image picker functionality coming soon!',
          style: GoogleFonts.poppins(),
        ),
        backgroundColor: AppTheme.primaryGreen,
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
} 