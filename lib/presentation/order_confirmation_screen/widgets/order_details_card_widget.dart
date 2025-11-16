import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class OrderDetailsCardWidget extends StatelessWidget {
  final Map<String, dynamic> orderData;

  const OrderDetailsCardWidget({
    super.key,
    required this.orderData,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: 90.w,
      margin: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
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
              'Order Details',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
            SizedBox(height: 2.h),
            _buildOrderItems(theme, colorScheme),
            SizedBox(height: 2.h),
            _buildDivider(colorScheme),
            SizedBox(height: 2.h),
            _buildOrderSummary(theme, colorScheme),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderItems(ThemeData theme, ColorScheme colorScheme) {
    final items = (orderData['items'] as List).cast<Map<String, dynamic>>();

    return Column(
      children: items.map((item) {
        return Padding(
          padding: EdgeInsets.only(bottom: 1.h),
          child: Row(
            children: [
              Container(
                width: 12.w,
                height: 12.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: colorScheme.primaryContainer,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CustomImageWidget(
                    imageUrl: item['image'] as String,
                    width: 12.w,
                    height: 12.w,
                    fit: BoxFit.cover,
                    semanticLabel: item['semanticLabel'] as String,
                  ),
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['name'] as String,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: colorScheme.onSurface,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      'Qty: ${item['quantity']}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '${item['price']}',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.primary,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDivider(ColorScheme colorScheme) {
    return Container(
      height: 1,
      width: double.infinity,
      color: colorScheme.outline.withValues(alpha: 0.2),
    );
  }

  Widget _buildOrderSummary(ThemeData theme, ColorScheme colorScheme) {
    return Column(
      children: [
        _buildSummaryRow(
          'Subtotal',
          orderData['subtotal'] as String,
          theme,
          colorScheme,
          false,
        ),
        SizedBox(height: 1.h),
        _buildSummaryRow(
          'Delivery Fee',
          orderData['deliveryFee'] as String,
          theme,
          colorScheme,
          false,
        ),
        SizedBox(height: 1.h),
        _buildSummaryRow(
          'GST (5%)',
          orderData['gst'] as String,
          theme,
          colorScheme,
          false,
        ),
        SizedBox(height: 1.h),
        _buildDivider(colorScheme),
        SizedBox(height: 1.h),
        _buildSummaryRow(
          'Total Paid',
          orderData['totalAmount'] as String,
          theme,
          colorScheme,
          true,
        ),
        SizedBox(height: 1.h),
        Row(
          children: [
            CustomIconWidget(
              iconName: 'payment',
              color: colorScheme.primary,
              size: 20,
            ),
            SizedBox(width: 2.w),
            Text(
              'Paid via ${orderData['paymentMethod']}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSummaryRow(
    String label,
    String value,
    ThemeData theme,
    ColorScheme colorScheme,
    bool isTotal,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: isTotal ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: isTotal ? colorScheme.primary : colorScheme.onSurface,
            fontWeight: isTotal ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
