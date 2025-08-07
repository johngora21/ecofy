from fastapi import APIRouter, Depends, HTTPException, status, UploadFile, File, Form
from typing import List, Dict, Any, Optional
import logging
import os
import shutil
from bson import ObjectId
from datetime import datetime

from app.api.deps import get_current_user
from app.database import get_database
from app.services.training_service import training_service
from app.services.voice_training_service import voice_training_service

router = APIRouter()
logger = logging.getLogger(__name__)

# Helper function to check admin role
def check_admin_permission(current_user: dict):
    if current_user.get("role") not in ["admin", "super_admin"]:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Admin access required"
        )

# Training Data Management
@router.post("/training-data/add")
async def add_training_data(
    category: str = Form(...),
    question_english: str = Form(...),
    answer_english: str = Form(...),
    question_swahili: str = Form(None),
    answer_swahili: str = Form(None),
    region: str = Form(None),
    crop_type: str = Form(None),
    season: str = Form(None),
    difficulty_level: str = Form("intermediate"),
    tags: str = Form(None),  # JSON string of tags
    current_user: dict = Depends(get_current_user),
    db = Depends(get_database)
):
    """Add new training data"""
    check_admin_permission(current_user)
    
    try:
        import json
        tags_list = json.loads(tags) if tags else []
    except:
        tags_list = []
    
    training_data_doc = {
        "admin_user_id": current_user["_id"],
        "category": category,
        "question_english": question_english,
        "question_swahili": question_swahili,
        "answer_english": answer_english,
        "answer_swahili": answer_swahili,
        "region": region,
        "crop_type": crop_type,
        "season": season,
        "difficulty_level": difficulty_level,
        "tags": tags_list,
        "is_approved": True,  # Auto-approve for admins
        "is_active": True,
        "usage_count": 0,
        "created_at": datetime.utcnow(),
        "updated_at": datetime.utcnow()
    }
    
    result = db.training_data.insert_one(training_data_doc)
    
    return {"message": "Training data added successfully", "id": str(result.inserted_id)}

@router.post("/training-data/bulk-add")
async def bulk_add_training_data(
    training_data_list: List[Dict[str, Any]],
    current_user: dict = Depends(get_current_user),
    db = Depends(get_database)
):
    """Bulk add training data"""
    check_admin_permission(current_user)
    
    added_count = 0
    for data in training_data_list:
        try:
            training_data_doc = {
                "admin_user_id": current_user["_id"],
                "category": data.get('category', 'general'),
                "question_english": data.get('question_english'),
                "question_swahili": data.get('question_swahili'),
                "answer_english": data.get('answer_english'),
                "answer_swahili": data.get('answer_swahili'),
                "region": data.get('region'),
                "crop_type": data.get('crop_type'),
                "season": data.get('season'),
                "difficulty_level": data.get('difficulty_level', 'intermediate'),
                "tags": data.get('tags', []),
                "is_approved": True,
                "is_active": True,
                "usage_count": 0,
                "created_at": datetime.utcnow(),
                "updated_at": datetime.utcnow()
            }
            
            db.training_data.insert_one(training_data_doc)
            added_count += 1
            
        except Exception as e:
            logger.error(f"Error adding training data: {e}")
            continue
    
    return {"message": f"Successfully added {added_count} training examples"}

@router.get("/training-data")
async def get_training_data(
    category: str = None,
    region: str = None,
    crop_type: str = None,
    limit: int = 100,
    offset: int = 0,
    current_user: dict = Depends(get_current_user),
    db = Depends(get_database)
):
    """Get training data with filters"""
    check_admin_permission(current_user)
    
    filter_query = {"is_active": True}
    
    if category:
        filter_query["category"] = category
    if region:
        filter_query["region"] = region
    if crop_type:
        filter_query["crop_type"] = crop_type
    
    total = db.training_data.count_documents(filter_query)
    data = list(db.training_data.find(filter_query).skip(offset).limit(limit))
    
    return {
        "total": total,
        "data": data,
        "limit": limit,
        "offset": offset
    }

