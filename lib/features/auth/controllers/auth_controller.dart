import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/network/api_client.dart';
import '../../../core/storage/token_storage.dart';

class AuthController extends GetxController {
  AuthController({ApiClient? apiClient, TokenStorage? tokenStorage})
      : _apiClient = apiClient ?? ApiClient(),
        _tokenStorage = tokenStorage ?? TokenStorage();

  final ApiClient _apiClient;
  final TokenStorage _tokenStorage;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final obscurePassword = true.obs;

  Future<void> login() async {
    if (isLoading.value) return;

    final email = emailController.text.trim();
    final password = passwordController.text;

    if (!GetUtils.isEmail(email)) {
      errorMessage.value = 'Please enter a valid email address.';
      return;
    }
    if (password.isEmpty) {
      errorMessage.value = 'Please enter your password.';
      return;
    }

    isLoading.value = true;
    errorMessage.value = '';

    try {
      final response = await _apiClient.login(email: email, password: password);
      if (response.success && response.data != null) {
        final dataMap = response.data!;
        final token = dataMap['accessToken'] ??
            dataMap['token'] ??
            dataMap['data']?['accessToken'] ??
            dataMap['data']?['token'] ??
            (dataMap['data'] is String ? dataMap['data'] : null) ??
            dataMap['meta']?['accessToken'];

        if (token is String && token.isNotEmpty) {
          await _tokenStorage.saveToken(token);
          Get.offAllNamed('/dashboard');
        } else {
          errorMessage.value = 'Login failed. Token not received.';
        }
      } else {
        errorMessage.value = response.message;
      }
    } catch (_) {
      errorMessage.value = 'Login failed. Please try again.';
    } finally {
      isLoading.value = false;
    }
  }

  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
