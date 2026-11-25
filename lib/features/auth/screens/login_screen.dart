import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:my_gallery/features/auth/screens/widgets/input_field.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_logo.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../core/widgets/social_button.dart';
import '../controllers/auth_controller.dart';

class LoginScreen extends GetView<AuthController> {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16.h),
              Align(
                alignment: Alignment.centerLeft,
                child: AppLogo(size: 72, withShadow: true),
              ),
              SizedBox(height: 24.h),
              Text('Welcome back', style: AppTextStyles.title),
              SizedBox(height: 6.h),
              Text(
                'Log in to continue managing your tasks.',
                style: AppTextStyles.subtitle,
              ),
              SizedBox(height: 32.h),
              Text('Email', style: AppTextStyles.label),
              SizedBox(height: 8.h),
              InputField(
                controller: controller.emailController,
                hint: 'you@example.com',
                icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 18.h),
              Text('Password', style: AppTextStyles.label),
              SizedBox(height: 8.h),
              Obx(
                () => InputField(
                  controller: controller.passwordController,
                  hint: '••••••••',
                  icon: Icons.lock_outline,
                  obscureText: controller.obscurePassword.value,
                  suffixIcon: IconButton(
                    icon: Icon(
                      controller.obscurePassword.value
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: AppColors.iconGrey,
                      size: 20.sp,
                    ),
                    onPressed: controller.togglePasswordVisibility,
                  ),
                ),
              ),
              SizedBox(height: 12.h),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'Forgot password?',
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.primary,
                  ),
                ),
              ),
              SizedBox(height: 12.h),
              Obx(
                () => controller.errorMessage.value.isEmpty
                    ? const SizedBox.shrink()
                    : Padding(
                        padding: EdgeInsets.only(bottom: 12.h),
                        child: Text(
                          controller.errorMessage.value,
                          style: TextStyle(color: Colors.red, fontSize: 13.sp),
                        ),
                      ),
              ),
              Obx(
                () => PrimaryButton(
                  text: controller.isLoading.value ? 'Logging in...' : 'Login',
                  onPressed: controller.isLoading.value ? null : controller.login,
                ),
              ),
              SizedBox(height: 24.h),
              Row(
                children: [
                  Expanded(child: Divider(color: AppColors.border)),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    child: Text('or continue with', style: AppTextStyles.small),
                  ),
                  Expanded(child: Divider(color: AppColors.border)),
                ],
              ),
              SizedBox(height: 20.h),
              Row(
                children: [
                  SocialButton(
                    icon: Icon(Icons.g_mobiledata, size: 24.sp, color: Colors.red),
                    label: 'Google',
                    onPressed: () {},
                  ),
                  SizedBox(width: 12.w),
                  SocialButton(
                    icon: Icon(Icons.apple, size: 22.sp, color: Colors.black),
                    label: 'Apple',
                    onPressed: () {},
                  ),
                ],
              ),
              SizedBox(height: 28.h),
              Center(
                child: RichText(
                  text: TextSpan(
                    style: AppTextStyles.small,
                    children: [
                      const TextSpan(text: "Don't have an account? "),
                      TextSpan(
                        text: 'Sign up',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                          fontSize: 12.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }
}

