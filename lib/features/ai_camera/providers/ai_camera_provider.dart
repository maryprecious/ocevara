import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ocevara/core/services/api_service.dart';
import 'package:ocevara/core/services/ai_camera_service.dart';
import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';

final aiCameraServiceProvider = Provider<AICameraService>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  final service = AICameraService(apiService);
  ref.onDispose(() => service.dispose());
  return service;
});

final fishDetectionProvider = FutureProvider.family<List<ImageLabel>, String>((ref, imagePath) async {
  final service = ref.watch(aiCameraServiceProvider);
  return await service.detectFish(imagePath);
});
