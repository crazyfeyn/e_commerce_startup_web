import 'package:e_commerce_startup_web/config/router/navigation_service.dart';
import 'package:e_commerce_startup_web/core/utils/app_colors.dart';
import 'package:e_commerce_startup_web/core/utils/app_styles.dart';
import 'package:e_commerce_startup_web/core/utils/locale_keys.g.dart';
import 'package:e_commerce_startup_web/presentation/pages/categories/page/categories_page.dart';
import 'package:e_commerce_startup_web/presentation/pages/sold_products/page/sold_products.dart';
import 'package:e_commerce_startup_web/presentation/pages/orders/page/orders_page.dart';
import 'package:e_commerce_startup_web/presentation/pages/products/page/products_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AdminShell extends StatefulWidget {
  final Widget child;
  final String currentRoute;

  const AdminShell({
    super.key,
    required this.child,
    required this.currentRoute,
  });

  @override
  State<AdminShell> createState() => _AdminShellState();
}

class _AdminShellState extends State<AdminShell> {
  final sideMenu = SideMenuController();
  int currentIndex = 0;

  @override
  void initState() {
    currentIndex = onCurrentIndex();
    sideMenu.changePage(currentIndex);
    super.initState();
  }

  @override
  void didUpdateWidget(covariant AdminShell oldWidget) {
    if (oldWidget.currentRoute != widget.currentRoute) {
      currentIndex = onCurrentIndex();
      sideMenu.changePage(currentIndex);
      if (mounted) setState(() {});
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: kIsWeb
          ? null
          : AppBar(title: Text(context.tr(LocaleKeys.admin_panel))),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SideMenu(
            controller: sideMenu,
            title: kIsWeb
                ? Container(
                    padding: EdgeInsets.symmetric(vertical: 24, horizontal: 12),
                    child: Text(
                      context.tr(LocaleKeys.admin_panel),
                      style: AppStyles.bodyXLSemibold,
                    ),
                  )
                : null,
            style: SideMenuStyle(
              displayMode: SideMenuDisplayMode.auto,
              hoverColor: AppColors.black200,
              selectedHoverColor: AppColors.primary600,
              selectedColor: AppColors.primary600,
              selectedTitleTextStyle: const TextStyle(color: AppColors.white50),
              selectedIconColor: AppColors.white50,
              selectedTitleTextStyleExpandable: const TextStyle(
                color: AppColors.primary600,
              ),
              backgroundColor: AppColors.black100,
            ),
            items: [
              SideMenuItem(
                title: context.tr(LocaleKeys.menu_orders),
                onTap: onChanged,
                icon: Icon(Icons.shopping_cart),
              ),
              SideMenuItem(
                title: context.tr(LocaleKeys.menu_categories),
                onTap: onChanged,
                icon: Icon(Icons.category),
              ),
              SideMenuItem(
                title: context.tr(LocaleKeys.menu_products),
                onTap: onChanged,
                icon: Icon(Icons.inventory),
              ),
              SideMenuItem(
                title: context.tr(LocaleKeys.menu_cities),
                onTap: onChanged,
                icon: Icon(Icons.location_city),
              ),
            ],
          ),
          Expanded(child: widget.child),
        ],
      ),
    );
  }

  void onChanged(int index, _) {
    final route = onNavigationPath(index);
    if (route != null) NavigationService.go(context, route);
  }

  String? onNavigationPath(int index) {
    if (currentIndex == index) return null;
    return switch (index) {
      0 => OrdersPage.path,
      1 => CategoriesPage.path,
      2 => ProductsPage.path,
      3 => SoldProductsPage.path,
      _ => OrdersPage.path,
    };
  }

  int onCurrentIndex() {
    return switch (widget.currentRoute) {
      final p when p.startsWith(OrdersPage.path) => 0,
      final p when p.startsWith(CategoriesPage.path) => 1,
      final p when p.startsWith(ProductsPage.path) => 2,
      final p when p.startsWith(SoldProductsPage.path) => 3,
      _ => 0,
    };
  }
}
