import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CustomerReviewsSection extends StatefulWidget {
  final List<Map<String, dynamic>> reviews;
  final double averageRating;
  final int totalReviews;

  const CustomerReviewsSection({
    super.key,
    required this.reviews,
    required this.averageRating,
    required this.totalReviews,
  });

  @override
  State<CustomerReviewsSection> createState() => _CustomerReviewsSectionState();
}

class _CustomerReviewsSectionState extends State<CustomerReviewsSection> {
  bool _showAllReviews = false;

  @override
  Widget build(BuildContext context) {
    final displayReviews =
        _showAllReviews ? widget.reviews : widget.reviews.take(3).toList();

    return Container(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Customer Reviews',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.lightTheme.colorScheme.onSurface,
                    ),
              ),
              Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  color: Colors.amber.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomIconWidget(
                      iconName: 'star',
                      color: Colors.amber,
                      size: 16,
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      '${widget.averageRating.toStringAsFixed(1)} (${widget.totalReviews})',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: displayReviews.length,
            separatorBuilder: (context, index) => SizedBox(height: 2.h),
            itemBuilder: (context, index) {
              final review = displayReviews[index];
              return _buildReviewCard(review);
            },
          ),
          if (widget.reviews.length > 3) ...[
            SizedBox(height: 2.h),
            Center(
              child: TextButton(
                onPressed: () {
                  setState(() {
                    _showAllReviews = !_showAllReviews;
                  });
                },
                child: Text(
                  _showAllReviews
                      ? 'Show Less Reviews'
                      : 'View All ${widget.reviews.length} Reviews',
                  style: TextStyle(
                    color: AppTheme.lightTheme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildReviewCard(Map<String, dynamic> review) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                child: CustomImageWidget(
                  imageUrl: review['userAvatar'] as String,
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                  semanticLabel: review['userAvatarLabel'] as String,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review['userName'] as String,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppTheme.lightTheme.colorScheme.onSurface,
                          ),
                    ),
                    Row(
                      children: [
                        Row(
                          children: List.generate(5, (index) {
                            return CustomIconWidget(
                              iconName: index < (review['rating'] as int)
                                  ? 'star'
                                  : 'star_border',
                              color: Colors.amber,
                              size: 14,
                            );
                          }),
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          review['date'] as String,
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppTheme.lightTheme.colorScheme
                                        .onSurfaceVariant,
                                  ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Text(
            review['comment'] as String,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                  height: 1.4,
                ),
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              _buildHelpfulButton(
                'thumb_up',
                'Helpful',
                review['helpfulCount'] as int,
                review['isHelpful'] as bool,
                () => _toggleHelpful(review, true),
              ),
              SizedBox(width: 4.w),
              _buildHelpfulButton(
                'thumb_down',
                'Not Helpful',
                review['notHelpfulCount'] as int,
                review['isNotHelpful'] as bool,
                () => _toggleHelpful(review, false),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHelpfulButton(
    String icon,
    String label,
    int count,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1)
              : AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? AppTheme.lightTheme.colorScheme.primary
                : AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomIconWidget(
              iconName: icon,
              color: isSelected
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 16,
            ),
            if (count > 0) ...[
              SizedBox(width: 1.w),
              Text(
                count.toString(),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: isSelected
                          ? AppTheme.lightTheme.colorScheme.primary
                          : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _toggleHelpful(Map<String, dynamic> review, bool isHelpful) {
    setState(() {
      if (isHelpful) {
        if (review['isHelpful'] as bool) {
          review['helpfulCount'] = (review['helpfulCount'] as int) - 1;
          review['isHelpful'] = false;
        } else {
          review['helpfulCount'] = (review['helpfulCount'] as int) + 1;
          review['isHelpful'] = true;
          if (review['isNotHelpful'] as bool) {
            review['notHelpfulCount'] = (review['notHelpfulCount'] as int) - 1;
            review['isNotHelpful'] = false;
          }
        }
      } else {
        if (review['isNotHelpful'] as bool) {
          review['notHelpfulCount'] = (review['notHelpfulCount'] as int) - 1;
          review['isNotHelpful'] = false;
        } else {
          review['notHelpfulCount'] = (review['notHelpfulCount'] as int) + 1;
          review['isNotHelpful'] = true;
          if (review['isHelpful'] as bool) {
            review['helpfulCount'] = (review['helpfulCount'] as int) - 1;
            review['isHelpful'] = false;
          }
        }
      }
    });
  }
}
