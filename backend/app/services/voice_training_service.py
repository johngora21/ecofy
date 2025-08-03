import os
import json
import logging
from typing import Dict, Any, List, Optional
from datetime import datetime
import httpx
from sqlalchemy.orm import Session
from fastapi import HTTPException
import librosa
import soundfile as sf
import io

from app.models.user import User
from app.models.training import FeedbackData, TrainingData
from app.services.openai_service import openai_service

logger = logging.getLogger(__name__)

class VoiceTrainingService:
    def __init__(self):
        from app.core.config import settings
        self.api_key = settings.OPENAI_API_KEY
        self.base_url = "https://api.openai.com/v1"
        self.headers = {
            "Authorization": f"Bearer {self.api_key}",
            "Content-Type": "application/json"
        }
        self.voice_samples_dir = "voice_samples/tanzanian"
        os.makedirs(self.voice_samples_dir, exist_ok=True)

    async def process_farmer_voice_for_training(self, audio_bytes: bytes, transcribed_text: str, 
                                              ai_response: str, user: User, db: Session) -> Dict[str, Any]:
        """Process farmer voice note for continuous training"""
        try:
            # 1. Analyze voice characteristics for Tanzanian accent
            voice_analysis = await self._analyze_tanzanian_accent(audio_bytes, transcribed_text)
            
            # 2. Save voice sample if it's good quality Tanzanian Swahili
            if voice_analysis["is_tanzanian"] and voice_analysis["quality_score"] > 0.7:
                sample_path = await self._save_voice_sample(audio_bytes, transcribed_text, user)
                logger.info(f"Saved Tanzanian voice sample: {sample_path}")
            
            # 3. Extract farming knowledge for training data
            farming_knowledge = await self._extract_farming_knowledge(transcribed_text, ai_response, user)
            
            # 4. Save training data to database
            if farming_knowledge:
                training_data = TrainingData(
                    admin_user_id=user.id,
                    category=farming_knowledge.get("category", "general"),
                    question_english=farming_knowledge.get("question_english", ""),
                    question_swahili=farming_knowledge.get("question_swahili", transcribed_text),
                    answer_english=farming_knowledge.get("answer_english", ""),
                    answer_swahili=farming_knowledge.get("answer_swahili", ai_response),
                    region=user.location if hasattr(user, 'location') else "Tanzania",
                    crop_type=farming_knowledge.get("crop_type"),
                    is_approved=False,  # Needs admin review
                    tags=["farmer_input", "voice_training", "continuous_learning"]
                )
                
                db.add(training_data)
                db.commit()
                logger.info(f"Added training data from farmer voice: {training_data.id}")
            
            # 5. Update voice model if we have enough samples
            await self._check_and_update_voice_model()
            
            return {
                "voice_analysis": voice_analysis,
                "farming_knowledge_extracted": bool(farming_knowledge),
                "training_data_added": bool(farming_knowledge),
                "voice_sample_saved": voice_analysis["is_tanzanian"] and voice_analysis["quality_score"] > 0.7
            }
            
        except Exception as e:
            logger.error(f"Error in voice training processing: {e}")
            return {"error": str(e)}

    async def _analyze_tanzanian_accent(self, audio_bytes: bytes, transcribed_text: str) -> Dict[str, Any]:
        """Analyze if voice has Tanzanian Swahili characteristics"""
        try:
            # Convert audio to analyze
            audio_buffer = io.BytesIO(audio_bytes)
            y, sr = librosa.load(audio_buffer, sr=16000)
            
            # Extract voice features
            pitch = librosa.yin(y, fmin=50, fmax=400)
            tempo, _ = librosa.beat.beat_track(y=y, sr=sr)
            spectral_centroid = librosa.feature.spectral_centroid(y=y, sr=sr)[0]
            
            # Tanzanian Swahili voice characteristics
            avg_pitch = float(pitch[~librosa.util.is_nan(pitch)].mean()) if len(pitch[~librosa.util.is_nan(pitch)]) > 0 else 0
            speech_rate = len(transcribed_text.split()) / (len(y) / sr * 60)  # words per minute
            
            # Tanzanian Swahili linguistic markers
            tanzanian_markers = [
                "hapana", "ndiyo", "sawa", "mambo", "poa", "freshi", 
                "shida", "hakuna", "mzuri", "vizuri", "sana", "hivi",
                "kitu", "jambo", "haya", "basi", "tu", "kwanza"
            ]
            
            swahili_content = any(marker in transcribed_text.lower() for marker in tanzanian_markers)
            
            # Quality metrics
            audio_duration = len(y) / sr
            is_clear = len(y) > sr * 0.5  # At least 0.5 seconds
            
            # Scoring
            quality_score = 0.0
            if swahili_content:
                quality_score += 0.4
            if 80 <= speech_rate <= 180:  # Normal Tanzanian speech rate
                quality_score += 0.3
            if audio_duration >= 1.0:  # Reasonable length
                quality_score += 0.3
            
            return {
                "is_tanzanian": swahili_content and 80 <= speech_rate <= 180,
                "quality_score": quality_score,
                "avg_pitch": avg_pitch,
                "speech_rate": speech_rate,
                "audio_duration": audio_duration,
                "swahili_markers_found": swahili_content,
                "analysis_timestamp": datetime.utcnow().isoformat()
            }
            
        except Exception as e:
            logger.error(f"Voice analysis error: {e}")
            return {
                "is_tanzanian": False,
                "quality_score": 0.0,
                "error": str(e)
            }

    async def _save_voice_sample(self, audio_bytes: bytes, transcribed_text: str, user: User) -> str:
        """Save high-quality Tanzanian voice sample for training"""
        try:
            timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
            filename = f"tanzanian_sample_{user.id}_{timestamp}.wav"
            file_path = os.path.join(self.voice_samples_dir, filename)
            
            # Convert to WAV format for training
            audio_buffer = io.BytesIO(audio_bytes)
            y, sr = librosa.load(audio_buffer, sr=16000)
            sf.write(file_path, y, sr)
            
            # Save metadata
            metadata = {
                "user_id": user.id,
                "transcription": transcribed_text,
                "timestamp": timestamp,
                "region": getattr(user, 'location', 'Tanzania'),
                "audio_duration": len(y) / sr,
                "sample_rate": sr
            }
            
            metadata_path = file_path.replace('.wav', '_metadata.json')
            with open(metadata_path, 'w', encoding='utf-8') as f:
                json.dump(metadata, f, ensure_ascii=False, indent=2)
            
            return file_path
            
        except Exception as e:
            logger.error(f"Error saving voice sample: {e}")
            raise

    async def _extract_farming_knowledge(self, question: str, answer: str, user: User) -> Optional[Dict[str, Any]]:
        """Extract farming knowledge from conversation for training data"""
        try:
            # Categorize the farming topic
            farming_categories = {
                "crops": ["mazao", "kilimo", "kupanda", "mavuno", "mbegu", "mahindi", "mpunga", "kunde", "nyanya"],
                "pests": ["wadudu", "mende", "nondo", "dawa", "kuua", "mazuia"],
                "diseases": ["magonjwa", "kuoza", "manjano", "kavu", "ugonjwa"],
                "soil": ["udongo", "rutuba", "mbolea", "pH", "kimiminya"],
                "weather": ["mvua", "jua", "upepo", "baridi", "joto", "hali ya hewa"],
                "market": ["bei", "soko", "uza", "nunua", "biashara", "gharama"]
            }
            
            category = "general"
            for cat, keywords in farming_categories.items():
                if any(keyword in question.lower() for keyword in keywords):
                    category = cat
                    break
            
            # Extract crop type if mentioned
            crops = ["mahindi", "mpunga", "kunde", "nyanya", "ndizi", "karanga", "maharagwe", "viazi"]
            crop_type = None
            for crop in crops:
                if crop in question.lower():
                    crop_type = crop
                    break
            
            # Check if it's valuable farming content
            farming_keywords = ["kilimo", "mazao", "shamba", "kupanda", "mavuno", "wadudu", "udongo", "mvua"]
            is_farming_related = any(keyword in question.lower() for keyword in farming_keywords)
            
            if is_farming_related and len(question.strip()) > 10 and len(answer.strip()) > 20:
                # Detect language
                is_swahili = any(word in question.lower() for word in ["ni", "ya", "na", "kwa", "katika"])
                
                return {
                    "category": category,
                    "question_swahili": question if is_swahili else "",
                    "question_english": "" if is_swahili else question,
                    "answer_swahili": answer if is_swahili else "",
                    "answer_english": "" if is_swahili else answer,
                    "crop_type": crop_type,
                    "difficulty_level": "intermediate",
                    "tags": ["farmer_voice", "real_question", category]
                }
            
            return None
            
        except Exception as e:
            logger.error(f"Error extracting farming knowledge: {e}")
            return None

    async def _check_and_update_voice_model(self):
        """Check if we have enough samples to update voice model"""
        try:
            # Count Tanzanian voice samples
            sample_files = [f for f in os.listdir(self.voice_samples_dir) if f.endswith('.wav')]
            
            if len(sample_files) >= 50:  # Minimum samples for voice training
                logger.info(f"Found {len(sample_files)} Tanzanian voice samples - ready for voice model update")
                
                # Create voice training dataset
                await self._create_voice_training_dataset()
                
                # Train custom voice model (placeholder - would need actual implementation)
                # This would involve uploading samples to OpenAI or another service
                logger.info("Voice model training initiated with Tanzanian samples")
            
        except Exception as e:
            logger.error(f"Error checking voice model update: {e}")

    async def _create_voice_training_dataset(self):
        """Create training dataset from collected Tanzanian voice samples"""
        try:
            dataset = []
            
            for filename in os.listdir(self.voice_samples_dir):
                if filename.endswith('_metadata.json'):
                    metadata_path = os.path.join(self.voice_samples_dir, filename)
                    audio_path = metadata_path.replace('_metadata.json', '.wav')
                    
                    if os.path.exists(audio_path):
                        with open(metadata_path, 'r', encoding='utf-8') as f:
                            metadata = json.load(f)
                        
                        dataset.append({
                            "audio_file": audio_path,
                            "text": metadata["transcription"],
                            "speaker_id": "tanzanian_farmer",
                            "language": "sw-TZ",
                            "region": metadata.get("region", "Tanzania")
                        })
            
            # Save dataset for voice training
            dataset_path = os.path.join(self.voice_samples_dir, "tanzanian_voice_dataset.json")
            with open(dataset_path, 'w', encoding='utf-8') as f:
                json.dump(dataset, f, ensure_ascii=False, indent=2)
            
            logger.info(f"Created voice training dataset with {len(dataset)} samples")
            return dataset_path
            
        except Exception as e:
            logger.error(f"Error creating voice training dataset: {e}")
            raise

    async def get_training_stats(self) -> Dict[str, Any]:
        """Get statistics about voice training progress"""
        try:
            sample_files = [f for f in os.listdir(self.voice_samples_dir) if f.endswith('.wav')]
            
            total_duration = 0
            unique_speakers = set()
            
            for filename in sample_files:
                metadata_file = filename.replace('.wav', '_metadata.json')
                metadata_path = os.path.join(self.voice_samples_dir, metadata_file)
                
                if os.path.exists(metadata_path):
                    with open(metadata_path, 'r', encoding='utf-8') as f:
                        metadata = json.load(f)
                    
                    total_duration += metadata.get("audio_duration", 0)
                    unique_speakers.add(metadata.get("user_id"))
            
            return {
                "total_samples": len(sample_files),
                "total_duration_minutes": round(total_duration / 60, 2),
                "unique_speakers": len(unique_speakers),
                "ready_for_training": len(sample_files) >= 50,
                "samples_needed": max(0, 50 - len(sample_files))
            }
            
        except Exception as e:
            logger.error(f"Error getting training stats: {e}")
            return {"error": str(e)}

# Global instance
voice_training_service = VoiceTrainingService() 