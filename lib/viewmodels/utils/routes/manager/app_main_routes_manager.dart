import 'package:bom_hamburguer/views/cart_screen.dart';
import 'package:bom_hamburguer/views/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NavigationService {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
}

final router = GoRouter(
  navigatorKey: NavigationService.navigatorKey,
  initialLocation: '/',
  observers: [],
  routes: [
    GoRoute(
      path: '/',
      name: 'home',
      pageBuilder: (context, state) => MaterialPage(
        child: const HomeScreen(),
        name: state.name,
      ),
    ),
    GoRoute(
      path: '/cart',
      name: 'cart',
      pageBuilder: (context, state) {
        return MaterialPage(
          child: CartScreen(),
          name: state.name,
        );
      },
    ),
  ],
);
