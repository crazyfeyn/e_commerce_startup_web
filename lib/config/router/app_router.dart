import 'package:e_commerce_startup_web/data/datasources/database/db_service.dart';
import 'package:e_commerce_startup_web/presentation/pages/categories/page/categories_page.dart';
import 'package:e_commerce_startup_web/presentation/pages/sold_products/page/sold_products.dart';
import 'package:e_commerce_startup_web/presentation/pages/login/page/login_page.dart';
import 'package:e_commerce_startup_web/presentation/pages/orders/page/orders_page.dart';
import 'package:e_commerce_startup_web/presentation/pages/products/page/products_page.dart';
import 'package:e_commerce_startup_web/presentation/widgets/admin_shell.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

import 'navigation_service.dart';

class AppRouter {
  static final router = GoRouter(
    observers: [NavigationService.routeObserver],
    navigatorKey: NavigationService.navigatorKey,
    initialLocation: LoginPage.path,
    redirect: (context, state) {
      print(state.fullPath);
      final loggedIn = DBService.ensure.isLoggedIn();
      final loggingIn = state.fullPath?.contains(LoginPage.path) ?? false;

      // If the user is not logged in, they need to login
      if (!loggedIn && !loggingIn) return LoginPage.path;

      // If the user is logged in but tries to go to login, send them home
      if (loggedIn && loggingIn) return OrdersPage.path;

      // No redirect
      return null;
    },
    routes: [
      GoRoute(
        path: LoginPage.path,
        pageBuilder: (context, state) => const MaterialPage(child: LoginPage()),
      ),

      /// Admin layout uchun ShellRoute
      ShellRoute(
        builder: (context, state, child) {
          return AdminShell(
            key: state.pageKey,
            currentRoute: state.uri.path,
            child: child,
          );
        },
        routes: [
          GoRoute(
            path: OrdersPage.path,
            builder: (context, state) => const OrdersPage(),
          ),
          GoRoute(
            path: CategoriesPage.path,
            builder: (context, state) => const CategoriesPage(),
          ),
          GoRoute(
            path: ProductsPage.path,
            builder: (context, state) => const ProductsPage(),
          ),
          GoRoute(
            path: SoldProductsPage.path,
            builder: (context, state) => const SoldProductsPage(),
          ),
        ],
      ),
    ],
  );

  AppRouter._();
}
