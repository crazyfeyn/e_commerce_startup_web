import 'package:e_commerce_startup_web/core/utils/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class OrdersPage extends StatelessWidget {
  static const String path = "/orders";

  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.tr(LocaleKeys.menu_orders))),
    );
  }
}
