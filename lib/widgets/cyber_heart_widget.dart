import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// A premium, futuristic animated AI Heart illustration with biometric radar rings,
/// neural circuitry, animated ECG waveform, and glowing pulse effects.
class CyberHeartWidget extends StatefulWidget {
  final double size;
  final bool showTelemetryBadge;
  final int bpm;

  const CyberHeartWidget({
    super.key,
    this.size = 220,
    this.showTelemetryBadge = true,
    this.bpm = 72,
  });

  @override
  State<CyberHeartWidget> createState() => _CyberHeartWidgetState();
}

class _CyberHeartWidgetState extends State<CyberHeartWidget>
    with TickerProviderStateMixin {
  // Continuous rotation for outer telemetry ring
  late AnimationController _rotationController;

  // Cardiac heartbeat pulse (lub-dub cycle)
  late AnimationController _heartbeatController;
  late Animation<double> _pulseScale;

  // ECG scanning wave animation
  late AnimationController _ecgController;

  @override
  void initState() {
    super.initState();

    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 14),
    )..repeat();

    // Natural 72 BPM cardiac rhythm: ~830ms per beat
    _heartbeatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();

    // Sequence for lub-dub pulse:
    _pulseScale = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 1.08)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 15,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.08, end: 1.02)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 12,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.02, end: 1.11)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 18,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.11, end: 1.0)
            .chain(CurveTween(curve: Curves.easeInCubic)),
        weight: 25,
      ),
      TweenSequenceItem(
        tween: ConstantTween<double>(1.0),
        weight: 30,
      ),
    ]).animate(_heartbeatController);

    _ecgController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat();
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _heartbeatController.dispose();
    _ecgController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.size;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: s,
          height: s,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // 1. Outermost Ambient Halo Glow
              AnimatedBuilder(
                animation: _pulseScale,
                builder: (context, _) {
                  return Container(
                    width: s * 0.88 * _pulseScale.value,
                    height: s * 0.88 * _pulseScale.value,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.cyanNeon.withValues(alpha: 0.28),
                          blurRadius: 40,
                          spreadRadius: 4,
                        ),
                        BoxShadow(
                          color: AppColors.electricBlue.withValues(alpha: 0.22),
                          blurRadius: 60,
                          spreadRadius: 10,
                        ),
                      ],
                    ),
                  );
                },
              ),

              // 2. Rotating Biometric Radar & Telemetry Rings
              AnimatedBuilder(
                animation: _rotationController,
                builder: (context, _) {
                  return CustomPaint(
                    size: Size(s, s),
                    painter: _TelemetryRingsPainter(
                      rotationAngle: _rotationController.value * 2 * math.pi,
                    ),
                  );
                },
              ),

              // 3. Pulsing Core & Cyber Heart Mesh
              AnimatedBuilder(
                animation: Listenable.merge([_pulseScale, _ecgController]),
                builder: (context, _) {
                  return Transform.scale(
                    scale: _pulseScale.value,
                    child: CustomPaint(
                      size: Size(s * 0.72, s * 0.72),
                      painter: _CyberHeartPainter(
                        ecgProgress: _ecgController.value,
                        pulseIntensity: (_pulseScale.value - 1.0) / 0.11,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),

        // 4. Biometric AI Telemetry Badge
        if (widget.showTelemetryBadge) ...[
          const SizedBox(height: 14),
          _buildTelemetryBadge(),
        ],
      ],
    );
  }

  Widget _buildTelemetryBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.bgElevated.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.cyanNeon.withValues(alpha: 0.35),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.cyanNeon.withValues(alpha: 0.12),
            blurRadius: 12,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Glowing status pulse dot
          AnimatedBuilder(
            animation: _heartbeatController,
            builder: (context, _) {
              final active = _heartbeatController.value < 0.4;
              return Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: active ? AppColors.neonTeal : AppColors.cyanNeon,
                  boxShadow: [
                    BoxShadow(
                      color: (active ? AppColors.neonTeal : AppColors.cyanNeon)
                          .withValues(alpha: 0.8),
                      blurRadius: active ? 8 : 4,
                      spreadRadius: active ? 2 : 0,
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(width: 8),
          Text(
            'NEURAL BIOMETRICS',
            style: TextStyle(
              color: AppColors.cyanNeon,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.5,
            ),
          ),
          Container(
            height: 10,
            width: 1,
            color: AppColors.cyanNeon.withValues(alpha: 0.3),
            margin: const EdgeInsets.symmetric(horizontal: 8),
          ),
          Text(
            '${widget.bpm} BPM',
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.8,
            ),
          ),
        ],
      ),
    );
  }
}

/// Painter for the rotating holographic radar rings with cyber tick marks
class _TelemetryRingsPainter extends CustomPainter {
  final double rotationAngle;

  _TelemetryRingsPainter({required this.rotationAngle});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 6;

    // Outermost subtle track
    final outerTrackPaint = Paint()
      ..color = AppColors.cyanNeon.withValues(alpha: 0.12)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    canvas.drawCircle(center, radius, outerTrackPaint);

