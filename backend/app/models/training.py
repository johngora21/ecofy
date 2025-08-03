from sqlalchemy import Column, String, Text, DateTime, Boolean, Integer, JSON, ForeignKey
from sqlalchemy.sql import func
from sqlalchemy.orm import relationship
import uuid

from app.database import Base

class TrainingData(Base):
    __tablename__ = "training_data"

    id = Column(String, primary_key=True, default=lambda: str(uuid.uuid4()))
    admin_user_id = Column(String, ForeignKey("users.id"), nullable=False)
    category = Column(String, nullable=False)  # crops, pests, diseases, market, weather, etc.
    question_english = Column(Text, nullable=False)
    question_swahili = Column(Text, nullable=True)
    answer_english = Column(Text, nullable=False)
    answer_swahili = Column(Text, nullable=True)
    region = Column(String, nullable=True)  # Tanzania region
    crop_type = Column(String, nullable=True)  # Specific crop if applicable
    season = Column(String, nullable=True)  # Planting/harvest season
    difficulty_level = Column(String, default="intermediate")  # basic, intermediate, advanced
    tags = Column(JSON, nullable=True)  # Array of tags for better organization
    is_approved = Column(Boolean, default=False)
    is_active = Column(Boolean, default=True)
    usage_count = Column(Integer, default=0)  # How many times this data was used in training
    created_at = Column(DateTime(timezone=True), server_default=func.now(), nullable=False)
    updated_at = Column(DateTime(timezone=True), server_default=func.now(), onupdate=func.now(), nullable=False)

    # Relationships
    admin_user = relationship("User", backref="training_data_created")

class TrainingJob(Base):
    __tablename__ = "training_jobs"

    id = Column(String, primary_key=True, default=lambda: str(uuid.uuid4()))
    admin_user_id = Column(String, ForeignKey("users.id"), nullable=False)
    job_name = Column(String, nullable=False)
    openai_job_id = Column(String, nullable=True)  # OpenAI's job ID
    openai_file_id = Column(String, nullable=True)  # Training file ID
    base_model = Column(String, default="gpt-4o-mini")
    fine_tuned_model_id = Column(String, nullable=True)  # Resulting model ID
    status = Column(String, default="pending")  # pending, running, completed, failed
    training_data_count = Column(Integer, default=0)
    hyperparameters = Column(JSON, nullable=True)
    cost_estimate = Column(String, nullable=True)
    actual_cost = Column(String, nullable=True)
    training_duration = Column(Integer, nullable=True)  # Duration in minutes
    accuracy_metrics = Column(JSON, nullable=True)
    error_message = Column(Text, nullable=True)
    is_deployed = Column(Boolean, default=False)  # Whether this model is currently active
    created_at = Column(DateTime(timezone=True), server_default=func.now(), nullable=False)
    updated_at = Column(DateTime(timezone=True), server_default=func.now(), onupdate=func.now(), nullable=False)

    # Relationships
    admin_user = relationship("User", backref="training_jobs_created")

class ModelPerformance(Base):
    __tablename__ = "model_performance"

    id = Column(String, primary_key=True, default=lambda: str(uuid.uuid4()))
    model_id = Column(String, nullable=False)  # Fine-tuned model ID
    evaluation_date = Column(DateTime(timezone=True), server_default=func.now(), nullable=False)
    test_questions_count = Column(Integer, default=0)
    accuracy_score = Column(String, nullable=True)  # Overall accuracy
    language_accuracy = Column(JSON, nullable=True)  # {"english": 95, "swahili": 87}
    category_performance = Column(JSON, nullable=True)  # Performance by category
    response_time_avg = Column(String, nullable=True)  # Average response time
    user_satisfaction = Column(String, nullable=True)  # User feedback scores
    common_errors = Column(JSON, nullable=True)  # Common error patterns
    notes = Column(Text, nullable=True)
    created_at = Column(DateTime(timezone=True), server_default=func.now(), nullable=False)

class FeedbackData(Base):
    __tablename__ = "feedback_data"

    id = Column(String, primary_key=True, default=lambda: str(uuid.uuid4()))
    user_id = Column(String, ForeignKey("users.id"), nullable=True)
    user_phone = Column(String, nullable=True)  # For WhatsApp users
    original_question = Column(Text, nullable=False)
    ai_response = Column(Text, nullable=False)
    user_feedback = Column(String, nullable=False)  # helpful, not_helpful, incorrect
    corrected_answer = Column(Text, nullable=True)  # User's suggested improvement
    language_used = Column(String, default="english")  # english, swahili
    category = Column(String, nullable=True)
    rating = Column(Integer, nullable=True)  # 1-5 stars
    is_processed = Column(Boolean, default=False)  # Whether used for retraining
    created_at = Column(DateTime(timezone=True), server_default=func.now(), nullable=False)

    # Relationships
    user = relationship("User", backref="ai_feedback")

class CropDataUpload(Base):
    __tablename__ = "crop_data_uploads"

    id = Column(String, primary_key=True, default=lambda: str(uuid.uuid4()))
    admin_user_id = Column(String, ForeignKey("users.id"), nullable=False)
    filename = Column(String, nullable=False)
    file_path = Column(String, nullable=False)
    file_size = Column(Integer, nullable=False)
    file_type = Column(String, nullable=False)  # xlsx, csv, json
    crop_type = Column(String, nullable=True)
    region = Column(String, nullable=True)
    data_points_count = Column(Integer, default=0)
    processing_status = Column(String, default="pending")  # pending, processing, completed, failed
    extracted_examples = Column(Integer, default=0)  # Training examples generated
    error_message = Column(Text, nullable=True)
    metadata = Column(JSON, nullable=True)  # File metadata and processing info
    created_at = Column(DateTime(timezone=True), server_default=func.now(), nullable=False)
    processed_at = Column(DateTime(timezone=True), nullable=True)

    # Relationships
    admin_user = relationship("User", backref="crop_data_uploads") 