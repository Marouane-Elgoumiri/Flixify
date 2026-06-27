import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:my_app/core/constants/app_theme.dart';
import 'package:my_app/presentation/bindings/initial_binding.dart';
import 'package:my_app/presentation/routes/app_router.dart';

/// The root widget of the application.
///
/// We use [GetMaterialApp] instead of [MaterialApp] because it provides
/// the necessary infrastructure for GetX (state management, dependency injection,
/// and navigation).
///
/// `initialBinding` is registered so GetX sets up our DI graph BEFORE any
/// page renders. This guarantees that controllers can resolve their
/// dependencies synchronously in their constructors.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flixify',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      initialBinding: InitialBinding(),
      getPages: AppRouter.routes,
      initialRoute: AppRouter.initialRoute,
    );
  }
}
