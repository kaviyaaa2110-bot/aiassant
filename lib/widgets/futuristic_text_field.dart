import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Futuristic Cyber-Medical text input field with glow focus,
/// glassmorphism background, and high-tech typography.
class FuturisticTextField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String? hintText;
  final IconData prefixIcon;
  final bool isPassword;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final Widget? suffix;
  final FocusNode? focusNode;
  final bool enabled;

  const FuturisticTextField({
    super.key,
    required this.controller,
    required this.label,
    this.hintText,
    required this.prefixIcon,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.onChanged,
    this.suffix,
    this.focusNode,
    this.enabled = true,
  });

  @override
  State<FuturisticTextField> createState() => _FuturisticTextFieldState();
}

class _FuturisticTextFieldState extends State<FuturisticTextField> {
  late FocusNode _effectiveFocusNode;
  bool _isFocused = false;
  bool _obscureText = true;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _effectiveFocusNode = widget.focusNode ?? FocusNode();
    _obscureText = widget.isPassword;
    _effectiveFocusNode.addListener(_handleFocusChange);
  }

  void _handleFocusChange() {
    setState(() {
      _isFocused = _effectiveFocusNode.hasFocus;
    });
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _effectiveFocusNode.dispose();
    } else {
      _effectiveFocusNode.removeListener(_handleFocusChange);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasError = _errorText != null && _errorText!.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Cybernetic Label
        Row(
          children: [
            Container(
              width: 5,
              height: 5,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _isFocused ? AppColors.cyanNeon : AppColors.textMuted,
                boxShadow: _isFocused
                    ? [
                        BoxShadow(
                          color: AppColors.cyanNeon.withValues(alpha: 0.8),
                          blurRadius: 6,
                        ),
                      ]
                    : null,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              widget.label.toUpperCase(),
              style: TextStyle(
                color: _isFocused ? AppColors.cyanNeon : AppColors.textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.1,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),

        // Glowing Glass Input Box
        AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: AppColors.bgElevated.withValues(alpha: 0.65),
            border: Border.all(
              color: hasError
                  ? AppColors.error
                  : _isFocused
                      ? AppColors.cyanNeon
                      : AppColors.cyanNeon.withValues(alpha: 0.18),
              width: _isFocused || hasError ? 1.6 : 1.0,
            ),
            boxShadow: [
              if (_isFocused && !hasError)
                BoxShadow(
                  color: AppColors.cyanNeon.withValues(alpha: 0.22),
                  blurRadius: 16,
                  spreadRadius: 0,
                ),
              if (hasError)
                BoxShadow(
                  color: AppColors.error.withValues(alpha: 0.25),
                  blurRadius: 16,
                  spreadRadius: 0,
                ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: TextFormField(
              controller: widget.controller,
              focusNode: _effectiveFocusNode,
              obscureText: _obscureText,
              keyboardType: widget.keyboardType,
              enabled: widget.enabled,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 15,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.4,
              ),
              cursorColor: AppColors.cyanNeon,
              cursorWidth: 2,
              decoration: InputDecoration(
                isDense: true,
                hintText: widget.hintText,
                hintStyle: const TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 14,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                border: InputBorder.none,
                prefixIcon: Icon(
                  widget.prefixIcon,
                  size: 20,
                  color: _isFocused ? AppColors.cyanNeon : AppColors.textMuted,
                ),
                suffixIcon: widget.isPassword
                    ? IconButton(
                        icon: Icon(
                          _obscureText
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          size: 20,
                          color: _obscureText
                              ? AppColors.textMuted
                              : AppColors.cyanNeon,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                      )
                    : widget.suffix,
              ),
              validator: (val) {
                final result = widget.validator?.call(val);
                setState(() {
                  _errorText = result;
                });
                return result;
              },
              onChanged: (val) {
                if (_errorText != null) {
                  setState(() {
                    _errorText = widget.validator?.call(val);
                  });
                }
                widget.onChanged?.call(val);
              },
            ),
          ),
        ),

        // Error message in cyber telemetry styling
        if (hasError) ...[
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(
                Icons.error_outline_rounded,
                size: 13,
                color: AppColors.error,
              ),
              const SizedBox(width: 6),
              Text(
                _errorText!,
                style: const TextStyle(
                  color: AppColors.error,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
