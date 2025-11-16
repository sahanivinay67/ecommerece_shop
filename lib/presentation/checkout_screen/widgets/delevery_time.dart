import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class DeliveryTimeWidget extends StatelessWidget {
  final String? selectedTimeSlot;
  final Function(String) onTimeSlotSelected;

  const DeliveryTimeWidget({
    super.key,
    this.selectedTimeSlot,
    required this.onTimeSlotSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final List<Map<String, dynamic>> timeSlots = [
      {
        'id': 'asap',
        'title': 'ASAP',
        'subtitle': '25-30 mins',
        'isAvailable': true,
      },
      {
        'id': 'slot1',
        'title': '12:00 PM - 1:00 PM',
        'subtitle': 'Today',
        'isAvailable': true,
      },
      {
        'id': 'slot2',
        'title': '1:00 PM - 2:00 PM',
        'subtitle': 'Today',
        'isAvailable': true,
      },
      {
        'id': 'slot3',
        'title': '2:00 PM - 3:00 PM',
        'subtitle': 'Today',
        'isAvailable': false,
      },
      {
        'id': 'slot4',
        'title': '6:00 PM - 7:00 PM',
        'subtitle': 'Today',
        'isAvailable': true,
      },
    ];

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
              'Delivery Time',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
            SizedBox(height: 2.h),
            Column(
              children: timeSlots
                  .map((slot) => _buildTimeSlot(slot, theme, colorScheme))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeSlot(
      Map<String, dynamic> slot, ThemeData theme, ColorScheme colorScheme) {
    final bool isSelected = selectedTimeSlot == slot['id'];
    final bool isAvailable = slot['isAvailable'] as bool;

    return GestureDetector(
      onTap:
          isAvailable ? () => onTimeSlotSelected(slot['id'] as String) : null,
      child: Container(
        margin: EdgeInsets.only(bottom: 2.h),
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1)
              : colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected
                ? AppTheme.lightTheme.primaryColor
                : colorScheme.outline.withValues(alpha: 0.3),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 5.w,
              height: 5.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected
                    ? AppTheme.lightTheme.primaryColor
                    : Colors.transparent,
                border: Border.all(
                  color: isSelected
                      ? AppTheme.lightTheme.primaryColor
                      : colorScheme.outline.withValues(alpha: 0.5),
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 2.w,
                        height: 2.w,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                      ),
                    )
                  : null,
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    slot['title'] as String,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: isAvailable
                          ? colorScheme.onSurface
                          : colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    slot['subtitle'] as String,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: isAvailable
                          ? colorScheme.onSurfaceVariant
                          : colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),
            if (!isAvailable)
              Text(
                'Not Available',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.error,
                  fontWeight: FontWeight.w500,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
