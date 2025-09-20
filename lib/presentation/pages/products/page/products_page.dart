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
                            onTap: viewmodel.editProduct
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
                                      ImageCarousel(urls: product.images ?? []),

                                      Positioned(
                                        top: 8,
                                        right: 8,
                                        child: IconButton(
                                          onPressed: () => viewmodel.deleteProduct(product.id),
                                          style: IconButton.styleFrom(
                                            backgroundColor: AppColors.white50,
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            product.titleData?.getTitle(context.locale.languageCode) ?? "",
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

            //: SingleChildScrollView(
            //                     child: SingleChildScrollView(
            //                       scrollDirection: Axis.horizontal,
            //                       child: DataTable(
            //                         dataRowMaxHeight: 100,
            //                         columns: [
            //                           DataColumn(label: Text(context.tr(LocaleKeys.id))),
            //                           DataColumn(
            //                             label: Text(
            //                               context.tr(LocaleKeys.product_name_uz_title),
            //                             ),
            //                           ),
            //                           DataColumn(
            //                             label: Text(
            //                               context.tr(LocaleKeys.product_name_kr_title),
            //                             ),
            //                           ),
            //                           DataColumn(
            //                             label: Text(
            //                               context.tr(LocaleKeys.product_name_en_title),
            //                             ),
            //                           ),
            //
            //                           DataColumn(
            //                             label: Text(
            //                               context.tr(LocaleKeys.product_amount_title),
            //                             ),
            //                           ),
            //                           DataColumn(
            //                             label: Text(
            //                               context.tr(LocaleKeys.product_price_title),
            //                             ),
            //                           ),
            //                           DataColumn(
            //                             label: Text(
            //                               context.tr(LocaleKeys.product_currency_title),
            //                             ),
            //                           ),
            //                           DataColumn(
            //                             label: Text(
            //                               context.tr(LocaleKeys.product_brand_title),
            //                             ),
            //                           ),
            //
            //                           DataColumn(
            //                             label: Text(
            //                               context.tr(LocaleKeys.product_prompt_title),
            //                             ),
            //                           ),
            //                           DataColumn(
            //                             label: Text(
            //                               context.tr(LocaleKeys.product_image_title),
            //                             ),
            //                           ),
            //                           DataColumn(label: Text("")),
            //                         ],
            //                         rows: List.generate(viewmodel.products.length, (index) {
            //                           final product = viewmodel.products[index];
            //                           return DataRow(
            //                             cells: [
            //                               DataCell(
            //                                 Text(
            //                                   product.id?.toString() ??
            //                                       context.tr(LocaleKeys.not_found),
            //                                 ),
            //                               ),
            //                               DataCell(
            //                                 Text(
            //                                   product.titleData?.uz ??
            //                                       context.tr(LocaleKeys.not_found),
            //                                 ),
            //                               ),
            //                               DataCell(
            //                                 Text(
            //                                   product.titleData?.kor ??
            //                                       context.tr(LocaleKeys.not_found),
            //                                 ),
            //                               ),
            //                               DataCell(
            //                                 Text(
            //                                   product.titleData?.en ??
            //                                       context.tr(LocaleKeys.not_found),
            //                                 ),
            //                               ),
            //
            //                               DataCell(Text(product.amount?.toString() ?? "0")),
            //                               DataCell(Text(product.price?.toString() ?? "0")),
            //                               DataCell(
            //                                 Text(
            //                                   product.currency ??
            //                                       context.tr(LocaleKeys.not_found),
            //                                 ),
            //                               ),
            //                               DataCell(
            //                                 Text(
            //                                   product.brand ??
            //                                       context.tr(LocaleKeys.not_found),
            //                                 ),
            //                               ),
            //
            //                               DataCell(
            //                                 Text(
            //                                   product.description ??
            //                                       context.tr(LocaleKeys.not_found),
            //                                   maxLines: 3,
            //                                   overflow: TextOverflow.ellipsis,
            //                                 ),
            //                               ),
            //                               DataCell(
            //                                 SizedBox(
            //                                   height: 100,
            //                                   width: 100,
            //                                   child: PhotoViewGallery.builder(
            //                                     scrollPhysics:
            //                                         const BouncingScrollPhysics(),
            //                                     builder: (BuildContext context, int index) {
            //                                       return PhotoViewGalleryPageOptions(
            //                                         imageProvider: NetworkImage(
            //                                           NetworkService.apiFileDownload(
            //                                             (product.images ?? [])[index],
            //                                           ),
            //                                         ),
            //                                         initialScale:
            //                                             PhotoViewComputedScale.contained *
            //                                             0.8,
            //                                       );
            //                                     },
            //                                     itemCount: product.images?.length ?? 0,
            //                                     loadingBuilder: (context, event) => Center(
            //                                       child: Container(
            //                                         width: 20.0,
            //                                         height: 20.0,
            //                                         child: CircularProgressIndicator(
            //                                           value: event == null
            //                                               ? 0
            //                                               : event.cumulativeBytesLoaded /
            //                                                     (event.expectedTotalBytes ??
            //                                                         1),
            //                                         ),
            //                                       ),
            //                                     ),
            //                                   ),
            //                                 ),
            //                               ),
            //                               DataCell(
            //                                 showEditIcon: true,
            //                                 onTap: () {},
            //                                 IconButton(
            //                                   onPressed: () {},
            //                                   icon: Icon(
            //                                     CupertinoIcons.delete,
            //                                     size: 16,
            //                                     color: AppColors.red500,
            //                                   ),
            //                                 ),
            //                               ),
            //                             ],
            //                           );
            //                         }),
            //                       ),
            //                     ),
            //                   ),

            floatingActionButton: FloatingActionButton(
              onPressed: () {
                ProductDialog.productShowDialog(
                  context: context,
                  onTap: (f, p) => viewmodel.createProduct(p),
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
