import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_logo.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      Get.offAllNamed('/login');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.splashBg,
      body: Stack(
        children: [
          // Decorative circles
          Positioned(
            top: -80.h,
            left: -60.w,
            child: _circle(220.w, Colors.white.withValues(alpha: 0.08)),
          ),
          Positioned(
            top: 120.h,
            right: -90.w,
            child: _circle(180.w, Colors.white.withValues(alpha: 0.06)),
          ),
          Positioned(
            bottom: -100.h,
            left: 40.w,
            child: _circle(260.w, Colors.white.withValues(alpha: 0.07)),
          ),
          Positioned(
            bottom: 60.h,
            right: -40.w,
            child: _circle(140.w, Colors.white.withValues(alpha: 0.05)),
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const AppLogo(size: 96, backgroundColor: Colors.white, iconColor: AppColors.primary),
                SizedBox(height: 24.h),
                Text('TEST', style: AppTextStyles.splashTitle),
                SizedBox(height: 8.h),
                Text('Plan your day. Achieve more.', style: AppTextStyles.splashTagline),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _circle(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
    );
  }
}
