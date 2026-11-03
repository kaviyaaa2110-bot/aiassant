import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/futuristic_background.dart';
import '../widgets/cyber_heart_widget.dart';
import '../widgets/futuristic_button.dart';
import 'login_screen.dart';
import 'register_screen.dart';
import 'main_shell.dart';

/// Stunning Futuristic Welcome Screen for AI Health Assistant
class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic),
    );

    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: FuturisticBackground(
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  children: [
                    const SizedBox(height: 12),

                    // Top Status Telemetry Pill
                    _buildTopStatusPill(),

                    const Spacer(flex: 2),

                    // Centerpiece: Glowing Futuristic AI Heart
                    Hero(
                      tag: 'cyber-heart-hero',
                      child: CyberHeartWidget(
                        size: size.width * 0.58 > 240 ? 240 : size.width * 0.58,
                        showTelemetryBadge: true,
                        bpm: 72,
                      ),
                    ),

                    const Spacer(flex: 2),

                    // Brand Title & Tagline
                    _buildBrandHeader(),

                    const SizedBox(height: 20),

                    // Futuristic Feature Highlights Carousel
                    _buildFeatureHighlights(),

                    const Spacer(flex: 3),

                    // Action Buttons (Login & Register)
                    _buildActionButtons(context),

                    const SizedBox(height: 16),

                    // Quick Demo / Guest Bypass
                    _buildGuestExplore(context),

                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopStatusPill() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.bgElevated.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: AppColors.cyanNeon.withValues(alpha: 0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.cyanNeon.withValues(alpha: 0.1),
            blurRadius: 12,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.neonTeal,
              boxShadow: [
                BoxShadow(
                  color: AppColors.neonTeal,
                  blurRadius: 6,
                  spreadRadius: 1,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          const Text(
            'QUANTUM HEALTH AI v4.2',
            style: TextStyle(
              color: AppColors.cyanNeon,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.6,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.neonTeal.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              'ONLINE',
              style: TextStyle(
                color: AppColors.neonTeal,
                fontSize: 9,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.8,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBrandHeader() {
    return Column(
      children: [
        // AI Health Assistant Title
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ShaderMask(
              shaderCallback: (bounds) => AppColors.primaryGradient.createShader(bounds),
              child: const Text(
                'AI HEALTH ',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  letterSpacing: 1.5,
                ),
              ),
            ),
            const Text(
              'ASSISTANT',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                letterSpacing: 1.5,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),

        // Tagline
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Next-Generation Neural Diagnostics & Real-Time Biometric Intelligence',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
              fontWeight: FontWeight.w400,
              height: 1.45,
              letterSpacing: 0.3,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFeatureHighlights() {
    final features = [
      {'icon': Icons.monitor_heart_rounded, 'label': 'Real-Time ECG AI'},
      {'icon': Icons.psychology_rounded, 'label': 'Neural Triage'},
      {'icon': Icons.security_rounded, 'label': 'Quantum Encrypted'},
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: features.map((feat) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.bgElevated.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.cyanNeon.withValues(alpha: 0.15),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                feat['icon'] as IconData,
                size: 13,
                color: AppColors.cyanNeon,
              ),
              const SizedBox(width: 5),
              Text(
                feat['label'] as String,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        // Primary CTA: Register
        FuturisticButton(
          text: 'INITIALIZE ACCOUNT',
          trailingIcon: Icons.arrow_forward_rounded,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const RegisterScreen()),
            );
          },
        ),

        const SizedBox(height: 12),

        // Secondary CTA: Login
        FuturisticButton(
          text: 'AUTHENTICATE SESSION',
          variant: FuturisticButtonVariant.secondary,
          leadingIcon: Icons.fingerprint_rounded,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const LoginScreen()),
            );
          },
        ),
      ],
    );
  }

  Widget _buildGuestExplore(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const MainShell()),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Explore Biometric Terminal as Guest',
              style: TextStyle(
                color: AppColors.textMuted,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 6),
            Icon(
              Icons.chevron_right_rounded,
              size: 16,
              color: AppColors.cyanNeon.withValues(alpha: 0.7),
            ),
          ],
        ),
      ),
    );
  }
}