    // Inner concentric ring
    final innerTrackPaint = Paint()
      ..color = AppColors.electricBlue.withValues(alpha: 0.18)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    canvas.drawCircle(center, radius * 0.82, innerTrackPaint);

    // Rotating segmented arcs
    final arcPaint = Paint()
      ..shader = SweepGradient(
        colors: [
          Colors.transparent,
          AppColors.cyanNeon.withValues(alpha: 0.6),
          AppColors.electricBlue,
          Colors.transparent,
        ],
        stops: const [0.0, 0.4, 0.8, 1.0],
        transform: GradientRotation(rotationAngle),
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      rotationAngle,
      math.pi * 0.65,
      false,
      arcPaint,
    );

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      rotationAngle + math.pi,
      math.pi * 0.45,
      false,
      arcPaint,
    );

    // Counter-rotating inner arc
    final counterArcPaint = Paint()
      ..color = AppColors.neonTeal.withValues(alpha: 0.45)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius * 0.82),
      -rotationAngle * 1.5,
      math.pi * 0.35,
      false,
      counterArcPaint,
    );

    // Tick marks around outer ring
    const totalTicks = 36;
    final tickPaint = Paint()..strokeWidth = 1.2;

    for (int i = 0; i < totalTicks; i++) {
      final angle = (i * 2 * math.pi / totalTicks) + rotationAngle * 0.3;
      final isMajor = i % 6 == 0;
      final tickLength = isMajor ? 6.0 : 3.0;

      tickPaint.color = isMajor
          ? AppColors.cyanNeon.withValues(alpha: 0.6)
          : AppColors.cyanNeon.withValues(alpha: 0.15);

      final p1 = Offset(
        center.dx + (radius - tickLength) * math.cos(angle),
        center.dy + (radius - tickLength) * math.sin(angle),
      );
      final p2 = Offset(
        center.dx + radius * math.cos(angle),
        center.dy + radius * math.sin(angle),
      );
      canvas.drawLine(p1, p2, tickPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _TelemetryRingsPainter oldDelegate) {
    return oldDelegate.rotationAngle != rotationAngle;
  }
}

/// Custom painter for the futuristic AI Heart silhouette, neural circuits, and ECG line
class _CyberHeartPainter extends CustomPainter {
  final double ecgProgress;
  final double pulseIntensity;

  _CyberHeartPainter({
    required this.ecgProgress,
    required this.pulseIntensity,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Build the geometric heart path
    final heartPath = Path();
    heartPath.moveTo(w * 0.5, h * 0.82);

    // Left lower curve
    heartPath.cubicTo(
      w * 0.18,
      h * 0.58,
      w * 0.05,
      h * 0.34,
      w * 0.18,
      h * 0.18,
    );

    // Left top lobe
    heartPath.cubicTo(
      w * 0.28,
      h * 0.05,
      w * 0.44,
      h * 0.10,
      w * 0.5,
      h * 0.26,
    );

    // Right top lobe
    heartPath.cubicTo(
      w * 0.56,
      h * 0.10,
      w * 0.72,
      h * 0.05,
      w * 0.82,
      h * 0.18,
    );

    // Right lower curve
    heartPath.cubicTo(
      w * 0.95,
      h * 0.34,
      w * 0.82,
      h * 0.58,
      w * 0.5,
      h * 0.82,
    );
    heartPath.close();

    // 1. Heart Fill with translucent cybernetic gradient
    final fillPaint = Paint()
      ..shader = LinearGradient(
        colors: [
          AppColors.cyanNeon.withValues(alpha: 0.18 + 0.10 * pulseIntensity),
          AppColors.electricBlue.withValues(alpha: 0.22 + 0.08 * pulseIntensity),
          AppColors.cyberPurple.withValues(alpha: 0.14),
          const Color(0xFF070B18).withValues(alpha: 0.8),
        ],
        stops: const [0.0, 0.35, 0.7, 1.0],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, 0, w, h))
      ..style = PaintingStyle.fill;

    canvas.drawPath(heartPath, fillPaint);

    // 2. Glowing Heart Perimeter Border
    final borderGlowPaint = Paint()
      ..shader = const LinearGradient(
        colors: [
          AppColors.cyanNeon,
          AppColors.electricBlue,
          AppColors.neonPink,
          AppColors.cyanNeon,
        ],
        stops: [0.0, 0.4, 0.75, 1.0],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromLTWH(0, 0, w, h))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.4
      ..maskFilter = MaskFilter.blur(BlurStyle.solid, 2.0 + 2.0 * pulseIntensity);

    canvas.drawPath(heartPath, borderGlowPaint);

    // 3. Cybernetic Neural/Vascular Circuit Traces inside the heart
    final circuitPaint = Paint()
      ..color = AppColors.cyanNeon.withValues(alpha: 0.35)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final nodePaint = Paint()
      ..color = AppColors.cyanNeon
      ..style = PaintingStyle.fill;

    // Left circuit trace
    final leftCircuit = Path()
      ..moveTo(w * 0.5, h * 0.32)
      ..lineTo(w * 0.38, h * 0.38)
      ..lineTo(w * 0.30, h * 0.32)
      ..lineTo(w * 0.24, h * 0.42);
    canvas.drawPath(leftCircuit, circuitPaint);
    canvas.drawCircle(Offset(w * 0.30, h * 0.32), 2.2, nodePaint);
    canvas.drawCircle(Offset(w * 0.24, h * 0.42), 2.8, nodePaint);

    // Right circuit trace
    final rightCircuit = Path()
      ..moveTo(w * 0.5, h * 0.32)
      ..lineTo(w * 0.62, h * 0.38)
      ..lineTo(w * 0.70, h * 0.32)
      ..lineTo(w * 0.76, h * 0.42);
    canvas.drawPath(rightCircuit, circuitPaint);
    canvas.drawCircle(Offset(w * 0.70, h * 0.32), 2.2, nodePaint);
    canvas.drawCircle(Offset(w * 0.76, h * 0.42), 2.8, nodePaint);

    // Center vertical neural bus line
    final busPath = Path()
      ..moveTo(w * 0.5, h * 0.26)
      ..lineTo(w * 0.5, h * 0.72);
    final busPaint = Paint()
      ..color = AppColors.neonTeal.withValues(alpha: 0.25)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    canvas.drawPath(busPath, busPaint);

    // 4. Live ECG Waveform passing horizontally through the heart
    _drawLiveEcgWave(canvas, size, ecgProgress);
  }

