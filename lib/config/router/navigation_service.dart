import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NavigationService {
  static int pushCount = 4;
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

  static void countAds(BuildContext context) {
    pushCount++;
  }

  static BuildContext? get context => navigatorKey.currentContext;

  static void pop<T extends Object?>(BuildContext context, [T? result]) {
    context.pop(result);
  }

  static go(BuildContext context, String location, {Object? extra}) {
    context.go(location, extra: extra);
  }

  static Future<T?> push<T extends Object?>(
    BuildContext context,
    String location, {
    Object? extra,
  }) async {
    pushCount++;
    return context.push(location, extra: extra);
  }

  static void pushReplacement(
    BuildContext context,
    String location, {
    Object? extra,
  }) async {
    pushCount++;
    return context.pushReplacement(location, extra: extra);
  }
}
