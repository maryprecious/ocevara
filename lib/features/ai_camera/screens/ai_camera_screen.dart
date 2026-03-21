import 'package:camera/camera.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ocevara/core/theme/app_colors.dart';
import 'package:ocevara/features/ai_camera/providers/ai_camera_provider.dart';
import 'package:ocevara/features/catch_log/widgets/add_catch_form.dart';

class AICameraScreen extends ConsumerStatefulWidget {
  const AICameraScreen({super.key});

  @override
  ConsumerState<AICameraScreen> createState() => _AICameraScreenState();
}

class _AICameraScreenState extends ConsumerState<AICameraScreen> {
  CameraController? _controller;
  bool _isProcessing = false;
  String? _detectedLabel;
  bool _isSafeToFish = true;
  String? _detectedFact;
  bool _isFish = true;
  Uint8List? _lastSnappedImage;
  bool _isSnapping = false;
  bool _showResultOverlay = false;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    final cameras = await availableCameras();
    if (cameras.isEmpty) return;

    _controller = CameraController(
      cameras[0],
      ResolutionPreset.high, 
      enableAudio: false,
    );

    await _controller!.initialize();
    if (!mounted) return;
    setState(() {});

    if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
      _controller!.startImageStream((image) {
        if (_isProcessing) return;
        _processImage(image);
      });
    }
  }

  Future<void> _processImage(CameraImage image) async {
    _isProcessing = true;
    
    
    await Future.delayed(const Duration(milliseconds: 1500));
    if (mounted && _detectedLabel == null) {
      setState(() {
        _detectedLabel = 'Scanning for species...';
      });
    }
    _isProcessing = false;
  }

  /// this takes a still photo and identifies it using Gemini Vision via the backend.
  Future<void> _snapAndIdentify() async {
    if (_controller == null || !_controller!.value.isInitialized) return;
    setState(() => _isSnapping = true);
    
    try {
      if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
        await _controller!.stopImageStream();
      }
      final file = await _controller!.takePicture();

      final service = ref.read(aiCameraServiceProvider);
      final bytes = await file.readAsBytes();
      _lastSnappedImage = bytes; // Save for logging
      final result = await service.identifyFish(bytes);

      if (mounted) {
        setState(() {
          final commonName = result['commonName'] ?? 'Unknown';
          final scientificName = result['scientificName'] ?? '';
          final confidence = ((result['confidence'] ?? 0.0) * 100).toInt();
          final isSafe = result['isSafeToFish'] ?? true;
          final fact = result['fact'] ?? '';
          final isFish = result['isFish'] ?? true;

          _detectedLabel = '$commonName ${scientificName.isNotEmpty ? "($scientificName)" : ""} - $confidence%';
          _isSafeToFish = isSafe;
          _detectedFact = fact;
          _isFish = isFish;
          _showResultOverlay = true; // Show the persistent overlay
        });
      }

      if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
        _controller!.startImageStream((image) {
          if (_isProcessing) return;
          _processImage(image);
        });
      }
    } catch (e) {
      debugPrint('Snap error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error identifying fish: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSnapping = false);
    }
  }

  /// Opens the Add Catch form pre-filled with the detected fish name.
  void _logCatch() {
    if (_detectedLabel != null) {
      showAddCatchDialog(
        context,
        initialSpecies: _detectedLabel!.split('-')[0].trim(), // Updated split logic
        initialImage: _lastSnappedImage,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Point the camera at a fish first!'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null || !_controller!.value.isInitialized) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator(color: Colors.white)),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      // no AppBar here just true full-screen camera experience
      body: Stack(
        fit: StackFit.expand, 
        children: [
     
          _FullScreenCamera(controller: _controller!),

          
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            left: 20,
            right: 60, 
            child: Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              decoration: BoxDecoration(
                color: AppColors.navy.withOpacity(0.85),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: AppColors.accentBlue, width: 1.5),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.psychology, color: Colors.white, size: 18),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      _detectedLabel ?? 
                      (!kIsWeb && (Platform.isAndroid || Platform.isIOS) 
                        ? 'Scanning for species and objects...' 
                        : 'Tap Snap & ID to identify objects/fish'),
                      style: GoogleFonts.lato(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),

          
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            right: 8,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white, size: 28),
              onPressed: () => Navigator.pop(context),
            ),
          ),

        
          Positioned(
            bottom: MediaQuery.of(context).padding.bottom + 24,
            left: 20,
            right: 20,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // Snap & Identify
                    _buildControlButton(
                      icon: _isSnapping
                          ? Icons.hourglass_top
                          : Icons.camera_alt,
                      label: 'Snap & ID',
                      onTap: _isSnapping ? null : _snapAndIdentify,
                    ),

                    // log Catch the primary large button
                    Column(
                      children: [
                        GestureDetector(
                          onTap: _logCatch,
                          child: Container(
                            padding: const EdgeInsets.all(22),
                            decoration: BoxDecoration(
                              color: AppColors.accentBlue,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      AppColors.accentBlue.withOpacity(0.45),
                                  blurRadius: 24,
                                  spreadRadius: 6,
                                ),
                              ],
                            ),
                            child: const Icon(Icons.add,
                                color: Colors.white, size: 34),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Log Catch',
                          style: GoogleFonts.lato(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),

                    // torch or th flash placeholder
                    _buildControlButton(
                      icon: Icons.flash_auto,
                      label: 'Flash',
                      onTap: () async {
                        try {
                          await _controller!.setFlashMode(
                            _controller!.value.flashMode == FlashMode.off
                                ? FlashMode.torch
                                : FlashMode.off,
                          );
                          setState(() {});
                        } catch (_) {}
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  'Point camera at fish • tap + to log catch',
                  style: GoogleFonts.lato(
                      color: Colors.white70, fontSize: 12),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          // Persistent AI Result Overlay
          if (_showResultOverlay)
            Positioned(
              bottom: MediaQuery.of(context).padding.bottom + 100,
              left: 20,
              right: 20,
              child: GestureDetector(
                onTap: () {
                  setState(() => _showResultOverlay = false);
                },
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F3950).withOpacity(0.95),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.accentBlue, width: 1),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                _isFish ? Icons.set_meal : Icons.inventory_2,
                                color: Colors.white,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                _isFish ? 'Identified Fish' : 'Identified Object',
                                style: GoogleFonts.lato(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          const Icon(Icons.close, color: Colors.white70, size: 20),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _detectedLabel ?? 'Unknown',
                        style: GoogleFonts.lato(
                          color: AppColors.primaryTeal,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      if (!_isFish) ...[
                        const SizedBox(height: 8),
                        Text(
                          'Note: This is not a fish. Logging this catch may not be necessary.',
                          style: GoogleFonts.lato(
                            color: Colors.orangeAccent,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                      if (_detectedFact != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          _detectedFact!,
                          style: GoogleFonts.lato(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 14,
                            height: 1.4,
                          ),
                        ),
                      ],
                      if (_isFish) ...[
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: _isSafeToFish ? Colors.green.withOpacity(0.2) : Colors.red.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: _isSafeToFish ? Colors.greenAccent : Colors.redAccent,
                              width: 0.5,
                            ),
                          ),
                          child: Text(
                            _isSafeToFish ? '✅ SAFE TO FISH' : '❌ NOT SAFE TO FISH',
                            style: GoogleFonts.lato(
                              color: _isSafeToFish ? Colors.greenAccent : Colors.redAccent,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                      const SizedBox(height: 12),
                      Text(
                        'Tap to dismiss, or log catch below',
                        style: GoogleFonts.lato(
                          color: Colors.white54,
                          fontSize: 11,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required String label,
    VoidCallback? onTap,
  }) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(40),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.18),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 22),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: GoogleFonts.lato(color: Colors.white, fontSize: 11),
        ),
      ],
    );
  }
}


class _FullScreenCamera extends StatelessWidget {
  final CameraController controller;
  const _FullScreenCamera({required this.controller});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final previewAspect = controller.value.aspectRatio;

    
    var scale = size.aspectRatio * previewAspect;
    if (scale < 1) scale = 1 / scale;

    return Transform.scale(
      scale: scale,
      child: Center(child: CameraPreview(controller)),
    );
  }
}
