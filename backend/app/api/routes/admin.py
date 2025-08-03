from fastapi import APIRouter, Depends, HTTPException, status, UploadFile, File, Form
from sqlalchemy.orm import Session
from typing import List, Dict, Any, Optional
import logging
import os
import shutil
from sqlalchemy import func

from app.api.deps import get_current_user
from app.database import get_db
from app.models.user import User
from app.models.training import TrainingData, TrainingJob, ModelPerformance, FeedbackData, CropDataUpload
from app.services.training_service import training_service
from app.services.voice_training_service import voice_training_service

router = APIRouter()
logger = logging.getLogger(__name__)

# Helper function to check admin role
def check_admin_permission(current_user: User):
    if current_user.role not in ["admin", "super_admin"]:
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
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    """Add new training data"""
    check_admin_permission(current_user)
    
    try:
        import json
        tags_list = json.loads(tags) if tags else []
    except:
        tags_list = []
    
    training_data = TrainingData(
        admin_user_id=current_user.id,
        category=category,
        question_english=question_english,
        question_swahili=question_swahili,
        answer_english=answer_english,
        answer_swahili=answer_swahili,
        region=region,
        crop_type=crop_type,
        season=season,
        difficulty_level=difficulty_level,
        tags=tags_list,
        is_approved=True  # Auto-approve for admins
    )
    
    db.add(training_data)
    db.commit()
    db.refresh(training_data)
    
    return {"message": "Training data added successfully", "id": training_data.id}

