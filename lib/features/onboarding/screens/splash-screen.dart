import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' as math;
import 'package:ocevara/features/onboarding/screens/onboarding-screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ocevara/core/services/auth_service.dart';
import 'package:ocevara/features/home/screens/home_screen.dart';
import 'package:ocevara/features/catch_log/services/catch_log_service.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _waveController;
  late final AnimationController _logoController;
  late final AnimationController _textController;

  @override
  void initState() {
    super.initState();

    _waveController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 3000));
    _logoController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 2500));
    _textController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1500));

    // Start wave loop
    _waveController.repeat();

    // Start sequence
    _logoController.forward();
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) _textController.forward();
    });

    // Navigate to Onboarding or Home
    Future.delayed(const Duration(milliseconds: 3000), () async {
      if (mounted) {
        final authService = ref.read(authServiceProvider);
        final user = await authService.getCurrentUser();
        
        if (mounted) {
          if (user != null) {
            ref.read(userProvider.notifier).state = user;
            
            // Critical fix: load the user's logs from the database immediately
            // so CatchLogService is ready when the Home screen opens.
            try {
              final catchLogService = ref.read(catchLogServiceProvider.notifier);
              await catchLogService.loadUserLogs(user.id);
            } catch (e) {
              debugPrint('Error loading logs on startup: $e');
            }

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            );
          } else {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const OnboardingScreen()),
            );
          }
        }
      }
    });
  }

  @override
  void dispose() {
    _waveController.dispose();
    _logoController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF0F6072), // Darker teal at top
                  Color(0xFF1CB5AC), // Lighter teal at bottom
                ],
              ),
            ),
          ),

          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: 200, // Height for waves
            child: AnimatedBuilder(
                animation: _waveController,
                builder: (context, child) {
                  return CustomPaint(
                    painter: WavePainter(
                        animationValue: _waveController.value,
                        color: Colors.white.withOpacity(0.1)),
                    size: Size.infinite,
                  );
                }),
          ),
           Positioned(
            bottom: -20,
            left: 0,
            right: 0,
            height: 220, // Height for second wave layer
            child: AnimatedBuilder(
                animation: _waveController,
                builder: (context, child) {
                  return CustomPaint(
                    painter: WavePainter(
                        animationValue: _waveController.value,
                         offset: 0.5, // Phase shift
                         waveCount: 3,
                        color: Colors.white.withOpacity(0.05)),
                    size: Size.infinite,
                  );
                }),
          ),


          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo Animation
                FadeTransition(
                  opacity: _logoController,
                  child: ScaleTransition(
                    scale: Tween<double>(begin: 0.0, end: 2.2).animate(
                      CurvedAnimation(
                        parent: _logoController,
                        curve: Curves.easeInOutCubic,
                      ),
                    ),
                    child: SizedBox(
                      width: 299, // Adjust size as needed
                      height: 247,
                      child: Image.asset('assets/images/splashscreen.png'),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Text Animation
                SlideTransition(
                  position: Tween<Offset>(
                          begin: const Offset(0, 0.5), end: Offset.zero)
                      .animate(CurvedAnimation(
                          parent: _textController, curve: Curves.easeOut)),
                  child: FadeTransition(
                    opacity: _textController,
                    child: Column(
                      children: [
                        Text(
                          'ocevara',
                          style: GoogleFonts.playfairDisplay(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF002824), // Dark text color from image
                            letterSpacing: 4.0,
                          ),
                        ),
                        const SizedBox(height: 10),
                         Padding(
                           padding: const EdgeInsets.symmetric(horizontal: 40.0),
                           child: Text(
                            'Protecting life below the water, one responsible catch at a time',
                             textAlign: TextAlign.center,
                            style: GoogleFonts.lato( // using Lato as secondary
                              fontSize: 14,
                              color: Colors.white.withOpacity(0.9),
                              height: 1.4,
                            ),
                                                   ),
                         ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class WavePainter extends CustomPainter {
  final double animationValue;
  final Color color;
  final double offset; // to shift waves
  final int waveCount;

  WavePainter({required this.animationValue, required this.color, this.offset = 0.0, this.waveCount = 2});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final path = Path();
    
    // Draw waves
    // Simple sine wave logic + animation shift
    // y = A * sin(kx - wt)
    
    for (double x = 0; x <= size.width; x++) {
      // Calculate y based on sine wave
       // Amplitude 
      double y =  20 * math.sin((x / size.width * math.pi * waveCount) + (animationValue * 2 * math.pi) + (offset * math.pi));
      
      // Center vertical
      y += size.height / 2;
      
      if (x == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant WavePainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}

