import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class QuantitySelector extends StatefulWidget {
  final int initialQuantity;
  final int maxQuantity;
  final Function(int) onQuantityChanged;

  const QuantitySelector({
    super.key,
    this.initialQuantity = 1,
    this.maxQuantity = 10,
    required this.onQuantityChanged,
  });

  @override
  State<QuantitySelector> createState() => _QuantitySelectorState();
}

class _QuantitySelectorState extends State<QuantitySelector> {
  late int _quantity;

  @override
  void initState() {
    super.initState();
    _quantity = widget.initialQuantity;
  }

  void _updateQuantity(int newQuantity) {
    if (newQuantity >= 1 && newQuantity <= widget.maxQuantity) {
      setState(() {
        _quantity = newQuantity;
      });
      widget.onQuantityChanged(_quantity);
      HapticFeedback.lightImpact();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quantity',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                ),
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              _buildQuantityButton(
                icon: 'remove',
                onPressed:
                    _quantity > 1 ? () => _updateQuantity(_quantity - 1) : null,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 4.w),
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppTheme.lightTheme.colorScheme.outline
                        .withValues(alpha: 0.3),
                  ),
                ),
                child: Text(
                  _quantity.toString(),
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppTheme.lightTheme.colorScheme.onSurface,
                      ),
                ),
              ),
              _buildQuantityButton(
                icon: 'add',
                onPressed: _quantity < widget.maxQuantity
                    ? () => _updateQuantity(_quantity + 1)
                    : null,
              ),
              Spacer(),
              if (_quantity == widget.maxQuantity)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                  decoration: BoxDecoration(
                    color: AppTheme.warningLight.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    'Max limit reached',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.warningLight,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuantityButton({
    required String icon,
    required VoidCallback? onPressed,
  }) {
    final isEnabled = onPressed != null;

    return Container(
      decoration: BoxDecoration(
        color: isEnabled
            ? AppTheme.lightTheme.colorScheme.primary
            : AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: !isEnabled
            ? Border.all(
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.3),
              )
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: EdgeInsets.all(3.w),
            child: CustomIconWidget(
              iconName: icon,
              color: isEnabled
                  ? Colors.white
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant
                      .withValues(alpha: 0.5),
              size: 20,
            ),
          ),
        ),
      ),
    );
  }
}
