import os
import io
import asyncio
from typing import Optional, Dict, Any, List
import httpx
from fastapi import HTTPException
import logging
from datetime import datetime

# Configure logging
logger = logging.getLogger(__name__)

class OpenAIService:
    def __init__(self):
        from app.core.config import settings
        self.api_key = settings.OPENAI_API_KEY
        self.base_url = "https://api.openai.com/v1"
        self.headers = {
            "Authorization": f"Bearer {self.api_key}",
            "Content-Type": "application/json"
        }
        self.model = "gpt-4o"  # Can be updated to fine-tuned model
        
    def _get_system_instruction_for_user(self, user=None, db=None, language="en"):
        """Generate system instruction with agricultural context"""
        system_instruction = """You are EcoFy AI, an expert agricultural assistant for Tanzanian farmers. 
        
Your expertise includes:
- Crop cultivation and management in Tanzania
- Soil health and fertilization
- Pest and disease control
- Weather patterns and farming calendar
- Market prices and crop economics
- Sustainable farming practices
        
Guidelines:
- Provide practical, actionable farming advice
- Consider Tanzania's climate and growing conditions
- Suggest crops suitable for different regions
- Include cost-effective solutions for small-scale farmers
- Mention local varieties when possible
- Be encouraging and supportive
"""
        
        if language == "sw" or language == "swahili":
            system_instruction += "\n- Respond in Swahili (Kiswahili)"
        else:
            system_instruction += "\n- Respond primarily in English, but include Swahili terms when helpful"
            
        # Add user context if available
        if user and db:
            try:
                if user.role == "farmer":
                    from app.models.farm import Farm
                    farms = db.query(Farm).filter(Farm.user_id == user.id).all()
                    
                    if farms:
                        system_instruction += f"\n\nUser's Farm Context:"
                        for farm in farms:
                            system_instruction += f"\n- Farm: {farm.name} in {farm.location}"
                            system_instruction += f"\n- Size: {farm.size}"
                            if farm.soil_params:
                                system_instruction += f"\n- Soil: {farm.soil_params}"
                            if farm.crop_history:
                                crops = [crop.get('crop_type', 'Unknown') for crop in farm.crop_history[-3:]]
                                system_instruction += f"\n- Recent crops: {', '.join(crops)}"
            except Exception as e:
                logger.error(f"Error adding user context: {e}")
                
        return system_instruction

    async def transcribe_audio(self, audio_bytes: bytes, filename: str = "audio.mp3") -> str:
        """Convert audio to text using Whisper"""
        try:
            async with httpx.AsyncClient(timeout=30.0) as client:
                files = {
                    "file": (filename, audio_bytes, "audio/mpeg"),
                    "model": (None, "whisper-1"),
                    "language": (None, "sw")  # Swahili + English detection
                }
                
                headers = {"Authorization": f"Bearer {self.api_key}"}
                
                response = await client.post(
                    f"{self.base_url}/audio/transcriptions",
                    headers=headers,
                    files=files
                )
                
                if response.status_code == 200:
                    result = response.json()
                    return result["text"]
                else:
                    logger.error(f"Whisper API error: {response.status_code} - {response.text}")
                    raise HTTPException(status_code=500, detail="Failed to transcribe audio")
                    
        except Exception as e:
            logger.error(f"Error transcribing audio: {e}")
            raise HTTPException(status_code=500, detail=f"Transcription error: {str(e)}")

    async def generate_text_response(self, message: str, user=None, db=None, language="en") -> str:
        """Generate text response using GPT-4o"""
        try:
            system_instruction = self._get_system_instruction_for_user(user, db, language)
            
            async with httpx.AsyncClient(timeout=30.0) as client:
                payload = {
                    "model": self.model,  # Use current model (could be fine-tuned)
                    "messages": [
                        {"role": "system", "content": system_instruction},
                        {"role": "user", "content": message}
                    ],
                    "max_tokens": 1000,
                    "temperature": 0.7
                }
                
                response = await client.post(
                    f"{self.base_url}/chat/completions",
                    headers=self.headers,
                    json=payload
                )
                
                if response.status_code == 200:
                    result = response.json()
                    return result["choices"][0]["message"]["content"]
                else:
                    logger.error(f"GPT-4o API error: {response.status_code} - {response.text}")
                    raise HTTPException(status_code=500, detail="Failed to generate response")
                    
        except Exception as e:
            logger.error(f"Error generating text response: {e}")
            raise HTTPException(status_code=500, detail=f"Response generation error: {str(e)}")

    async def text_to_speech(self, text: str, voice: str = "alloy") -> bytes:
        """Convert text to speech using OpenAI TTS"""
        try:
            async with httpx.AsyncClient(timeout=30.0) as client:
                payload = {
                    "model": "tts-1",
                    "input": text,
                    "voice": voice,  # alloy, echo, fable, onyx, nova, shimmer
                    "response_format": "mp3"
                }
                
                response = await client.post(
                    f"{self.base_url}/audio/speech",
                    headers=self.headers,
                    json=payload
                )
                
                if response.status_code == 200:
                    return response.content
                else:
                    logger.error(f"TTS API error: {response.status_code} - {response.text}")
                    raise HTTPException(status_code=500, detail="Failed to generate speech")
                    
        except Exception as e:
            logger.error(f"Error generating speech: {e}")
            raise HTTPException(status_code=500, detail=f"Speech generation error: {str(e)}")

    async def process_voice_message(self, audio_bytes: bytes, user=None, db=None) -> tuple[str, bytes]:
        """Complete voice-to-voice pipeline: Audio → Text → GPT-4o → Audio"""
        try:
            # Step 1: Transcribe audio to text
            logger.info("Transcribing audio message...")
            transcribed_text = await self.transcribe_audio(audio_bytes)
            logger.info(f"Transcribed: {transcribed_text[:100]}...")
            
            # Detect language for better responses
            language = "sw" if any(word in transcribed_text.lower() for word in 
                                 ["kilimo", "mazao", "shamba", "mbegu", "mvua"]) else "en"
            
            # Step 2: Generate response with GPT-4o
            logger.info("Generating AI response...")
            response_text = await self.generate_text_response(transcribed_text, user, db, language)
            logger.info(f"Generated response: {response_text[:100]}...")
            
            # Step 3: Convert response to speech
            logger.info("Converting response to speech...")
            voice = "nova" if language == "sw" else "alloy"  # Better voice for Swahili
            response_audio = await self.text_to_speech(response_text, voice)
            logger.info("Voice response generated successfully")
            
            return response_text, response_audio
            
        except Exception as e:
            logger.error(f"Error in voice processing pipeline: {e}")
            raise HTTPException(status_code=500, detail=f"Voice processing error: {str(e)}")

    async def analyze_crop_image(self, image_bytes: bytes, user_message: str = "", user=None, db=None) -> str:
        """Analyze crop/farm images using GPT-4o Vision"""
        try:
            import base64
            
            # Encode image to base64
            image_b64 = base64.b64encode(image_bytes).decode('utf-8')
            
            system_instruction = self._get_system_instruction_for_user(user, db)
            system_instruction += "\n\nYou are analyzing a farm/crop image. Provide detailed agricultural advice based on what you see."
            
            async with httpx.AsyncClient(timeout=30.0) as client:
                payload = {
                    "model": "gpt-4o",
                    "messages": [
                        {"role": "system", "content": system_instruction},
                        {
                            "role": "user",
                            "content": [
                                {"type": "text", "text": user_message or "Please analyze this crop/farm image and provide agricultural advice."},
                                {
                                    "type": "image_url",
                                    "image_url": {"url": f"data:image/jpeg;base64,{image_b64}"}
                                }
                            ]
                        }
                    ],
                    "max_tokens": 1000
                }
                
                response = await client.post(
                    f"{self.base_url}/chat/completions",
                    headers=self.headers,
                    json=payload
                )
                
                if response.status_code == 200:
                    result = response.json()
                    return result["choices"][0]["message"]["content"]
                else:
                    logger.error(f"Vision API error: {response.status_code} - {response.text}")
                    raise HTTPException(status_code=500, detail="Failed to analyze image")
                    
        except Exception as e:
            logger.error(f"Error analyzing image: {e}")
            raise HTTPException(status_code=500, detail=f"Image analysis error: {str(e)}")

# Global instance
openai_service = OpenAIService() 