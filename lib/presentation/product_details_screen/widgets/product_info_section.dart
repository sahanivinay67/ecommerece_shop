import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ProductInfoSection extends StatelessWidget {
  final Map<String, dynamic> product;

  const ProductInfoSection({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product['name'] as String,
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppTheme.lightTheme.colorScheme.onSurface,
                          ),
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      product['hindiName'] as String,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                            fontStyle: FontStyle.italic,
                          ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.primary
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  product['price'] as String,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppTheme.lightTheme.colorScheme.primary,
                      ),
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Row(
                children: List.generate(5, (index) {
                  return CustomIconWidget(
                    iconName: index < (product['rating'] as double).floor()
                        ? 'star'
                        : 'star_border',
                    color: Colors.amber,
                    size: 20,
                  );
                }),
              ),
              SizedBox(width: 2.w),
              Text(
                '${product['rating']} (${product['reviewCount']} reviews)',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              _buildInfoChip(
                context,
                CustomIconWidget(
                  iconName: 'local_fire_department',
                  color: _getSpiceColor(product['spiceLevel'] as String),
                  size: 16,
                ),
                product['spiceLevel'] as String,
              ),
              SizedBox(width: 3.w),
              _buildInfoChip(
                context,
                CustomIconWidget(
                  iconName: 'schedule',
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 16,
                ),
                '${product['prepTime']} mins',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(BuildContext context, Widget icon, String label) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon,
          SizedBox(width: 1.w),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
          ),
        ],
      ),
    );
  }

  Color _getSpiceColor(String spiceLevel) {
    switch (spiceLevel.toLowerCase()) {
      case 'mild':
        return Colors.green;
      case 'medium':
        return Colors.orange;
      case 'hot':
        return Colors.red;
      default:
        return AppTheme.lightTheme.colorScheme.onSurfaceVariant;
    }
  }
}
