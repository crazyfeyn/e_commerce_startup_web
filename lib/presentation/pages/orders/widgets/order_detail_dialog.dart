import 'package:e_commerce_startup_web/data/models/order_product_model.dart';
import 'package:e_commerce_startup_web/presentation/pages/orders/widgets/order_helpers.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/utils/locale_keys.g.dart';

String _getProductDisplayName(OrderProductModel product) {
  return "Product #${product.productId}";
}

void showOrderDetails(BuildContext context, dynamic order) {
  print("📦 Showing order details for ID: ${order.orderId}");
  print("🖼️ Products count: ${order.products.length}");

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        clipBehavior: Clip.antiAlias,
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.58,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.fromLTRB(24, 20, 20, 20),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF4F46E5), Color(0xFF6366F1)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        CupertinoIcons.shopping_cart,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            context.tr(LocaleKeys.order),
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.75),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            "#${order.orderId}",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(
                        CupertinoIcons.xmark,
                        color: Colors.white,
                        size: 18,
                      ),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.white.withOpacity(0.15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Body
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Two-column top section
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: _buildSection(
                              context: context,
                              icon: CupertinoIcons.person_circle,
                              iconColor: const Color(0xFF4F46E5),
                              title: context.tr(
                                LocaleKeys.customer_information,
                              ),
                              children: [
                                _buildInfoTile(
                                  icon: CupertinoIcons.person,
                                  label: context.tr(LocaleKeys.name),
                                  value: order.receiverName,
                                ),
                                _buildInfoTile(
                                  icon: CupertinoIcons.phone,
                                  label: context.tr(LocaleKeys.phone),
                                  value: order.receiverPhone,
                                ),
                                _buildInfoTile(
                                  icon: CupertinoIcons.location,
                                  label: context.tr(LocaleKeys.address),
                                  value: order.receiverAddress,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildSection(
                              context: context,
                              icon: CupertinoIcons.doc_text,
                              iconColor: Colors.teal.shade600,
                              title: context.tr(LocaleKeys.order_information),
                              children: [
                                _buildInfoTile(
                                  icon: CupertinoIcons.circle_fill,
                                  label: context.tr(LocaleKeys.order_status),
                                  value: getStatusText(
                                    context,
                                    order.orderStatus,
                                  ),
                                  valueColor: getStatusTextColor(
                                    order.orderStatus,
                                  ),
                                ),
                                _buildInfoTile(
                                  icon: CupertinoIcons.creditcard,
                                  label: context.tr(LocaleKeys.payment_method),
                                  value: order.paymentMethod != null
                                      ? getPaymentMethodText(
                                          context,
                                          order.paymentMethod,
                                        )
                                      : "-",
                                ),
                                _buildInfoTile(
                                  icon: CupertinoIcons.money_dollar_circle,
                                  label: context.tr(LocaleKeys.total_price),
                                  value:
                                      "${NumberFormat('#,###').format(order.totalPrice)} ${order.currency.toUpperCase()}",
                                  valueColor: Colors.green.shade700,
                                  valueBold: true,
                                ),
                                _buildInfoTile(
                                  icon: CupertinoIcons.calendar,
                                  label: context.tr(LocaleKeys.order_date),
                                  value: DateFormat(
                                    'dd MMM yyyy · HH:mm',
                                  ).format(order.createdAt),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Products section
                      _buildSection(
                        context: context,
                        icon: CupertinoIcons.cube_box,
                        iconColor: Colors.orange.shade600,
                        title:
                            "${context.tr(LocaleKeys.products)}  ·  ${order.products.length} items",
                        children: [
                          ...order.products.asMap().entries.map<Widget>((
                            entry,
                          ) {
                            final int idx = entry.key;
                            final OrderProductModel product = entry.value;
                            return Padding(
                              padding: EdgeInsets.only(
                                bottom: idx < order.products.length - 1
                                    ? 10
                                    : 0,
                              ),
                              child: _buildProductCard(product),
                            );
                          }).toList(),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Footer
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F9FC),
                  border: Border(
                    top: BorderSide(color: const Color(0xFFEEF0F4)),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    FilledButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFF4F46E5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                      child: Text(context.tr(LocaleKeys.close)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

Widget _buildSection({
  required BuildContext context,
  required IconData icon,
  required Color iconColor,
  required String title,
  required List<Widget> children,
}) {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: const Color(0xFFEEF0F4)),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.03),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, size: 14, color: iconColor),
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 13,
                color: Color(0xFF111827),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        const Divider(height: 1, color: Color(0xFFEEF0F4)),
        const SizedBox(height: 12),
        ...children,
      ],
    ),
  );
}

Widget _buildInfoTile({
  required IconData icon,
  required String label,
  required String value,
  Color? valueColor,
  bool valueBold = false,
}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 13, color: Colors.grey.shade400),
        const SizedBox(width: 8),
        SizedBox(
          width: 90,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade500,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 12,
              fontWeight: valueBold ? FontWeight.w700 : FontWeight.w500,
              color: valueColor ?? const Color(0xFF111827),
            ),
          ),
        ),
      ],
    ),
  );
}

Widget _buildProductCard(OrderProductModel product) {
  return Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: const Color(0xFFF8F9FC),
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: const Color(0xFFEEF0F4)),
    ),
    child: Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: const Color(0xFFEEF2FF),
          ),
          child: const Icon(
            CupertinoIcons.cube_box_fill,
            size: 22,
            color: Color(0xFF4F46E5),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _getProductDisplayName(product),
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  color: Color(0xFF111827),
                ),
              ),
              const SizedBox(height: 3),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      "Qty: ${product.amount}",
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Text(
          NumberFormat('#,###').format(product.price),
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 14,
            color: Colors.green,
          ),
        ),
      ],
    ),
  );
}
