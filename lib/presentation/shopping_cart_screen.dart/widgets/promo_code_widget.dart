import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PromoCodeWidget extends StatefulWidget {
  final Function(String, double) onPromoApplied;
  final Function() onPromoRemoved;
  final String? appliedPromoCode;
  final double appliedDiscount;

  const PromoCodeWidget({
    super.key,
    required this.onPromoApplied,
    required this.onPromoRemoved,
    this.appliedPromoCode,
    this.appliedDiscount = 0,
  });

  @override
  State<PromoCodeWidget> createState() => _PromoCodeWidgetState();
}

class _PromoCodeWidgetState extends State<PromoCodeWidget> {
  final TextEditingController _promoController = TextEditingController();
  bool _isApplying = false;
  String? _errorMessage;

  // Mock promo codes for demonstration
  final Map<String, Map<String, dynamic>> _promoCodes = {
    'SAVE20': {
      'discount': 20.0,
      'type': 'percentage',
      'description': '20% off on orders above ₹200',
      'minOrder': 200.0,
    },
    'FLAT50': {
      'discount': 50.0,
      'type': 'fixed',
      'description': '₹50 off on orders above ₹300',
      'minOrder': 300.0,
    },
    'WELCOME10': {
      'discount': 10.0,
      'type': 'percentage',
      'description': '10% off for new users',
      'minOrder': 100.0,
    },
    'FREESHIP': {
      'discount': 40.0,
      'type': 'shipping',
      'description': 'Free delivery on all orders',
      'minOrder': 0.0,
    },
  };

  @override
  void initState() {
    super.initState();
    if (widget.appliedPromoCode != null) {
      _promoController.text = widget.appliedPromoCode!;
    }
  }

  @override
  void dispose() {
    _promoController.dispose();
    super.dispose();
  }

  void _applyPromoCode() async {
    if (_promoController.text.trim().isEmpty) {
      setState(() {
        _errorMessage = 'Please enter a promo code';
      });
      return;
    }

    setState(() {
      _isApplying = true;
      _errorMessage = null;
    });

    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 800));

    final promoCode = _promoController.text.trim().toUpperCase();
    final promoData = _promoCodes[promoCode];

    if (promoData != null) {
      // Calculate discount based on type
      double discount = 0;
      final subtotal = 250.0; // This should come from parent widget

      if (subtotal >= (promoData['minOrder'] as double)) {
        if (promoData['type'] == 'percentage') {
          discount = subtotal * (promoData['discount'] as double) / 100;
        } else {
          discount = promoData['discount'] as double;
        }

        HapticFeedback.lightImpact();
        widget.onPromoApplied(promoCode, discount);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Promo code applied! You saved ₹${discount.toStringAsFixed(0)}'),
            backgroundColor: AppTheme.lightTheme.colorScheme.primary,
            behavior: SnackBarBehavior.floating,
          ),
        );
      } else {
        setState(() {
          _errorMessage =
              'Minimum order value ₹${(promoData['minOrder'] as double).toStringAsFixed(0)} required';
        });
      }
    } else {
      setState(() {
        _errorMessage = 'Invalid promo code';
      });
    }

    setState(() {
      _isApplying = false;
    });
  }

  void _removePromoCode() {
    HapticFeedback.lightImpact();
    _promoController.clear();
    widget.onPromoRemoved();
    setState(() {
      _errorMessage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final hasAppliedPromo = widget.appliedPromoCode != null;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'local_offer',
                  color: colorScheme.primary,
                  size: 20,
                ),
                SizedBox(width: 2.w),
                Text(
                  'Promo Code',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),

            // Applied Promo Code Display
            if (hasAppliedPromo) ...[
              Container(
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: colorScheme.primary.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.appliedPromoCode!,
                            style: theme.textTheme.titleSmall?.copyWith(
                              color: colorScheme.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            'You saved ₹${widget.appliedDiscount.toStringAsFixed(0)}',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: _removePromoCode,
                      icon: CustomIconWidget(
                        iconName: 'close',
                        color: colorScheme.primary,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ] else ...[
              // Promo Code Input
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _promoController,
                      textCapitalization: TextCapitalization.characters,
                      decoration: InputDecoration(
                        hintText: 'Enter promo code',
                        prefixIcon: Padding(
                          padding: EdgeInsets.all(3.w),
                          child: CustomIconWidget(
                            iconName: 'confirmation_number',
                            color: colorScheme.onSurfaceVariant,
                            size: 20,
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: colorScheme.outline.withValues(alpha: 0.3),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: colorScheme.outline.withValues(alpha: 0.3),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: colorScheme.primary,
                            width: 2,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: colorScheme.error,
                          ),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 4.w,
                          vertical: 3.w,
                        ),
                      ),
                      onSubmitted: (_) => _applyPromoCode(),
                    ),
                  ),
                  SizedBox(width: 3.w),
                  ElevatedButton(
                    onPressed: _isApplying ? null : _applyPromoCode,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        horizontal: 6.w,
                        vertical: 3.w,
                      ),
                    ),
                    child: _isApplying
                        ? SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                        : Text('Apply'),
                  ),
                ],
              ),

              // Error Message
              if (_errorMessage != null) ...[
                SizedBox(height: 1.h),
                Text(
                  _errorMessage!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.error,
                  ),
                ),
              ],

              // Available Promo Codes
              SizedBox(height: 2.h),
              Text(
                'Available Offers',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 1.h),
              ..._promoCodes.entries.map((entry) {
                return GestureDetector(
                  onTap: () {
                    _promoController.text = entry.key;
                    _applyPromoCode();
                  },
                  child: Container(
                    margin: EdgeInsets.only(bottom: 1.h),
                    padding: EdgeInsets.all(3.w),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: colorScheme.outline.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 2.w,
                            vertical: 1.w,
                          ),
                          decoration: BoxDecoration(
                            color: colorScheme.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            entry.key,
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: colorScheme.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        SizedBox(width: 3.w),
                        Expanded(
                          child: Text(
                            entry.value['description'] as String,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ],
          ],
        ),
      ),
    );
  }
}
