import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class OrderTrackingWidget extends StatelessWidget {
  final Map<String, dynamic> trackingData;

  const OrderTrackingWidget({
    super.key,
    required this.trackingData,
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Order Tracking',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.5.h),
                  decoration: BoxDecoration(
                    color:
                        _getStatusColor(trackingData['currentStatus'] as String)
                            .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    trackingData['currentStatus'] as String,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: _getStatusColor(
                          trackingData['currentStatus'] as String),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 3.h),
            _buildTrackingSteps(theme, colorScheme),
            SizedBox(height: 2.h),
            _buildEstimatedDelivery(theme, colorScheme),
          ],
        ),
      ),
    );
  }

  Widget _buildTrackingSteps(ThemeData theme, ColorScheme colorScheme) {
    final steps = (trackingData['steps'] as List).cast<Map<String, dynamic>>();

    return Column(
      children: steps.asMap().entries.map((entry) {
        final index = entry.key;
        final step = entry.value;
        final isCompleted = step['isCompleted'] as bool;
        final isActive = step['isActive'] as bool;
        final isLast = index == steps.length - 1;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Container(
                  width: 6.w,
                  height: 6.w,
                  decoration: BoxDecoration(
                    color: isCompleted
                        ? AppTheme.successLight
                        : isActive
                            ? colorScheme.primary
                            : colorScheme.outline.withValues(alpha: 0.3),
                    shape: BoxShape.circle,
                  ),
                  child: isCompleted
                      ? CustomIconWidget(
                          iconName: 'check',
                          color: Colors.white,
                          size: 16,
                        )
                      : isActive
                          ? Container(
                              width: 2.w,
                              height: 2.w,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                            )
                          : null,
                ),
                if (!isLast)
                  Container(
                    width: 2,
                    height: 4.h,
                    color: isCompleted
                        ? AppTheme.successLight
                        : colorScheme.outline.withValues(alpha: 0.3),
                  ),
              ],
            ),
            SizedBox(width: 4.w),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(bottom: isLast ? 0 : 2.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      step['title'] as String,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: isCompleted || isActive
                            ? colorScheme.onSurface
                            : colorScheme.onSurfaceVariant,
                      ),
                    ),
                    if (step['description'] != null) ...[
                      SizedBox(height: 0.5.h),
                      Text(
                        step['description'] as String,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                    if (step['timestamp'] != null) ...[
                      SizedBox(height: 0.5.h),
                      Text(
                        step['timestamp'] as String,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildEstimatedDelivery(ThemeData theme, ColorScheme colorScheme) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: 'access_time',
            color: colorScheme.primary,
            size: 20,
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Estimated Delivery',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  trackingData['estimatedDelivery'] as String,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return AppTheme.successLight;
      case 'preparing':
        return AppTheme.warningLight;
      case 'out for delivery':
        return AppTheme.primaryLight;
      case 'delivered':
        return AppTheme.successLight;
      default:
        return AppTheme.primaryLight;
    }
  }
}
