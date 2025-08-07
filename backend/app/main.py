from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from contextlib import asynccontextmanager
import logging

from app.database import connect_to_mongo, close_mongo_connection
from app.api.routes import users, farms, crops, marketplace, market, external
from app.services.scraper_service import setup_scraper_scheduler
from app.services.monitor_service import start_document_monitor

# Set up logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

@asynccontextmanager
async def lifespan(app: FastAPI):
    # Startup
    connect_to_mongo()
    
    # Setup scraper scheduler
    from app.database import get_database
    db = get_database()
    setup_scraper_scheduler(db)
    
    # Start document monitor for automatic new PDF detection
    logger.info("Starting document monitor...")
    monitor_thread = start_document_monitor()
    
    yield
    
    # Shutdown
    close_mongo_connection()

app = FastAPI(
    title="EcoFy API",
    description="API for EcoFy agricultural management system",
    version="1.0.0",
    lifespan=lifespan
)

# CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Include routers
app.include_router(users.router, prefix="/api/v1/users", tags=["users"])
app.include_router(farms.router, prefix="/api/v1/farms", tags=["farms"])
app.include_router(crops.router, prefix="/api/v1/crops", tags=["crops"])
app.include_router(marketplace.router, prefix="/api/v1/marketplace", tags=["marketplace"])
app.include_router(market.router, prefix="/api/v1/market", tags=["market"])
app.include_router(external.router, prefix="/api/v1/external", tags=["external"])

@app.get("/")
async def root():
    return {"message": "EcoFy API is running!"}

@app.get("/health")
async def health_check():
    return {"status": "healthy", "message": "EcoFy API is operational"} 