import 'package:flutter/material.dart';
import '../services/api_service.dart';

class ResultPage extends StatelessWidget {
  const ResultPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final PredictionResult result = arguments['result'];
    final int inputYear = arguments['inputYear'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Prediction Results'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
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
                  colors: result.success 
                      ? [Colors.green[100]!, Colors.green[50]!]
                      : [Colors.red[100]!, Colors.red[50]!],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Icon(
                    result.success ? Icons.check_circle : Icons.error,
                    size: 48,
                    color: result.success ? Colors.green[700] : Colors.red[700],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    result.success ? 'Prediction Complete!' : 'Prediction Failed',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: result.success ? Colors.green[800] : Colors.red[800],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    result.success 
                        ? 'Here are your temperature change results'
                        : 'Something went wrong with the prediction',
                    style: TextStyle(
                      fontSize: 16,
                      color: result.success ? Colors.green[600] : Colors.red[600],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            if (result.success) ...[
              // Main Result Card
              Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: LinearGradient(
                      colors: [Colors.blue[600]!, Colors.blue[800]!],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.thermostat,
                          size: 64,
                          color: Colors.white,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Temperature Change Prediction',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white70,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${result.prediction?.toStringAsFixed(4)} °C',
                          style: const TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'for the year ${result.year}',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Details Card
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
                          Icon(Icons.analytics, color: Colors.blue[700]),
                          const SizedBox(width: 8),
                          const Text(
                            'Prediction Details',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildDetailRow(
                        'Input Year:', 
                        '$inputYear',
                        Icons.calendar_today,
                      ),
                      _buildDetailRow(
                        'Predicted Change:', 
                        '${result.prediction?.toStringAsFixed(6)} °C',
                        Icons.trending_up,
                      ),
                      _buildDetailRow(
                        'Model Used:', 
                        result.model ?? 'Unknown',
                        Icons.psychology,
                      ),
                      _buildDetailRow(
                        'Unit:', 
                        result.unit ?? 'degrees Celsius change',
                        Icons.straighten,
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Interpretation Card
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
                          Icon(Icons.lightbulb_outline, color: Colors.orange[700]),
                          const SizedBox(width: 8),
                          const Text(
                            'Interpretation',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildInterpretation(result.prediction ?? 0),
                    ],
                  ),
                ),
              ),
            ] else ...[
              // Error Card
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                color: Colors.red[50],
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 48,
                        color: Colors.red[700],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Error Details',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.red[800],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.red[100],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.red[300]!),
                        ),
                        child: Text(
                          result.error ?? 'Unknown error occurred',
                          style: TextStyle(
                            color: Colors.red[800],
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
            
            const SizedBox(height: 24),
            
            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[600],
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.arrow_back),
                        SizedBox(width: 8),
                        Text('Try Again'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/input',
                      (route) => false,
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.home),
                        SizedBox(width: 8),
                        Text('New Prediction'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 12),
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInterpretation(double prediction) {
    String interpretation;
    Color interpretationColor;
    IconData interpretationIcon;

    if (prediction > 1.0) {
      interpretation = 'This indicates a significant warming trend. Temperature changes above 1°C suggest substantial climate impact.';
      interpretationColor = Colors.red;
      interpretationIcon = Icons.trending_up;
    } else if (prediction > 0.5) {
      interpretation = 'This shows a moderate warming trend. The predicted temperature increase is noticeable and concerning.';
      interpretationColor = Colors.orange;
      interpretationIcon = Icons.trending_up;
    } else if (prediction > 0.0) {
      interpretation = 'This indicates a mild warming trend. Even small positive changes contribute to long-term climate patterns.';
      interpretationColor = Colors.amber;
      interpretationIcon = Icons.trending_up;
    } else if (prediction > -0.5) {
      interpretation = 'This suggests a slight cooling trend. Negative values indicate temperatures below the baseline.';
      interpretationColor = Colors.blue;
      interpretationIcon = Icons.trending_down;
    } else {
      interpretation = 'This indicates a significant cooling trend. Large negative values suggest substantial temperature decrease.';
      interpretationColor = Colors.cyan;
      interpretationIcon = Icons.trending_down;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: interpretationColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: interpretationColor.withOpacity(0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            interpretationIcon,
            color: interpretationColor,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              interpretation,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[800], // FIXED: Changed from interpretationColor.shade800
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}