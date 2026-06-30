import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:my_app/core/constants/app_theme.dart';
import 'package:my_app/core/constants/app_dimensions.dart';
import 'package:my_app/core/constants/app_route_names.dart';
import 'package:my_app/presentation/controllers/auth_controller.dart';

/// Email/password registration screen.
class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController auth = Get.find<AuthController>();
    final emailCtrl = TextEditingController();
    final passCtrl = TextEditingController();
    final nameCtrl = TextEditingController();

    return Scaffold(
      backgroundColor: AppTheme.primaryBlack,
      appBar: AppBar(
        title: const Text('Create Account'),
        backgroundColor: AppTheme.secondaryBlack,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppDimensions.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: AppDimensions.md),
                TextField(
                  controller: nameCtrl,
                  style: const TextStyle(color: AppTheme.primaryText),
                  decoration: _decoration('Display name (optional)'),
                ),
                const SizedBox(height: AppDimensions.md),
                TextField(
                  controller: emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(color: AppTheme.primaryText),
                  decoration: _decoration('Email'),
                ),
                const SizedBox(height: AppDimensions.md),
                TextField(
                  controller: passCtrl,
                  obscureText: true,
                  style: const TextStyle(color: AppTheme.primaryText),
                  decoration: _decoration('Password (min 6 chars)'),
                ),
                const SizedBox(height: AppDimensions.md),
                Obx(() => Text(
                      auth.errorMessage.value,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: AppTheme.accentColor),
                    )),
                const SizedBox(height: AppDimensions.sm),
                Obx(() => ElevatedButton(
                      onPressed: auth.isLoading.value
                          ? null
                          : () async {
                              final ok = await auth.signUp(
                                email: emailCtrl.text,
                                password: passCtrl.text,
                                displayName: nameCtrl.text.trim().isEmpty
                                    ? null
                                    : nameCtrl.text.trim(),
                              );
                              if (ok) Get.offAllNamed(AppRoutes.home);
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.accentColor,
                        foregroundColor: AppTheme.primaryText,
                        minimumSize: const Size.fromHeight(48),
                      ),
                      child: auth.isLoading.value
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppTheme.primaryText,
                              ),
                            )
                          : const Text('Sign Up'),
                    )),
                const SizedBox(height: AppDimensions.md),
                TextButton(
                  onPressed: () => Get.back(),
                  child: const Text('Already have an account? Sign in'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _decoration(String label) => InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: AppTheme.lightGrey),
        filled: true,
        fillColor: AppTheme.darkGrey,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          borderSide: BorderSide.none,
        ),
      );
}
