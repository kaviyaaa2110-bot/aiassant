import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

enum FuturisticButtonVariant { primary, secondary, danger, ghost }

/// High-tech cybernetic action button with gradient glow, loading state, and haptic response
class FuturisticButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? leadingIcon;
  final IconData? trailingIcon;
  final FuturisticButtonVariant variant;
  final double height;
  final double? width;
  final double borderRadius;

  const FuturisticButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.leadingIcon,
    this.trailingIcon,
    this.variant = FuturisticButtonVariant.primary,
    this.height = 54,
    this.width,
    this.borderRadius = 16,
  });

  @override
  State<FuturisticButton> createState() => _FuturisticButtonState();
}

class _FuturisticButtonState extends State<FuturisticButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _pressController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _pressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.97).animate(
      CurvedAnimation(parent: _pressController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pressController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails _) {
    if (widget.onPressed != null && !widget.isLoading) {
      _pressController.forward();
    }
  }

  void _handleTapUp(TapUpDetails _) {
    if (widget.onPressed != null && !widget.isLoading) {
      _pressController.reverse();
    }
  }

  void _handleTapCancel() {
    _pressController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final isEnabled = widget.onPressed != null && !widget.isLoading;

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: child,
        );
      },
      child: GestureDetector(
        onTapDown: _handleTapDown,
        onTapUp: _handleTapUp,
        onTapCancel: _handleTapCancel,
        onTap: isEnabled ? widget.onPressed : null,
        child: Container(
          width: widget.width ?? double.infinity,
          height: widget.height,
          decoration: _buildDecoration(isEnabled),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Top subtle highlight sheen for primary variant
                if (widget.variant == FuturisticButtonVariant.primary && isEnabled)
                  Positioned(
                    top: 0,
                    left: 20,
                    right: 20,
                    height: 1.5,
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.transparent,
                            Colors.white,
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),

                // Button Content
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: widget.isLoading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.bgDarkest,
                            ),
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (widget.leadingIcon != null) ...[
                              Icon(
                                widget.leadingIcon,
                                size: 19,
                                color: _getTextColor(isEnabled),
                              ),
                              const SizedBox(width: 10),
                            ],
                            Text(
                              widget.text,
                              style: TextStyle(
                                color: _getTextColor(isEnabled),
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.8,
                              ),
                            ),
                            if (widget.trailingIcon != null) ...[
                              const SizedBox(width: 10),
                              Icon(
                                widget.trailingIcon,
                                size: 19,
                                color: _getTextColor(isEnabled),
                              ),
                            ],
                          ],
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  BoxDecoration _buildDecoration(bool isEnabled) {
    switch (widget.variant) {
      case FuturisticButtonVariant.primary:
        return BoxDecoration(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          gradient: isEnabled
              ? AppColors.primaryGradient
              : LinearGradient(
                  colors: [
                    AppColors.bgElevated,
                    AppColors.bgCard,
                  ],
                ),
          boxShadow: isEnabled
              ? [
                  BoxShadow(
                    color: AppColors.cyanNeon.withValues(alpha: 0.38),
                    blurRadius: 18,
                    offset: const Offset(0, 4),
                  ),
                  BoxShadow(
                    color: AppColors.electricBlue.withValues(alpha: 0.25),
                    blurRadius: 30,
                    offset: const Offset(0, 8),
                  ),
                ]
              : null,
        );

      case FuturisticButtonVariant.secondary:
        return BoxDecoration(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          color: AppColors.bgElevated.withValues(alpha: 0.6),
          border: Border.all(
            color: isEnabled
                ? AppColors.cyanNeon.withValues(alpha: 0.45)
                : AppColors.textDisabled,
            width: 1.3,
          ),
          boxShadow: isEnabled
              ? [
                  BoxShadow(
                    color: AppColors.cyanNeon.withValues(alpha: 0.12),
                    blurRadius: 14,
                  ),
                ]
              : null,
        );

      case FuturisticButtonVariant.danger:
        return BoxDecoration(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          color: AppColors.error.withValues(alpha: 0.15),
          border: Border.all(
            color: AppColors.error.withValues(alpha: 0.6),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.error.withValues(alpha: 0.25),
              blurRadius: 16,
            ),
          ],
        );

      case FuturisticButtonVariant.ghost:
        return BoxDecoration(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          color: Colors.transparent,
        );
    }
  }

  Color _getTextColor(bool isEnabled) {
    if (!isEnabled) return AppColors.textDisabled;
    switch (widget.variant) {
      case FuturisticButtonVariant.primary:
        return AppColors.bgDarkest;
      case FuturisticButtonVariant.secondary:
        return AppColors.cyanNeon;
      case FuturisticButtonVariant.danger:
        return AppColors.error;
      case FuturisticButtonVariant.ghost:
        return AppColors.textSecondary;
    }
  }
}
