import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/futuristic_background.dart';
import '../widgets/glass_container.dart';
import '../widgets/futuristic_button.dart';
import '../widgets/futuristic_text_field.dart';
import 'login_screen.dart';
import 'main_shell.dart';

/// Premium Futuristic Registration & Identity Initialization Screen
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _agreeTerms = true;
  bool _isLoading = false;

  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  // Real-time password strength calculation
  int _passwordScore = 0;

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

    _passwordController.addListener(_evalPasswordStrength);
  }

  void _evalPasswordStrength() {
    final text = _passwordController.text;
    int score = 0;
    if (text.length >= 8) score++;
    if (text.contains(RegExp(r'[A-Z]'))) score++;
    if (text.contains(RegExp(r'[0-9]'))) score++;
    if (text.contains(RegExp(r'[!@#\$&*~]'))) score++;
    setState(() {
      _passwordScore = score;
    });
  }

  @override
  void dispose() {
    _animController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleRegister() async {
    if (!_agreeTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppColors.error.withValues(alpha: 0.9),
          content: const Text('Please accept the HIPAA & Quantum Data Protocol to proceed'),
        ),
      );
      return;
    }

    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);
      // Simulate cryptographic key pair generation & biometric registration
      await Future.delayed(const Duration(milliseconds: 1400));
      if (!mounted) return;
      setState(() => _isLoading = false);

      // Show activation dialog and enter MainShell
      _showActivationSuccessDialog();
    }
  }

  void _showActivationSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: GlassContainer(
            borderRadius: 28,
            hasGlow: true,
            padding: const EdgeInsets.all(28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.cyanNeon.withValues(alpha: 0.15),
                    border: Border.all(color: AppColors.cyanNeon, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.cyanNeon.withValues(alpha: 0.4),
                        blurRadius: 20,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.security_update_good_rounded,
                    color: AppColors.cyanNeon,
                    size: 42,
                  ),
                ),
                const SizedBox(height: 18),
                const Text(
                  'HEALTH ID ACTIVATED',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Your 256-bit biometric identity ledger has been established. Loading clinical dashboard...',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 24),
                FuturisticButton(
                  text: 'ENTER CLINICAL PORTAL',
                  onPressed: () {
                    Navigator.pop(ctx);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const MainShell()),
                    );
                  },
                ),
              ],
            ),
          ),
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
                    // Top Bar
                    _buildTopBar(context),

                    const SizedBox(height: 16),

                    // Title Header
                    _buildHeader(),

                    const SizedBox(height: 20),

                    // Registration Form Card
                    _buildFormCard(),

                    const SizedBox(height: 20),

                    // Footer Link
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
        GestureDetector(
          onTap: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              );
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

        // Stage indicator
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
                Icons.hub_rounded,
                size: 13,
                color: AppColors.cyanNeon,
              ),
              SizedBox(width: 6),
              Text(
                'NEURAL LEDGER REGISTRATION',
                style: TextStyle(
                  color: AppColors.cyanNeon,
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
      children: const [
        Text(
          'INITIALIZE IDENTITY',
          style: TextStyle(
            color: AppColors.cyanNeon,
            fontSize: 12,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.6,
          ),
        ),
        SizedBox(height: 6),
        Text(
          'Create Health ID',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 28,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.3,
          ),
        ),
        SizedBox(height: 4),
        Text(
          'Set up your quantum-encrypted biometric profile',
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
            // Full Legal Name
            FuturisticTextField(
              controller: _nameController,
              label: 'Full Legal Name',
              hintText: 'Dr. Alex Mercer',
              prefixIcon: Icons.badge_outlined,
              validator: (val) {
                if (val == null || val.trim().isEmpty) {
                  return 'Legal name is required';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            // Email Address
            FuturisticTextField(
              controller: _emailController,
              label: 'Biometric Email / ID',
              hintText: 'alex.mercer@neuralmed.ai',
              prefixIcon: Icons.alternate_email_rounded,
              keyboardType: TextInputType.emailAddress,
              validator: (val) {
                if (val == null || val.trim().isEmpty) {
                  return 'Email address is required';
                }
                if (!val.contains('@') || !val.contains('.')) {
                  return 'Enter a valid email address';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            // Contact Number
            FuturisticTextField(
              controller: _phoneController,
              label: 'Telemetry Comm Channel (Phone)',
              hintText: '+1 (555) 019-2834',
              prefixIcon: Icons.phone_android_rounded,
              keyboardType: TextInputType.phone,
              validator: (val) {
                if (val == null || val.trim().isEmpty) {
                  return 'Comm channel is required';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            // Password
            FuturisticTextField(
              controller: _passwordController,
              label: 'Quantum Security Key',
              hintText: 'Minimum 8 characters with numbers & symbols',
              prefixIcon: Icons.lock_outline_rounded,
              isPassword: true,
              validator: (val) {
                if (val == null || val.isEmpty) {
                  return 'Security key is required';
                }
                if (val.length < 8) {
                  return 'Must contain at least 8 characters';
                }
                return null;
              },
            ),

            // Real-Time Password Strength Meter
            if (_passwordController.text.isNotEmpty) ...[
              const SizedBox(height: 8),
              _buildPasswordStrengthBar(),
            ],

            const SizedBox(height: 16),

            // Confirm Password
            FuturisticTextField(
              controller: _confirmPasswordController,
              label: 'Verify Security Key',
              hintText: 'Re-enter security key',
              prefixIcon: Icons.lock_reset_rounded,
              isPassword: true,
              validator: (val) {
                if (val != _passwordController.text) {
                  return 'Security keys do not match';
                }
                return null;
              },
            ),

            const SizedBox(height: 18),

            // HIPAA and Terms Checkbox
            _buildTermsCheckbox(),

            const SizedBox(height: 22),

            // Submit Button
            FuturisticButton(
              text: 'INITIALIZE QUANTUM HEALTH ID',
              isLoading: _isLoading,
              trailingIcon: Icons.arrow_forward_rounded,
              onPressed: _handleRegister,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPasswordStrengthBar() {
    Color barColor;
    String strengthLabel;

    switch (_passwordScore) {
      case 1:
        barColor = AppColors.error;
        strengthLabel = 'WEAK ENCRYPTION';
        break;
      case 2:
        barColor = AppColors.warning;
        strengthLabel = 'MODERATE CIPHER';
        break;
      case 3:
        barColor = AppColors.electricBlue;
        strengthLabel = 'STRONG KEY';
        break;
      case 4:
        barColor = AppColors.neonTeal;
        strengthLabel = 'QUANTUM-SHIELDED';
        break;
      default:
        barColor = AppColors.textDisabled;
        strengthLabel = 'KEY TOO SHORT';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              strengthLabel,
              style: TextStyle(
                color: barColor,
                fontSize: 10,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.0,
              ),
            ),
            Text(
              '$_passwordScore / 4',
              style: TextStyle(
                color: barColor,
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          children: List.generate(4, (index) {
            final active = index < _passwordScore;
            return Expanded(
              child: Container(
                height: 3.5,
                margin: const EdgeInsets.symmetric(horizontal: 2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: active ? barColor : AppColors.bgDarkest,
                  boxShadow: active
                      ? [
                          BoxShadow(
                            color: barColor.withValues(alpha: 0.6),
                            blurRadius: 4,
                          ),
                        ]
                      : null,
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildTermsCheckbox() {
    return GestureDetector(
      onTap: () {
        setState(() => _agreeTerms = !_agreeTerms);
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 18,
            height: 18,
            margin: const EdgeInsets.only(top: 2),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: _agreeTerms ? AppColors.cyanNeon : AppColors.bgElevated,
              border: Border.all(
                color: _agreeTerms ? AppColors.cyanNeon : AppColors.textMuted,
                width: 1.2,
              ),
              boxShadow: _agreeTerms
                  ? [
                      BoxShadow(
                        color: AppColors.cyanNeon.withValues(alpha: 0.4),
                        blurRadius: 8,
                      ),
                    ]
                  : null,
            ),
            child: _agreeTerms
                ? const Icon(
                    Icons.check,
                    size: 13,
                    color: AppColors.bgDarkest,
                  )
                : null,
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: Text(
              'I consent to HIPAA-compliant quantum biometric data hashing & Neural AI diagnostic processing protocols.',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const LoginScreen()),
          );
        },
        child: RichText(
          text: const TextSpan(
            text: 'Already hold an active Identity Key? ',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
            ),
            children: [
              TextSpan(
                text: 'Authenticate',
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