  void _drawLiveEcgWave(Canvas canvas, Size size, double progress) {
    final w = size.width;
    final cy = size.height * 0.52;

    // ECG baseline spanning across the heart
    final ecgPoints = <Offset>[
      Offset(w * 0.16, cy),
      Offset(w * 0.28, cy),
      Offset(w * 0.32, cy - 4), // P wave
      Offset(w * 0.36, cy),
      Offset(w * 0.40, cy),
      Offset(w * 0.43, cy + 6), // Q dip
      Offset(w * 0.48, cy - 32), // R peak (high spike)
      Offset(w * 0.53, cy + 12), // S dip
      Offset(w * 0.56, cy),
      Offset(w * 0.60, cy),
      Offset(w * 0.65, cy - 8), // T wave
      Offset(w * 0.70, cy),
      Offset(w * 0.84, cy),
    ];

    final ecgPath = Path();
    ecgPath.moveTo(ecgPoints[0].dx, ecgPoints[0].dy);
    for (int i = 1; i < ecgPoints.length; i++) {
      ecgPath.lineTo(ecgPoints[i].dx, ecgPoints[i].dy);
    }

    // Static dimmed ECG trace
    final bgEcgPaint = Paint()
      ..color = AppColors.cyanNeon.withValues(alpha: 0.16)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawPath(ecgPath, bgEcgPaint);

    // Active glowing scan beam along the ECG path
    final scanX = w * 0.16 + (w * 0.68) * progress;
    final scanY = _interpolateEcgY(ecgPoints, scanX);

    // Glowing head
    final headGlowPaint = Paint()
      ..color = AppColors.cyanNeon
      ..maskFilter = const MaskFilter.blur(BlurStyle.solid, 4.0);
    canvas.drawCircle(Offset(scanX, scanY), 3.5, headGlowPaint);

    // Inner bright white node
    final coreNodePaint = Paint()..color = Colors.white;
    canvas.drawCircle(Offset(scanX, scanY), 1.8, coreNodePaint);

    // Trail effect behind the scan point
    final trailPaint = Paint()
      ..shader = LinearGradient(
        colors: [
          Colors.transparent,
          AppColors.cyanNeon.withValues(alpha: 0.8),
        ],
      ).createShader(Rect.fromLTWH(scanX - 30, cy - 35, 30, 70))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2;

    final trailPath = Path();
    bool started = false;
    for (final pt in ecgPoints) {
      if (pt.dx <= scanX && pt.dx >= scanX - 35) {
        if (!started) {
          trailPath.moveTo(pt.dx, pt.dy);
          started = true;
        } else {
          trailPath.lineTo(pt.dx, pt.dy);
        }
      }
    }
    if (started) {
      trailPath.lineTo(scanX, scanY);
      canvas.drawPath(trailPath, trailPaint);
    }
  }

  double _interpolateEcgY(List<Offset> points, double targetX) {
    if (targetX <= points.first.dx) return points.first.dy;
    if (targetX >= points.last.dx) return points.last.dy;

    for (int i = 0; i < points.length - 1; i++) {
      if (targetX >= points[i].dx && targetX <= points[i + 1].dx) {
        final t = (targetX - points[i].dx) / (points[i + 1].dx - points[i].dx);
        return points[i].dy + (points[i + 1].dy - points[i].dy) * t;
      }
    }
    return points.first.dy;
  }

  @override
  bool shouldRepaint(covariant _CyberHeartPainter oldDelegate) {
    return oldDelegate.ecgProgress != ecgProgress ||
        oldDelegate.pulseIntensity != pulseIntensity;
  }
}
