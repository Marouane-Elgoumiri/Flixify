import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:my_app/core/constants/app_theme.dart';
import 'package:my_app/core/constants/app_dimensions.dart';
import 'package:my_app/presentation/controllers/auth_controller.dart';

/// Password-reset email screen.
class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController auth = Get.find<AuthController>();
    final emailCtrl = TextEditingController();

    return Scaffold(
      backgroundColor: AppTheme.primaryBlack,
      appBar: AppBar(
        title: const Text('Reset Password'),
        backgroundColor: AppTheme.secondaryBlack,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppDimensions.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'We will email you a reset link.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppTheme.lightGrey),
                ),
                const SizedBox(height: AppDimensions.lg),
                TextField(
                  controller: emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(color: AppTheme.primaryText),
                  decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: const TextStyle(color: AppTheme.lightGrey),
                    filled: true,
                    fillColor: AppTheme.darkGrey,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                          AppDimensions.radiusMd),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: AppDimensions.md),
                Obx(() => Text(
                      auth.errorMessage.value,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: AppTheme.accentColor),
                    )),
                Obx(() => ElevatedButton(
                      onPressed: auth.isLoading.value
                          ? null
                          : () async {
                              final ok =
                                  await auth.sendPasswordReset(emailCtrl.text);
                              if (ok) {
                                Get.snackbar(
                                  'Check your inbox',
                                  'We sent a password-reset link if the email is registered.',
                                  snackPosition: SnackPosition.BOTTOM,
                                );
                                Get.back();
                              }
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
                          : const Text('Send Reset Link'),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
