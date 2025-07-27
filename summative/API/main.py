from fastapi import FastAPI
from pydantic import BaseModel, Field
from fastapi.middleware.cors import CORSMiddleware
import uvicorn
import joblib  # Changed from pickle to joblib to match your training code
import os
import nest_asyncio

app = FastAPI(title="Temperature Change Prediction API", version="1.0.0")

# CORS setup to allow requests from any origin
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Allow all origins
    allow_credentials=True,
    allow_methods=["*"],  # Allow all methods
    allow_headers=["*"],  # Allow all headers
)

class InputData(BaseModel):
    year: int = Field(..., ge=1960, le=2030, description="Year for temperature prediction (1960-2030)")

@app.get("/")
def read_root():
    """Root endpoint to check if API is running"""
    return {"message": "Temperature Change Prediction API is running!", "status": "healthy"}

@app.get("/health")
def health_check():
    """Health check endpoint"""
    return {"status": "healthy", "service": "Temperature Prediction API"}

@app.post("/predict")
def predict(data: InputData):
    """
    Predict temperature change for a given year
    
    Args:
        data: InputData containing the year
        
    Returns:
        Dictionary with prediction or error message
    """
    # Look for the model file in multiple possible locations
    possible_paths = [
        "Random Forest.pkl",  # Same directory as main.py
        "../linear_regression/Random Forest.pkl",  # Parent directory
        "linear_regression/Random Forest.pkl",  # Subdirectory
        os.path.join(os.path.dirname(__file__), "Random Forest.pkl"),  # Absolute path
    ]
    
    model_path = None
    for path in possible_paths:
        if os.path.exists(path):
            model_path = path
            break
    
    if not model_path:
        return {
            "error": f"Model file not found. Searched in: {possible_paths}. Please ensure 'Random Forest.pkl' exists in one of these locations."
        }
    
    try:
        # Load the model using joblib (matching your training code)
        model = joblib.load(model_path)
    except Exception as e:
        return {"error": f"Error loading the model from {model_path}: {str(e)}"}
    
    # Prepare the input data - your model expects [[year]]
    input_data = [[data.year]]
    
    try:
        # Predict the temperature change
        prediction = model.predict(input_data)[0]
        
        # Return the prediction as a float
        return {
            "year": data.year,
            "prediction": float(prediction),
            "unit": "degrees Celsius change",
            "model": "Random Forest"
        }
    except Exception as e:
        return {"error": f"Error during prediction: {str(e)}"}

@app.get("/model-info")
def get_model_info():
    """Get information about the loaded model"""
    # Look for the model file in multiple possible locations
    possible_paths = [
        "Random Forest.pkl",
        "../linear_regression/Random Forest.pkl",
        "linear_regression/Random Forest.pkl",
        os.path.join(os.path.dirname(__file__), "Random Forest.pkl"),
    ]
    
    model_path = None
    for path in possible_paths:
        if os.path.exists(path):
            model_path = path
            break
    
    if not model_path:
        return {"error": "Model file not found"}
    
    try:
        model = joblib.load(model_path)
        
        return {
            "model_type": str(type(model).__name__),
            "model_path": model_path,
            "input_features": ["year"],
            "output": "temperature_change_celsius",
            "year_range": "1960-2030"
        }
    except Exception as e:
        return {"error": f"Error loading model info: {str(e)}"}

if __name__ == "__main__":
    nest_asyncio.apply()  # To handle the async event loop for FastAPI
    
    # Use 0.0.0.0 to allow connections from emulator (10.0.2.2)
    uvicorn.run(app, host="0.0.0.0", port=8000)