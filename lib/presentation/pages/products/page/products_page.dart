import 'package:e_commerce_startup_web/core/utils/app_colors.dart';
import 'package:e_commerce_startup_web/core/utils/app_enums.dart';
import 'package:e_commerce_startup_web/core/utils/app_styles.dart';
import 'package:e_commerce_startup_web/core/utils/locale_keys.g.dart';
import 'package:e_commerce_startup_web/presentation/pages/products/viewmodel/products_viewmodel.dart';
import 'package:e_commerce_startup_web/presentation/pages/products/widget/product_dialog.dart';
import 'package:e_commerce_startup_web/presentation/widgets/network_image_loader.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductsPage extends StatelessWidget {
  static const String path = "/products";

  const ProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ProductsViewmodel(),
      child: Consumer<ProductsViewmodel>(
        builder: (_, viewmodel, __) {
          return Scaffold(
            appBar: AppBar(title: Text(context.tr(LocaleKeys.menu_products))),
            body: viewmodel.formzStatus.isInProgress
                ? Center(child: CircularProgressIndicator())
                : GridView.builder(
                    padding: EdgeInsets.only(
                      left: 16,
                      right: 16,
                      top: 16,
                      bottom: 128,
                    ),
                    itemCount: viewmodel.products.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: onCount(context),
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      final product = viewmodel.products[index];
                      return Card(
                        color: AppColors.white50,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: InkWell(
                          onTap: () {
                            ProductDialog.productShowDialog(
                              context: context,
                              product: product,
                              onTap: (files, updatedProduct) =>
                                  viewmodel.editProduct(files, updatedProduct),
                            );
                          },
                          borderRadius: BorderRadius.circular(16),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Container(
                                    color: AppColors.primary50,
                                    child: Stack(
                                      children: [
                                        ImageCarousel(
                                          urls: product.images ?? [],
                                        ),
                                        Positioned(
                                          top: 8,
                                          right: 8,
                                          child: IconButton(
                                            onPressed: () {
                                              showDialog(
                                                context: context,
                                                builder: (ctx) => AlertDialog(
                                                  title: Text(
                                                    context.tr(
                                                      LocaleKeys.delete_product,
                                                    ),
                                                  ),
                                                  content: Text(
                                                    context.tr(
                                                      LocaleKeys
                                                          .are_you_sure_delete_product,
                                                    ),
                                                  ),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () =>
                                                          Navigator.of(
                                                            ctx,
                                                          ).pop(),
                                                      child: Text(
                                                        context.tr(
                                                          LocaleKeys.cancel,
                                                        ),
                                                      ),
                                                    ),
                                                    ElevatedButton(
                                                      style:
                                                          ElevatedButton.styleFrom(
                                                            backgroundColor:
                                                                AppColors
                                                                    .red500,
                                                          ),
                                                      onPressed: () {
                                                        Navigator.of(ctx).pop();
                                                        viewmodel.deleteProduct(
                                                          product.id,
                                                        );
                                                      },
                                                      child: Text(
                                                        context.tr(
                                                          LocaleKeys.delete,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                            style: IconButton.styleFrom(
                                              backgroundColor:
                                                  AppColors.white50,
                                              maximumSize: Size(32, 32),
                                              minimumSize: Size(32, 32),
                                              shape: CircleBorder(),
                                            ),
                                            icon: Icon(
                                              CupertinoIcons.delete,
                                              size: 16,
                                              color: AppColors.red500,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              product.titleData?.getTitle(
                                                    context.locale.languageCode,
                                                  ) ??
                                                  "",
                                              style: AppStyles.titleLGSemibold,
                                            ),
                                          ),
                                          Text(
                                            "${product.price ?? ""} ${product.currency ?? ""}",
                                            style: AppStyles.bodySMRegular,
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 12),
                                      Text(
                                        product.description ?? "",
                                        style: AppStyles.bodySMRegular.copyWith(
                                          color: AppColors.black500,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                ProductDialog.productShowDialog(
                  context: context,
                  onTap: (files, newProduct) =>
                      viewmodel.createProduct(newProduct, files),
                );
              },
              child: Icon(Icons.add, size: 32),
            ),
          );
        },
      ),
    );
  }

  int onCount(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    if (width <= 600) {
      return 1;
    } else if (width > 600 && width < 1024) {
      return 2;
    } else {
      return 3;
    }
  }
}
