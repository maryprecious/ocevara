import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';
import 'package:ocevara/core/services/api_service.dart';

class AICameraService {
  late ImageLabeler _labeler;
  final ApiService _apiService;

  AICameraService(this._apiService) {
    // Initialize the labeler with default options
    _labeler = ImageLabeler(options: ImageLabelerOptions());
  }

  Future<List<ImageLabel>> detectFish(String imagePath) async {
    final inputImage = InputImage.fromFilePath(imagePath);
    final labels = await _labeler.processImage(inputImage);
    
 
    return labels.where((label) => label.confidence > 0.6).toList();
  }

  
  Future<Map<String, dynamic>> identifyFish(Uint8List bytes) async {
    try {
      final base64Image = base64Encode(bytes);

      final response = await _apiService.post('/fish/ai/scan', data: {
        'image': base64Image,
      });

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to identify: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('AI Identification failed: $e');
    }
  }

  void dispose() {
    _labeler.close();
  }
}
