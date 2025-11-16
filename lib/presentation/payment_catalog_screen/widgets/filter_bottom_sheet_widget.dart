import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class FilterBottomSheetWidget extends StatefulWidget {
  final Map<String, dynamic> currentFilters;
  final Function(Map<String, dynamic>) onApplyFilters;

  const FilterBottomSheetWidget({
    super.key,
    required this.currentFilters,
    required this.onApplyFilters,
  });

  @override
  State<FilterBottomSheetWidget> createState() =>
      _FilterBottomSheetWidgetState();
}

class _FilterBottomSheetWidgetState extends State<FilterBottomSheetWidget> {
  late Map<String, dynamic> _filters;
  RangeValues _priceRange = const RangeValues(10, 200);
  String _selectedSpiceLevel = 'All';
  bool _vegetarianOnly = false;
  double _minRating = 0.0;

  @override
  void initState() {
    super.initState();
    _filters = Map.from(widget.currentFilters);
    _priceRange = RangeValues(
      (_filters['minPrice'] as double?) ?? 10.0,
      (_filters['maxPrice'] as double?) ?? 200.0,
    );
    _selectedSpiceLevel = (_filters['spiceLevel'] as String?) ?? 'All';
    _vegetarianOnly = (_filters['vegetarianOnly'] as bool?) ?? false;
    _minRating = (_filters['minRating'] as double?) ?? 0.0;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70.h,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle Bar
          Container(
            margin: EdgeInsets.only(top: 2.h),
            width: 12.w,
            height: 0.5.h,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.outline
                  .withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Header
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Filter Products',
                  style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextButton(
                  onPressed: _resetFilters,
                  child: Text(
                    'Reset',
                    style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
            height: 1,
          ),
          // Filter Content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Price Range
                  _buildSectionTitle('Price Range'),
                  SizedBox(height: 2.h),
                  Text(
                    '₹${_priceRange.start.round()} - ₹${_priceRange.end.round()}',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  RangeSlider(
                    values: _priceRange,
                    min: 10,
                    max: 500,
                    divisions: 49,
                    labels: RangeLabels(
                      '₹${_priceRange.start.round()}',
                      '₹${_priceRange.end.round()}',
                    ),
                    onChanged: (values) {
                      setState(() {
                        _priceRange = values;
                      });
                    },
                  ),
                  SizedBox(height: 3.h),

                  // Spice Level
                  _buildSectionTitle('Spice Level'),
                  SizedBox(height: 2.h),
                  Wrap(
                    spacing: 2.w,
                    children: ['All', 'Mild', 'Medium', 'Hot'].map((level) {
                      final isSelected = _selectedSpiceLevel == level;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedSpiceLevel = level;
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 4.w, vertical: 1.h),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppTheme.lightTheme.colorScheme.primary
                                : AppTheme.lightTheme.colorScheme.surface,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isSelected
                                  ? AppTheme.lightTheme.colorScheme.primary
                                  : AppTheme.lightTheme.colorScheme.outline
                                      .withValues(alpha: 0.3),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            level,
                            style: AppTheme.lightTheme.textTheme.labelMedium
                                ?.copyWith(
                              color: isSelected
                                  ? Colors.white
                                  : AppTheme.lightTheme.colorScheme.onSurface,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.w500,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 3.h),

                  // Dietary Preferences
                  _buildSectionTitle('Dietary Preferences'),
                  SizedBox(height: 2.h),
                  Row(
                    children: [
                      Checkbox(
                        value: _vegetarianOnly,
                        onChanged: (value) {
                          setState(() {
                            _vegetarianOnly = value ?? false;
                          });
                        },
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        'Vegetarian Only',
                        style: AppTheme.lightTheme.textTheme.bodyMedium,
                      ),
                      SizedBox(width: 2.w),
                      Container(
                        width: 3.w,
                        height: 3.w,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 3.h),

                  // Minimum Rating
                  _buildSectionTitle('Minimum Rating'),
                  SizedBox(height: 2.h),
                  Row(
                    children: [
                      Expanded(
                        child: Slider(
                          value: _minRating,
                          min: 0,
                          max: 5,
                          divisions: 10,
                          label: '${_minRating.toStringAsFixed(1)} ⭐',
                          onChanged: (value) {
                            setState(() {
                              _minRating = value;
                            });
                          },
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        '${_minRating.toStringAsFixed(1)} ⭐',
                        style:
                            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // Apply Button
          Container(
            padding: EdgeInsets.all(4.w),
            child: SizedBox(
              width: double.infinity,
              height: 6.h,
              child: ElevatedButton(
                onPressed: _applyFilters,
                child: Text(
                  'Apply Filters',
                  style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.w600,
      ),
    );
  }

  void _resetFilters() {
    setState(() {
      _priceRange = const RangeValues(10, 200);
      _selectedSpiceLevel = 'All';
      _vegetarianOnly = false;
      _minRating = 0.0;
    });
  }

  void _applyFilters() {
    final filters = {
      'minPrice': _priceRange.start,
      'maxPrice': _priceRange.end,
      'spiceLevel': _selectedSpiceLevel,
      'vegetarianOnly': _vegetarianOnly,
      'minRating': _minRating,
    };
    widget.onApplyFilters(filters);
    Navigator.pop(context);
  }
}
