import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ProductCardWidget extends StatelessWidget {
  final Map<String, dynamic> product;
  final VoidCallback onTap;
  final VoidCallback? onFavorite;
  final VoidCallback? onShare;

  const ProductCardWidget({
    super.key,
    required this.product,
    required this.onTap,
    this.onFavorite,
    this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    final String name = (product['name'] as String?) ?? '';
    final String price = (product['price'] as String?) ?? '';
    final String image = (product['image'] as String?) ?? '';
    final String semanticLabel = (product['semanticLabel'] as String?) ?? '';
    final double rating = ((product['rating'] as num?) ?? 0.0).toDouble();
    final bool isVeg = (product['isVeg'] as bool?) ?? true;
    final String spiceLevel = (product['spiceLevel'] as String?) ?? '';

    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      onLongPress: () {
        HapticFeedback.mediumImpact();
        _showQuickActions(context);
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color:
                  AppTheme.lightTheme.colorScheme.shadow.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image with Veg/Non-veg indicator
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(12)),
                    child: CustomImageWidget(
                      imageUrl: image,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                      semanticLabel: semanticLabel,
                    ),
                  ),
                  // Veg/Non-veg indicator
                  Positioned(
                    top: 2.w,
                    left: 2.w,
                    child: Container(
                      padding: EdgeInsets.all(1.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Container(
                        width: 3.w,
                        height: 3.w,
                        decoration: BoxDecoration(
                          color: isVeg ? Colors.green : Colors.red,
                          shape: isVeg ? BoxShape.rectangle : BoxShape.circle,
                          borderRadius: isVeg ? BorderRadius.circular(2) : null,
                        ),
                      ),
                    ),
                  ),
                  // Spice level indicator
                  if (spiceLevel.isNotEmpty)
                    Positioned(
                      top: 2.w,
                      right: 2.w,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 2.w, vertical: 1.w),
                        decoration: BoxDecoration(
                          color: _getSpiceLevelColor(spiceLevel),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          spiceLevel,
                          style: AppTheme.lightTheme.textTheme.labelSmall
                              ?.copyWith(
                            color: Colors.white,
                            fontSize: 8.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            // Product Details
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.all(3.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product Name
                    Text(
                      name,
                      style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 12.sp,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 1.h),
                    // Rating
                    Row(
                      children: [
                        ...List.generate(5, (index) {
                          return CustomIconWidget(
                            iconName:
                                index < rating.floor() ? 'star' : 'star_border',
                            color: Colors.amber,
                            size: 12.sp,
                          );
                        }),
                        SizedBox(width: 2.w),
                        Text(
                          rating.toStringAsFixed(1),
                          style: AppTheme.lightTheme.textTheme.labelSmall
                              ?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                            fontSize: 10.sp,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    // Price
                    Text(
                      price,
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.primary,
                        fontWeight: FontWeight.w700,
                        fontSize: 14.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getSpiceLevelColor(String spiceLevel) {
    switch (spiceLevel.toLowerCase()) {
      case 'mild':
        return Colors.green;
      case 'medium':
        return Colors.orange;
      case 'hot':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void _showQuickActions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.symmetric(vertical: 2.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: CustomIconWidget(
                iconName: 'favorite_border',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              title: const Text('Add to Favorites'),
              onTap: () {
                Navigator.pop(context);
                onFavorite?.call();
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'share',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              title: const Text('Share via WhatsApp'),
              onTap: () {
                Navigator.pop(context);
                onShare?.call();
              },
            ),
          ],
        ),
      ),
    );
  }
}
