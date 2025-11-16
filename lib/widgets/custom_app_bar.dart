import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum AppBarVariant {
  standard,
  centered,
  search,
  minimal,
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final AppBarVariant variant;
  final String? title;
  final Widget? titleWidget;
  final List<Widget>? actions;
  final Widget? leading;
  final bool automaticallyImplyLeading;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? elevation;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final TextEditingController? searchController;
  final String? searchHint;
  final Function(String)? onSearchChanged;
  final VoidCallback? onSearchSubmitted;

  const CustomAppBar({
    super.key,
    this.variant = AppBarVariant.standard,
    this.title,
    this.titleWidget,
    this.actions,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation,
    this.showBackButton = false,
    this.onBackPressed,
    this.searchController,
    this.searchHint,
    this.onSearchChanged,
    this.onSearchSubmitted,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    switch (variant) {
      case AppBarVariant.centered:
        return _buildCenteredAppBar(context, theme, colorScheme);
      case AppBarVariant.search:
        return _buildSearchAppBar(context, theme, colorScheme);
      case AppBarVariant.minimal:
        return _buildMinimalAppBar(context, theme, colorScheme);
      case AppBarVariant.standard:
      default:
        return _buildStandardAppBar(context, theme, colorScheme);
    }
  }

  Widget _buildStandardAppBar(
      BuildContext context, ThemeData theme, ColorScheme colorScheme) {
    return AppBar(
      title: titleWidget ?? (title != null ? Text(title!) : null),
      leading: _buildLeading(context),
      actions: _buildActions(context),
      backgroundColor: backgroundColor ?? colorScheme.surface,
      foregroundColor: foregroundColor ?? colorScheme.onSurface,
      elevation: elevation ?? 0,
      surfaceTintColor: Colors.transparent,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: theme.brightness == Brightness.light
            ? Brightness.dark
            : Brightness.light,
      ),
    );
  }

  Widget _buildCenteredAppBar(
      BuildContext context, ThemeData theme, ColorScheme colorScheme) {
    return AppBar(
      title: titleWidget ?? (title != null ? Text(title!) : null),
      centerTitle: true,
      leading: _buildLeading(context),
      actions: _buildActions(context),
      backgroundColor: backgroundColor ?? colorScheme.surface,
      foregroundColor: foregroundColor ?? colorScheme.onSurface,
      elevation: elevation ?? 0,
      surfaceTintColor: Colors.transparent,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: theme.brightness == Brightness.light
            ? Brightness.dark
            : Brightness.light,
      ),
    );
  }

  Widget _buildSearchAppBar(
      BuildContext context, ThemeData theme, ColorScheme colorScheme) {
    return AppBar(
      title: Container(
        height: 40,
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: colorScheme.outline.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: TextField(
          controller: searchController,
          onChanged: onSearchChanged,
          onSubmitted: (value) => onSearchSubmitted?.call(),
          decoration: InputDecoration(
            hintText: searchHint ?? 'Search food items...',
            prefixIcon: Icon(
              Icons.search,
              color: colorScheme.onSurfaceVariant,
              size: 20,
            ),
            suffixIcon: searchController?.text.isNotEmpty == true
                ? IconButton(
                    icon: Icon(
                      Icons.clear,
                      color: colorScheme.onSurfaceVariant,
                      size: 20,
                    ),
                    onPressed: () {
                      searchController?.clear();
                      onSearchChanged?.call('');
                    },
                  )
                : null,
            border: InputBorder.none,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            hintStyle: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurface,
          ),
        ),
      ),
      leading: _buildLeading(context),
      actions: _buildActions(context),
      backgroundColor: backgroundColor ?? colorScheme.surface,
      foregroundColor: foregroundColor ?? colorScheme.onSurface,
      elevation: elevation ?? 0,
      surfaceTintColor: Colors.transparent,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: theme.brightness == Brightness.light
            ? Brightness.dark
            : Brightness.light,
      ),
    );
  }

  Widget _buildMinimalAppBar(
      BuildContext context, ThemeData theme, ColorScheme colorScheme) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: colorScheme.outline.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        child: Container(
          height: kToolbarHeight,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              if (_buildLeading(context) != null) ...[
                _buildLeading(context)!,
                const SizedBox(width: 16),
              ],
              Expanded(
                child: titleWidget ??
                    (title != null
                        ? Text(
                            title!,
                            style: theme.textTheme.titleLarge?.copyWith(
                              color: foregroundColor ?? colorScheme.onSurface,
                              fontWeight: FontWeight.w600,
                            ),
                          )
                        : const SizedBox.shrink()),
              ),
              if (_buildActions(context) != null) ...[
                const SizedBox(width: 16),
                Row(children: _buildActions(context)!),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget? _buildLeading(BuildContext context) {
    if (leading != null) return leading;

    if (showBackButton ||
        (automaticallyImplyLeading && Navigator.canPop(context))) {
      return IconButton(
        icon: const Icon(Icons.arrow_back_ios),
        onPressed: () {
          HapticFeedback.lightImpact();
          if (onBackPressed != null) {
            onBackPressed!();
          } else {
            Navigator.pop(context);
          }
        },
      );
    }

    return null;
  }

  List<Widget>? _buildActions(BuildContext context) {
    if (actions != null) return actions;

    // Default actions based on context
    return [
      IconButton(
        icon: const Icon(Icons.shopping_cart_outlined),
        onPressed: () {
          HapticFeedback.lightImpact();
          Navigator.pushNamed(context, '/shopping-cart-screen');
        },
      ),
      IconButton(
        icon: const Icon(Icons.more_vert),
        onPressed: () {
          HapticFeedback.lightImpact();
          _showMoreOptions(context);
        },
      ),
    ];
  }

  void _showMoreOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.receipt_long_outlined),
              title: const Text('Order History'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/order-confirmation-screen');
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings_outlined),
              title: const Text('Settings'),
              onTap: () {
                Navigator.pop(context);
                // Navigate to settings if available
              },
            ),
            ListTile(
              leading: const Icon(Icons.help_outline),
              title: const Text('Help & Support'),
              onTap: () {
                Navigator.pop(context);
                // Navigate to help if available
              },
            ),
          ],
        ),
      ),
    );
  }
}
