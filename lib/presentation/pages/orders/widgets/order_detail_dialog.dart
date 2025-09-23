import 'package:e_commerce_startup_web/data/datasources/network/network_service.dart';
import 'package:e_commerce_startup_web/presentation/pages/orders/widgets/detail_row_widget.dart';
import 'package:e_commerce_startup_web/presentation/pages/orders/widgets/detail_section_widget.dart';
import 'package:e_commerce_startup_web/presentation/pages/orders/widgets/order_helpers.dart';
import 'package:e_commerce_startup_web/presentation/widgets/network_image_loader.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/locale_keys.g.dart';

void showOrderDetails(BuildContext context, dynamic order) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("${context.tr(LocaleKeys.order)} #${order.orderId}"),
        content: Container(
          width: MediaQuery.of(context).size.width * 0.6,
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.7,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildDetailSection(
                  context,
                  context.tr(LocaleKeys.customer_information),
                  [
                    buildDetailRow(
                      context.tr(LocaleKeys.name),
                      order.receiverName,
                    ),
                    buildDetailRow(
                      context.tr(LocaleKeys.phone),
                      order.receiverPhone,
                    ),
                    buildDetailRow(
                      context.tr(LocaleKeys.address),
                      order.receiverAddress,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                buildDetailSection(
                  context,
                  context.tr(LocaleKeys.order_information),
                  [
                    buildDetailRow(
                      context.tr(LocaleKeys.order_status),
                      getStatusText(context, order.orderStatus),
                    ),
                    buildDetailRow(
                      context.tr(LocaleKeys.payment_method),
                      getPaymentMethodText(context, order.paymentMethod),
                    ),
                    buildDetailRow(
                      context.tr(LocaleKeys.total_price),
                      "${order.totalPrice.toStringAsFixed(2)} ${order.currency.toUpperCase()}",
                    ),
                    buildDetailRow(
                      context.tr(LocaleKeys.order_date),
                      DateFormat('dd.MM.yyyy HH:mm').format(order.createdAt),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                buildDetailSection(
                  context,
                  "${context.tr(LocaleKeys.products)} (${order.products.length})",
                  order.products.map<Widget>((product) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          if (product.images?.isNotEmpty == true)
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              clipBehavior: Clip.antiAlias,
                              child: NetworkImageLoader(
                                url:
                                    "${NetworkService.getService}${NetworkService.apiFileDownload(product.images!.first)}",
                                width: 40,
                                height: 40,
                              ),
                            )
                          else
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color: Colors.grey.shade200,
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              child: Icon(
                                CupertinoIcons.photo,
                                size: 20,
                                color: Colors.grey.shade500,
                              ),
                            ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product.titleData?.getTitle(
                                        context.locale.languageCode,
                                      ) ??
                                      'N/A',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                if (product.brand?.isNotEmpty == true)
                                  Text(
                                    product.brand!,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                Text(
                                  "${product.price?.toStringAsFixed(2) ?? '0.00'} ${product.currency?.toUpperCase() ?? ''}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.green,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(context.tr(LocaleKeys.close)),
          ),
        ],
      );
    },
  );
}
