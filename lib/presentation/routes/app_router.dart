import 'package:get/get.dart';

import 'package:my_app/presentation/pages/home_page.dart';
import 'package:my_app/presentation/pages/search_page.dart';
import 'package:my_app/presentation/pages/watchlist_page.dart';
import 'package:my_app/presentation/pages/profile_page.dart';

/// Centralizes all route definitions for the application.
/// Using a named route approach makes navigation type-safe and easy to manage.
/// With GetX, we define routes in a list of [GetPage] objects.
///
/// Benefits of this approach:
/// 1. No typos in route strings (use [Routes.home] instead of "/home").
/// 2. Easy to pass arguments and handle deep linking.
/// 3. Clean separation of navigation logic.
class AppRouter {
  AppRouter._(); // Private constructor to prevent instantiation

  static const String home = '/home';
  static const String search = '/search';
  static const String watchlist = '/watchlist';
  static const String profile = '/profile';

  // Add more routes here as the app grows (e.g., details, player)

  /// The list of pages used by GetX for navigation.
  /// Each [GetPage] defines a path and the widget to render.
  static final routes = [
    GetPage(name: home, page: () => const HomePage()),
    GetPage(name: search, page: () => const SearchPage()),
    GetPage(name: watchlist, page: () => const WatchlistPage()),
    GetPage(name: profile, page: () => const ProfilePage()),
  ];
}
