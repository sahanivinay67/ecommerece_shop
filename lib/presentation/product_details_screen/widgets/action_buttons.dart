import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ActionButtons extends StatefulWidget {
  final Map<String, dynamic> product;
  final int quantity;
  final bool isInCart;
  final VoidCallback onAddToCart;
  final VoidCallback onBuyNow;

  const ActionButtons({
    super.key,
    required this.product,
    required this.quantity,
    required this.isInCart,
    required this.onAddToCart,
    required this.onBuyNow,
  });

  @override
  State<ActionButtons> createState() => _ActionButtonsState();
}

class _ActionButtonsState extends State<ActionButtons> {
  bool _isAddingToCart = false;

  Future<void> _handleAddToCart() async {
    if (_isAddingToCart) return;

    setState(() {
      _isAddingToCart = true;
    });

    HapticFeedback.mediumImpact();

    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 800));

    widget.onAddToCart();

    setState(() {
      _isAddingToCart = false;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.isInCart
                ? 'Cart updated successfully!'
                : '${widget.product['name']} added to cart!',
          ),
          backgroundColor: AppTheme.successLight,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isOutOfStock = !(widget.product['inStock'] as bool);

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isOutOfStock) ...[
              _buildOutOfStockSection(),
              SizedBox(height: 2.h),
            ],
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: _buildAddToCartButton(isOutOfStock),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: _buildBuyNowButton(isOutOfStock),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            _buildShareButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildAddToCartButton(bool isOutOfStock) {
    return ElevatedButton(
      onPressed: isOutOfStock ? null : _handleAddToCart,
      style: ElevatedButton.styleFrom(
        backgroundColor: isOutOfStock
            ? AppTheme.lightTheme.colorScheme.surface
            : AppTheme.lightTheme.colorScheme.primary,
        foregroundColor: isOutOfStock
            ? AppTheme.lightTheme.colorScheme.onSurfaceVariant
            : Colors.white,
        padding: EdgeInsets.symmetric(vertical: 2.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: isOutOfStock
              ? BorderSide(
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.3),
                )
              : BorderSide.none,
        ),
      ),
      child: _isAddingToCart
          ? SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  isOutOfStock
                      ? AppTheme.lightTheme.colorScheme.onSurfaceVariant
                      : Colors.white,
                ),
              ),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomIconWidget(
                  iconName:
                      widget.isInCart ? 'shopping_cart' : 'add_shopping_cart',
                  color: isOutOfStock
                      ? AppTheme.lightTheme.colorScheme.onSurfaceVariant
                      : Colors.white,
                  size: 20,
                ),
                SizedBox(width: 2.w),
                Text(
                  widget.isInCart ? 'Update Cart' : 'Add to Cart',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: isOutOfStock
                            ? AppTheme.lightTheme.colorScheme.onSurfaceVariant
                            : Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
    );
  }

  Widget _buildBuyNowButton(bool isOutOfStock) {
    return OutlinedButton(
      onPressed: isOutOfStock
          ? null
          : () {
              HapticFeedback.lightImpact();
              widget.onBuyNow();
            },
      style: OutlinedButton.styleFrom(
        foregroundColor: isOutOfStock
            ? AppTheme.lightTheme.colorScheme.onSurfaceVariant
            : AppTheme.lightTheme.colorScheme.primary,
        padding: EdgeInsets.symmetric(vertical: 2.h),
        side: BorderSide(
          color: isOutOfStock
              ? AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3)
              : AppTheme.lightTheme.colorScheme.primary,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Text(
        'Buy Now',
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: isOutOfStock
                  ? AppTheme.lightTheme.colorScheme.onSurfaceVariant
                  : AppTheme.lightTheme.colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }

  Widget _buildOutOfStockSection() {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.errorLight.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppTheme.errorLight.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: 'info_outline',
            color: AppTheme.errorLight,
            size: 20,
          ),
          SizedBox(width: 2.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Currently Out of Stock',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.errorLight,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                Text(
                  'Get notified when it\'s back in stock',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.errorLight,
                      ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () {
              HapticFeedback.lightImpact();
              _showNotifyDialog();
            },
            child: Text(
              'Notify Me',
              style: TextStyle(
                color: AppTheme.errorLight,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShareButton() {
    return InkWell(
      onTap: () {
        HapticFeedback.lightImpact();
        _showShareOptions();
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 1.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'share',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 20,
            ),
            SizedBox(width: 2.w),
            Text(
              'Share this product',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  void _showNotifyDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Stock Notification'),
        content: const Text(
          'We\'ll notify you via push notification when this item is back in stock.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content:
                      Text('You\'ll be notified when item is back in stock!'),
                ),
              );
            },
            child: const Text('Notify Me'),
          ),
        ],
      ),
    );
  }

  void _showShareOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Share ${widget.product['name']}',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            SizedBox(height: 3.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildShareOption('WhatsApp', 'message', Colors.green),
                _buildShareOption('Instagram', 'camera_alt', Colors.purple),
                _buildShareOption('More', 'more_horiz',
                    AppTheme.lightTheme.colorScheme.primary),
              ],
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  Widget _buildShareOption(String label, String icon, Color color) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Shared via $label')),
        );
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: EdgeInsets.all(3.w),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: CustomIconWidget(
                iconName: icon,
                color: color,
                size: 24,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
