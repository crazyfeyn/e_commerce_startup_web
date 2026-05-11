import 'package:e_commerce_startup_web/presentation/pages/orders/viewmodel/orders_viewmodel.dart';
import 'package:e_commerce_startup_web/presentation/pages/orders/widgets/order_helpers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const _editableStatuses = [
  'NEW',
  'WAITING',
  'CONFIRMED',
  'PAYMENT_CREATED',
  'PAYMENT_PENDING',
  'PAYMENT_FAILED',
  'PAYMENT_SUCCEEDED',
  'DELIVERED',
  'COMPLETED',
  'CANCELLED',
];

void showUpdateStatusDialog(
  BuildContext context,
  dynamic order,
  OrdersViewmodel viewmodel,
) {
  String selectedStatus = order.orderStatus;
  final scaffoldContext = context; // capture before dialog opens

  showDialog(
    context: context,
    builder: (BuildContext dialogContext) {
      return StatefulBuilder(
        builder: (dialogContext, setState) {
          final bool isUpdating = viewmodel.isOrderEditing(order.orderId);

          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            clipBehavior: Clip.antiAlias,
            child: SizedBox(
              width: 420,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header
                  Container(
                    padding: const EdgeInsets.fromLTRB(20, 18, 16, 18),
                    color: const Color(0xFFF8F9FC),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.orange.shade50,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            CupertinoIcons.pencil_circle_fill,
                            color: Colors.orange.shade600,
                            size: 18,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Update Order Status',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                  color: Color(0xFF111827),
                                ),
                              ),
                              Text(
                                "Order #${order.orderId}",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: isUpdating
                              ? null
                              : () => Navigator.of(dialogContext).pop(),
                          icon: const Icon(
                            CupertinoIcons.xmark,
                            size: 16,
                            color: Color(0xFF6B7280),
                          ),
                          style: IconButton.styleFrom(
                            backgroundColor: const Color(0xFFEEF0F4),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Divider(height: 1, color: Color(0xFFEEF0F4)),

                  // Body
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Select new status',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ..._editableStatuses.map((status) {
                          final bool isSelected = selectedStatus == status;
                          final Color statusColor = getStatusTextColor(status);
                          final Color statusBgColor = getStatusColor(status);

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: InkWell(
                              onTap: isUpdating
                                  ? null
                                  : () {
                                      setState(() => selectedStatus = status);
                                    },
                              borderRadius: BorderRadius.circular(10),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 150),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? statusBgColor
                                      : const Color(0xFFF8F9FC),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: isSelected
                                        ? statusColor.withOpacity(0.5)
                                        : const Color(0xFFEEF0F4),
                                    width: isSelected ? 1.5 : 1,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    AnimatedContainer(
                                      duration: const Duration(
                                        milliseconds: 150,
                                      ),
                                      width: 18,
                                      height: 18,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: isSelected
                                            ? statusColor
                                            : Colors.transparent,
                                        border: Border.all(
                                          color: isSelected
                                              ? statusColor
                                              : Colors.grey.shade300,
                                          width: 2,
                                        ),
                                      ),
                                      child: isSelected
                                          ? const Icon(
                                              Icons.check,
                                              size: 11,
                                              color: Colors.white,
                                            )
                                          : null,
                                    ),
                                    const SizedBox(width: 12),
                                    Container(
                                      width: 8,
                                      height: 8,
                                      decoration: BoxDecoration(
                                        color: statusColor,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      getStatusText(status),
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: isSelected
                                            ? FontWeight.w600
                                            : FontWeight.w500,
                                        color: isSelected
                                            ? statusColor
                                            : const Color(0xFF374151),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  ),

                  // Footer
                  Container(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                    decoration: const BoxDecoration(
                      color: Color(0xFFF8F9FC),
                      border: Border(top: BorderSide(color: Color(0xFFEEF0F4))),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: isUpdating
                                ? null
                                : () => Navigator.of(dialogContext).pop(),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              side: const BorderSide(color: Color(0xFFD1D5DB)),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text(
                              'Cancel',
                              style: TextStyle(
                                color: Color(0xFF374151),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: FilledButton(
                            onPressed:
                                !isUpdating &&
                                    selectedStatus != order.orderStatus
                                ? () async {
                                    final success = await viewmodel
                                        .editOrderStatus(
                                          order.orderId,
                                          selectedStatus,
                                        );
                                    if (dialogContext.mounted) {
                                      Navigator.of(dialogContext).pop();
                                    }
                                    if (success && scaffoldContext.mounted) {
                                      ScaffoldMessenger.of(
                                        scaffoldContext,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Row(
                                            children: [
                                              const Icon(
                                                CupertinoIcons
                                                    .check_mark_circled_solid,
                                                color: Colors.white,
                                                size: 16,
                                              ),
                                              const SizedBox(width: 8),
                                              Text(
                                                "Order status updated #${order.orderId}",
                                              ),
                                            ],
                                          ),
                                          backgroundColor:
                                              Colors.green.shade600,
                                          behavior: SnackBarBehavior.floating,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                          ),
                                          margin: const EdgeInsets.all(16),
                                        ),
                                      );
                                    }
                                  }
                                : null,
                            style: FilledButton.styleFrom(
                              backgroundColor: Colors.orange.shade600,
                              disabledBackgroundColor: Colors.grey.shade200,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: isUpdating
                                ? SizedBox(
                                    height: 16,
                                    width: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.grey.shade400,
                                    ),
                                  )
                                : Text(
                                    'Update',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: selectedStatus != order.orderStatus
                                          ? Colors.white
                                          : Colors.grey.shade400,
                                    ),
                                  ),
                          ),
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
    },
  );
}
