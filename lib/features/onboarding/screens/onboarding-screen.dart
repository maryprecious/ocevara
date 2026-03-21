import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' as math;
import 'package:ocevara/features/auth/screens/signup-screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingContent> _contents = [
    OnboardingContent(
      image: 'assets/images/firstlineinside.png',
      secondaryImage: 'assets/images/secondline.png',
      title: 'Oceans Worth Protecting',
      description:
          'Every species plays a role in our marine ecosystem. Our app encourages sustainable fishing practices that prevent overexploitation and protect ocean wildlife for the future',
      scale: 0.85,
      alignment: Alignment.topLeft,
      opacity: 0.55,
    ),
    OnboardingContent(
      image: 'assets/images/fisherman01.png',
      title: 'Your Partner in Sustainable Fishing',
      description:
          'From species alerts to compliance support, we help you reduce risks, avoid penalties, and build a long-term, sustainable fishing business.',
      scale: 1.0, // zoom in to show one person
      alignment: const Alignment(
        1.3,
        0,
      ), // pushed image further right to hide the blue person on the left
      opacity: 0.5,
    ),
    OnboardingContent(
      image: 'assets/images/fisherman01.png',
      title: 'Offline, But Still Connected',
      description:
          'Download essential resources and catch regulations so you can fish responsibly and stay informed, even when you’re at sea, or away from internet connectivity.',
      scale: 1.1, // slightly zoomed out so full body is visible
      alignment: const Alignment(
        -1.5,
        -0,
      ), // shifted image to right-bottom so legs are visible 
      opacity: 0.55,
      blendMode: BlendMode.srcOver,
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _contents.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // navigate to signupScreen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const SignupScreen()),
      );
    }
  }

  void _skip() {
    _pageController.animateToPage(
      _contents.length - 1,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF0F6072), // dark Teal
                    Color(0xFF1CB5AC), // light Teal
                  ],
                ),
              ),
            ),
          ),

          Positioned.fill(child: WaveLayer(currentPage: _currentPage)),

          Positioned.fill(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              child: _contents[_currentPage].secondaryImage != null
                  ? Stack(
                      key: ValueKey(_contents[_currentPage].image),
                      children: [
                        // bottom Layer (first line)
                        Positioned(
                          left: -50,
                          top: 0,
                          bottom: 200, // constrain bottom to keep it upper
                          width: 400,
                          child: Opacity(
                            // i used content opacity as base and slightly reduce for bottom layer
                            opacity: (_contents[_currentPage].opacity) * 0.75,
                            child: Image.asset(
                              _contents[_currentPage].image!,
                              fit: BoxFit.contain,
                              alignment: Alignment.topLeft,
                            ),
                          ),
                        ),
                        // top layer (second line)
                        Positioned(
                          left: -50,
                          top: 0,
                          bottom: 200,
                          width: 400,
                          child: Opacity(
                            // top layer slightly stronger but still semi-transparent
                            opacity: (_contents[_currentPage].opacity) * 0.9,
                            child: Image.asset(
                              _contents[_currentPage].secondaryImage!,
                              fit: BoxFit.contain,
                              alignment: Alignment.topLeft,
                            ),
                          ),
                        ),
                      ],
                    )
                  : (_contents[_currentPage].image != null
                        ? Opacity(
                            key: ValueKey(
                              _contents[_currentPage].image,
                            ), // Key for animation
                            opacity: _contents[_currentPage].opacity,
                            child: Transform.scale(
                              scale: _contents[_currentPage].scale,
                              child: Image.asset(
                                _contents[_currentPage].image!,
                                width: double.infinity,
                                height: double.infinity,
                                fit: BoxFit.cover,
                                alignment: _contents[_currentPage].alignment,
                                color:
                                    _contents[_currentPage].blendMode !=
                                        BlendMode.srcOver
                                    ? Colors.black.withOpacity(
                                        0.3,
                                      ) // Apply a dark tint if blending
                                    : null,
                                colorBlendMode:
                                    _contents[_currentPage].blendMode,
                              ),
                            ),
                          )
                        : const SizedBox()),
            ),
          ),

          Positioned.fill(
            child: CustomPaint(painter: BackgroundSwirlPainter()),
          ),

          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemCount: _contents.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(40.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(flex: 2),
                    // text Area
                    Text(
                      _contents[index].title,
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          const Shadow(
                            blurRadius: 10.0,
                            color: Colors.black26,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      _contents[index].description,
                      style: GoogleFonts.lato(
                        fontSize: 16,
                        color: Colors.white.withOpacity(0.9),
                        height: 1.5,
                        shadows: [
                          const Shadow(
                            blurRadius: 5.0,
                            color: Colors.black26,
                            offset: Offset(0, 1),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const Spacer(),
                  ],
                ),
              );
            },
          ),

          Positioned(
            bottom: 40,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Skip Button
                TextButton(
                  onPressed: _skip,
                  style: TextButton.styleFrom(
                    backgroundColor: const Color(0xFF003840).withOpacity(0.3),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    'Skip',
                    style: GoogleFonts.lato(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                // Dots Indicator
                Row(
                  children: List.generate(
                    _contents.length,
                    (index) => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      height: 10,
                      width: _currentPage == index ? 20 : 10,
                      decoration: BoxDecoration(
                        color: _currentPage == index
                            ? Colors.white
                            : Colors.white.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                ),

                // Next Button (use app accent color)
                ElevatedButton(
                  onPressed: _nextPage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1CB5AC),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                  child: Text(
                    _currentPage == _contents.length - 1
                        ? 'Get Started'
                        : 'Next',
                    style: GoogleFonts.lato(fontWeight: FontWeight.bold),
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

class OnboardingContent {
  final String? image;
  final String? secondaryImage; // New field for layered image
  final String title;
  final String description;
  final double scale;
  final Alignment alignment;
  final double opacity;
  final BlendMode blendMode;

  OnboardingContent({
    this.image,
    this.secondaryImage,
    required this.title,
    required this.description,
    this.scale = 1.0,
    this.alignment = Alignment.center,
    this.opacity = 1.0,
    this.blendMode = BlendMode.srcOver,
  });
}

class BackgroundSwirlPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.05)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final path = Path();

    // Abstract swirls - simplified visualization
    path.moveTo(0, size.height * 0.7);
    path.quadraticBezierTo(
      size.width * 0.5,
      size.height * 0.6,
      size.width,
      size.height * 0.8,
    );
    path.moveTo(0, size.height * 0.8);
    path.quadraticBezierTo(
      size.width * 0.5,
      size.height * 0.7,
      size.width,
      size.height * 0.9,
    );

    canvas.drawPath(path, paint);

    // Top swirl
    final paintFill = Paint()
      ..color = Colors.white.withOpacity(0.03)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(size.width * 0.8, size.height * 0.1),
      100,
      paintFill,
    );
    canvas.drawCircle(
      Offset(size.width * 0.1, size.height * 0.5),
      150,
      paintFill,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Wave animation layer used on onboarding screens
class WaveLayer extends StatelessWidget {
  final int currentPage;
  const WaveLayer({super.key, required this.currentPage});

  @override
  Widget build(BuildContext context) {
    // Page 0: small bottom wave like splash; pages 1 & 2: full-screen wave
    if (currentPage == 0) {
      return Align(
        alignment: Alignment.bottomCenter,
        child: SizedBox(
          height: 220,
          child: AnimatedWaves(
            color: const Color(0xFF1CB5AC).withOpacity(0.18),
            secondaryColor: const Color(0xFF0F3950).withOpacity(0.08),
            speed: 1.0,
            amplitude: 16,
            waveCount: 2,
            fullScreen: false,
          ),
        ),
      );
    }

    return const Positioned.fill(
      child: AnimatedWaves(
        color: Color(0xFF1CB5AC),
        secondaryColor: Color(0xFF0F3950),
        speed: 0.6,
        amplitude: 40,
        waveCount: 3,
        fullScreen: true,
      ),
    );
  }
}

class AnimatedWaves extends StatefulWidget {
  final Color color;
  final Color secondaryColor;
  final double speed;
  final double amplitude;
  final int waveCount;
  final bool fullScreen;

  const AnimatedWaves({
    super.key,
    required this.color,
    required this.secondaryColor,
    this.speed = 1.0,
    this.amplitude = 20.0,
    this.waveCount = 2,
    this.fullScreen = false,
  });

  @override
  State<AnimatedWaves> createState() => _AnimatedWavesState();
}

class _AnimatedWavesState extends State<AnimatedWaves>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: _WavesPainter(
            progress: _controller.value,
            color: widget.color,
            secondaryColor: widget.secondaryColor,
            amplitude: widget.amplitude,
            waveCount: widget.waveCount,
            fullScreen: widget.fullScreen,
          ),
        );
      },
    );
  }
}

class _WavesPainter extends CustomPainter {
  final double progress;
  final Color color;
  final Color secondaryColor;
  final double amplitude;
  final int waveCount;
  final bool fullScreen;

  _WavesPainter({
    required this.progress,
    required this.color,
    required this.secondaryColor,
    required this.amplitude,
    required this.waveCount,
    required this.fullScreen,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    final path = Path();

    // draw primary wave
    path.moveTo(0, size.height);
    for (double x = 0; x <= size.width; x++) {
      final double normX = x / size.width;
      final double y =
          _waveY(normX, size) + (fullScreen ? 0 : size.height * 0.1);
      path.lineTo(x, y);
    }
    path.lineTo(size.width, size.height);
    path.close();

    paint.color = color;
    canvas.drawPath(path, paint..color = color.withOpacity(0.16));

    // secondary wave overlay
    final path2 = Path();
    path2.moveTo(0, size.height);
    for (double x = 0; x <= size.width; x++) {
      final double normX = x / size.width;
      final double y =
          _waveY(normX, size, phaseOffset: 1.5) +
          (fullScreen ? size.height * 0.02 : size.height * 0.08);
      path2.lineTo(x, y);
    }
    path2.lineTo(size.width, size.height);
    path2.close();
    canvas.drawPath(path2, paint..color = secondaryColor.withOpacity(0.12));
  }

  double _waveY(double x, Size size, {double phaseOffset = 0.0}) {
    final double freq = 2.0 + waveCount; // frequency depends on waveCount
    final double phase =
        (progress * 2 * math.pi * (0.5 + waveCount * 0.3)) + phaseOffset;
    final double sine = math.sin((x * freq * 2 * math.pi) + phase);
    final double base = fullScreen ? size.height * 0.45 : size.height * 0.6;
    return base + sine * amplitude;
  }

  @override
  bool shouldRepaint(covariant _WavesPainter oldDelegate) =>
      oldDelegate.progress != progress;
}

