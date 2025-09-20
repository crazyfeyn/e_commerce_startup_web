import 'package:e_commerce_startup_web/core/utils/app_styles.dart';
import 'package:e_commerce_startup_web/core/utils/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class CitiesPage extends StatelessWidget {
  static const String path = "/cities";

  const CitiesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.tr(LocaleKeys.menu_cities))),
      body: ListView.separated(
        padding: EdgeInsets.only(bottom: 64),
        itemCount: 100,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Text("${index + 1}", style: AppStyles.labelLGSemibold),
            title: Text("Seoul shahri", style: AppStyles.titleSMMedium),
            trailing: Text("10 ta", style: AppStyles.titleSMMedium),
          );
        },
        separatorBuilder: (context, index) {
          return Divider();
        },
      ),
    );
  }
}
