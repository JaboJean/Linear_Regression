import 'package:flutter/material.dart';
import '../services/api_service.dart';

class InputPage extends StatefulWidget {
  const InputPage({Key? key}) : super(key: key);

  @override
  State<InputPage> createState() => _InputPageState();
}

class _InputPageState extends State<InputPage> {
  final TextEditingController _yearController = TextEditingController();
  bool _isLoading = false;
  bool _isConnected = false;
  ModelInfo? _modelInfo;
  String? _connectionError;

  @override
  void initState() {
    super.initState();
    _checkConnection();
    _loadModelInfo();
  }

  Future<void> _checkConnection() async {
    setState(() {
      _isLoading = true;
      _connectionError = null;
    });

    final health = await ApiService.healthCheck();
    
    setState(() {
      _isConnected = health != null;
      _isLoading = false;
      if (health == null) {
        _connectionError = 'Cannot connect to API server. Make sure your FastAPI server is running on http://127.0.0.1:8000';
      }
    });
  }

  Future<void> _loadModelInfo() async {
    final info = await ApiService.getModelInfo();
    setState(() {
      _modelInfo = info;
    });
  }

  Future<void> _predictTemperature() async {
    if (_yearController.text.isEmpty) {
      _showSnackBar('Please enter a year');
      return;
    }

    final year = int.tryParse(_yearController.text);
    if (year == null) {
      _showSnackBar('Please enter a valid year');
      return;
    }

    if (year < 1960 || year > 2030) {
      _showSnackBar('Year must be between 1960 and 2030');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final result = await ApiService.predictTemperature(year);
    
    setState(() {
      _isLoading = false;
    });

    if (result != null) {
      // Navigate to result page with the prediction data
      Navigator.pushNamed(
        context,
        '/result',
        arguments: {
          'result': result,
          'inputYear': year,
        },
      );
    } else {
      _showSnackBar('Failed to get prediction from server');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Temperature Change Prediction'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _checkConnection,
            tooltip: 'Check Connection',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header Section
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue[100]!, Colors.blue[50]!],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.thermostat,
                    size: 48,
                    color: Colors.blue[700],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Climate Change Predictor',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[800],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Predict temperature changes using machine learning',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.blue[600],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Connection Status Card
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              color: _isConnected ? Colors.green[50] : Colors.red[50],
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: _isConnected ? Colors.green : Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _isConnected ? Icons.wifi : Icons.wifi_off,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _isConnected ? 'Server Connected' : 'Server Disconnected',
                            style: TextStyle(
                              color: _isConnected ? Colors.green[800] : Colors.red[800],
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          if (!_isConnected && _connectionError != null)
                            Text(
                              _connectionError!,
                              style: TextStyle(
                                color: Colors.red[600],
                                fontSize: 12,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Model Info Card
            if (_modelInfo != null && _modelInfo!.success) ...[
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.smart_toy, color: Colors.blue[700]),
                          const SizedBox(width: 8),
                          const Text(
                            'Model Information',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _buildInfoRow('Model Type:', _modelInfo!.modelType ?? 'Unknown'),
                      _buildInfoRow('Year Range:', _modelInfo!.yearRange ?? 'Unknown'),
                      _buildInfoRow('Output:', _modelInfo!.output ?? 'Unknown'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
            
            // Input Section
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.input, color: Colors.blue[700]),
                        const SizedBox(width: 8),
                        const Text(
                          'Enter Prediction Year',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _yearController,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(fontSize: 18),
                      decoration: InputDecoration(
                        labelText: 'Year',
                        hintText: 'Enter year (1960-2030)',
                        prefixIcon: const Icon(Icons.calendar_today),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Colors.blue, width: 2),
                        ),
                        helperText: 'Valid range: 1960 - 2030',
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _isConnected && !_isLoading ? _predictTemperature : null,
                        child: _isLoading
                            ? const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  ),
                                  SizedBox(width: 12),
                                  Text('Predicting...'),
                                ],
                              )
                            : const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.analytics),
                                  SizedBox(width: 8),
                                  Text(
                                    'Predict Temperature Change',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Instructions Card
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.orange[700]),
                        const SizedBox(width: 8),
                        const Text(
                          'How to Use',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildInstructionStep('1', 'Ensure your FastAPI server is running'),
                    _buildInstructionStep('2', 'Enter a year between 1960 and 2030'),
                    _buildInstructionStep('3', 'Click "Predict Temperature Change"'),
                    _buildInstructionStep('4', 'View results on the next page'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 90,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInstructionStep(String number, String instruction) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: Colors.orange[100],
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                number,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange[700],
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              instruction,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _yearController.dispose();
    super.dispose();
  }
}