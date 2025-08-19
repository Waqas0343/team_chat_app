import 'package:flutter/material.dart';
import '../app_styles/complete_app_theme.dart';

class CustomCard extends StatelessWidget {
  final Color? color;
  final VoidCallback? onPressed, onLongPressed;
  final Widget? child;
  final EdgeInsets? margin;
  final double? radius;

  const CustomCard({
    super.key,
    this.child,
    this.color,
    this.onPressed,
    this.onLongPressed,
    this.margin,
    this.radius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? EdgeInsets.zero,
      decoration: BoxDecoration(
        borderRadius:
        BorderRadius.circular(radius ?? AppThemeInfo.borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 2.5,
            spreadRadius: 1.0,
          )
        ],
      ),
      child: Material(
        color: color ?? Colors.white,
        borderRadius: BorderRadius.circular(radius ?? AppThemeInfo.borderRadius),
        type: MaterialType.button,
        child: InkWell(
          borderRadius: BorderRadius.circular(radius ?? AppThemeInfo.borderRadius),
          onTap: onPressed,
          onLongPress: onLongPressed,
          child: child,
        ),
      ),
    );
  }
}