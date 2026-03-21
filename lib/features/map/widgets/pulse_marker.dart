import 'package:flutter/material.dart';

class PulseMarker extends StatefulWidget {
  final Color color;
  final Widget child;
  const PulseMarker({super.key, required this.color, required this.child});

  @override
  State<PulseMarker> createState() => _PulseMarkerState();
}

class _PulseMarkerState extends State<PulseMarker> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
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
        return Stack(
          alignment: Alignment.center,
          children: [
            ...List.generate(3, (index) {
              final val = (_controller.value + index / 3) % 1.0;
              return Container(
                width: 60 * val,
                height: 60 * val,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: widget.color.withOpacity(1.0 - val),
                    width: 2,
                  ),
                ),
              );
            }),
            widget.child,
          ],
        );
      },
    );
  }
}
