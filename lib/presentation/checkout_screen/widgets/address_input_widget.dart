import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AddressInputWidget extends StatelessWidget {
  final TextEditingController addressController;
  final TextEditingController landmarkController;
  final String selectedAddressType;
  final Function(String) onAddressTypeChanged;
  final VoidCallback onSaveAddress;
  final VoidCallback onCancel;
  final String? addressError;

  const AddressInputWidget({
    super.key,
    required this.addressController,
    required this.landmarkController,
    required this.selectedAddressType,
    required this.onAddressTypeChanged,
    required this.onSaveAddress,
    required this.onCancel,
    this.addressError,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final List<String> addressTypes = ['Home', 'Work', 'Other'];

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Add New Address',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
              IconButton(
                onPressed: onCancel,
                icon: CustomIconWidget(
                  iconName: 'close',
                  color: colorScheme.onSurfaceVariant,
                  size: 24,
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          Text(
            'Address Type',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
              color: colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 1.h),
          Row(
            children: addressTypes
                .map((type) => _buildAddressTypeChip(type, theme, colorScheme))
                .toList(),
          ),
          SizedBox(height: 3.h),
          Text(
            'Complete Address',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
              color: colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 1.h),
          TextFormField(
            controller: addressController,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'Enter your complete address',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: colorScheme.outline.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: colorScheme.outline.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: AppTheme.lightTheme.primaryColor,
                  width: 2,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: colorScheme.error,
                  width: 1,
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: colorScheme.error,
                  width: 2,
                ),
              ),
              contentPadding: EdgeInsets.all(3.w),
              errorText: addressError,
            ),
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 3.h),
          Text(
            'Landmark (Optional)',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
              color: colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 1.h),
          TextFormField(
            controller: landmarkController,
            decoration: InputDecoration(
              hintText: 'Nearby landmark for easy delivery',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: colorScheme.outline.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: colorScheme.outline.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: AppTheme.lightTheme.primaryColor,
                  width: 2,
                ),
              ),
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
            ),
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 4.h),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: onCancel,
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                    side: BorderSide(
                      color: colorScheme.outline.withValues(alpha: 0.5),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    'Cancel',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: ElevatedButton(
                  onPressed: onSaveAddress,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.lightTheme.primaryColor,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                  ),
                  child: Text(
                    'Save Address',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
        ],
      ),
    );
  }

  Widget _buildAddressTypeChip(
      String type, ThemeData theme, ColorScheme colorScheme) {
    final bool isSelected = selectedAddressType == type;

    return Padding(
      padding: EdgeInsets.only(right: 2.w),
      child: GestureDetector(
        onTap: () => onAddressTypeChanged(type),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
          decoration: BoxDecoration(
            color: isSelected
                ? AppTheme.lightTheme.primaryColor
                : colorScheme.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected
                  ? AppTheme.lightTheme.primaryColor
                  : colorScheme.outline.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Text(
            type,
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w500,
              color: isSelected ? Colors.white : colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ),
    );
  }
}
