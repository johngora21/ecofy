#!/bin/bash

echo "🚀 Starting Ecofy Development Environment..."

# Check if Python is installed
if ! command -v python3 &> /dev/null; then
    echo "❌ Python 3 is not installed. Please install Python 3 first."
    exit 1
fi

# Check if Node.js is installed
if ! command -v node &> /dev/null; then
    echo "❌ Node.js is not installed. Please install Node.js first."
    exit 1
fi

# Check if pip is installed
if ! command -v pip3 &> /dev/null; then
    echo "❌ pip3 is not installed. Please install pip3 first."
    exit 1
fi

echo "📦 Installing Python dependencies..."
cd backend
pip3 install -r requirements.txt
cd ..

echo "📦 Installing Node.js dependencies..."
npm install

echo "🔧 Starting backend server..."
cd backend
python3 main.py &
BACKEND_PID=$!
cd ..

echo "🔧 Starting frontend server..."
npm run dev &
FRONTEND_PID=$!

echo ""
echo "✅ Ecofy is starting up!"
echo "🌐 Frontend: http://localhost:5173"
echo "🔌 Backend API: http://localhost:8000"
echo "📚 API Documentation: http://localhost:8000/docs"
echo ""
echo "Press Ctrl+C to stop both servers"

# Function to cleanup on exit
cleanup() {
    echo ""
    echo "🛑 Stopping servers..."
    kill $BACKEND_PID 2>/dev/null
    kill $FRONTEND_PID 2>/dev/null
    exit 0
}

# Set up signal handlers
trap cleanup SIGINT SIGTERM

# Wait for both processes
wait 
 
 

echo "🚀 Starting Ecofy Development Environment..."

# Check if Python is installed
if ! command -v python3 &> /dev/null; then
    echo "❌ Python 3 is not installed. Please install Python 3 first."
    exit 1
fi

# Check if Node.js is installed
if ! command -v node &> /dev/null; then
    echo "❌ Node.js is not installed. Please install Node.js first."
    exit 1
fi

# Check if pip is installed
if ! command -v pip3 &> /dev/null; then
    echo "❌ pip3 is not installed. Please install pip3 first."
    exit 1
fi

echo "📦 Installing Python dependencies..."
cd backend
pip3 install -r requirements.txt
cd ..

echo "📦 Installing Node.js dependencies..."
npm install

echo "🔧 Starting backend server..."
cd backend
python3 main.py &
BACKEND_PID=$!
cd ..

echo "🔧 Starting frontend server..."
npm run dev &
FRONTEND_PID=$!

echo ""
echo "✅ Ecofy is starting up!"
echo "🌐 Frontend: http://localhost:5173"
echo "🔌 Backend API: http://localhost:8000"
echo "📚 API Documentation: http://localhost:8000/docs"
echo ""
echo "Press Ctrl+C to stop both servers"

# Function to cleanup on exit
cleanup() {
    echo ""
    echo "🛑 Stopping servers..."
    kill $BACKEND_PID 2>/dev/null
    kill $FRONTEND_PID 2>/dev/null
    exit 0
}

# Set up signal handlers
trap cleanup SIGINT SIGTERM

# Wait for both processes
wait 
 
 