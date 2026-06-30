import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import 'package:my_app/core/constants/app_route_names.dart';
import 'package:my_app/presentation/controllers/auth_controller.dart';

/// GetX route middleware that bouncer-unauthenticated traffic to
/// the Login page.
///
/// Usage in router.dart:
/// ```dart
/// GetPage(
///   name: AppRoutes.home,
///   page: () => const NetflixHomePage(),
///   middlewares: [AuthGuard()],
/// )
/// ```
///
/// On every navigation attempt, the guard:
/// 1. Looks up the AuthController (registered in InitialBinding).
/// 2. Waits for the first non-`unknown` auth state (so we don't flash
///    the login screen during the brief moment before Firebase resolves
///    the persisted session).
/// 3. Routes:
///    - signedIn  → continue as normal.
///    - signedOut → redirect to `/login` and store the intended
///      destination for after-login deep-linking return.
class AuthGuard extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final auth = Get.find<AuthController>();
    final status = auth.status.value;

    // Wait: while status is `unknown`, allow the navigation but the UI
    // must show a loading screen (handled by the page itself). We don't
    // redirect to /login in this state.
    if (status == AuthStatus.unknown) return null;

    if (status == AuthStatus.signedOut) {
      // Save the original destination so login can return us.
      final redirectTo =
          (route == null || route == AppRoutes.login) ? null : RouteSettings(name: route);
      return RouteSettings(
        name: AppRoutes.login,
        arguments: redirectTo,
      );
    }
    return null;
  }
}
