import 'package:e_commerce_startup_web/core/utils/app_enums.dart';
import 'package:e_commerce_startup_web/core/utils/app_styles.dart';
import 'package:e_commerce_startup_web/core/utils/locale_keys.g.dart';
import 'package:e_commerce_startup_web/presentation/pages/products/viewmodel/products_viewmodel.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SoldProductsPage extends StatelessWidget {
  static const String path = "/soldProducts";

  const SoldProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ProductsViewmodel()..fetchProducts(),
      child: Consumer<ProductsViewmodel>(
        builder: (context, viewmodel, _) {
          return Scaffold(
            appBar: AppBar(
              title: Text(context.tr(LocaleKeys.menu_sold_products)),
            ),
            body: viewmodel.formzStatus.isInProgress
                ? const Center(child: CircularProgressIndicator())
                : ListView.separated(
                    padding: const EdgeInsets.only(bottom: 64),
                    itemCount: viewmodel.products.length,
                    itemBuilder: (context, index) {
                      final product = viewmodel.products[index];
                      return ListTile(
                        leading: Text(
                          "${index + 1}",
                          style: AppStyles.labelLGSemibold,
                        ),
                        title: Text(
                          product.titleData?.getTitle(
                                context.locale.languageCode,
                              ) ??
                              "",
                          style: AppStyles.titleSMMedium,
                        ),
                        trailing: Text(
                          "${product.totalSoldAmount ?? 0}",
                          style: AppStyles.titleSMMedium,
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return const Divider();
                    },
                  ),
          );
        },
      ),
    );
  }
}

//sadasd
