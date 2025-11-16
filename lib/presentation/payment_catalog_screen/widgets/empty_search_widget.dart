import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class EmptySearchWidget extends StatelessWidget {
  final String searchQuery;
  final VoidCallback onClearSearch;

  const EmptySearchWidget({
    super.key,
    required this.searchQuery,
    required this.onClearSearch,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Empty Search Illustration
            Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primary
                    .withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: CustomIconWidget(
                iconName: 'search_off',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 20.w,
              ),
            ),
            SizedBox(height: 4.h),
            // No Results Title
            Text(
              'No results found',
              style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.lightTheme.colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 2.h),
            // Search Query
            if (searchQuery.isNotEmpty) ...[
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                  children: [
                    const TextSpan(text: 'We couldn\'t find any results for '),
                    TextSpan(
                      text: '"$searchQuery"',
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 3.h),
            ],
            // Suggestions
            Text(
              'Try different keywords or check the spelling',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 4.h),
            // Suggested Actions
            Column(
              children: [
                Text(
                  'Popular searches:',
                  style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: 2.h),
                Wrap(
                  spacing: 2.w,
                  runSpacing: 1.h,
                  children: ['Samosa', 'Vada Pav', 'Jalebi', 'Patties']
                      .map((suggestion) {
                    return GestureDetector(
                      onTap: () {
                        // This would typically update the search query
                        onClearSearch();
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 4.w, vertical: 1.h),
                        decoration: BoxDecoration(
                          color: AppTheme.lightTheme.colorScheme.primary
                              .withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: AppTheme.lightTheme.colorScheme.primary
                                .withValues(alpha: 0.3),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          suggestion,
                          style: AppTheme.lightTheme.textTheme.labelMedium
                              ?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
            SizedBox(height: 4.h),
            // Clear Search Button
            if (searchQuery.isNotEmpty)
              SizedBox(
                width: double.infinity,
                height: 6.h,
                child: OutlinedButton(
                  onPressed: onClearSearch,
                  child: Text(
                    'Clear Search',
                    style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
