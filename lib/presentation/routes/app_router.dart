import 'package:get/get.dart';

import 'package:my_app/core/constants/app_route_names.dart';
import 'package:my_app/core/middleware/auth_guard.dart';
import 'package:my_app/presentation/pages/forgot_password_page.dart';
import 'package:my_app/presentation/pages/home_page_section1.dart';
import 'package:my_app/presentation/pages/login_page.dart';
import 'package:my_app/presentation/pages/movie_details_page.dart';
import 'package:my_app/presentation/pages/movies_page.dart';
import 'package:my_app/presentation/pages/netflix_home_page.dart';
import 'package:my_app/presentation/pages/player_page.dart';
import 'package:my_app/presentation/pages/profile_page.dart';
import 'package:my_app/presentation/pages/register_page.dart';
import 'package:my_app/presentation/pages/search_page.dart';
import 'package:my_app/presentation/pages/watchlist_page.dart';

/// Centralizes route definitions + their auth posture.
///
/// Routes guarded by [AuthGuard] redirect to `/login` if the user is
/// signed-out. Once the user signs in, the redirect-after-login logic
/// inside [LoginPage] (via `Get.arguments`) sends them back.
class AppRouter {
  AppRouter._();

  /// Default landing route. We LAND on the home and let the guard
  /// bounce us to /login if needed.
  static String get initialRoute => AppRoutes.home;

  /// ROUTES: only the auth screens are public; everything else is
  /// guarded so unauthenticated users land on /login.
  static final routes = [
    GetPage(name: AppRoutes.login, page: () => const LoginPage()),
    GetPage(
        name: AppRoutes.register, page: () => const RegisterPage()),
    GetPage(
        name: AppRoutes.forgotPassword,
        page: () => const ForgotPasswordPage()),

    // ─── guarded routes ───
    GetPage(
      name: AppRoutes.home,
      page: () => const NetflixHomePage(),
      middlewares: [AuthGuard()],
    ),
    GetPage(
      name: AppRoutes.search,
      page: () => const SearchPage(),
      middlewares: [AuthGuard()],
    ),
    GetPage(
      name: AppRoutes.watchlist,
      page: () => const WatchlistPage(),
      middlewares: [AuthGuard()],
    ),
    GetPage(
      name: AppRoutes.profile,
      page: () => const ProfilePage(),
      middlewares: [AuthGuard()],
    ),

    // ─── Section 6: details + player ───
    GetPage(
      name: '/details',
      page: () {
        // Get.arguments carries a Movie instance.
        final dynamic movie = Get.arguments;
        return MovieDetailsPage(movie: movie);
      },
      middlewares: [AuthGuard()],
    ),
    GetPage(
      name: '/player',
      page: () => const PlayerPage(),
      middlewares: [AuthGuard()],
    ),

    // ─── legacy/demo routes (also guarded) ───
    GetPage(
      name: '/movies',
      page: () => const MoviesPage(),
      middlewares: [AuthGuard()],
    ),
    GetPage(
      name: '/section1',
      page: () => const HomePage(),
      middlewares: [AuthGuard()],
    ),
  ];
}
