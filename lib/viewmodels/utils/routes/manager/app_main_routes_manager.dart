import 'package:bom_hamburguer/viewmodels/utils/routes/main_routes.dart';
import 'package:bom_hamburguer/views/checkout_screen.dart';
import 'package:bom_hamburguer/views/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NavigationService {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
}

final router = GoRouter(
  navigatorKey: NavigationService.navigatorKey,
  initialLocation: MainRoutes.home.route,
  observers: [],
  routes: [
    GoRoute(
      path: MainRoutes.home.route,
      name: MainRoutes.home.name,
      pageBuilder: (context, state) => MaterialPage(
        child: const HomeScreen(),
        name: state.name,
      ),
    ),
    GoRoute(
      path: MainRoutes.checkout.route,
      name: MainRoutes.checkout.name,
      pageBuilder: (context, state) => MaterialPage(
        child: const CheckoutScreen(),
        name: state.name,
      ),
    ),
  ],
);
