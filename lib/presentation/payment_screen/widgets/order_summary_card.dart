import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class OrderSummaryCard extends StatelessWidget {
  final List<Map<String, dynamic>> orderItems;
  final double subtotal;
  final double deliveryFee;
  final double gst;
  final double total;

  const OrderSummaryCard({
    super.key,
    required this.orderItems,
    required this.subtotal,
    required this.deliveryFee,
    required this.gst,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.colorScheme.shadow.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'receipt',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 20,
              ),
              SizedBox(width: 2.w),
              Text(
                'Order Summary',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Container(
            constraints: BoxConstraints(maxHeight: 20.h),
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: orderItems.length,
              separatorBuilder: (context, index) => SizedBox(height: 1.h),
              itemBuilder: (context, index) {
                final item = orderItems[index];
                return Row(
                  children: [
                    Container(
                      width: 12.w,
                      height: 12.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
                          width: 1,
                        ),
                      ),
                      child: CustomImageWidget(
                        imageUrl: item["image"] as String,
                        width: 12.w,
                        height: 12.w,
                        fit: BoxFit.cover,
                        semanticLabel: item["semanticLabel"] as String,
                      ),
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item["name"] as String,
                            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                              color: AppTheme.lightTheme.colorScheme.onSurface,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 0.5.h),
                          Text(
                            'Qty: ${item["quantity"]}',
                            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '₹${((item["price"] as double) * (item["quantity"] as int)).toStringAsFixed(0)}',
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.lightTheme.colorScheme.onSurface,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          SizedBox(height: 2.h),
          Divider(
            color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
            thickness: 1,
          ),
          SizedBox(height: 2.h),
          _buildSummaryRow('Subtotal', subtotal),
          SizedBox(height: 1.h),
          _buildSummaryRow('Delivery Fee', deliveryFee),
          SizedBox(height: 1.h),
          _buildSummaryRow('GST (18%)', gst),
          SizedBox(height: 2.h),
          Divider(
            color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
            thickness: 1,
          ),
          SizedBox(height: 2.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Amount',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                ),
              ),
              Text(
                '₹${total.toStringAsFixed(0)}',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppTheme.lightTheme.colorScheme.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, double amount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
        ),
        Text(
          '₹${amount.toStringAsFixed(0)}',
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
            color: AppTheme.lightTheme.colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}