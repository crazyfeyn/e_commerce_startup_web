import 'package:flutter/material.dart';

Color getStatusColor(String status) {
  switch (status.toUpperCase()) {
    case 'NEW':
      return Colors.orange.shade50;
    case 'WAITING':
      return Colors.amber.shade50;
    case 'CONFIRMED':
      return Colors.indigo.shade50;
    case 'PAYMENT_CREATED':
      return Colors.blue.shade50;
    case 'PAYMENT_PENDING':
      return Colors.cyan.shade50;
    case 'PAYMENT_FAILED':
      return Colors.red.shade50;
    case 'PAYMENT_SUCCEEDED':
      return Colors.green.shade50;
    case 'DELIVERED':
      return Colors.teal.shade50;
    case 'COMPLETED':
      return Colors.teal.shade50;
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
    case 'WAITING':
      return Colors.amber.shade700;
    case 'CONFIRMED':
      return Colors.indigo.shade700;
    case 'PAYMENT_CREATED':
      return Colors.blue.shade700;
    case 'PAYMENT_PENDING':
      return Colors.cyan.shade700;
    case 'PAYMENT_FAILED':
      return Colors.red.shade700;
    case 'PAYMENT_SUCCEEDED':
      return Colors.green.shade700;
    case 'DELIVERED':
      return Colors.teal.shade700;
    case 'COMPLETED':
      return Colors.teal.shade700;
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

String getStatusText(String status) {
  switch (status.toUpperCase()) {
    case 'NEW':
      return 'New';
    case 'WAITING':
      return 'Pending';
    case 'CONFIRMED':
      return 'Confirmed';
    case 'PAYMENT_CREATED':
      return 'Payment created';
    case 'PAYMENT_PENDING':
      return 'Pending';
    case 'PAYMENT_FAILED':
      return 'Payment failed';
    case 'PAYMENT_SUCCEEDED':
      return 'Payment succeeded';
    case 'DELIVERED':
      return 'Delivered';
    case 'COMPLETED':
      return 'Completed';
    case 'CANCELLED':
      return 'Cancelled';
    case 'DONE':
      return 'Done';
    case 'PROCESSING':
      return 'Processing';
    default:
      return status;
  }
}

String getPaymentMethodText(String method) {
  switch (method.toUpperCase()) {
    case 'CARD':
      return 'Card';
    case 'VIRTUAL_ACCOUNT':
      return 'Virtual account';
    case 'MOBILE_PHONE':
      return 'Mobile phone';
    case 'TRANSFER':
      return 'Bank transfer';
    case 'FOREIGN_EASY_PAY':
      return 'Foreign easy payment';
    default:
      return method;
  }
}
