import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/futuristic_background.dart';
import '../widgets/glass_container.dart';
import '../widgets/futuristic_button.dart';
import '../widgets/futuristic_text_field.dart';
import 'register_screen.dart';
import 'forgot_password_sheet.dart';
import 'main_shell.dart';

/// Premium Futuristic Login Screen for AI Health Assistant
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController(text: 'mercer.alex@neuralmed.ai');
  final _passwordController = TextEditingController(text: 'QuantumPass77!');
  bool _rememberMe = true;
  bool _isLoading = false;

  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOut),
    );
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic),
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);
      await Future.delayed(const Duration(milliseconds: 1000));
      if (!mounted) return;
      setState(() => _isLoading = false);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainShell()),
      );
    }
  }

  void _handleBiometricAuth() {
    // Show simulated futuristic biometric scan modal
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return _BiometricScanDialog(
          onComplete: () {
            Navigator.pop(ctx);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const MainShell()),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FuturisticBackground(
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnim,
            child: SlideTransition(
              position: _slideAnim,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top Navigation Bar
                    _buildTopBar(context),

                    const SizedBox(height: 16),

                    // Cyber Medical Header
                    _buildHeader(),

                    const SizedBox(height: 24),

                    // Main Glassmorphism Form Card
                    _buildFormCard(),

                    const SizedBox(height: 20),

                    // Quick Neural/Biometric Login Button
                    _buildBiometricLoginOption(),

                    const SizedBox(height: 24),

                    // Social Authenticate Protocol
                    _buildSocialAuthDivider(),

                    const SizedBox(height: 16),

                    _buildSocialButtons(),

                    const SizedBox(height: 28),

                    // Bottom Register Redirect
                    _buildFooter(context),

                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Back Button
        GestureDetector(
          onTap: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          },
          child: Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppColors.bgElevated.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.cyanNeon.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: const Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 16,
              color: AppColors.cyanNeon,
            ),
          ),
        ),

        // Cyber Medical Security Badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.bgElevated.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppColors.cyanNeon.withValues(alpha: 0.25),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(
                Icons.shield_outlined,
                size: 14,
                color: AppColors.neonTeal,
              ),
              SizedBox(width: 6),
              Text(
                'SSL 256-BIT ENCRYPTED',
                style: TextStyle(
                  color: AppColors.neonTeal,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.1,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.cyanNeon.withValues(alpha: 0.12),
                border: Border.all(
                  color: AppColors.cyanNeon.withValues(alpha: 0.4),
                ),
              ),
              child: const Icon(
                Icons.fingerprint_rounded,
                color: AppColors.cyanNeon,
                size: 20,
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              'BIOMETRIC AUTHENTICATION',
              style: TextStyle(
                color: AppColors.cyanNeon,
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.4,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        const Text(
          'Welcome Back',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 28,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Initialize session to decrypt your neural telemetry record',
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildFormCard() {
    return GlassContainer(
      hasGlow: true,
      borderRadius: 24,
      padding: const EdgeInsets.all(22),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Email Input
            FuturisticTextField(
              controller: _emailController,
              label: 'Neural ID / Email',
              hintText: 'alex.mercer@neuralmed.ai',
              prefixIcon: Icons.alternate_email_rounded,
              keyboardType: TextInputType.emailAddress,
              validator: (val) {
                if (val == null || val.trim().isEmpty) {
                  return 'Neural ID is required';
                }
                if (!val.contains('@')) {
                  return 'Invalid email syntax';
                }
                return null;
              },
            ),

            const SizedBox(height: 18),

            // Password Input
            FuturisticTextField(
              controller: _passwordController,
              label: 'Security Access Key',
              hintText: '••••••••••••',
              prefixIcon: Icons.lock_outline_rounded,
              isPassword: true,
              validator: (val) {
                if (val == null || val.isEmpty) {
                  return 'Access key is required';
                }
                if (val.length < 6) {
                  return 'Key must be at least 6 characters';
                }
                return null;
              },
            ),

            const SizedBox(height: 14),

            // Remember Me & Forgot Password Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Custom Cyber Checkbox
                GestureDetector(
                  onTap: () {
                    setState(() => _rememberMe = !_rememberMe);
                  },
                  child: Row(
                    children: [
                      Container(
                        width: 18,
                        height: 18,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: _rememberMe
                              ? AppColors.cyanNeon
                              : AppColors.bgElevated,
                          border: Border.all(
                            color: _rememberMe
                                ? AppColors.cyanNeon
                                : AppColors.textMuted,
                            width: 1.2,
                          ),
                          boxShadow: _rememberMe
                              ? [
                                  BoxShadow(
                                    color: AppColors.cyanNeon.withValues(alpha: 0.4),
                                    blurRadius: 8,
                                  ),
                                ]
                              : null,
                        ),
                        child: _rememberMe
                            ? const Icon(
                                Icons.check,
                                size: 13,
                                color: AppColors.bgDarkest,
                              )
                            : null,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Trust Terminal',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),

                // Forgot Password Button
                GestureDetector(
                  onTap: () => ForgotPasswordSheet.show(context),
                  child: const Text(
                    'Lost Key?',
                    style: TextStyle(
                      color: AppColors.cyanNeon,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.4,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 22),

            // Submit Button
            FuturisticButton(
              text: 'INITIALIZE SESSION',
              isLoading: _isLoading,
              trailingIcon: Icons.bolt_rounded,
              onPressed: _handleLogin,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBiometricLoginOption() {
    return FuturisticButton(
      text: 'AUTHENTICATE VIA NEURAL SCAN',
      variant: FuturisticButtonVariant.secondary,
      leadingIcon: Icons.document_scanner_rounded,
      onPressed: _handleBiometricAuth,
    );
  }

  Widget _buildSocialAuthDivider() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  AppColors.cyanNeon.withValues(alpha: 0.3),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Text(
            'OR CONNECT VIA',
            style: TextStyle(
              color: AppColors.textMuted,
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
            ),
          ),
        ),
        Expanded(
          child: Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.cyanNeon.withValues(alpha: 0.3),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSocialButtons() {
    return Row(
      children: [
        Expanded(
          child: _buildSocialPill(
            label: 'Google Neural',
            icon: Icons.g_mobiledata_rounded,
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const MainShell()),
              );
            },
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: _buildSocialPill(
            label: 'Apple BioKey',
            icon: Icons.apple_rounded,
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const MainShell()),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSocialPill({
    required String label,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: AppColors.bgElevated.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: AppColors.cyanNeon.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 22,
              color: AppColors.textPrimary,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const RegisterScreen()),
          );
        },
        child: RichText(
          text: const TextSpan(
            text: "Don't have a registered terminal? ",
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
            ),
            children: [
              TextSpan(
                text: 'Register Identity',
                style: TextStyle(
                  color: AppColors.cyanNeon,
                  fontWeight: FontWeight.w700,
                  decoration: TextDecoration.underline,
                  decorationColor: AppColors.cyanNeon,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Simulated Futuristic Biometric / Neural Face ID Scan Dialog
class _BiometricScanDialog extends StatefulWidget {
  final VoidCallback onComplete;

  const _BiometricScanDialog({required this.onComplete});

  @override
  State<_BiometricScanDialog> createState() => _BiometricScanDialogState();
}

class _BiometricScanDialogState extends State<_BiometricScanDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _scanController;
  late Animation<double> _scanPos;

  @override
  void initState() {
    super.initState();
    _scanController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);

    _scanPos = Tween<double>(begin: -0.8, end: 0.8).animate(
      CurvedAnimation(parent: _scanController, curve: Curves.easeInOut),
    );

    // Auto-complete after 2.2 seconds
    Future.delayed(const Duration(milliseconds: 2200), () {
      if (mounted) widget.onComplete();
    });
  }

  @override
  void dispose() {
    _scanController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: GlassContainer(
        borderRadius: 28,
        hasGlow: true,
        borderColor: AppColors.cyanNeon,
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Holographic Scanner Box
            Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                color: AppColors.bgElevated.withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppColors.cyanNeon.withValues(alpha: 0.5),
                  width: 1.5,
                ),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const Icon(
                    Icons.face_retouching_natural_rounded,
                    size: 64,
                    color: AppColors.cyanNeon,
                  ),

                  // Animated laser scan line
                  AnimatedBuilder(
                    animation: _scanPos,
                    builder: (context, _) {
                      return Align(
                        alignment: Alignment(0, _scanPos.value),
                        child: Container(
                          height: 3,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                Colors.transparent,
                                AppColors.cyanNeon,
                                Colors.white,
                                AppColors.cyanNeon,
                                Colors.transparent,
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.cyanNeon.withValues(alpha: 0.9),
                                blurRadius: 10,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'SCANNING NEURAL BIOMETRICS...',
              style: TextStyle(
                color: AppColors.cyanNeon,
                fontSize: 13,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.4,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Matching facial vascular pattern with quantum medical ledger...',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
