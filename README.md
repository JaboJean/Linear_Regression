Temperature Prediction Mobile App
A Flutter mobile application that predicts global temperature changes using machine learning models (Linear Regression, Random Forest, and Decision Trees). The app connects to a FastAPI backend for real-time temperature predictions based on historical climate data as my mission aligns with climate change.

API Endpoint: https://linear-regression-api.onrender.com
📹 Video Demonstration: https://youtu.be/H0bxHxqaKGo

Mobile App Features:
Real-time temperature prediction
Multiple ML model comparison
Interactive results with interpretation
Clean, intuitive user interface
 Prerequisites
1. Install Flutter SDK
Download Flutter from: https://docs.flutter.dev/get-started/install
Add Flutter to your system PATH
Verify installation: flutter doctor
2. Install Android Studio
Download from: https://developer.android.com/studio
Install Android SDK and create a virtual device (AVD)
3. Install Git
Download from: https://git-scm.com/downloads
 Setup Instructions
Clone the Repository
git clone https://github.com/JaboJean/Linear_Regression.git
cd Linear_Regression

Flutter App Setup
Navigate to Flutter App Directory
cd summative/Flutter/temp_predict

Install Dependencies
flutter pub get

Backend API Setup
Option 1: Use Live API (Recommended)
The app is configured to use our live API at: https://linear-regression-api.onrender.com
No additional setup required - just run the Flutter app!
Option 2: Run API Locally
Navigate to API Directory:
cd ../../API

Install Python Dependencies:
pip install -r requirements.txt

Verify Model File:
ls "Random Forest.pkl"

Start the API Server:
uvicorn main:app --reload --host 0.0.0.0 --port 8000

Note: Keep this terminal window open - the API server must be running for the app to work.
 Running the Mobile App
Step 1: Start Android Emulator
Open Android Studio
Go to Tools > AVD Manager
Start an existing virtual device OR create a new one
Step 2: Navigate to Flutter Directory
cd summative/Flutter/temp_predict

Step 3: Check Flutter Setup
flutter doctor

Fix any issues shown in red.
Step 4: Run the App
flutter run

Using the App
1. Launch Screen
The app opens with a temperature prediction interface
2. Make a Prediction
Enter a year (e.g., 2014)
Tap "Predict Temperature"
Wait for the result
3. View Results
Prediction Result: Shows predicted temperature change
Prediction Details: Displays input parameters and model info
Interpretation: Provides context about the prediction
4. Additional Actions
Try Again: Make another prediction with different input
New Prediction: Clear current results and start fresh
🔧 Troubleshooting
Common Issues:
1. "Model file not found" Error (Local API only)
# Verify model file location
ls "../../API/Random Forest.pkl"


# If missing, copy from the correct location
cp "../Linear_regression_model/Random Forest.pkl" "../../API/"

2. API Connection Error
Live API: Check your internet connection
Local API: Ensure API server is running on http://localhost:8000
Check if port 8000 is available
Verify your computer's firewall settings
3. Flutter Build Errors
# Clean and rebuild
flutter clean
flutter pub get
flutter run

4. Android Emulator Issues
Restart the emulator
Try a different virtual device
Check Android SDK installation
5. Network Connection Issues
For live API: Ensure stable internet connection
For local API: Ensure both API server and Flutter app are on the same network
For physical device testing, use your computer's IP address instead of localhost
💻 Development Commands
Hot Reload (while app is running):
Press r in the terminal to hot reload
Press R for hot restart
Press q to quit
Build for Release:
flutter build apk --release

🖥️ System Requirements
Operating System: Windows 10+, macOS 10.14+, or Linux
RAM: Minimum 8GB (16GB recommended)
Storage: 10GB free space
Internet: Required for initial setup and dependencies
🏗️ Project Structure
Linear_Regression/
├── summative/
│   ├── Flutter/
│   │   └── temp_predict/          # Flutter mobile app
│   ├── API/                       # FastAPI backend
│   │   ├── main.py
│   │   ├── Random Forest.pkl      # ML model file
│   │   └── requirements.txt
│   └── Linear_regression_model/   # Model training files

🤖 Machine Learning Models
The app uses three different models for temperature prediction:
Linear Regression with SGD: Simple baseline model
Random Forest: Ensemble method (currently deployed)
Decision Tree: Interpretable single-tree model
Model performance is compared using Mean Squared Error (MSE) metrics.
🚀 Deployment
API Deployment (Render)
The FastAPI backend is deployed on Render at: https://linear-regression-api.onrender.com
Mobile App Deployment
Build APK: flutter build apk --release
APK location: build/app/outputs/flutter-apk/app-release.apk
🤝 Contributing
Fork the repository
Create a feature branch
Make your changes
Submit a pull request
📄 License
This project is licensed under the MIT License.
📞 Support
If you encounter issues:
Check the terminal output for error messages
Ensure all prerequisites are installed
Verify API connectivity (live or local)
Check Flutter doctor output
Review the troubleshooting section above
For additional support, please open an issue on GitHub.

Built with: Flutter, FastAPI, Scikit-learn, Python, Dart
