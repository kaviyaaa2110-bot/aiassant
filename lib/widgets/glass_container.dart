import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Premium futuristic glassmorphism container with backdrop blur,
/// neon glowing borders, and cybernetic styling.
class GlassContainer extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final double borderRadius;
  final double blur;
  final Color? borderColor;
  final Color? backgroundColor;
  final bool hasGlow;
  final VoidCallback? onTap;

  const GlassContainer({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.padding = const EdgeInsets.all(20),
    this.margin,
    this.borderRadius = 24,
    this.blur = 16.0,
    this.borderColor,
    this.backgroundColor,
    this.hasGlow = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {

    Widget content = Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: hasGlow
            ? [
                BoxShadow(
                  color: (borderColor ?? AppColors.cyanNeon).withValues(alpha: 0.18),
                  blurRadius: 24,
                  spreadRadius: -2,
                ),
              ]
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.35),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
              ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadius),
              gradient: LinearGradient(
                colors: [
                  backgroundColor ?? AppColors.bgElevated.withValues(alpha: 0.55),
                  AppColors.bgCard.withValues(alpha: 0.40),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border.all(
                color: borderColor ?? AppColors.cyanNeon.withValues(alpha: 0.22),
                width: 1.2,
              ),
            ),
            child: Stack(
              children: [
                // Top-left subtle highlight sheen
                Positioned(
                  top: 0,
                  left: 20,
                  right: 20,
                  height: 1,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          AppColors.cyanNeon.withValues(alpha: 0.5),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: padding,
                  child: child,
                ),
              ],
            ),
          ),
        ),
      ),
    );

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: content,
      );
    }

    return content;
  }
}
