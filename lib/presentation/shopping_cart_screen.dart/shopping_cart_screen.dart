import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_bottom_bar.dart';
import '../../widgets/custom_icon_widget.dart';
import 'widgets/cart_item_card.dart';
import 'widgets/delivery_address_card.dart';
import 'widgets/empty_cart_widget.dart';
import 'widgets/order_summary_card.dart';
import 'widgets/promo_code_widget.dart';

class ShoppingCartScreen extends StatefulWidget {
  const ShoppingCartScreen({super.key});

  @override
  State<ShoppingCartScreen> createState() => _ShoppingCartScreenState();
}

class _ShoppingCartScreenState extends State<ShoppingCartScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = false;
  String? _appliedPromoCode;
  double _appliedDiscount = 0;

  // Mock cart data
  List<Map<String, dynamic>> _cartItems = [
    {
      "id": 1,
      "name": "Classic Vada Pav",
      "description": "Mumbai's favorite street food with spicy potato filling",
      "price": 25.0,
      "quantity": 2,
      "image":
          "https://images.unsplash.com/photo-1711020383042-55d7755a7b3b",
      "semanticLabel":
          "Golden brown vada pav served on a white plate with green chutney and fried green chilies on the side",
    },
    {
      "id": 2,
      "name": "Crispy Samosa",
      "description": "Deep-fried pastry with spiced potato and pea filling",
      "price": 20.0,
      "quantity": 3,
      "image":
          "https://images.unsplash.com/photo-1601050690597-df0568f70950",
      "semanticLabel":
          "Golden triangular samosas arranged on a wooden serving board with mint chutney and sliced onions",
    },
    {
      "id": 3,
      "name": "Sweet Jalebi",
      "description": "Crispy spiral-shaped sweet soaked in sugar syrup",
      "price": 30.0,
      "quantity": 1,
      "image":
          "https://images.unsplash.com/photo-1706785743444-e1ccf0373193",
      "semanticLabel":
          "Orange spiral-shaped jalebis glistening with sugar syrup arranged on a traditional brass plate",
    },
    {
      "id": 4,
      "name": "Aloo Patties",
      "description": "Spiced potato patties with tangy chutneys",
      "price": 35.0,
      "quantity": 1,
      "image":
          "https://images.unsplash.com/photo-1708782340351-25feb5640076",
      "semanticLabel":
          "Round golden potato patties garnished with fresh coriander leaves and served with colorful chutneys",
    },
  ];

  // Mock delivery address
  Map<String, dynamic>? _selectedAddress = {
    "type": "HOME",
    "name": "Rajesh Kumar",
    "address":
        "Flat 302, Sunrise Apartments, MG Road, Andheri West, Mumbai - 400058",
    "phone": "+91 98765 43210",
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.index = 0; // Cart tab active
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  double get _subtotal {
    return (_cartItems as List).fold(0.0, (sum, item) {
      return sum + ((item["price"] as double) * (item["quantity"] as int));
    });
  }

  double get _deliveryCharges {
    return _subtotal >= 200 ? 0.0 : 40.0;
  }

  double get _taxes {
    return _subtotal * 0.05; // 5% GST
  }

  double get _total {
    return _subtotal + _deliveryCharges + _taxes - _appliedDiscount;
  }

  int get _totalItems {
    return (_cartItems as List).fold(0, (sum, item) {
      return sum + (item["quantity"] as int);
    });
  }

  void _removeItem(String itemId) {
    setState(() {
      _cartItems.removeWhere((item) => item["id"].toString() == itemId);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Item removed from cart'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            // Implement undo functionality
          },
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _updateQuantity(String itemId, int newQuantity) {
    setState(() {
      final itemIndex =
          _cartItems.indexWhere((item) => item["id"].toString() == itemId);
      if (itemIndex != -1) {
        _cartItems[itemIndex]["quantity"] = newQuantity;
      }
    });
  }

  void _applyPromoCode(String promoCode, double discount) {
    setState(() {
      _appliedPromoCode = promoCode;
      _appliedDiscount = discount;
    });
  }

  void _removePromoCode() {
    setState(() {
      _appliedPromoCode = null;
      _appliedDiscount = 0;
    });
  }

  void _changeAddress() {
    // Mock address selection
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        builder: (context, scrollController) => Container(
          padding: EdgeInsets.all(4.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 12.w,
                  height: 0.5.h,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.outline,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                'Select Delivery Address',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              SizedBox(height: 2.h),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  children: [
                    _buildAddressOption(
                      'HOME',
                      'Rajesh Kumar',
                      'Flat 302, Sunrise Apartments, MG Road, Andheri West, Mumbai - 400058',
                      '+91 98765 43210',
                      true,
                    ),
                    _buildAddressOption(
                      'OFFICE',
                      'Rajesh Kumar',
                      'Tech Park, 5th Floor, Bandra Kurla Complex, Mumbai - 400051',
                      '+91 98765 43210',
                      false,
                    ),
                    SizedBox(height: 2.h),
                    OutlinedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: CustomIconWidget(
                        iconName: 'add',
                        color: Theme.of(context).colorScheme.primary,
                        size: 18,
                      ),
                      label: const Text('Add New Address'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddressOption(
    String type,
    String name,
    String address,
    String phone,
    bool isSelected,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedAddress = {
            "type": type,
            "name": name,
            "address": address,
            "phone": phone,
          };
        });
        Navigator.pop(context);
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 2.h),
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: isSelected
              ? colorScheme.primary.withValues(alpha: 0.1)
              : colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? colorScheme.primary
                : colorScheme.outline.withValues(alpha: 0.3),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Radio<bool>(
              value: true,
              groupValue: isSelected,
              onChanged: (value) {
                setState(() {
                  _selectedAddress = {
                    "type": type,
                    "name": name,
                    "address": address,
                    "phone": phone,
                  };
                });
                Navigator.pop(context);
              },
            ),
            SizedBox(width: 2.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 2.w, vertical: 1.w),
                        decoration: BoxDecoration(
                          color: colorScheme.primary,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          type,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    name,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    address,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    phone,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _refreshCart() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 1000));

    setState(() {
      _isLoading = false;
    });
  }

  void _proceedToCheckout() {
    if (_cartItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Your cart is empty'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    if (_selectedAddress == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a delivery address'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    HapticFeedback.mediumImpact();
    Navigator.pushNamed(context, '/checkout-screen');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: CustomAppBar(
        variant: AppBarVariant.centered,
        title: 'Shopping Cart',
        showBackButton: true,
      ),
      body: Column(
        children: [
          // Tab Bar
          Container(
            decoration: BoxDecoration(
              color: colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: colorScheme.shadow.withValues(alpha: 0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TabBar(
              controller: _tabController,
              tabs: [
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Cart'),
                      if (_cartItems.isNotEmpty) ...[
                        SizedBox(width: 1.w),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 2.w, vertical: 0.5.w),
                          decoration: BoxDecoration(
                            color: colorScheme.primary,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '$_totalItems',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const Tab(text: 'Wishlist'),
              ],
            ),
          ),

          // Sticky Header (if cart has items)
          if (_cartItems.isNotEmpty)
            Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(alpha: 0.1),
                border: Border(
                  bottom: BorderSide(
                    color: colorScheme.outline.withValues(alpha: 0.2),
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$_totalItems items in cart',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'Estimated delivery: 25-30 mins',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  CustomIconWidget(
                    iconName: 'delivery_dining',
                    color: colorScheme.primary,
                    size: 24,
                  ),
                ],
              ),
            ),

          // Main Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Cart Tab
                _cartItems.isEmpty
                    ? const EmptyCartWidget()
                    : RefreshIndicator(
                        onRefresh: _refreshCart,
                        child: SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: Column(
                            children: [
                              SizedBox(height: 1.h),

                              // Cart Items
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: _cartItems.length,
                                itemBuilder: (context, index) {
                                  return CartItemCard(
                                    item: _cartItems[index],
                                    onRemove: _removeItem,
                                    onQuantityChanged: _updateQuantity,
                                  );
                                },
                              ),

                              SizedBox(height: 2.h),

                              // Promo Code Widget
                              PromoCodeWidget(
                                onPromoApplied: _applyPromoCode,
                                onPromoRemoved: _removePromoCode,
                                appliedPromoCode: _appliedPromoCode,
                                appliedDiscount: _appliedDiscount,
                              ),

                              SizedBox(height: 2.h),

                              // Delivery Address
                              DeliveryAddressCard(
                                selectedAddress: _selectedAddress,
                                onChangeAddress: _changeAddress,
                              ),

                              SizedBox(height: 2.h),

                              // Order Summary
                              OrderSummaryCard(
                                subtotal: _subtotal,
                                deliveryCharges: _deliveryCharges,
                                taxes: _taxes,
                                discount: _appliedDiscount,
                                total: _total,
                              ),

                              SizedBox(height: 10.h), // Space for bottom button
                            ],
                          ),
                        ),
                      ),

                // Wishlist Tab (placeholder)
                const Center(
                  child: Text('Wishlist feature coming soon!'),
                ),
              ],
            ),
          ),
        ],
      ),

      // Bottom Checkout Button
      bottomNavigationBar: _cartItems.isNotEmpty
          ? Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.shadow.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '₹${_total.toStringAsFixed(0)}',
                              style: theme.textTheme.titleLarge?.copyWith(
                                color: colorScheme.primary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              'Total amount',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(left: 4.w),
                            child: ElevatedButton(
                              onPressed: _proceedToCheckout,
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(vertical: 4.w),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text('Proceed to Checkout'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          : CustomBottomBar(
              variant: BottomBarVariant.standard,
              currentIndex: 2, // Cart tab active
            ),
    );
  }
}
