import 'package:e_commerce_startup_web/core/utils/app_enums.dart';
import 'package:e_commerce_startup_web/core/utils/app_styles.dart';
import 'package:e_commerce_startup_web/core/utils/locale_keys.g.dart';
import 'package:e_commerce_startup_web/presentation/pages/products/viewmodel/products_viewmodel.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
          // Filter products that have been sold (totalSoldAmount > 0)
          final soldProducts = viewmodel.products
              .where((p) => (p.totalSoldAmount ?? 0) > 0)
              .toList();
          final totalRevenue = soldProducts.fold<double>(
            0,
            (sum, p) => sum + ((p.price ?? 0) * (p.totalSoldAmount ?? 0)),
          );

          return Scaffold(
            backgroundColor: const Color(0xFFF4F6FA),
            appBar: _buildAppBar(context, soldProducts.length),
            body: viewmodel.formzStatus.isInProgress
                ? _buildLoading()
                : soldProducts.isEmpty
                ? _buildEmpty(context)
                : _buildSoldProductsTable(context, soldProducts, totalRevenue),
          );
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, int soldCount) {
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
              CupertinoIcons.chart_bar,
              size: 18,
              color: Color(0xFFF97316),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            context.tr(LocaleKeys.menu_sold_products),
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 18,
              color: Color(0xFF111827),
            ),
          ),
          if (soldCount > 0) ...[
            const SizedBox(width: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: const Color(0xFFF97316),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '$soldCount',
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
            'Loading sold products...',
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
            child: const Icon(
              CupertinoIcons.chart_bar,
              size: 44,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            context.tr(LocaleKeys.menu_sold_products),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'No sold products yet.',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }

  Widget _buildSoldProductsTable(
    BuildContext context,
    List<dynamic> soldProducts,
    double totalRevenue,
  ) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Container(
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
        child: Column(
          children: [
            // Header row
            Container(
              height: 44,
              decoration: const BoxDecoration(
                color: Color(0xFFF8F9FC),
                border: Border(bottom: BorderSide(color: Color(0xFFE5E7EB))),
              ),
              child: Row(
                children: [
                  _buildHeaderCell(context.tr(LocaleKeys.id), flex: 1),
                  _buildHeaderCell(
                    context.tr(LocaleKeys.product_name),
                    flex: 4,
                  ),
                  _buildHeaderCell(context.tr(LocaleKeys.sold_amount), flex: 2),
                  _buildHeaderCell(
                    context.tr(LocaleKeys.total_revenue),
                    flex: 2,
                  ),
                ],
              ),
            ),
            // List of sold products
            Expanded(
              child: ListView.separated(
                itemCount: soldProducts.length,
                separatorBuilder: (_, __) =>
                    const Divider(height: 0, thickness: 1),
                itemBuilder: (context, index) {
                  final product = soldProducts[index];
                  final soldAmount = product.totalSoldAmount ?? 0;
                  final revenue = (product.price ?? 0) * soldAmount;
                  return Container(
                    height: 56,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        _buildDataCell('#${index + 1}', flex: 1),
                        _buildDataCell(
                          product.titleData?.getTitle(
                                context.locale.languageCode,
                              ) ??
                              'N/A',
                          flex: 4,
                          isBold: true,
                        ),
                        _buildDataCell(
                          NumberFormat('#,###').format(soldAmount),
                          flex: 2,
                        ),
                        _buildDataCell(
                          '${NumberFormat('#,###').format(revenue)} ${product.currency?.toUpperCase() ?? ''}',
                          flex: 2,
                          isPrice: true,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            // Footer: total revenue summary
            Container(
              height: 52,
              decoration: const BoxDecoration(
                color: Color(0xFFF8F9FC),
                border: Border(top: BorderSide(color: Color(0xFFE5E7EB))),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(flex: 5, child: Container()),
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Total Revenue:',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                        color: Colors.grey.shade700,
                      ),
                      textAlign: TextAlign.end,
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      '${NumberFormat('#,###').format(totalRevenue)} ${soldProducts.isNotEmpty ? soldProducts.first.currency?.toUpperCase() ?? '' : ''}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 14,
                        color: Color(0xFFF97316),
                      ),
                      textAlign: TextAlign.end,
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

  Widget _buildHeaderCell(String text, {required int flex}) {
    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Text(
          text.toUpperCase(),
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 11,
            color: Color(0xFF6B7280),
            letterSpacing: 0.5,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  Widget _buildDataCell(
    String text, {
    required int flex,
    bool isBold = false,
    bool isPrice = false,
  }) {
    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isBold ? FontWeight.w600 : FontWeight.w400,
            color: isPrice ? const Color(0xFFF97316) : const Color(0xFF374151),
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
