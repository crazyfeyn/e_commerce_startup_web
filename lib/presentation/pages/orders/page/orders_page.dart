import 'package:e_commerce_startup_web/core/utils/app_colors.dart';
import 'package:e_commerce_startup_web/core/utils/app_enums.dart';
import 'package:e_commerce_startup_web/core/utils/locale_keys.g.dart';
import 'package:e_commerce_startup_web/presentation/pages/orders/viewmodel/orders_viewmodel.dart';
import 'package:e_commerce_startup_web/presentation/pages/orders/widgets/order_detail_dialog.dart';
import 'package:e_commerce_startup_web/presentation/pages/orders/widgets/order_helpers.dart';
import 'package:e_commerce_startup_web/presentation/pages/orders/widgets/sample.dart';
import 'package:e_commerce_startup_web/presentation/pages/orders/widgets/update_status_dialod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrdersPage extends StatelessWidget {
  static const String path = "/orders";

  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => OrdersViewmodel(),
      child: Consumer<OrdersViewmodel>(
        builder: (_, viewmodel, __) {
          return Scaffold(
            appBar: AppBar(title: Text(context.tr(LocaleKeys.menu_orders))),
            body: viewmodel.formzStatus.isInProgress
                ? const Center(child: CircularProgressIndicator())
                : viewmodel.orders.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          CupertinoIcons.shopping_cart,
                          size: 80,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          context.tr(LocaleKeys.no_orders_found),
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  )
                : SingleChildScrollView(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width - 1,
                        ),
                        child: DataTable(
                          columnSpacing: 16,
                          horizontalMargin: 16,
                          // ignore: deprecated_member_use
                          dataRowHeight: 80,
                          headingRowHeight: 56,
                          columns: [
                            DataColumn(
                              label: SizedBox(
                                width: 80,
                                child: Text(
                                  context.tr(LocaleKeys.order_id),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            DataColumn(
                              label: SizedBox(
                                width: 160,
                                child: Text(
                                  context.tr(LocaleKeys.customer_info),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            DataColumn(
                              label: SizedBox(
                                width: 140,
                                child: Text(
                                  context.tr(LocaleKeys.products),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            DataColumn(
                              label: SizedBox(
                                width: 100,
                                child: Text(
                                  context.tr(LocaleKeys.total_price),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            DataColumn(
                              label: SizedBox(
                                width: 100,
                                child: Text(
                                  context.tr(LocaleKeys.order_status),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            DataColumn(
                              label: SizedBox(
                                width: 100,
                                child: Text(
                                  context.tr(LocaleKeys.payment_method),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            DataColumn(
                              label: SizedBox(
                                width: 90,
                                child: Text(
                                  context.tr(LocaleKeys.order_date),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            DataColumn(
                              label: SizedBox(
                                width: 80,
                                child: Text(
                                  context.tr(LocaleKeys.actions),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ],
                          rows: List.generate(Sample.sampleOrders.length, (
                            index,
                          ) {
                            final order = Sample.sampleOrders[index];
                            return DataRow(
                              cells: [
                                DataCell(
                                  SizedBox(
                                    width: 80,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 6,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.blue.shade50,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        "#${order.orderId}",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: Colors.blue.shade700,
                                          fontSize: 12,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                ),
                                DataCell(
                                  SizedBox(
                                    width: 160,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          order.receiverName,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 12,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          order.receiverPhone,
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: Colors.grey.shade600,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          order.receiverAddress,
                                          style: TextStyle(
                                            fontSize: 9,
                                            color: Colors.grey.shade500,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                DataCell(
                                  SizedBox(
                                    width: 140,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 6,
                                            vertical: 2,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.green.shade50,
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          child: Text(
                                            "${order.products.length} items",
                                            style: TextStyle(
                                              fontSize: 9,
                                              color: Colors.green.shade700,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        if (order.products.isNotEmpty) ...[
                                          Text(
                                            "• ${order.products.first.titleData?.getTitle(context.locale.languageCode) ?? 'N/A'}",
                                            style: const TextStyle(fontSize: 9),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          ),
                                          if (order.products.length > 1) ...[
                                            Text(
                                              "• ${order.products[1].titleData?.getTitle(context.locale.languageCode) ?? 'N/A'}",
                                              style: const TextStyle(
                                                fontSize: 9,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                            ),
                                          ],
                                          if (order.products.length > 2)
                                            Text(
                                              "...+${order.products.length - 2} more",
                                              style: TextStyle(
                                                fontSize: 9,
                                                color: Colors.grey.shade600,
                                                fontStyle: FontStyle.italic,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                        ],
                                      ],
                                    ),
                                  ),
                                ),
                                DataCell(
                                  SizedBox(
                                    width: 100,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "${(order.totalPrice / 1000000).toStringAsFixed(1)}M",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 14,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          order.currency.toUpperCase(),
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: Colors.grey.shade600,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                DataCell(
                                  SizedBox(
                                    width: 100,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 6,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: getStatusColor(
                                          order.orderStatus,
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        getStatusText(
                                          context,
                                          order.orderStatus,
                                        ),
                                        style: TextStyle(
                                          fontSize: 9,
                                          fontWeight: FontWeight.w600,
                                          color: getStatusTextColor(
                                            order.orderStatus,
                                          ),
                                        ),
                                        textAlign: TextAlign.center,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                ),
                                DataCell(
                                  SizedBox(
                                    width: 100,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 6,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade100,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        getPaymentMethodText(
                                          context,
                                          order.paymentMethod,
                                        ),
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.grey.shade700,
                                        ),
                                        textAlign: TextAlign.center,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                ),
                                DataCell(
                                  SizedBox(
                                    width: 90,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          DateFormat(
                                            'dd.MM.yyyy',
                                          ).format(order.createdAt),
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 11,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          DateFormat(
                                            'HH:mm',
                                          ).format(order.createdAt),
                                          style: TextStyle(
                                            fontSize: 9,
                                            color: Colors.grey.shade600,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                DataCell(
                                  SizedBox(
                                    width: 80,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: 28,
                                          height: 28,
                                          child: IconButton(
                                            padding: EdgeInsets.zero,
                                            constraints: const BoxConstraints(),
                                            onPressed: () => showOrderDetails(
                                              context,
                                              order,
                                            ),
                                            icon: Icon(
                                              CupertinoIcons.eye,
                                              size: 14,
                                              color: Colors.blue.shade600,
                                            ),
                                            tooltip: context.tr(
                                              LocaleKeys.view_details,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        SizedBox(
                                          width: 28,
                                          height: 28,
                                          child: IconButton(
                                            padding: EdgeInsets.zero,
                                            constraints: const BoxConstraints(),
                                            onPressed: () =>
                                                showUpdateStatusDialog(
                                                  context,
                                                  order,
                                                  viewmodel,
                                                ),
                                            icon: Icon(
                                              CupertinoIcons.pencil,
                                              size: 14,
                                              color: AppColors.warning400,
                                            ),
                                            tooltip: context.tr(
                                              LocaleKeys.update_status,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }),
                        ),
                      ),
                    ),
                  ),
          );
        },
      ),
    );
  }
}
