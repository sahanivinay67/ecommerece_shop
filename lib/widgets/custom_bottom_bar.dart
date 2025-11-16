import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum BottomBarVariant {
  standard,
  floating,
  minimal,
}

class CustomBottomBar extends StatefulWidget {
  final BottomBarVariant variant;
  final int currentIndex;
  final Function(int)? onTap;
  final Color? backgroundColor;
  final Color? selectedItemColor;
  final Color? unselectedItemColor;
  final double? elevation;
  final EdgeInsetsGeometry? margin;
  final BorderRadius? borderRadius;

  const CustomBottomBar({
    super.key,
    this.variant = BottomBarVariant.standard,
    this.currentIndex = 0,
    this.onTap,
    this.backgroundColor,
    this.selectedItemColor,
    this.unselectedItemColor,
    this.elevation,
    this.margin,
    this.borderRadius,
  });

  @override
  State<CustomBottomBar> createState() => _CustomBottomBarState();
}

class _CustomBottomBarState extends State<CustomBottomBar> {
  late int _currentIndex;

  final List<_BottomBarItem> _items = [
    _BottomBarItem(
      icon: Icons.home_outlined,
      selectedIcon: Icons.home,
      label: 'Home',
      route: '/product-catalog-screen',
    ),
    _BottomBarItem(
      icon: Icons.search_outlined,
      selectedIcon: Icons.search,
      label: 'Search',
      route: '/product-catalog-screen',
    ),
    _BottomBarItem(
      icon: Icons.shopping_cart_outlined,
      selectedIcon: Icons.shopping_cart,
      label: 'Cart',
      route: '/shopping-cart-screen',
    ),
    _BottomBarItem(
      icon: Icons.person_outline,
      selectedIcon: Icons.person,
      label: 'Profile',
      route: '/product-catalog-screen',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.currentIndex;
  }

  @override
  void didUpdateWidget(CustomBottomBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentIndex != oldWidget.currentIndex) {
      _currentIndex = widget.currentIndex;
    }
  }

  void _onItemTapped(int index) {
    if (index != _currentIndex) {
      // Haptic feedback for navigation
      HapticFeedback.lightImpact();

      setState(() {
        _currentIndex = index;
      });

      // Call the provided onTap callback
      widget.onTap?.call(index);

      // Navigate to the corresponding route
      if (_items[index].route.isNotEmpty) {
        Navigator.pushNamed(context, _items[index].route);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    switch (widget.variant) {
      case BottomBarVariant.floating:
        return _buildFloatingBottomBar(theme, colorScheme);
      case BottomBarVariant.minimal:
        return _buildMinimalBottomBar(theme, colorScheme);
      case BottomBarVariant.standard:
      default:
        return _buildStandardBottomBar(theme, colorScheme);
    }
  }

  Widget _buildStandardBottomBar(ThemeData theme, ColorScheme colorScheme) {
    return Container(
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Container(
          height: 64,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: _items.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final isSelected = index == _currentIndex;

              return Expanded(
                child: InkWell(
                  onTap: () => _onItemTapped(index),
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isSelected ? item.selectedIcon : item.icon,
                          color: isSelected
                              ? (widget.selectedItemColor ??
                                  colorScheme.primary)
                              : (widget.unselectedItemColor ??
                                  colorScheme.onSurfaceVariant),
                          size: 24,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item.label,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: isSelected
                                ? (widget.selectedItemColor ??
                                    colorScheme.primary)
                                : (widget.unselectedItemColor ??
                                    colorScheme.onSurfaceVariant),
                            fontWeight:
                                isSelected ? FontWeight.w500 : FontWeight.w400,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildFloatingBottomBar(ThemeData theme, ColorScheme colorScheme) {
    return Container(
      margin: widget.margin ?? const EdgeInsets.all(16),
      child: SafeArea(
        child: Container(
          height: 64,
          decoration: BoxDecoration(
            color: widget.backgroundColor ?? colorScheme.surface,
            borderRadius: widget.borderRadius ?? BorderRadius.circular(32),
            boxShadow: [
              BoxShadow(
                color: colorScheme.shadow.withValues(alpha: 0.15),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: _items.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final isSelected = index == _currentIndex;

              return Expanded(
                child: InkWell(
                  onTap: () => _onItemTapped(index),
                  borderRadius: BorderRadius.circular(32),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: isSelected
                              ? BoxDecoration(
                                  color: (widget.selectedItemColor ??
                                          colorScheme.primary)
                                      .withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(16),
                                )
                              : null,
                          child: Icon(
                            isSelected ? item.selectedIcon : item.icon,
                            color: isSelected
                                ? (widget.selectedItemColor ??
                                    colorScheme.primary)
                                : (widget.unselectedItemColor ??
                                    colorScheme.onSurfaceVariant),
                            size: 24,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildMinimalBottomBar(ThemeData theme, ColorScheme colorScheme) {
    return Container(
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: colorScheme.outline.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        child: Container(
          height: 56,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: _items.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final isSelected = index == _currentIndex;

              return InkWell(
                onTap: () => _onItemTapped(index),
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  child: Icon(
                    isSelected ? item.selectedIcon : item.icon,
                    color: isSelected
                        ? (widget.selectedItemColor ?? colorScheme.primary)
                        : (widget.unselectedItemColor ??
                            colorScheme.onSurfaceVariant),
                    size: 24,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

class _BottomBarItem {
  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final String route;

  const _BottomBarItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.route,
  });
}
