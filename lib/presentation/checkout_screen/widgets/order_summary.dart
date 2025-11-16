import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class OrderSummaryWidget extends StatelessWidget {
  final List<Map<String, dynamic>> cartItems;
  final bool isExpanded;
  final VoidCallback onToggleExpanded;

  const OrderSummaryWidget({
    super.key,
    required this.cartItems,
    required this.isExpanded,
    required this.onToggleExpanded,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    double subtotal = 0;
    for (var item in cartItems) {
      subtotal += (item['price'] as double) * (item['quantity'] as int);
    }

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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Order Summary',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
                GestureDetector(
                  onTap: onToggleExpanded,
                  child: Row(
                    children: [
                      Text(
                        '${cartItems.length} items',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      SizedBox(width: 2.w),
                      CustomIconWidget(
                        iconName: isExpanded
                            ? 'keyboard_arrow_up'
                            : 'keyboard_arrow_down',
                        color: colorScheme.onSurfaceVariant,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            isExpanded
                ? _buildExpandedView(theme, colorScheme)
                : _buildCompactView(theme, colorScheme),
            SizedBox(height: 2.h),
            Divider(color: colorScheme.outline.withValues(alpha: 0.3)),
            SizedBox(height: 1.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Subtotal',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
                Text(
                  '₹${subtotal.toStringAsFixed(2)}',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.lightTheme.primaryColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompactView(ThemeData theme, ColorScheme colorScheme) {
    return Column(
      children: cartItems
          .take(2)
          .map((item) => _buildOrderItem(item, theme, colorScheme, true))
          .toList(),
    );
  }

  Widget _buildExpandedView(ThemeData theme, ColorScheme colorScheme) {
    return Column(
      children: cartItems
          .map((item) => _buildOrderItem(item, theme, colorScheme, false))
          .toList(),
    );
  }

  Widget _buildOrderItem(Map<String, dynamic> item, ThemeData theme,
      ColorScheme colorScheme, bool isCompact) {
    return Padding(
      padding: EdgeInsets.only(bottom: isCompact ? 1.h : 1.5.h),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: CustomImageWidget(
              imageUrl: item['image'] as String,
              width: isCompact ? 12.w : 15.w,
              height: isCompact ? 12.w : 15.w,
              fit: BoxFit.cover,
              semanticLabel: item['semanticLabel'] as String,
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
                if (!isCompact) ...[
                  SizedBox(height: 0.5.h),
                  Text(
                    item['description'] as String,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
          SizedBox(width: 2.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Qty: ${item['quantity']}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              SizedBox(height: 0.5.h),
              Text(
                '₹${((item['price'] as double) * (item['quantity'] as int)).toStringAsFixed(2)}',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.lightTheme.primaryColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
