import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_container.dart';
import '../widgets/futuristic_button.dart';
import '../widgets/futuristic_text_field.dart';

/// Futuristic Recovery Key & Password Reset Modal Sheet
class ForgotPasswordSheet extends StatefulWidget {
  const ForgotPasswordSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const ForgotPasswordSheet(),
    );
  }

  @override
  State<ForgotPasswordSheet> createState() => _ForgotPasswordSheetState();
}

class _ForgotPasswordSheetState extends State<ForgotPasswordSheet> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _isSuccess = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _handleReset() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);
      // Simulate cryptographic token transmission
      await Future.delayed(const Duration(milliseconds: 1400));
      if (mounted) {
        setState(() {
          _isLoading = false;
          _isSuccess = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: GlassContainer(
        borderRadius: 32,
        hasGlow: true,
        borderColor: AppColors.cyanNeon.withValues(alpha: 0.5),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top drag bar
              Center(
                child: Container(
                  width: 44,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.cyanNeon.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              if (!_isSuccess) ...[
                // Header
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.cyanNeon.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.cyanNeon.withValues(alpha: 0.3),
                        ),
                      ),
                      child: const Icon(
                        Icons.key_rounded,
                        color: AppColors.cyanNeon,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'RECOVER CREDENTIALS',
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.8,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Quantum 256-bit Token Dispatch',
                            style: TextStyle(
                              color: AppColors.cyanNeon.withValues(alpha: 0.8),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text(
                  'Enter your registered Biometric Neural ID or Email address. A secure cryptographic authentication token will be dispatched to verify your identity.',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 24),

                Form(
                  key: _formKey,
                  child: FuturisticTextField(
                    controller: _emailController,
                    label: 'Biometric ID / Email',
                    hintText: 'alex.mercer@neuralmed.ai',
                    prefixIcon: Icons.alternate_email_rounded,
                    keyboardType: TextInputType.emailAddress,
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) {
                        return 'Terminal ID / Email is required';
                      }
                      if (!val.contains('@') || !val.contains('.')) {
                        return 'Provide a valid email address';
                      }
                      return null;
                    },
                  ),
                ),

                const SizedBox(height: 24),

                FuturisticButton(
                  text: 'DISPATCH RECOVERY TOKEN',
                  isLoading: _isLoading,
                  trailingIcon: Icons.send_rounded,
                  onPressed: _handleReset,
                ),
              ] else ...[
                // Success State
                Center(
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.neonTeal.withValues(alpha: 0.15),
                          border: Border.all(
                            color: AppColors.neonTeal,
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.neonTeal.withValues(alpha: 0.3),
                              blurRadius: 20,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.verified_user_rounded,
                          color: AppColors.neonTeal,
                          size: 40,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'TOKEN TRANSMITTED',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'A 6-digit cryptographic validation key was sent to ${_emailController.text}. Please check your neural comms or inbox.',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 13,
                            height: 1.45,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      FuturisticButton(
                        text: 'RETURN TO TERMINAL LOGIN',
                        variant: FuturisticButtonVariant.secondary,
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