@router.post("/training-data/upload-excel")
async def upload_excel_data(
    file: UploadFile = File(...),
    crop_type: str = Form(None),
    region: str = Form(None),
    current_user: dict = Depends(get_current_user),
    db = Depends(get_database)
):
    """Upload Excel file for training data extraction"""
    check_admin_permission(current_user)
    
    if not file.filename.endswith(('.xlsx', '.xls')):
        raise HTTPException(status_code=400, detail="Only Excel files are allowed")
    
    # Save uploaded file
    upload_dir = "uploads/training_data"
    os.makedirs(upload_dir, exist_ok=True)
    file_path = f"{upload_dir}/{file.filename}"
    
    try:
        with open(file_path, "wb") as buffer:
            shutil.copyfileobj(file.file, buffer)
        
        # Record upload
        upload_record_doc = {
            "admin_user_id": current_user["_id"],
            "filename": file.filename,
            "file_path": file_path,
            "file_size": os.path.getsize(file_path),
            "file_type": "xlsx",
            "crop_type": crop_type,
            "region": region,
            "processing_status": "processing",
            "data_points_count": 0,
            "extracted_examples": 0,
            "created_at": datetime.utcnow()
        }
        
        upload_result = db.crop_data_uploads.insert_one(upload_record_doc)
        upload_record_doc["_id"] = upload_result.inserted_id
        
        # Process Excel file
        try:
            training_examples = await training_service.prepare_training_data_from_excel(file_path)
            
            # Save training examples to database
            added_count = 0
            for example in training_examples:
                for message in example["messages"]:
                    if message["role"] == "user":
                        user_content = message["content"]
                    elif message["role"] == "assistant":
                        assistant_content = message["content"]
                
                # Detect language
                is_swahili = any(word in user_content.lower() for word in ["katika", "ya", "ni", "na", "kwa"])
                
                training_data_doc = {
                    "admin_user_id": current_user["_id"],
                    "category": crop_type or "crops",
                    "question_english": user_content if not is_swahili else "",
                    "question_swahili": user_content if is_swahili else "",
                    "answer_english": assistant_content if not is_swahili else "",
                    "answer_swahili": assistant_content if is_swahili else "",
                    "region": region,
                    "crop_type": crop_type,
                    "is_approved": True,
                    "is_active": True,
                    "usage_count": 0,
                    "created_at": datetime.utcnow(),
                    "updated_at": datetime.utcnow()
                }
                
                db.training_data.insert_one(training_data_doc)
                added_count += 1
            
            # Update upload record
            db.crop_data_uploads.update_one(
                {"_id": upload_result.inserted_id},
                {
                    "$set": {
                        "processing_status": "completed",
                        "extracted_examples": added_count,
                        "processed_at": datetime.utcnow()
                    }
                }
            )
            
            return {
                "message": f"Successfully processed Excel file and added {added_count} training examples",
                "upload_id": str(upload_result.inserted_id),
                "examples_added": added_count
            }
            
        except Exception as e:
            db.crop_data_uploads.update_one(
                {"_id": upload_result.inserted_id},
                {
                    "$set": {
                        "processing_status": "failed",
                        "error_message": str(e)
                    }
                }
            )
            raise HTTPException(status_code=500, detail=f"Excel processing failed: {str(e)}")
            
    except Exception as e:
        logger.error(f"File upload error: {e}")
        raise HTTPException(status_code=500, detail=f"File upload failed: {str(e)}")

# Model Training
@router.post("/training/start")
async def start_training(
    job_name: str,
    base_model: str = "gpt-4o-mini",
    include_excel_data: bool = True,
    current_user: dict = Depends(get_current_user),
    db = Depends(get_database)
):
    """Start model fine-tuning"""
    check_admin_permission(current_user)
    
    try:
        # Get training data from database
        training_data_query = db.training_data.find({
            "is_approved": True,
            "is_active": True
        })
        
        admin_data = []
        for data in training_data_query:
            admin_data.append({
                "question_english": data["question_english"],
                "question_swahili": data["question_swahili"],
                "answer_english": data["answer_english"],
                "answer_swahili": data["answer_swahili"],
                "category": data["category"]
            })
        
        # Include Excel files if requested
        excel_files = []
        if include_excel_data:
            excel_files = [
                "ecofyapp/lib/data/specifieddata/crops conditions/maize data.xlsx",
                "ecofyapp/lib/data/specifieddata/crops conditions/Tomato data.xlsx",
                "ecofyapp/lib/data/specifieddata/crops conditions/Banana data.xlsx",
            ]
        
        # Create training job record
        training_job_doc = {
            "admin_user_id": current_user["_id"],
            "job_name": job_name,
            "base_model": base_model,
            "status": "starting",
            "training_data_count": len(admin_data),
            "created_at": datetime.utcnow(),
            "updated_at": datetime.utcnow()
        }
        
        job_result = db.training_jobs.insert_one(training_job_doc)
        training_job_doc["_id"] = job_result.inserted_id
        
        # Start training
        openai_job_id = await training_service.train_from_all_sources(
            admin_data=admin_data,
            excel_files=excel_files
        )
        
        # Update job record
        db.training_jobs.update_one(
            {"_id": job_result.inserted_id},
            {
                "$set": {
                    "openai_job_id": openai_job_id,
                    "status": "running",
                    "updated_at": datetime.utcnow()
                }
            }
        )
        
        return {
            "message": "Training started successfully",
            "job_id": str(job_result.inserted_id),
            "openai_job_id": openai_job_id,
            "training_examples": len(admin_data)
        }
        
    except Exception as e:
        logger.error(f"Training start error: {e}")
        raise HTTPException(status_code=500, detail=f"Training failed to start: {str(e)}")

