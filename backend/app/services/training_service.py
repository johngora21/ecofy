import os
import json
import logging
from typing import List, Dict, Any, Optional
from datetime import datetime
import httpx
from sqlalchemy.orm import Session
from fastapi import HTTPException
import pandas as pd

from app.models.user import User
from app.services.openai_service import openai_service

logger = logging.getLogger(__name__)

class TrainingService:
    def __init__(self):
        from app.core.config import settings
        self.api_key = settings.OPENAI_API_KEY
        self.base_url = "https://api.openai.com/v1"
        self.headers = {
            "Authorization": f"Bearer {self.api_key}",
            "Content-Type": "application/json"
        }
        self.current_model = "gpt-4o"  # Will be updated when fine-tuned model is ready
        
    async def prepare_training_data_from_excel(self, file_path: str) -> List[Dict]:
        """Convert Excel crop data to training format"""
        try:
            df = pd.read_excel(file_path)
            training_examples = []
            
            # Process crop data into Q&A format
            for _, row in df.iterrows():
                # Create multiple training examples from each row
                crop_name = str(row.get('Crop', 'Unknown')).strip()
                region = str(row.get('Region', 'Tanzania')).strip()
                
                # Example 1: Growing conditions
                if 'Temperature' in df.columns and 'Rainfall' in df.columns:
                    temp = row.get('Temperature', '')
                    rainfall = row.get('Rainfall', '')
                    
                    # English example
                    training_examples.append({
                        "messages": [
                            {"role": "system", "content": "You are EcoFy AI, a Tanzania farming expert. Provide practical advice in the user's language."},
                            {"role": "user", "content": f"What are the growing conditions for {crop_name} in {region}?"},
                            {"role": "assistant", "content": f"{crop_name} grows best in {region} with temperatures around {temp}°C and rainfall of {rainfall}mm. For optimal yields, ensure proper soil preparation and pest management."}
                        ]
                    })
                    
                    # Swahili example
                    training_examples.append({
                        "messages": [
                            {"role": "system", "content": "You are EcoFy AI, a Tanzania farming expert. Provide practical advice in the user's language."},
                            {"role": "user", "content": f"Mazingira gani ya ukuaji ya {crop_name} katika {region}?"},
                            {"role": "assistant", "content": f"{crop_name} inakua vizuri katika {region} na joto la digrii {temp} na mvua ya milimita {rainfall}. Kwa mavuno mazuri, hakikisha udongo umepangwa vizuri na kudhibiti wadudu."}
                        ]
                    })
                
                # Example 2: Planting seasons
                if 'Planting_Season' in df.columns:
                    season = row.get('Planting_Season', '')
                    training_examples.append({
                        "messages": [
                            {"role": "system", "content": "You are EcoFy AI, a Tanzania farming expert. Provide practical advice in the user's language."},
                            {"role": "user", "content": f"When should I plant {crop_name}?"},
                            {"role": "assistant", "content": f"The best time to plant {crop_name} in {region} is during {season}. This timing ensures optimal growth conditions and better yields."}
                        ]
                    })
                
                # Example 3: Common problems and solutions
                if 'Common_Pests' in df.columns:
                    pests = row.get('Common_Pests', '')
                    training_examples.append({
                        "messages": [
                            {"role": "system", "content": "You are EcoFy AI, a Tanzania farming expert. Provide practical advice in the user's language."},
                            {"role": "user", "content": f"Nimepanda {crop_name} lakini nina matatizo ya wadudu"},
                            {"role": "assistant", "content": f"Matatizo ya wadudu katika {crop_name} ni ya kawaida. Wadudu wakuu ni {pests}. Tumia dawa za wadudu za asili au za kisasa. Pia, hakikisha mazingira ya shamba ni safi."}
                        ]
                    })
            
            return training_examples
            
        except Exception as e:
            logger.error(f"Error processing Excel file: {e}")
            raise HTTPException(status_code=500, detail=f"Excel processing error: {str(e)}")

    async def prepare_admin_training_data(self, admin_data: List[Dict]) -> List[Dict]:
        """Convert admin input data to training format"""
        training_examples = []
        
        for data in admin_data:
            question_en = data.get('question_english', '')
            question_sw = data.get('question_swahili', '')
            answer_en = data.get('answer_english', '')
            answer_sw = data.get('answer_swahili', '')
            category = data.get('category', 'general')
            
            # English training example
            if question_en and answer_en:
                training_examples.append({
                    "messages": [
                        {"role": "system", "content": f"You are EcoFy AI, a Tanzania farming expert specializing in {category}. Provide practical advice in the user's language."},
                        {"role": "user", "content": question_en},
                        {"role": "assistant", "content": answer_en}
                    ]
                })
            
            # Swahili training example
            if question_sw and answer_sw:
                training_examples.append({
                    "messages": [
                        {"role": "system", "content": f"You are EcoFy AI, a Tanzania farming expert specializing in {category}. Provide practical advice in the user's language."},
                        {"role": "user", "content": question_sw},
                        {"role": "assistant", "content": answer_sw}
                    ]
                })
        
        return training_examples

    async def create_training_file(self, training_data: List[Dict], filename: str = None) -> str:
        """Create JSONL file for OpenAI fine-tuning"""
        if not filename:
            filename = f"training_data_{datetime.now().strftime('%Y%m%d_%H%M%S')}.jsonl"
        
        file_path = f"/tmp/{filename}"
        
        try:
            with open(file_path, 'w', encoding='utf-8') as f:
                for example in training_data:
                    f.write(json.dumps(example, ensure_ascii=False) + '\n')
            
            logger.info(f"Training file created: {file_path} with {len(training_data)} examples")
            return file_path
            
        except Exception as e:
            logger.error(f"Error creating training file: {e}")
            raise HTTPException(status_code=500, detail=f"Training file creation error: {str(e)}")

    async def upload_training_file(self, file_path: str) -> str:
        """Upload training file to OpenAI"""
        try:
            async with httpx.AsyncClient(timeout=60.0) as client:
                with open(file_path, 'rb') as f:
                    files = {"file": (f"training_data.jsonl", f, "application/jsonl")}
                    data = {"purpose": "fine-tune"}
                    
                    response = await client.post(
                        f"{self.base_url}/files",
                        headers={"Authorization": f"Bearer {self.api_key}"},
                        files=files,
                        data=data
                    )
                
                if response.status_code == 200:
                    result = response.json()
                    file_id = result["id"]
                    logger.info(f"Training file uploaded successfully: {file_id}")
                    return file_id
                else:
                    logger.error(f"File upload failed: {response.status_code} - {response.text}")
                    raise HTTPException(status_code=500, detail="File upload failed")
                    
        except Exception as e:
            logger.error(f"Error uploading training file: {e}")
            raise HTTPException(status_code=500, detail=f"File upload error: {str(e)}")

    async def create_fine_tuning_job(self, training_file_id: str, model: str = "gpt-4o-mini") -> str:
        """Create fine-tuning job"""
        try:
            payload = {
                "training_file": training_file_id,
                "model": model,
                "hyperparameters": {
                    "n_epochs": 3,
                    "batch_size": 4,
                    "learning_rate_multiplier": 0.1
                },
                "suffix": "ecofy-tanzania-farming"
            }
            
            async with httpx.AsyncClient(timeout=60.0) as client:
                response = await client.post(
                    f"{self.base_url}/fine_tuning/jobs",
                    headers=self.headers,
                    json=payload
                )
                
                if response.status_code == 200:
                    result = response.json()
                    job_id = result["id"]
                    logger.info(f"Fine-tuning job created: {job_id}")
                    return job_id
                else:
                    logger.error(f"Fine-tuning job creation failed: {response.status_code} - {response.text}")
                    raise HTTPException(status_code=500, detail="Fine-tuning job creation failed")
                    
        except Exception as e:
            logger.error(f"Error creating fine-tuning job: {e}")
            raise HTTPException(status_code=500, detail=f"Fine-tuning job error: {str(e)}")

    async def check_fine_tuning_status(self, job_id: str) -> Dict[str, Any]:
        """Check fine-tuning job status"""
        try:
            async with httpx.AsyncClient(timeout=30.0) as client:
                response = await client.get(
                    f"{self.base_url}/fine_tuning/jobs/{job_id}",
                    headers=self.headers
                )
                
                if response.status_code == 200:
                    return response.json()
                else:
                    logger.error(f"Status check failed: {response.status_code} - {response.text}")
                    raise HTTPException(status_code=500, detail="Status check failed")
                    
        except Exception as e:
            logger.error(f"Error checking fine-tuning status: {e}")
            raise HTTPException(status_code=500, detail=f"Status check error: {str(e)}")

    async def update_model(self, fine_tuned_model_id: str):
        """Update the service to use fine-tuned model"""
        self.current_model = fine_tuned_model_id
        # Update OpenAI service too
        openai_service.model = fine_tuned_model_id
        logger.info(f"Model updated to: {fine_tuned_model_id}")

    async def train_from_all_sources(self, admin_data: List[Dict] = None, excel_files: List[str] = None) -> str:
        """Complete training pipeline from all data sources"""
        try:
            all_training_data = []
            
            # Process admin data
            if admin_data:
                admin_examples = await self.prepare_admin_training_data(admin_data)
                all_training_data.extend(admin_examples)
                logger.info(f"Added {len(admin_examples)} admin examples")
            
            # Process Excel files
            if excel_files:
                for excel_file in excel_files:
                    excel_examples = await self.prepare_training_data_from_excel(excel_file)
                    all_training_data.extend(excel_examples)
                    logger.info(f"Added {len(excel_examples)} examples from {excel_file}")
            
            # Add existing crop data from your files
            crop_files = [
                "ecofyapp/lib/data/specifieddata/crops conditions/maize data.xlsx",
                "ecofyapp/lib/data/specifieddata/crops conditions/Tomato data.xlsx",
                "ecofyapp/lib/data/specifieddata/crops conditions/Banana data.xlsx",
                # Add more as needed
            ]
            
            for crop_file in crop_files:
                if os.path.exists(crop_file):
                    try:
                        crop_examples = await self.prepare_training_data_from_excel(crop_file)
                        all_training_data.extend(crop_examples)
                        logger.info(f"Added {len(crop_examples)} examples from {crop_file}")
                    except Exception as e:
                        logger.warning(f"Skipped {crop_file}: {e}")
            
            if not all_training_data:
                raise HTTPException(status_code=400, detail="No training data available")
            
            # Create and upload training file
            file_path = await self.create_training_file(all_training_data)
            file_id = await self.upload_training_file(file_path)
            
            # Start fine-tuning
            job_id = await self.create_fine_tuning_job(file_id)
            
            # Clean up local file
            if os.path.exists(file_path):
                os.remove(file_path)
            
            logger.info(f"Training started with {len(all_training_data)} examples. Job ID: {job_id}")
            return job_id
            
        except Exception as e:
            logger.error(f"Error in training pipeline: {e}")
            raise HTTPException(status_code=500, detail=f"Training pipeline error: {str(e)}")

# Global instance
training_service = TrainingService() 