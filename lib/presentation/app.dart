import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:my_app/core/constants/app_theme.dart';
import 'package:my_app/presentation/routes/app_router.dart';

/// The root widget of the application.
/// 
/// We use [GetMaterialApp] instead of [MaterialApp] because it provides
/// the necessary infrastructure for GetX (state management, dependency injection, 
/// and navigation).
///
/// This is the entry point where we inject our dependencies and configure
/// the application's global settings.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flixify',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      // Use the centralized route definition for GetX navigation.
      getPages: AppRouter.routes,
      // Start the app at the home page. In the future, we might check 
      // auth state here to decide between LoginPage and HomePage.
      initialRoute: AppRouter.home,
    );
  }
}
