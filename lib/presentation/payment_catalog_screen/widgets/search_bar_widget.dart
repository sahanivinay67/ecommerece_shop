import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SearchBarWidget extends StatefulWidget {
  final TextEditingController controller;
  final Function(String) onChanged;
  final VoidCallback onFilterTap;
  final List<String> suggestions;

  const SearchBarWidget({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.onFilterTap,
    this.suggestions = const [],
  });

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  bool _showSuggestions = false;
  List<String> _filteredSuggestions = [];

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onSearchChanged);
    super.dispose();
  }

  void _onSearchChanged() {
    final query = widget.controller.text.toLowerCase();
    if (query.isNotEmpty) {
      _filteredSuggestions = widget.suggestions
          .where((suggestion) => suggestion.toLowerCase().contains(query))
          .take(5)
          .toList();
      setState(() {
        _showSuggestions = _filteredSuggestions.isNotEmpty;
      });
    } else {
      setState(() {
        _showSuggestions = false;
      });
    }
    widget.onChanged(widget.controller.text);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 6.h,
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppTheme.lightTheme.colorScheme.outline
                  .withValues(alpha: 0.3),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: AppTheme.lightTheme.colorScheme.shadow
                    .withValues(alpha: 0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              // Search Icon
              Padding(
                padding: EdgeInsets.only(left: 4.w),
                child: CustomIconWidget(
                  iconName: 'search',
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 20,
                ),
              ),
              // Search TextField
              Expanded(
                child: TextField(
                  controller: widget.controller,
                  decoration: InputDecoration(
                    hintText: 'Search samosa, vada pav, jalebi...',
                    hintStyle:
                        AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                    border: InputBorder.none,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.5.h),
                  ),
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                  ),
                ),
              ),
              // Clear Button
              if (widget.controller.text.isNotEmpty)
                GestureDetector(
                  onTap: () {
                    widget.controller.clear();
                    widget.onChanged('');
                  },
                  child: Padding(
                    padding: EdgeInsets.only(right: 2.w),
                    child: CustomIconWidget(
                      iconName: 'clear',
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 18,
                    ),
                  ),
                ),
              // Filter Button
              GestureDetector(
                onTap: widget.onFilterTap,
                child: Container(
                  margin: EdgeInsets.only(right: 3.w, left: 2.w),
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.primary
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: CustomIconWidget(
                    iconName: 'tune',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 18,
                  ),
                ),
              ),
            ],
          ),
        ),
        // Suggestions Dropdown
        if (_showSuggestions)
          Container(
            margin: EdgeInsets.only(top: 1.h),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.3),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.lightTheme.colorScheme.shadow
                      .withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: _filteredSuggestions.map((suggestion) {
                return ListTile(
                  dense: true,
                  leading: CustomIconWidget(
                    iconName: 'search',
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 16,
                  ),
                  title: Text(
                    suggestion,
                    style: AppTheme.lightTheme.textTheme.bodyMedium,
                  ),
                  onTap: () {
                    widget.controller.text = suggestion;
                    widget.onChanged(suggestion);
                    setState(() {
                      _showSuggestions = false;
                    });
                  },
                );
              }).toList(),
            ),
          ),
      ],
    );
  }
}
