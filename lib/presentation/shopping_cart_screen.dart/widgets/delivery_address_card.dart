import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class DeliveryAddressCard extends StatelessWidget {
  final Map<String, dynamic>? selectedAddress;
  final Function() onChangeAddress;

  const DeliveryAddressCard({
    super.key,
    this.selectedAddress,
    required this.onChangeAddress,
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
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'location_on',
                  color: colorScheme.primary,
                  size: 20,
                ),
                SizedBox(width: 2.w),
                Text(
                  'Delivery Address',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            selectedAddress != null
                ? _buildSelectedAddress(context, theme, colorScheme)
                : _buildNoAddress(context, theme, colorScheme),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedAddress(
    BuildContext context,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: colorScheme.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: colorScheme.primary.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.w),
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  selectedAddress!['type'] as String,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {
                  HapticFeedback.lightImpact();
                  onChangeAddress();
                },
                child: Text('Change'),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Text(
            selectedAddress!['name'] as String,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 0.5.h),
          Text(
            selectedAddress!['address'] as String,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          if (selectedAddress!['phone'] != null) ...[
            SizedBox(height: 0.5.h),
            Text(
              'Phone: ${selectedAddress!['phone']}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
          SizedBox(height: 1.h),
          Row(
            children: [
              CustomIconWidget(
                iconName: 'access_time',
                color: colorScheme.primary,
                size: 16,
              ),
              SizedBox(width: 1.w),
              Text(
                'Delivery in 25-30 mins',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNoAddress(
    BuildContext context,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.3),
          style: BorderStyle.solid,
        ),
      ),
      child: Column(
        children: [
          CustomIconWidget(
            iconName: 'add_location_alt',
            color: colorScheme.onSurfaceVariant,
            size: 32,
          ),
          SizedBox(height: 2.h),
          Text(
            'Add Delivery Address',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Please add your delivery address to proceed with the order',
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 2.h),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                HapticFeedback.lightImpact();
                onChangeAddress();
              },
              icon: CustomIconWidget(
                iconName: 'add',
                color: colorScheme.primary,
                size: 18,
              ),
              label: const Text('Add Address'),
            ),
          ),
        ],
      ),
    );
  }
}