@router.get("/training/status/{job_id}")
async def get_training_status(
    job_id: str,
    current_user: dict = Depends(get_current_user),
    db = Depends(get_database)
):
    """Get training job status"""
    check_admin_permission(current_user)
    
    training_job = db.training_jobs.find_one({"_id": ObjectId(job_id)})
    if not training_job:
        raise HTTPException(status_code=404, detail="Training job not found")
    
    # Check OpenAI status if job is running
    if training_job.get("openai_job_id") and training_job["status"] == "running":
        try:
            openai_status = await training_service.check_fine_tuning_status(training_job["openai_job_id"])
            
            # Update local status
            update_data = {
                "status": openai_status.get("status", "running"),
                "updated_at": datetime.utcnow()
            }
            if openai_status.get("fine_tuned_model"):
                update_data["fine_tuned_model_id"] = openai_status["fine_tuned_model"]
            
            db.training_jobs.update_one(
                {"_id": ObjectId(job_id)},
                {"$set": update_data}
            )
            
            return {
                "job_id": job_id,
                "status": update_data["status"],
                "openai_status": openai_status,
                "fine_tuned_model": openai_status.get("fine_tuned_model")
            }
            
        except Exception as e:
            logger.error(f"Status check error: {e}")
            return {
                "job_id": job_id,
                "status": training_job["status"],
                "error": str(e)
            }
    
    return {
        "job_id": job_id,
        "status": training_job["status"],
        "fine_tuned_model": training_job.get("fine_tuned_model_id")
    }

@router.post("/training/deploy/{job_id}")
async def deploy_model(
    job_id: str,
    current_user: dict = Depends(get_current_user),
    db = Depends(get_database)
):
    """Deploy fine-tuned model"""
    check_admin_permission(current_user)
    
    training_job = db.training_jobs.find_one({"_id": ObjectId(job_id)})
    if not training_job:
        raise HTTPException(status_code=404, detail="Training job not found")
    
    if not training_job.get("fine_tuned_model_id"):
        raise HTTPException(status_code=400, detail="No fine-tuned model available")
    
    try:
        # Update training service to use new model
        await training_service.update_model(training_job["fine_tuned_model_id"])
        
        # Mark as deployed
        db.training_jobs.update_one(
            {"_id": ObjectId(job_id)},
            {"$set": {"is_deployed": True, "updated_at": datetime.utcnow()}}
        )
        
        # Mark other models as not deployed
        db.training_jobs.update_many(
            {"_id": {"$ne": ObjectId(job_id)}},
            {"$set": {"is_deployed": False, "updated_at": datetime.utcnow()}}
        )
        
        return {
            "message": "Model deployed successfully",
            "model_id": training_job["fine_tuned_model_id"]
        }
        
    except Exception as e:
        logger.error(f"Model deployment error: {e}")
        raise HTTPException(status_code=500, detail=f"Deployment failed: {str(e)}")

# Feedback Management
@router.get("/feedback")
async def get_user_feedback(
    rating: int = None,
    language: str = None,
    limit: int = 100,
    offset: int = 0,
    current_user: dict = Depends(get_current_user),
    db = Depends(get_database)
):
    """Get user feedback data"""
    check_admin_permission(current_user)
    
    filter_query = {}
    
    if rating:
        filter_query["rating"] = rating
    if language:
        filter_query["language_used"] = language
    
    total = db.feedback_data.count_documents(filter_query)
    feedback = list(db.feedback_data.find(filter_query).skip(offset).limit(limit))
    
    return {
        "total": total,
        "feedback": feedback,
        "limit": limit,
        "offset": offset
    }

# Voice Training Monitoring
@router.get("/voice-training/stats")
async def get_voice_training_stats(
    current_user: dict = Depends(get_current_user),
    db = Depends(get_database)
):
    """Get voice training statistics"""
    check_admin_permission(current_user)
    
    try:
        stats = await voice_training_service.get_training_stats()
        return stats
    except Exception as e:
        logger.error(f"Error getting voice training stats: {e}")
        raise HTTPException(status_code=500, detail="Failed to get voice training stats")

