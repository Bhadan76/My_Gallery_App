import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  static TextStyle get splashTitle => TextStyle(
        fontSize: 32.sp,
        fontWeight: FontWeight.w700,
        color: Colors.white,
        letterSpacing: 2,
      );

  static TextStyle get splashTagline => TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w400,
        color: Colors.white70,
      );

  static TextStyle get title => TextStyle(
        fontSize: 26.sp,
        fontWeight: FontWeight.w700,
        color: AppColors.textDark,
      );

  static TextStyle get subtitle => TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w400,
        color: AppColors.textGrey,
      );

  static TextStyle get body => TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w400,
        color: AppColors.textDark,
      );

  static TextStyle get label => TextStyle(
        fontSize: 13.sp,
        fontWeight: FontWeight.w500,
        color: AppColors.textDark,
      );

  static TextStyle get button => TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      );

  static TextStyle get small => TextStyle(
        fontSize: 12.sp,
        fontWeight: FontWeight.w400,
        color: AppColors.textGrey,
      );
}
