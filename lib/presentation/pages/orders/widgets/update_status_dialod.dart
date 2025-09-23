import 'package:e_commerce_startup_web/core/utils/locale_keys.g.dart';
import 'package:e_commerce_startup_web/presentation/pages/orders/viewmodel/orders_viewmodel.dart';
import 'package:e_commerce_startup_web/presentation/pages/orders/widgets/order_helpers.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

void showUpdateStatusDialog(
  BuildContext context,
  dynamic order,
  OrdersViewmodel viewmodel,
) {
  final statuses = [
    'pending',
    'confirmed',
    'processing',
    'shipped',
    'delivered',
    'cancelled',
  ];

  String selectedStatus = order.orderStatus;

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text(
              "${context.tr(LocaleKeys.update_order_status)} #${order.orderId}",
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.tr(LocaleKeys.select_new_status),
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 12),
                ...statuses.map((status) {
                  return RadioListTile<String>(
                    title: Text(getStatusText(context, status)),
                    value: status,
                    groupValue: selectedStatus,
                    onChanged: (value) {
                      setState(() {
                        selectedStatus = value!;
                      });
                    },
                    dense: true,
                  );
                }).toList(),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(context.tr(LocaleKeys.cancel)),
              ),
              ElevatedButton(
                onPressed: selectedStatus != order.orderStatus
                    ? () {
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              "${context.tr(LocaleKeys.order_status_updated)} #${order.orderId}",
                            ),
                            backgroundColor: Colors.green,
                          ),
                        );
                      }
                    : null,
                child: Text(context.tr(LocaleKeys.update)),
              ),
            ],
          );
        },
      );
    },
  );
}
