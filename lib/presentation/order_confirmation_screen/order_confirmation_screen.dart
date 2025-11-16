import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_icon_widget.dart';
import 'widgets/action_buttons_widget.dart';
import 'widgets/celebration_animation_widget.dart';
import 'widgets/contact_support_widget.dart';
import 'widgets/delivery_info_widget.dart';
import 'widgets/order_details_card_widget.dart';
import 'widgets/order_tracking_widget.dart';

class OrderConfirmationScreen extends StatefulWidget {
  const OrderConfirmationScreen({super.key});

  @override
  State<OrderConfirmationScreen> createState() =>
      _OrderConfirmationScreenState();
}

class _OrderConfirmationScreenState extends State<OrderConfirmationScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  // Mock order data
  final Map<String, dynamic> orderData = {
    "orderNumber": "VPE2024111601",
    "orderDate": "16 Nov 2024, 4:36 PM",
    "items": [
      {
        "id": 1,
        "name": "Classic Vada Pav",
        "quantity": 2,
        "price": "₹60",
        "image":
            "https://images.unsplash.com/photo-1711020383042-55d7755a7b3b",
        "semanticLabel":
            "Golden brown vada pav served on a white plate with green chutney and fried green chilies on the side"
      },
      {
        "id": 2,
        "name": "Samosa (2 pcs)",
        "quantity": 1,
        "price": "₹40",
        "image":
            "https://images.unsplash.com/photo-1708782341272-48c2af8c7bf7",
        "semanticLabel":
            "Crispy golden triangular samosas filled with spiced potato mixture, served with mint chutney"
      },
      {
        "id": 3,
        "name": "Masala Chai",
        "quantity": 1,
        "price": "₹25",
        "image":
            "https://images.unsplash.com/photo-1692768628118-e7547541e1e0",
        "semanticLabel":
            "Steaming hot masala chai in a traditional clay cup with aromatic spices and milk foam on top"
      }
    ],
    "subtotal": "₹125",
    "deliveryFee": "₹30",
    "gst": "₹7.75",
    "totalAmount": "₹162.75",
    "paymentMethod": "UPI (PhonePe)"
  };

  final Map<String, dynamic> deliveryData = {
    "address":
        "Flat 204, Sunrise Apartments, MG Road, Pune, Maharashtra 411001",
    "estimatedTime": "25-30 minutes",
    "deliveryPartner": {
      "name": "Rajesh Kumar",
      "phone": "+91 98765 43210",
      "rating": 4.8,
      "avatar":
          "https://img.rocket.new/generatedImages/rocket_gen_img_156075397-1762249047116.png",
      "semanticLabel":
          "Professional headshot of a middle-aged Indian man with short black hair wearing a blue delivery uniform and smiling"
    }
  };

  final Map<String, dynamic> trackingData = {
    "currentStatus": "Preparing",
    "estimatedDelivery": "5:06 PM - 5:11 PM",
    "steps": [
      {
        "title": "Order Confirmed",
        "description": "Your order has been confirmed and payment received",
        "timestamp": "4:36 PM",
        "isCompleted": true,
        "isActive": false
      },
      {
        "title": "Preparing Your Food",
        "description": "Our chefs are preparing your delicious meal",
        "timestamp": "4:42 PM",
        "isCompleted": false,
        "isActive": true
      },
      {
        "title": "Out for Delivery",
        "description": "Your order is on the way to your location",
        "timestamp": null,
        "isCompleted": false,
        "isActive": false
      },
      {
        "title": "Delivered",
        "description": "Enjoy your meal!",
        "timestamp": null,
        "isCompleted": false,
        "isActive": false
      }
    ]
  };

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    // Start fade animation after celebration
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        _fadeController.forward();
      }
    });

    // Haptic feedback for success
    HapticFeedback.mediumImpact();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              SizedBox(height: 2.h),
              // Celebration Animation
              const CelebrationAnimationWidget(),

              // Success Message
              AnimatedBuilder(
                animation: _fadeAnimation,
                builder: (context, child) {
                  return Opacity(
                    opacity: _fadeAnimation.value,
                    child: Transform.translate(
                      offset: Offset(0, 20 * (1 - _fadeAnimation.value)),
                      child: Column(
                        children: [
                          Text(
                            'Order Confirmed!',
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: colorScheme.onSurface,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 1.h),
                          Text(
                            'Thank you for choosing Vada Pav Express',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 1.h),
                          // Order Number
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 4.w, vertical: 1.h),
                            decoration: BoxDecoration(
                              color: colorScheme.primaryContainer
                                  .withValues(alpha: 0.3),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CustomIconWidget(
                                  iconName: 'receipt',
                                  color: colorScheme.primary,
                                  size: 16,
                                ),
                                SizedBox(width: 2.w),
                                Text(
                                  'Order #${orderData['orderNumber']}',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: colorScheme.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 0.5.h),
                          Text(
                            orderData['orderDate'] as String,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),

              SizedBox(height: 3.h),

              // Order Details Card
              AnimatedBuilder(
                animation: _fadeAnimation,
                builder: (context, child) {
                  return Opacity(
                    opacity: _fadeAnimation.value,
                    child: Transform.translate(
                      offset: Offset(0, 30 * (1 - _fadeAnimation.value)),
                      child: OrderDetailsCardWidget(orderData: orderData),
                    ),
                  );
                },
              ),

              // Delivery Information
              AnimatedBuilder(
                animation: _fadeAnimation,
                builder: (context, child) {
                  return Opacity(
                    opacity: _fadeAnimation.value,
                    child: Transform.translate(
                      offset: Offset(0, 40 * (1 - _fadeAnimation.value)),
                      child: DeliveryInfoWidget(deliveryData: deliveryData),
                    ),
                  );
                },
              ),

              // Order Tracking
              AnimatedBuilder(
                animation: _fadeAnimation,
                builder: (context, child) {
                  return Opacity(
                    opacity: _fadeAnimation.value,
                    child: Transform.translate(
                      offset: Offset(0, 50 * (1 - _fadeAnimation.value)),
                      child: OrderTrackingWidget(trackingData: trackingData),
                    ),
                  );
                },
              ),

              // Action Buttons
              AnimatedBuilder(
                animation: _fadeAnimation,
                builder: (context, child) {
                  return Opacity(
                    opacity: _fadeAnimation.value,
                    child: Transform.translate(
                      offset: Offset(0, 60 * (1 - _fadeAnimation.value)),
                      child: ActionButtonsWidget(
                        orderNumber: orderData['orderNumber'] as String,
                        orderData: orderData,
                      ),
                    ),
                  );
                },
              ),

              // Contact Support
              AnimatedBuilder(
                animation: _fadeAnimation,
                builder: (context, child) {
                  return Opacity(
                    opacity: _fadeAnimation.value,
                    child: Transform.translate(
                      offset: Offset(0, 70 * (1 - _fadeAnimation.value)),
                      child: const ContactSupportWidget(),
                    ),
                  );
                },
              ),

              SizedBox(height: 4.h),
            ],
          ),
        ),
      ),
    );
  }
}
