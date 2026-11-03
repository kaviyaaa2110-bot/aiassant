import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Immersive futuristic dark background with animated neon ambient glows & cyber grid
class FuturisticBackground extends StatefulWidget {
  final Widget child;
  final bool showGrid;

  const FuturisticBackground({
    super.key,
    required this.child,
    this.showGrid = true,
  });

  @override
  State<FuturisticBackground> createState() => _FuturisticBackgroundState();
}

class _FuturisticBackgroundState extends State<FuturisticBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Stack(
      children: [
        // Base dark navy/black gradient
        Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: AppColors.darkBackgroundGradient,
          ),
        ),

        // Animated Ambient Glowing Radial Orbs
        AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            final t = _controller.value;
            final cyanOffset = Offset(
              size.width * (0.8 + 0.1 * math.sin(t * math.pi)),
              size.height * (0.15 + 0.08 * math.cos(t * math.pi)),
            );
            final blueOffset = Offset(
              size.width * (0.15 - 0.08 * math.cos(t * math.pi)),
              size.height * (0.55 + 0.1 * math.sin(t * math.pi)),
            );
            final purpleOffset = Offset(
              size.width * (0.75 + 0.08 * math.sin(t * 2 * math.pi)),
              size.height * (0.85 - 0.08 * math.cos(t * math.pi)),
            );

            return Stack(
              children: [
                // Cyan Glow Orb (Top Right)
                Positioned(
                  left: cyanOffset.dx - 180,
                  top: cyanOffset.dy - 180,
                  child: Container(
                    width: 360,
                    height: 360,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          AppColors.cyanNeon.withValues(alpha: 0.16),
                          AppColors.cyanNeon.withValues(alpha: 0.05),
                          Colors.transparent,
                        ],
                        stops: const [0.0, 0.45, 1.0],
                      ),
                    ),
                  ),
                ),

                // Electric Blue Glow Orb (Mid-Left)
                Positioned(
                  left: blueOffset.dx - 220,
                  top: blueOffset.dy - 220,
                  child: Container(
                    width: 440,
                    height: 440,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          AppColors.electricBlue.withValues(alpha: 0.18),
                          AppColors.electricBlue.withValues(alpha: 0.04),
                          Colors.transparent,
                        ],
                        stops: const [0.0, 0.5, 1.0],
                      ),
                    ),
                  ),
                ),

                // Cyber Purple / Magenta Glow Orb (Bottom Right)
                Positioned(
                  left: purpleOffset.dx - 200,
                  top: purpleOffset.dy - 200,
                  child: Container(
                    width: 400,
                    height: 400,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          AppColors.cyberPurple.withValues(alpha: 0.14),
                          AppColors.neonPink.withValues(alpha: 0.04),
                          Colors.transparent,
                        ],
                        stops: const [0.0, 0.45, 1.0],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),

        // Subtle Cyber Grid Overlay
        if (widget.showGrid)
          Positioned.fill(
            child: IgnorePointer(
              child: CustomPaint(
                painter: _CyberGridPainter(),
              ),
            ),
          ),

        // Foreground Content
        widget.child,
      ],
    );
  }
}

class _CyberGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF00F0FF).withValues(alpha: 0.025)
      ..strokeWidth = 1.0;

    const step = 44.0;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }

    // Subtle corner telemetry crosshairs
    final crossPaint = Paint()
      ..color = const Color(0xFF00F0FF).withValues(alpha: 0.08)
      ..strokeWidth = 1.2;

    _drawCrosshair(canvas, const Offset(24, 60), crossPaint);
    _drawCrosshair(canvas, Offset(size.width - 24, 60), crossPaint);
  }

  void _drawCrosshair(Canvas canvas, Offset center, Paint paint) {
    const len = 8.0;
    canvas.drawLine(
        Offset(center.dx - len, center.dy), Offset(center.dx + len, center.dy), paint);
    canvas.drawLine(
        Offset(center.dx, center.dy - len), Offset(center.dx, center.dy + len), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
