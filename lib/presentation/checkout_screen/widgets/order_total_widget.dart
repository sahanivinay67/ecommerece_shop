import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class OrderTotalWidget extends StatelessWidget {
  final List<Map<String, dynamic>> cartItems;
  final double deliveryFee;
  final double gstRate;

  const OrderTotalWidget({
    super.key,
    required this.cartItems,
    this.deliveryFee = 30.0,
    this.gstRate = 0.18,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    double subtotal = 0;
    for (var item in cartItems) {
      subtotal += (item['price'] as double) * (item['quantity'] as int);
    }

    final double gstAmount = subtotal * gstRate;
    final double total = subtotal + deliveryFee + gstAmount;

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bill Details',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
            SizedBox(height: 2.h),
            _buildBillRow('Item Total', '₹${subtotal.toStringAsFixed(2)}',
                theme, colorScheme, false),
            SizedBox(height: 1.h),
            _buildBillRow('Delivery Fee', '₹${deliveryFee.toStringAsFixed(2)}',
                theme, colorScheme, false),
            SizedBox(height: 1.h),
            _buildBillRow('GST (18%)', '₹${gstAmount.toStringAsFixed(2)}',
                theme, colorScheme, false),
            SizedBox(height: 1.h),
            Divider(
              color: colorScheme.outline.withValues(alpha: 0.3),
              thickness: 1,
            ),
            SizedBox(height: 1.h),
            _buildBillRow('Total Amount', '₹${total.toStringAsFixed(2)}', theme,
                colorScheme, true),
            SizedBox(height: 2.h),
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primaryContainer
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color:
                      AppTheme.lightTheme.primaryColor.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'info_outline',
                    color: AppTheme.lightTheme.primaryColor,
                    size: 20,
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: Text(
                      'Free delivery on orders above ₹299',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.primaryColor,
                        fontWeight: FontWeight.w500,
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
  }

  Widget _buildBillRow(String label, String amount, ThemeData theme,
      ColorScheme colorScheme, bool isTotal) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: isTotal ? FontWeight.w600 : FontWeight.w400,
            color:
                isTotal ? colorScheme.onSurface : colorScheme.onSurfaceVariant,
          ),
        ),
        Text(
          amount,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: isTotal ? FontWeight.w700 : FontWeight.w500,
            color: isTotal
                ? AppTheme.lightTheme.primaryColor
                : colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}