@router.post("/training-data/bulk-add")
async def bulk_add_training_data(
    training_data_list: List[Dict[str, Any]],
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    """Bulk add training data"""
    check_admin_permission(current_user)
    
    added_count = 0
    for data in training_data_list:
        try:
            training_data = TrainingData(
                admin_user_id=current_user.id,
                category=data.get('category', 'general'),
                question_english=data.get('question_english'),
                question_swahili=data.get('question_swahili'),
                answer_english=data.get('answer_english'),
                answer_swahili=data.get('answer_swahili'),
                region=data.get('region'),
                crop_type=data.get('crop_type'),
                season=data.get('season'),
                difficulty_level=data.get('difficulty_level', 'intermediate'),
                tags=data.get('tags', []),
                is_approved=True
            )
            
            db.add(training_data)
            added_count += 1
            
        except Exception as e:
            logger.error(f"Error adding training data: {e}")
            continue
    
    db.commit()
    return {"message": f"Successfully added {added_count} training examples"}

@router.get("/training-data")
async def get_training_data(
    category: str = None,
    region: str = None,
    crop_type: str = None,
    limit: int = 100,
    offset: int = 0,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    """Get training data with filters"""
    check_admin_permission(current_user)
    
    query = db.query(TrainingData).filter(TrainingData.is_active == True)
    
    if category:
        query = query.filter(TrainingData.category == category)
    if region:
        query = query.filter(TrainingData.region == region)
    if crop_type:
        query = query.filter(TrainingData.crop_type == crop_type)
    
    total = query.count()
    data = query.offset(offset).limit(limit).all()
    
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
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
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
        upload_record = CropDataUpload(
            admin_user_id=current_user.id,
            filename=file.filename,
            file_path=file_path,
            file_size=os.path.getsize(file_path),
            file_type="xlsx",
            crop_type=crop_type,
            region=region,
            processing_status="processing"
        )
        
        db.add(upload_record)
        db.commit()
        db.refresh(upload_record)
        
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
                
                training_data = TrainingData(
                    admin_user_id=current_user.id,
                    category=crop_type or "crops",
                    question_english=user_content if not is_swahili else "",
                    question_swahili=user_content if is_swahili else "",
                    answer_english=assistant_content if not is_swahili else "",
                    answer_swahili=assistant_content if is_swahili else "",
                    region=region,
                    crop_type=crop_type,
                    is_approved=True
                )
                
                db.add(training_data)
                added_count += 1
            
            # Update upload record
            upload_record.processing_status = "completed"
            upload_record.extracted_examples = added_count
            upload_record.processed_at = func.now()
            
            db.commit()
            
            return {
                "message": f"Successfully processed Excel file and added {added_count} training examples",
                "upload_id": upload_record.id,
                "examples_added": added_count
            }
            
        except Exception as e:
            upload_record.processing_status = "failed"
            upload_record.error_message = str(e)
            db.commit()
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
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    """Start model fine-tuning"""
    check_admin_permission(current_user)
    
    try:
        # Get training data from database
        training_data_query = db.query(TrainingData).filter(
            TrainingData.is_approved == True,
            TrainingData.is_active == True
        ).all()
        
        admin_data = []
        for data in training_data_query:
            admin_data.append({
                "question_english": data.question_english,
                "question_swahili": data.question_swahili,
                "answer_english": data.answer_english,
                "answer_swahili": data.answer_swahili,
                "category": data.category
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
        training_job = TrainingJob(
            admin_user_id=current_user.id,
            job_name=job_name,
            base_model=base_model,
            status="starting",
            training_data_count=len(admin_data)
        )
        
        db.add(training_job)
        db.commit()
        db.refresh(training_job)
        
        # Start training
        openai_job_id = await training_service.train_from_all_sources(
            admin_data=admin_data,
            excel_files=excel_files
        )
        
        # Update job record
        training_job.openai_job_id = openai_job_id
        training_job.status = "running"
        db.commit()
        
        return {
            "message": "Training started successfully",
            "job_id": training_job.id,
            "openai_job_id": openai_job_id,
            "training_examples": len(admin_data)
        }
        
    except Exception as e:
        logger.error(f"Training start error: {e}")
        raise HTTPException(status_code=500, detail=f"Training failed to start: {str(e)}")

@router.get("/training/status/{job_id}")
async def get_training_status(
    job_id: str,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    """Get training job status"""
    check_admin_permission(current_user)
    
    training_job = db.query(TrainingJob).filter(TrainingJob.id == job_id).first()
    if not training_job:
        raise HTTPException(status_code=404, detail="Training job not found")
    
    # Check OpenAI status if job is running
    if training_job.openai_job_id and training_job.status == "running":
        try:
            openai_status = await training_service.check_fine_tuning_status(training_job.openai_job_id)
            
            # Update local status
            training_job.status = openai_status.get("status", "running")
            if openai_status.get("fine_tuned_model"):
                training_job.fine_tuned_model_id = openai_status["fine_tuned_model"]
            
            db.commit()
            
            return {
                "job_id": job_id,
                "status": training_job.status,
                "openai_status": openai_status,
                "fine_tuned_model": training_job.fine_tuned_model_id
            }
            
        except Exception as e:
            logger.error(f"Status check error: {e}")
            return {
                "job_id": job_id,
                "status": training_job.status,
                "error": str(e)
            }
    
    return {
        "job_id": job_id,
        "status": training_job.status,
        "fine_tuned_model": training_job.fine_tuned_model_id
    }

@router.post("/training/deploy/{job_id}")
async def deploy_model(
    job_id: str,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    """Deploy fine-tuned model"""
    check_admin_permission(current_user)
    
    training_job = db.query(TrainingJob).filter(TrainingJob.id == job_id).first()
    if not training_job:
        raise HTTPException(status_code=404, detail="Training job not found")
    
    if not training_job.fine_tuned_model_id:
        raise HTTPException(status_code=400, detail="No fine-tuned model available")
    
    try:
        # Update training service to use new model
        await training_service.update_model(training_job.fine_tuned_model_id)
        
        # Mark as deployed
        training_job.is_deployed = True
        
        # Mark other models as not deployed
        db.query(TrainingJob).filter(
            TrainingJob.id != job_id,
            TrainingJob.is_deployed == True
        ).update({"is_deployed": False})
        
        db.commit()
        
        return {
            "message": "Model deployed successfully",
            "model_id": training_job.fine_tuned_model_id
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
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    """Get user feedback data"""
    check_admin_permission(current_user)
    
    query = db.query(FeedbackData)
    
    if rating:
        query = query.filter(FeedbackData.rating == rating)
    if language:
        query = query.filter(FeedbackData.language_used == language)
    
    total = query.count()
    feedback = query.offset(offset).limit(limit).all()
    
    return {
        "total": total,
        "feedback": feedback,
        "limit": limit,
        "offset": offset
    }

# Voice Training Monitoring
@router.get("/voice-training/stats")
async def get_voice_training_stats(
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
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
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
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
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    """Get detailed voice training analytics"""
    check_admin_permission(current_user)
    
    try:
        # Get voice training stats
        voice_stats = await voice_training_service.get_training_stats()
        
        # Get recent voice interactions from database
        recent_feedback = db.query(FeedbackData).filter(
            FeedbackData.language_used == "swahili"
        ).order_by(FeedbackData.created_at.desc()).limit(50).all()
        
        # Calculate accent improvement metrics
        swahili_interactions = len([f for f in recent_feedback if f.language_used == "swahili"])
        positive_swahili_feedback = len([f for f in recent_feedback if f.language_used == "swahili" and f.rating >= 4])
        
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
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    """Get admin dashboard analytics"""
    check_admin_permission(current_user)
    
    # Training data stats
    total_training_data = db.query(TrainingData).filter(TrainingData.is_active == True).count()
    approved_data = db.query(TrainingData).filter(
        TrainingData.is_active == True,
        TrainingData.is_approved == True
    ).count()
    
    # Training jobs stats
    total_jobs = db.query(TrainingJob).count()
    completed_jobs = db.query(TrainingJob).filter(TrainingJob.status == "completed").count()
    active_model = db.query(TrainingJob).filter(TrainingJob.is_deployed == True).first()
    
    # Feedback stats
    total_feedback = db.query(FeedbackData).count()
    positive_feedback = db.query(FeedbackData).filter(
        FeedbackData.rating >= 4
    ).count()
    
    # Category breakdown
    category_stats = db.query(TrainingData.category, func.count(TrainingData.id)).filter(
        TrainingData.is_active == True
    ).group_by(TrainingData.category).all()
    
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
            "model_id": active_model.fine_tuned_model_id if active_model else None,
            "deployed_at": active_model.updated_at if active_model else None
        },
        "feedback": {
            "total": total_feedback,
            "positive": positive_feedback,
            "satisfaction_rate": round((positive_feedback / total_feedback * 100), 2) if total_feedback > 0 else 0
        },
        "categories": dict(category_stats)
    } 