@router.post("/voice-training/manual-sample")
async def add_manual_voice_sample(
    audio_file: UploadFile = File(...),
    transcription: str = Form(...),
    region: str = Form("Tanzania"),
    current_user: dict = Depends(get_current_user),
    db = Depends(get_database)
):
    """Manually add a high-quality Tanzanian voice sample"""
    check_admin_permission(current_user)
    
    if not audio_file.filename.endswith(('.wav', '.mp3', '.m4a')):
        raise HTTPException(status_code=400, detail="Only audio files are allowed")
    
    try:
        # Read audio file
        audio_bytes = await audio_file.read()
        
        # Process as training sample
        training_result = await voice_training_service.process_farmer_voice_for_training(
            audio_bytes, transcription, "Manual training sample", current_user, db
        )
        
        return {
            "message": "Voice sample added successfully",
            "training_result": training_result
        }
        
    except Exception as e:
        logger.error(f"Error adding manual voice sample: {e}")
        raise HTTPException(status_code=500, detail="Failed to add voice sample")

@router.get("/analytics/voice-training")
async def get_voice_training_analytics(
    current_user: dict = Depends(get_current_user),
    db = Depends(get_database)
):
    """Get detailed voice training analytics"""
    check_admin_permission(current_user)
    
    try:
        # Get voice training stats
        voice_stats = await voice_training_service.get_training_stats()
        
        # Get recent voice interactions from database
        recent_feedback = list(db.feedback_data.find({
            "language_used": "swahili"
        }).sort("created_at", -1).limit(50))
        
        # Calculate accent improvement metrics
        swahili_interactions = len([f for f in recent_feedback if f.get("language_used") == "swahili"])
        positive_swahili_feedback = len([f for f in recent_feedback if f.get("language_used") == "swahili" and f.get("rating", 0) >= 4])
        
        accent_satisfaction = round((positive_swahili_feedback / swahili_interactions * 100), 2) if swahili_interactions > 0 else 0
        
        return {
            "voice_training": voice_stats,
            "accent_metrics": {
                "swahili_interactions": swahili_interactions,
                "positive_feedback": positive_swahili_feedback,
                "accent_satisfaction_rate": accent_satisfaction
            },
            "training_progress": {
                "samples_collected": voice_stats.get("total_samples", 0),
                "training_ready": voice_stats.get("ready_for_training", False),
                "improvement_trend": "increasing" if accent_satisfaction > 70 else "needs_improvement"
            }
        }
        
    except Exception as e:
        logger.error(f"Error getting voice training analytics: {e}")
        raise HTTPException(status_code=500, detail="Failed to get voice training analytics")

@router.get("/analytics/dashboard")
async def get_admin_dashboard(
    current_user: dict = Depends(get_current_user),
    db = Depends(get_database)
):
    """Get admin dashboard analytics"""
    check_admin_permission(current_user)
    
    # Training data stats
    total_training_data = db.training_data.count_documents({"is_active": True})
    approved_data = db.training_data.count_documents({
        "is_active": True,
        "is_approved": True
    })
    
    # Training jobs stats
    total_jobs = db.training_jobs.count_documents({})
    completed_jobs = db.training_jobs.count_documents({"status": "completed"})
    active_model = db.training_jobs.find_one({"is_deployed": True})
    
    # Feedback stats
    total_feedback = db.feedback_data.count_documents({})
    positive_feedback = db.feedback_data.count_documents({"rating": {"$gte": 4}})
    
    # Category breakdown
    category_stats = list(db.training_data.aggregate([
        {"$match": {"is_active": True}},
        {"$group": {"_id": "$category", "count": {"$sum": 1}}}
    ]))
    
    return {
        "training_data": {
            "total": total_training_data,
            "approved": approved_data,
            "approval_rate": round((approved_data / total_training_data * 100), 2) if total_training_data > 0 else 0
        },
        "training_jobs": {
            "total": total_jobs,
            "completed": completed_jobs,
            "success_rate": round((completed_jobs / total_jobs * 100), 2) if total_jobs > 0 else 0
        },
        "active_model": {
            "model_id": active_model.get("fine_tuned_model_id") if active_model else None,
            "deployed_at": active_model.get("updated_at") if active_model else None
        },
        "feedback": {
            "total": total_feedback,
            "positive": positive_feedback,
            "satisfaction_rate": round((positive_feedback / total_feedback * 100), 2) if total_feedback > 0 else 0
        },
        "categories": {stat["_id"]: stat["count"] for stat in category_stats}
    } 