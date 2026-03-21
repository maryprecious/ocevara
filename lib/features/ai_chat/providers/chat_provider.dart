import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ocevara/core/services/ai_chat_service.dart';
import 'package:ocevara/core/services/api_service.dart';
import 'package:ocevara/core/services/location_service.dart';
import 'package:intl/intl.dart';
import 'package:ocevara/core/services/local_chat_service.dart';

final localChatServiceProvider = Provider((ref) => LocalChatService());

final aiChatServiceProvider = Provider<AIChatService>((ref) {
  final apiService = ref.read(apiServiceProvider);
  return AIChatService(apiService: apiService);
});

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({required this.text, required this.isUser, DateTime? timestamp})
      : timestamp = timestamp ?? DateTime.now();
}

class ChatNotifier extends StateNotifier<List<ChatMessage>> {
  final AIChatService _chatService;
  final LocationService _locationService;
  final LocalChatService _localService;

  ChatNotifier(this._chatService, this._locationService, this._localService)
      : super([
          ChatMessage(
            text:
                "Hello! I'm Ocevara AI 🐟\n\nI can help you with fishing tips, fish farming, ocean life, water safety, and how to use this app. What would you like to know?",
            isUser: false,
          )
        ]);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> sendMessage(String text, {DateTime? customDateTime}) async {
    if (_isLoading) return;

    final userMsg = ChatMessage(text: text, isUser: true);
    state = [...state, userMsg];
    _isLoading = true;

    final typingMsg = ChatMessage(text: '...', isUser: false);
    state = [...state, typingMsg];

    try {
      Map<String, dynamic>? locationContext;
      try {
        final position = await _locationService.getCurrentLocation().timeout(
          const Duration(seconds: 3),
        );
        locationContext = {
          'lat': position.latitude,
          'lng': position.longitude,
          'name': 'Live Location',
        };
      } catch (e) {
        // Location failed or timed out, proceed without it
        print('Location fetch failed or timed out: $e');
      }

      final timeContext = DateFormat('yyyy-MM-dd HH:mm').format(customDateTime ?? DateTime.now());

      String response;
      try {
        response = await _chatService.sendMessage(
          text,
          location: locationContext,
          currentTime: timeContext,
        );
        
        // If the response contains "Server Error" or "Backend error", trigger fallback
        if (response.contains('Server Error') || response.contains('Backend error') || response.contains('Connection Error')) {
           throw Exception('Server unavailable');
        }
      } catch (e) {
        print('AI Server failed, using local fallback: $e');
        response = _localService.getResponse(text);
      }

      // i will replace typing indicator with real response
      state = [
        ...state.where((m) => m != typingMsg),
        ChatMessage(text: response, isUser: false),
      ];
    } catch (e) {
      state = [
        ...state.where((m) => m != typingMsg),
        ChatMessage(
          text: _localService.getResponse(text), // i will use local even on hard failure
          isUser: false,
        ),
      ];
    } finally {
      _isLoading = false;
    }
  }
}

final chatProvider =
    StateNotifierProvider<ChatNotifier, List<ChatMessage>>((ref) {
  final service = ref.watch(aiChatServiceProvider);
  final locationService = ref.watch(locationServiceProvider);
  final localService = ref.watch(localChatServiceProvider);
  return ChatNotifier(service, locationService, localService);
});
