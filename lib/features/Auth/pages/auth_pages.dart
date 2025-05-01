import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parcking_slot_booking/features/Auth/controllers/auth_controller.dart';


class SignUpPage extends GetView<AuthController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEFEFF2),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                )
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "SIGN UP",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                _buildTextField(controller.emailController, "Mail id"),
                SizedBox(height: 12),
                _buildTextField(controller.mobileController, "Mobile Number"),
                SizedBox(height: 12),
                Obx(() => _buildPasswordField()), // Use Obx for eye toggle
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: controller.signUp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    minimumSize: Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text("SIGN UP"),
                ),
                SizedBox(height: 10),
                TextButton(
                  onPressed: () => Get.toNamed('/signin'),
                  child: Text("Already have an account? SIGN IN"),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint, {bool isPassword = false}) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      keyboardType: hint == "Mail id"
          ? TextInputType.emailAddress
          : hint == "Mobile Number"
              ? TextInputType.phone
              : TextInputType.text,
      decoration: InputDecoration(
        hintText: hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Widget _buildPasswordField() {
    final controller = Get.find<AuthController>();
    return TextField(
      controller: controller.passwordController,
      obscureText: controller.isPasswordHidden.value,
      decoration: InputDecoration(
        hintText: "Password",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        suffixIcon: IconButton(
          icon: Icon(
            controller.isPasswordHidden.value
                ? Icons.visibility_off
                : Icons.visibility,
          ),
          onPressed: () {
            controller.isPasswordHidden.toggle();
          },
        ),
      ),
    );
  }
}
