import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parcking_slot_booking/features/Auth/Services/auth_services.dart';


class AuthController extends GetxController {
  final AuthService _authService = AuthService();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final mobileController = TextEditingController();

  var isPasswordHidden = true.obs; // 👈 for eye toggle

  void signUp() async {
    try {
      final user = await _authService.signUp(
        emailController.text.trim(),
        passwordController.text.trim(),
        mobileController.text.trim(),
      );
      if (user != null) {
        Get.snackbar("Success", "Account created for ${user.email}");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }
  void signIn() async {
  try {
    final user = await _authService.signIn(
      emailController.text.trim(),
      passwordController.text.trim(),
    );
    if (user != null) {
      Get.snackbar("Success", "Welcome back, ${user.email}");
          Get.offAllNamed('/parking');
    }
  } catch (e) {
    Get.snackbar("Error", e.toString());
  }
}


  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    mobileController.dispose();
    super.onClose();
  }
}
