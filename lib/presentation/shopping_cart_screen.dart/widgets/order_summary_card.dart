import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class OrderSummaryCard extends StatelessWidget {
  final double subtotal;
  final double deliveryCharges;
  final double taxes;
  final double discount;
  final double total;

  const OrderSummaryCard({
    super.key,
    required this.subtotal,
    required this.deliveryCharges,
    required this.taxes,
    required this.discount,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order Summary',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 2.h),

            // Subtotal
            _buildSummaryRow(
              context,
              'Subtotal',
              '₹${subtotal.toStringAsFixed(0)}',
              false,
            ),
            SizedBox(height: 1.h),

            // Delivery Charges
            _buildSummaryRow(
              context,
              'Delivery Charges',
              deliveryCharges > 0
                  ? '₹${deliveryCharges.toStringAsFixed(0)}'
                  : 'FREE',
              false,
              valueColor: deliveryCharges > 0 ? null : colorScheme.primary,
            ),
            SizedBox(height: 1.h),

            // Taxes (GST)
            _buildSummaryRow(
              context,
              'Taxes (GST)',
              '₹${taxes.toStringAsFixed(0)}',
              false,
            ),

            // Discount (if applicable)
            if (discount > 0) ...[
              SizedBox(height: 1.h),
              _buildSummaryRow(
                context,
                'Discount',
                '-₹${discount.toStringAsFixed(0)}',
                false,
                valueColor: colorScheme.primary,
              ),
            ],

            SizedBox(height: 1.h),
            Divider(
              color: colorScheme.outline.withValues(alpha: 0.3),
              thickness: 1,
            ),
            SizedBox(height: 1.h),

            // Total
            _buildSummaryRow(
              context,
              'Total Amount',
              '₹${total.toStringAsFixed(0)}',
              true,
            ),

            SizedBox(height: 2.h),

            // Savings Info
            if (discount > 0 || deliveryCharges == 0)
              Container(
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'savings',
                      color: colorScheme.primary,
                      size: 20,
                    ),
                    SizedBox(width: 2.w),
                    Expanded(
                      child: Text(
                        'You saved ₹${(discount + (deliveryCharges == 0 ? 40 : 0)).toStringAsFixed(0)} on this order!',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.primary,
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

  Widget _buildSummaryRow(
    BuildContext context,
    String label,
    String value,
    bool isTotal, {
    Color? valueColor,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: isTotal
              ? theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                )
              : theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
        ),
        Text(
          value,
          style: isTotal
              ? theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: colorScheme.primary,
                )
              : theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: valueColor ?? colorScheme.onSurface,
                ),
        ),
      ],
    );
  }
}
