import 'package:e_commerce_startup_web/core/utils/app_colors.dart';
import 'package:e_commerce_startup_web/core/utils/app_enums.dart';
import 'package:e_commerce_startup_web/core/utils/app_styles.dart';
import 'package:e_commerce_startup_web/core/utils/locale_keys.g.dart';
import 'package:e_commerce_startup_web/data/datasources/network/network_service.dart';
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
            backgroundColor: const Color(0xFFF4F6FA),
            appBar: _buildAppBar(context, viewmodel),
            body: viewmodel.formzStatus.isInProgress
                ? _buildLoading()
                : viewmodel.products.isEmpty
                ? _buildEmpty(context)
                : _buildProductGrid(context, viewmodel),
            floatingActionButton: _buildFab(context, viewmodel),
          );
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(
    BuildContext context,
    ProductsViewmodel viewmodel,
  ) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(height: 1, color: const Color(0xFFE5E7EB)),
      ),
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF3E0),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              CupertinoIcons.square_grid_2x2,
              size: 18,
              color: Color(0xFFF97316),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            context.tr(LocaleKeys.menu_products),
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 18,
              color: Color(0xFF111827),
            ),
          ),
          if (!viewmodel.formzStatus.isInProgress &&
              viewmodel.products.isNotEmpty) ...[
            const SizedBox(width: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: const Color(0xFFF97316),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '${viewmodel.products.length}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildLoading() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            width: 40,
            height: 40,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              color: Color(0xFFF97316),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Loading products...',
            style: TextStyle(color: Colors.grey.shade500, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildEmpty(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Icon(
              CupertinoIcons.square_grid_2x2,
              size: 44,
              color: Colors.grey.shade400,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            context.tr(LocaleKeys.menu_products),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'No products yet. Tap + to add one.',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }

  Widget _buildProductGrid(BuildContext context, ProductsViewmodel viewmodel) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: _crossAxisCount(context),
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
          childAspectRatio: 0.75, // makes cards taller
        ),
        itemCount: viewmodel.products.length,
        itemBuilder: (context, index) {
          final product = viewmodel.products[index];
          return _buildProductCard(context, product, viewmodel);
        },
      ),
    );
  }

  Widget _buildProductCard(
    BuildContext context,
    dynamic product,
    ProductsViewmodel viewmodel,
  ) {
    final imageUrl = (product.images != null && product.images!.isNotEmpty)
        ? "${NetworkService.getService}${NetworkService.apiFileDownload(product.images!.first)}"
        : null;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image section
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                  child: imageUrl != null
                      ? NetworkImageLoader(
                          url: imageUrl,
                          width: double.infinity,
                          height: 160,
                          fit: BoxFit.cover,
                        )
                      : Container(
                          height: 160,
                          color: const Color(0xFFF8F9FC),
                          child: Center(
                            child: Icon(
                              CupertinoIcons.photo,
                              size: 40,
                              color: Colors.grey.shade400,
                            ),
                          ),
                        ),
                ),
                // Delete button (top right)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: IconButton(
                      onPressed: () =>
                          _showDeleteConfirmation(context, product, viewmodel),
                      icon: Icon(
                        CupertinoIcons.delete,
                        size: 14,
                        color: AppColors.red500,
                      ),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding: const EdgeInsets.all(6),
                        minimumSize: const Size(28, 28),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // Details
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.titleData?.getTitle(context.locale.languageCode) ??
                        'No name',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF111827),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        product.brand ?? '',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade500,
                        ),
                      ),
                      Text(
                        "${product.price?.toStringAsFixed(0) ?? '0'} ${product.currency?.toUpperCase() ?? ''}",
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFFF97316),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  if (product.amount != null)
                    Text(
                      "Stock: ${product.amount}",
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey.shade400,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFab(BuildContext context, ProductsViewmodel viewmodel) {
    return FloatingActionButton.extended(
      onPressed: () {
        ProductDialog.productShowDialog(
          context: context,
          onTap: (files, newProduct) =>
              viewmodel.createProduct(newProduct, files),
        );
      },
      backgroundColor: const Color(0xFFF97316),
      foregroundColor: Colors.white,
      elevation: 2,
      icon: const Icon(Icons.add, size: 20),
      label: Text(
        context.tr(LocaleKeys.add_product),
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
      ),
    );
  }

  void _showDeleteConfirmation(
    BuildContext context,
    dynamic product,
    ProductsViewmodel viewmodel,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.red.shade100,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        CupertinoIcons.delete,
                        color: AppColors.red500,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        ctx.tr(LocaleKeys.delete_product),
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                          color: Color(0xFF111827),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  ctx.tr(LocaleKeys.are_you_sure_delete_product),
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                    height: 1.5,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(ctx).pop(),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          side: const BorderSide(color: Color(0xFFD1D5DB)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          ctx.tr(LocaleKeys.cancel),
                          style: const TextStyle(
                            color: Color(0xFF374151),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: FilledButton(
                        onPressed: () {
                          Navigator.of(ctx).pop();
                          viewmodel.deleteProduct(product.id);
                        },
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.red500,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          ctx.tr(LocaleKeys.delete),
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  int _crossAxisCount(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < 800) return 2;
    if (width < 1200) return 3;
    return 4;
  }
}
