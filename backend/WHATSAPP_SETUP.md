# WhatsApp AI Integration Setup

## Overview
EcoFy now supports WhatsApp chatbot integration powered by OpenAI GPT-4o with voice capabilities. Farmers can:

- Send text messages and get AI farming advice
- Send voice notes and receive voice responses  
- Send crop/pest images for AI analysis
- Receive farming alerts and notifications

## Required API Keys

### 1. OpenAI API
- Get your API key from: https://platform.openai.com/api-keys
- Capabilities: GPT-4o text, Whisper speech-to-text, TTS text-to-speech, Vision

### 2. Beem Africa WhatsApp API
You need to register at [Beem Africa](https://beem.africa) and get:
- `BEEM_API_KEY`
- `BEEM_SECRET_KEY` 
- `WHATSAPP_FROM_NUMBER` (your approved WhatsApp business number)

## Environment Variables
Add to your `.env` file:

```env
# OpenAI API
OPENAI_API_KEY=your_openai_api_key_here

# WhatsApp/Beem Africa API
BEEM_API_KEY=your-beem-api-key
BEEM_SECRET_KEY=your-beem-secret-key
WHATSAPP_FROM_NUMBER=255712345678
```

## API Endpoints

### WhatsApp Management
- `GET /api/whatsapp/templates` - List WhatsApp templates
- `POST /api/whatsapp/templates/send` - Send template message
- `GET /api/whatsapp/sessions` - Get WhatsApp chat sessions
- `GET /api/whatsapp/messages` - Get message history

### AI Chat Integration
- `POST /api/whatsapp/ai/chat` - Process text message with AI
- `POST /api/whatsapp/ai/voice` - Process voice message with AI
- `POST /api/whatsapp/ai/image` - Analyze crop images with AI

### Webhooks
- `POST /api/whatsapp/webhook` - Receive WhatsApp webhooks from Beem
- `GET /api/whatsapp/webhook` - Webhook verification

### Utilities
- `POST /api/whatsapp/alerts/send` - Send farming alerts
- `GET /api/whatsapp/test/ai` - Test AI integration

## How It Works

### 1. Incoming Messages
1. Farmer sends WhatsApp message to your business number
2. Beem Africa sends webhook to `/api/whatsapp/webhook`
3. System processes message based on type:
   - **Text**: Sent to GPT-4o for farming advice
   - **Voice**: Transcribed with Whisper → GPT-4o → TTS response
   - **Image**: Analyzed with GPT-4o Vision for crop/pest identification

### 2. AI Processing
- GPT-4o knows about Tanzania farming, your crops data, user's farm history
- Responds in English or Swahili based on input language
- Provides specific advice for user's location and crops

### 3. Response Delivery
- Text responses sent immediately via WhatsApp
- Voice responses converted to audio files and sent as voice notes
- All conversations stored in database for context

## WhatsApp Templates

### Required Templates
You need to create these templates in Beem Africa portal:

#### 1. Welcome Template (UTILITY)
```
Hello {{1}}! 👋 

Welcome to EcoFy - your AI farming assistant. I can help you with:

🌱 Crop advice and recommendations
🌾 Pest and disease identification  
🌤️ Weather and planting guidance
💰 Market prices and selling tips

Send me a message or voice note to get started!
```

#### 2. Farming Alert Template (UTILITY)
```
🚨 EcoFy Farming Alert

{{1}}

For more farming advice, reply to this message or visit our app.

Best regards,
EcoFy Team 🌱
```

#### 3. Authentication Template
```
{{1}} is your EcoFy verification code.

For your security, do not share this code.

Valid for 5 minutes.
```

## Testing

### 1. Test AI Integration
```bash
curl http://localhost:8000/api/whatsapp/test/ai?message="What crops should I plant in Dar es Salaam?"
```

### 2. Test WhatsApp Chat
```bash
curl -X POST http://localhost:8000/api/whatsapp/ai/chat \
  -H "Content-Type: application/json" \
  -d '{
    "phone_number": "255712345678",
    "message": "Nimepanda mahindi lakini yana matatizo ya wadudu"
  }'
```

### 3. Test Voice Processing
```bash
curl -X POST http://localhost:8000/api/whatsapp/ai/voice \
  -H "Content-Type: application/json" \
  -d '{
    "phone_number": "255712345678",
    "voice_url": "https://example.com/voice.mp3"
  }'
```

## Database Tables Created

- `whatsapp_templates` - Store template configurations
- `whatsapp_messages` - Message history and status
- `whatsapp_sessions` - Conversation sessions with context
- `whatsapp_webhooks` - Webhook delivery reports

## Next Steps

1. **Get Beem Africa Account**: Register and get API credentials
2. **Create Templates**: Set up required WhatsApp templates
3. **Configure Webhook**: Set webhook URL in Beem portal to `https://yourserver.com/api/whatsapp/webhook`
4. **Test Integration**: Use test endpoints to verify functionality
5. **Train AI**: Fine-tune responses with your specific crop data

## Production Considerations

1. **Media Storage**: Implement cloud storage for voice/image files
2. **Rate Limiting**: Add rate limits for API calls
3. **Monitoring**: Set up logging and alerting
4. **Scaling**: Consider message queues for high volume
5. **Security**: Validate webhook signatures from Beem

## Support

The integration supports:
- ✅ Text messages in English/Swahili
- ✅ Voice messages with transcription and TTS
- ✅ Image analysis for crops/pests
- ✅ Template-based notifications
- ✅ Conversation context and history
- ✅ User farm data integration
- ✅ Automatic user creation from phone numbers 