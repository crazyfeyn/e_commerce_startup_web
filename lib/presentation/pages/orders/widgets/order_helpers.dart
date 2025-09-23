import 'package:e_commerce_startup_web/core/utils/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

Color getStatusColor(String status) {
  switch (status.toLowerCase()) {
    case 'pending':
      return Colors.orange.shade50;
    case 'confirmed':
      return Colors.blue.shade50;
    case 'processing':
      return Colors.purple.shade50;
    case 'shipped':
      return Colors.teal.shade50;
    case 'delivered':
      return Colors.green.shade50;
    case 'cancelled':
      return Colors.red.shade50;
    default:
      return Colors.grey.shade50;
  }
}

Color getStatusTextColor(String status) {
  switch (status.toLowerCase()) {
    case 'pending':
      return Colors.orange.shade700;
    case 'confirmed':
      return Colors.blue.shade700;
    case 'processing':
      return Colors.purple.shade700;
    case 'shipped':
      return Colors.teal.shade700;
    case 'delivered':
      return Colors.green.shade700;
    case 'cancelled':
      return Colors.red.shade700;
    default:
      return Colors.grey.shade700;
  }
}

String getStatusText(BuildContext context, String status) {
  // You'll need to add these to your LocaleKeys
  switch (status.toLowerCase()) {
    case 'pending':
      return context.tr(LocaleKeys.status_pending);
    case 'confirmed':
      return context.tr(LocaleKeys.status_confirmed);
    case 'processing':
      return context.tr(LocaleKeys.status_processing);
    case 'shipped':
      return context.tr(LocaleKeys.status_shipped);
    case 'delivered':
      return context.tr(LocaleKeys.status_delivered);
    case 'cancelled':
      return context.tr(LocaleKeys.status_cancelled);
    default:
      return status;
  }
}

String getPaymentMethodText(BuildContext context, String method) {
  // You'll need to add these to your LocaleKeys
  switch (method.toLowerCase()) {
    case 'cash':
      return context.tr(LocaleKeys.payment_cash);
    case 'card':
      return context.tr(LocaleKeys.payment_card);
    case 'online':
      return context.tr(LocaleKeys.payment_online);
    default:
      return method;
  }
}
