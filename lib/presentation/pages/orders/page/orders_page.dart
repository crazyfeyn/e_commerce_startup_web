import 'package:e_commerce_startup_web/core/utils/app_enums.dart';
import 'package:e_commerce_startup_web/core/utils/app_snackbar.dart';
import 'package:e_commerce_startup_web/core/utils/locale_keys.g.dart';
import 'package:e_commerce_startup_web/data/models/order_model.dart';
import 'package:e_commerce_startup_web/data/models/order_product_model.dart';
import 'package:e_commerce_startup_web/presentation/pages/orders/viewmodel/orders_viewmodel.dart';
import 'package:e_commerce_startup_web/presentation/pages/orders/widgets/order_detail_dialog.dart';
import 'package:e_commerce_startup_web/presentation/pages/orders/widgets/order_helpers.dart';
import 'package:e_commerce_startup_web/presentation/pages/orders/widgets/update_status_dialod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

// Flex weights for 7 columns: ID | Customer | Products | Price | Status | Date | Actions
const List<int> _flex = [1, 2, 2, 1, 2, 2, 2];

class OrdersPage extends StatelessWidget {
  static const String path = "/orders";

  const OrdersPage({super.key});

  Future<void> _handleConfirmOrder(
    BuildContext context,
    OrdersViewmodel viewmodel,
    OrderModel order,
  ) async {
    final shouldConfirm =
        await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    CupertinoIcons.check_mark_circled_solid,
                    color: Colors.green.shade600,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    ctx.tr(LocaleKeys.confirm_order),
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
            content: Text(
              ctx.tr(
                LocaleKeys.confirm_order_message,
                args: ['${order.orderId}'],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(false),
                child: Text(ctx.tr(LocaleKeys.cancel)),
              ),
              FilledButton(
                onPressed: () => Navigator.of(ctx).pop(true),
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.green.shade600,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(ctx.tr(LocaleKeys.confirm)),
              ),
            ],
          ),
        ) ??
        false;

    if (!shouldConfirm) return;
    final success = await viewmodel.confirmOrder(order.orderId);
    if (success) {
      GlobalSnackBar.showSuccess(context.tr(LocaleKeys.confirm_order_success));
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => OrdersViewmodel(),
      child: Consumer<OrdersViewmodel>(
        builder: (_, viewmodel, __) => Scaffold(
          backgroundColor: const Color(0xFFF4F6FA),
          appBar: _buildAppBar(context, viewmodel),
          body: viewmodel.formzStatus.isInProgress
              ? _buildLoading()
              : viewmodel.orders.isEmpty
              ? _buildEmpty(context)
              : _buildTable(context, viewmodel),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(
    BuildContext context,
    OrdersViewmodel viewmodel,
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
              color: const Color(0xFFEEF2FF),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              CupertinoIcons.shopping_cart,
              size: 18,
              color: Color(0xFF4F46E5),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            context.tr(LocaleKeys.menu_orders),
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 18,
              color: Color(0xFF111827),
            ),
          ),
          if (!viewmodel.formzStatus.isInProgress &&
              viewmodel.orders.isNotEmpty) ...[
            const SizedBox(width: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: const Color(0xFF4F46E5),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '${viewmodel.orders.length}',
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
              color: Color(0xFF4F46E5),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Loading orders...',
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
              CupertinoIcons.shopping_cart,
              size: 44,
              color: Colors.grey.shade400,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            context.tr(LocaleKeys.no_orders_found),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'New orders will appear here once received.',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }

  // ─── Table ────────────────────────────────────────────────────────────────

  Widget _buildTable(BuildContext context, OrdersViewmodel viewmodel) {
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
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Column(
            children: [
              _buildHeaderRow(context),
              Expanded(
                child: ListView.builder(
                  itemCount: viewmodel.orders.length,
                  itemBuilder: (context, i) =>
                      _buildDataRow(context, viewmodel, i),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderRow(BuildContext context) {
    final labels = [
      context.tr(LocaleKeys.order_id),
      context.tr(LocaleKeys.customer_info),
      context.tr(LocaleKeys.products),
      context.tr(LocaleKeys.total_price),
      context.tr(LocaleKeys.order_status),
      context.tr(LocaleKeys.order_date),
      context.tr(LocaleKeys.actions),
    ];

    return Container(
      height: 44,
      decoration: const BoxDecoration(
        color: Color(0xFFF8F9FC),
        border: Border(bottom: BorderSide(color: Color(0xFFE5E7EB))),
      ),
      child: Row(
        children: List.generate(
          labels.length,
          (i) => Expanded(
            flex: _flex[i],
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                labels[i].toUpperCase(),
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 11,
                  color: Colors.grey.shade500,
                  letterSpacing: 0.5,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDataRow(
    BuildContext context,
    OrdersViewmodel viewmodel,
    int index,
  ) {
    final order = viewmodel.orders[index];
    final bool canConfirm =
        order.orderStatus.toUpperCase() == 'PAYMENT_SUCCEEDED';
    final bool isConfirming = viewmodel.isOrderConfirming(order.orderId);
    final bool isLast = index == viewmodel.orders.length - 1;

    return Container(
      height: 72,
      decoration: BoxDecoration(
        color: Colors.white,
        border: isLast
            ? null
            : const Border(bottom: BorderSide(color: Color(0xFFF3F4F6))),
      ),
      child: Row(
        children: [
          // ── 1. Order ID ──────────────────────────────────────────────────
          Expanded(
            flex: _flex[0],
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEEF2FF),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    "#${order.orderId}",
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF4F46E5),
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // ── 2. Customer ───────────────────────────────────────────────────
          Expanded(
            flex: _flex[1],
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEEF2FF),
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: Center(
                      child: Text(
                        order.receiverName.isNotEmpty
                            ? order.receiverName[0].toUpperCase()
                            : '?',
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF4F46E5),
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          order.receiverName,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                            color: Color(0xFF111827),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          order.receiverPhone,
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade500,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          order.receiverAddress,
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey.shade400,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── 3. Products ───────────────────────────────────────────────────
          Expanded(
            flex: _flex[2],
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 7,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      "${order.products.length} items",
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.green.shade700,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  if (order.products.isNotEmpty)
                    _productLine(order.products.first),
                  if (order.products.length > 1)
                    _productLine(order.products[1]),
                  if (order.products.length > 2)
                    Text(
                      "+${order.products.length - 2} more",
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey.shade400,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                ],
              ),
            ),
          ),

          // ── 4. Price ──────────────────────────────────────────────────────
          Expanded(
            flex: _flex[3],
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    NumberFormat('#,###').format(order.totalPrice),
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      color: Color(0xFF111827),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 5,
                      vertical: 1,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F4F6),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      order.currency.toUpperCase(),
                      style: TextStyle(
                        fontSize: 9,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── 5. Status ─────────────────────────────────────────────────────
          Expanded(
            flex: _flex[4],
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Align(
                alignment: Alignment.centerLeft,
                child: _statusBadge(context, order.orderStatus),
              ),
            ),
          ),

          // ── 6. Date ───────────────────────────────────────────────────────
          Expanded(
            flex: _flex[5],
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    DateFormat('dd MMM yyyy').format(order.createdAt),
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                      color: Color(0xFF374151),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Icon(
                        CupertinoIcons.clock,
                        size: 10,
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(width: 3),
                      Text(
                        DateFormat('HH:mm').format(order.createdAt),
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade400,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // ── 7. Actions ────────────────────────────────────────────────────
          Expanded(
            flex: _flex[6],
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  if (canConfirm) ...[
                    _actionBtn(
                      onPressed: isConfirming
                          ? null
                          : () =>
                                _handleConfirmOrder(context, viewmodel, order),
                      icon: isConfirming
                          ? const SizedBox(
                              width: 14,
                              height: 14,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(
                              CupertinoIcons.check_mark_circled_solid,
                              size: 15,
                              color: Colors.white,
                            ),
                      bg: Colors.green.shade500,
                      tip: context.tr(LocaleKeys.confirm_order),
                    ),
                    const SizedBox(width: 6),
                  ],
                  _actionBtn(
                    onPressed: () => showOrderDetails(context, order),
                    icon: const Icon(
                      CupertinoIcons.eye_fill,
                      size: 14,
                      color: Color(0xFF4F46E5),
                    ),
                    bg: const Color(0xFFEEF2FF),
                    tip: context.tr(LocaleKeys.view_details),
                  ),
                  const SizedBox(width: 6),
                  _actionBtn(
                    onPressed: () =>
                        showUpdateStatusDialog(context, order, viewmodel),
                    icon: Icon(
                      CupertinoIcons.pencil,
                      size: 14,
                      color: Colors.orange.shade600,
                    ),
                    bg: Colors.orange.shade50,
                    tip: context.tr(LocaleKeys.update_status),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Helpers ──────────────────────────────────────────────────────────────

  Widget _productLine(OrderProductModel product) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 4,
            margin: const EdgeInsets.only(right: 5),
            decoration: BoxDecoration(
              color: Colors.grey.shade400,
              shape: BoxShape.circle,
            ),
          ),
          Expanded(
            child: Text(
              "Product #${product.productId}",
              style: const TextStyle(fontSize: 10, color: Color(0xFF6B7280)),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusBadge(BuildContext context, String status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: getStatusColor(status),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 5,
            height: 5,
            decoration: BoxDecoration(
              color: getStatusTextColor(status),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 5),
          Flexible(
            child: Text(
              getStatusText(context, status),
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: getStatusTextColor(status),
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionBtn({
    required VoidCallback? onPressed,
    required Widget icon,
    required Color bg,
    required String tip,
  }) {
    return Tooltip(
      message: tip,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: onPressed == null ? Colors.grey.shade100 : bg,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(child: icon),
        ),
      ),
    );
  }
}
