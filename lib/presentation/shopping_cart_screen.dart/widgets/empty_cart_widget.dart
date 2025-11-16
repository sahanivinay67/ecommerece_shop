import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class EmptyCartWidget extends StatelessWidget {
  const EmptyCartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Empty Cart Illustration
            Container(
              width: 60.w,
              height: 40.h,
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomIconWidget(
                    iconName: 'shopping_cart_outlined',
                    color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                    size: 80,
                  ),
                  SizedBox(height: 2.h),
                  CustomIconWidget(
                    iconName: 'sentiment_dissatisfied',
                    color: colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
                    size: 32,
                  ),
                ],
              ),
            ),
            SizedBox(height: 4.h),

            // Empty Cart Message
            Text(
              'Your cart is empty',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 2.h),

            Text(
              'Looks like you haven\'t added any delicious street food to your cart yet. Browse our menu and discover amazing flavors!',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 4.h),

            // Browse Products Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  HapticFeedback.lightImpact();
                  Navigator.pushNamed(context, '/product-catalog-screen');
                },
                icon: CustomIconWidget(
                  iconName: 'restaurant_menu',
                  color: Colors.white,
                  size: 20,
                ),
                label: const Text('Browse Products'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 4.w),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            SizedBox(height: 2.h),

            // Popular Items Suggestion
            OutlinedButton.icon(
              onPressed: () {
                HapticFeedback.lightImpact();
                Navigator.pushNamed(context, '/product-catalog-screen');
              },
              icon: CustomIconWidget(
                iconName: 'trending_up',
                color: colorScheme.primary,
                size: 18,
              ),
              label: const Text('View Popular Items'),
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(
                  horizontal: 6.w,
                  vertical: 3.w,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            SizedBox(height: 4.h),

            // Quick Suggestions
            Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: colorScheme.primary.withValues(alpha: 0.2),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'lightbulb_outline',
                        color: colorScheme.primary,
                        size: 20,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        'Quick Suggestions',
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildSuggestionChip(
                        context,
                        'Vada Pav',
                        'local_dining',
                        colorScheme,
                        theme,
                      ),
                      _buildSuggestionChip(
                        context,
                        'Samosa',
                        'restaurant',
                        colorScheme,
                        theme,
                      ),
                      _buildSuggestionChip(
                        context,
                        'Jalebi',
                        'cake',
                        colorScheme,
                        theme,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuggestionChip(
    BuildContext context,
    String label,
    String iconName,
    ColorScheme colorScheme,
    ThemeData theme,
  ) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        Navigator.pushNamed(context, '/product-catalog-screen');
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.w),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: colorScheme.outline.withValues(alpha: 0.3),
          ),
        ),
        child: Column(
          children: [
            CustomIconWidget(
              iconName: iconName,
              color: colorScheme.primary,
              size: 24,
            ),
            SizedBox(height: 1.w),
            Text(
              label,
              style: theme.textTheme.labelSmall?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
