import 'package:e_commerce_startup_web/core/utils/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

// Real backend statuses: NEW, PAYMENT_CREATED, PAYMENT_FAILED, PAYMENT_SUCCEEDED, CANCELLED, DONE, PROCESSING (rare)
Color getStatusColor(String status) {
  switch (status.toUpperCase()) {
    case 'NEW':
      return Colors.orange.shade50;
    case 'PAYMENT_CREATED':
      return Colors.blue.shade50;
    case 'PAYMENT_FAILED':
      return Colors.red.shade50;
    case 'PAYMENT_SUCCEEDED':
      return Colors.green.shade50;
    case 'CANCELLED':
      return Colors.red.shade50;
    case 'DONE':
      return Colors.teal.shade50;
    case 'PROCESSING':
      return Colors.purple.shade50;
    default:
      return Colors.grey.shade50;
  }
}

Color getStatusTextColor(String status) {
  switch (status.toUpperCase()) {
    case 'NEW':
      return Colors.orange.shade700;
    case 'PAYMENT_CREATED':
      return Colors.blue.shade700;
    case 'PAYMENT_FAILED':
      return Colors.red.shade700;
    case 'PAYMENT_SUCCEEDED':
      return Colors.green.shade700;
    case 'CANCELLED':
      return Colors.red.shade700;
    case 'DONE':
      return Colors.teal.shade700;
    case 'PROCESSING':
      return Colors.purple.shade700;
    default:
      return Colors.grey.shade700;
  }
}

String getStatusText(BuildContext context, String status) {
  switch (status.toUpperCase()) {
    case 'NEW':
      return context.tr(LocaleKeys.status_new);
    case 'PAYMENT_CREATED':
      return context.tr(LocaleKeys.status_payment_created);
    case 'PAYMENT_FAILED':
      return context.tr(LocaleKeys.status_payment_failed);
    case 'PAYMENT_SUCCEEDED':
      return context.tr(LocaleKeys.status_payment_succeeded);
    case 'CANCELLED':
      return context.tr(LocaleKeys.status_cancelled);
    case 'DONE':
      return context.tr(LocaleKeys.status_done);
    case 'PROCESSING':
      return context.tr(LocaleKeys.status_processing);
    default:
      return status;
  }
}

String getPaymentMethodText(BuildContext context, String method) {
  // Backend payment method enum: CARD, VIRTUAL_ACCOUNT, MOBILE_PHONE, TRANSFER, FOREIGN_EASY_PAY
  switch (method.toUpperCase()) {
    case 'CARD':
      return context.tr(LocaleKeys.payment_card);
    case 'VIRTUAL_ACCOUNT':
      return context.tr(LocaleKeys.payment_virtual_account);
    case 'MOBILE_PHONE':
      return context.tr(LocaleKeys.payment_mobile_phone);
    case 'TRANSFER':
      return context.tr(LocaleKeys.payment_transfer);
    case 'FOREIGN_EASY_PAY':
      return context.tr(LocaleKeys.payment_foreign_easy_pay);
    default:
      return method;
  }
}
