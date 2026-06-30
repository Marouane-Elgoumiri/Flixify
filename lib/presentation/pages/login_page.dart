import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:my_app/core/constants/app_theme.dart';
import 'package:my_app/core/constants/app_route_names.dart';
import 'package:my_app/core/constants/app_dimensions.dart';
import 'package:my_app/presentation/controllers/auth_controller.dart';

/// Email/password login screen.
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController auth = Get.find<AuthController>();
    final emailCtrl = TextEditingController();
    final passCtrl = TextEditingController();

    // If we were navigated here by the AuthGuard, arguments may carry
    // the original destination so we can deep-link back.
    final deepLink = Get.arguments is RouteSettings
        ? (Get.arguments as RouteSettings).name
        : AppRoutes.home;

    return Scaffold(
      backgroundColor: AppTheme.primaryBlack,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppDimensions.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: AppDimensions.xxl),
                const Text(
                  'Welcome back',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppTheme.primaryText,
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppDimensions.xs),
                const Text(
                  'Sign in to access your watchlist and continue watching.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppTheme.lightGrey),
                ),
                const SizedBox(height: AppDimensions.xl),
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
                  decoration: _decoration('Password'),
                ),
                const SizedBox(height: AppDimensions.md),
                Obx(() {
                  if (auth.errorMessage.value.isEmpty) {
                    return const SizedBox.shrink();
                  }
                  return Padding(
                    padding: const EdgeInsets.only(bottom: AppDimensions.md),
                    child: Text(
                      auth.errorMessage.value,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: AppTheme.accentColor),
                    ),
                  );
                }),
                Obx(() => ElevatedButton(
                      onPressed: auth.isLoading.value
                          ? null
                          : () async {
                              final ok = await auth.signIn(
                                email: emailCtrl.text,
                                password: passCtrl.text,
                              );
                              if (ok) {
                                Get.offAllNamed(deepLink ?? AppRoutes.home);
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
                                color: AppTheme.primaryText,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text('Sign In'),
                    )),
                const SizedBox(height: AppDimensions.md),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () => Get.toNamed(AppRoutes.forgotPassword),
                      child: const Text('Forgot password?'),
                    ),
                    TextButton(
                      onPressed: () => Get.toNamed(AppRoutes.register),
                      child: const Text('Create account'),
                    ),
                  ],
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
