import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // For Android Emulator - use 10.0.2.2 to access host machine's localhost
  // This is the special IP that Android emulator uses to access host machine
  static const String baseUrl = 'https://linear-regression-3b4h.onrender.com';
  
  // Health check endpoint
  static Future<Map<String, dynamic>?> healthCheck() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/health'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 10));
      
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        print('Health check failed with status: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Health check error: $e');
      return null;
    }
  }
  
  // Predict temperature change for a given year
  static Future<PredictionResult?> predictTemperature(int year) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/predict'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'year': year}),
      ).timeout(const Duration(seconds: 15));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        // Check if there's an error in the response
        if (data.containsKey('error')) {
          return PredictionResult(
            success: false,
            error: data['error'],
          );
        }
        
        return PredictionResult(
          success: true,
          year: data['year'],
          prediction: data['prediction']?.toDouble(),
          unit: data['unit'],
          model: data['model'],
        );
      } else {
        return PredictionResult(
          success: false,
          error: 'Server error: ${response.statusCode}',
        );
      }
    } catch (e) {
      return PredictionResult(
        success: false,
        error: 'Connection error: $e',
      );
    }
  }
  
  // Get model information
  static Future<ModelInfo?> getModelInfo() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/model-info'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 10));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        if (data.containsKey('error')) {
          return ModelInfo(
            success: false,
            error: data['error'],
          );
        }
        
        return ModelInfo(
          success: true,
          modelType: data['model_type'],
          modelPath: data['model_path'],
          inputFeatures: List<String>.from(data['input_features']),
          output: data['output'],
          yearRange: data['year_range'],
        );
      } else {
        return ModelInfo(
          success: false,
          error: 'Server error: ${response.statusCode}',
        );
      }
    } catch (e) {
      return ModelInfo(
        success: false,
        error: 'Connection error: $e',
      );
    }
  }
}

// Data models for API responses
class PredictionResult {
  final bool success;
  final int? year;
  final double? prediction;
  final String? unit;
  final String? model;
  final String? error;
  
  PredictionResult({
    required this.success,
    this.year,
    this.prediction,
    this.unit,
    this.model,
    this.error,
  });
}

class ModelInfo {
  final bool success;
  final String? modelType;
  final String? modelPath;
  final List<String>? inputFeatures;
  final String? output;
  final String? yearRange;
  final String? error;
  
  ModelInfo({
    required this.success,
    this.modelType,
    this.modelPath,
    this.inputFeatures,
    this.output,
    this.yearRange,
    this.error,
  });
}