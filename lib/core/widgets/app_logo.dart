import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theme/app_colors.dart';

class AppLogo extends StatelessWidget {
  final double size;
  final Color backgroundColor;
  final Color iconColor;
  final bool withShadow;

  const AppLogo({
    super.key,
    this.size = 72,
    this.backgroundColor = Colors.white,
    this.iconColor = AppColors.primary,
    this.withShadow = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.w,
      height: size.w,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular((size * 0.28).r),
        boxShadow: withShadow
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ]
            : null,
      ),
      child: Center(
        child: Icon(
          Icons.check_rounded,
          color: iconColor,
          size: (size * 0.55).sp,
        ),
      ),
    );
  }
}