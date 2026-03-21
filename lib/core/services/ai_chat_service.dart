import 'package:ocevara/core/services/api_service.dart';
import 'package:dio/dio.dart';

class AIChatService {
  final ApiService _apiService;

  AIChatService({required ApiService apiService}) : _apiService = apiService;

  Future<String> sendMessage(
    String message, {
    Map<String, dynamic>? location,
    String? currentTime,
  }) async {
    try {
      final response = await _apiService.post('/fish/ai/chat', data: {
        'message': message,
        'location': location,
        'currentTime': currentTime,
        // i will include history to support multi-turn conversations
       

      });

      if (response.statusCode == 200) {
        return response.data['response'] ?? "I'm sorry, I couldn't process that.";
      } else {
        // Return a more specific message for backend errors
        return 'Backend error: ${response.statusCode} - ${response.statusMessage ?? 'Unknown error'}';
      }
    } on DioException catch (e) {
      if (e.response != null) {
        final data = e.response?.data;
        String? errorMessage;
        if (data is Map) {
          final error = data['error'];
          if (error is Map) {
            errorMessage = error['message']?.toString();
          } else if (error is String) {
            errorMessage = error;
          } else {
            errorMessage = data['message']?.toString();
          }
        }
        return 'Server Error (${e.response?.statusCode}): ${errorMessage ?? e.response?.statusMessage ?? 'Unknown error'}';
      }
      return 'Connection Error: Please check if the backend is running and reachable.';
    } catch (e) {
      return 'An unexpected error occurred: ${e.toString()}';
    }
  }
}
