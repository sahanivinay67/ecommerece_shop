import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CartItemCard extends StatefulWidget {
  final Map<String, dynamic> item;
  final Function(String) onRemove;
  final Function(String, int) onQuantityChanged;

  const CartItemCard({
    super.key,
    required this.item,
    required this.onRemove,
    required this.onQuantityChanged,
  });

  @override
  State<CartItemCard> createState() => _CartItemCardState();
}

class _CartItemCardState extends State<CartItemCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  bool _isRemoving = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(-1.0, 0.0),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _showRemoveConfirmation() {
    HapticFeedback.mediumImpact();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Remove Item',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          content: Text(
            'Are you sure you want to remove ${widget.item["name"]} from your cart?',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _removeItem();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.lightTheme.colorScheme.error,
              ),
              child: const Text('Remove'),
            ),
          ],
        );
      },
    );
  }

  void _removeItem() {
    setState(() {
      _isRemoving = true;
    });
    _animationController.forward().then((_) {
      widget.onRemove(widget.item["id"].toString());
    });
  }

  void _updateQuantity(int newQuantity) {
    if (newQuantity > 0 && newQuantity <= 10) {
      HapticFeedback.lightImpact();
      widget.onQuantityChanged(widget.item["id"].toString(), newQuantity);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SlideTransition(
      position: _slideAnimation,
      child: Dismissible(
        key: Key(widget.item["id"].toString()),
        direction: DismissDirection.endToStart,
        confirmDismiss: (direction) async {
          _showRemoveConfirmation();
          return false;
        },
        background: Container(
          alignment: Alignment.centerRight,
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          decoration: BoxDecoration(
            color: colorScheme.error,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomIconWidget(
                iconName: 'delete',
                color: Colors.white,
                size: 24,
              ),
              SizedBox(height: 0.5.h),
              Text(
                'Remove',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        child: Container(
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
            padding: EdgeInsets.all(3.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Image
                Container(
                  width: 20.w,
                  height: 20.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: colorScheme.surfaceContainerHighest,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CustomImageWidget(
                      imageUrl: widget.item["image"] as String,
                      width: 20.w,
                      height: 20.w,
                      fit: BoxFit.cover,
                      semanticLabel: widget.item["semanticLabel"] as String,
                    ),
                  ),
                ),
                SizedBox(width: 3.w),

                // Product Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.item["name"] as String,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 0.5.h),
                      if (widget.item["description"] != null)
                        Text(
                          widget.item["description"] as String,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      SizedBox(height: 1.h),

                      // Price and Quantity Controls
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Price
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '₹${((widget.item["price"] as double) * (widget.item["quantity"] as int)).toStringAsFixed(0)}',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  color: colorScheme.primary,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              if ((widget.item["quantity"] as int) > 1)
                                Text(
                                  '₹${(widget.item["price"] as double).toStringAsFixed(0)} each',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                ),
                            ],
                          ),

                          // Quantity Controls
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color:
                                    colorScheme.outline.withValues(alpha: 0.3),
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                InkWell(
                                  onTap: () => _updateQuantity(
                                      (widget.item["quantity"] as int) - 1),
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(8),
                                    bottomLeft: Radius.circular(8),
                                  ),
                                  child: Container(
                                    padding: EdgeInsets.all(2.w),
                                    child: CustomIconWidget(
                                      iconName: 'remove',
                                      color:
                                          (widget.item["quantity"] as int) > 1
                                              ? colorScheme.primary
                                              : colorScheme.onSurfaceVariant
                                                  .withValues(alpha: 0.5),
                                      size: 16,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 3.w, vertical: 2.w),
                                  decoration: BoxDecoration(
                                    border: Border.symmetric(
                                      vertical: BorderSide(
                                        color: colorScheme.outline
                                            .withValues(alpha: 0.3),
                                      ),
                                    ),
                                  ),
                                  child: Text(
                                    '${widget.item["quantity"]}',
                                    style: theme.textTheme.titleSmall?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () => _updateQuantity(
                                      (widget.item["quantity"] as int) + 1),
                                  borderRadius: const BorderRadius.only(
                                    topRight: Radius.circular(8),
                                    bottomRight: Radius.circular(8),
                                  ),
                                  child: Container(
                                    padding: EdgeInsets.all(2.w),
                                    child: CustomIconWidget(
                                      iconName: 'add',
                                      color:
                                          (widget.item["quantity"] as int) < 10
                                              ? colorScheme.primary
                                              : colorScheme.onSurfaceVariant
                                                  .withValues(alpha: 0.5),
                                      size: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
