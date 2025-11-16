import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ActionButtonsWidget extends StatelessWidget {
  final String orderNumber;
  final Map<String, dynamic> orderData;

  const ActionButtonsWidget({
    super.key,
    required this.orderNumber,
    required this.orderData,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: 90.w,
      margin: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
      child: Column(
        children: [
          // Primary Track Order Button
          SizedBox(
            width: double.infinity,
            height: 6.h,
            child: ElevatedButton(
              onPressed: () => _trackOrder(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: Colors.white,
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomIconWidget(
                    iconName: 'location_on',
                    color: Colors.white,
                    size: 20,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    'Track Your Order',
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 2.h),
          // Secondary Action Buttons Row
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 5.h,
                  child: OutlinedButton(
                    onPressed: () => _downloadReceipt(context),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: colorScheme.primary,
                      side: BorderSide(color: colorScheme.primary, width: 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomIconWidget(
                          iconName: 'download',
                          color: colorScheme.primary,
                          size: 18,
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          'Receipt',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: SizedBox(
                  height: 5.h,
                  child: OutlinedButton(
                    onPressed: () => _shareOrder(context),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: colorScheme.primary,
                      side: BorderSide(color: colorScheme.primary, width: 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomIconWidget(
                          iconName: 'share',
                          color: colorScheme.primary,
                          size: 18,
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          'Share',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          // Navigation Buttons
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 5.h,
                  child: TextButton(
                    onPressed: () => _continueShopping(context),
                    style: TextButton.styleFrom(
                      foregroundColor: colorScheme.onSurfaceVariant,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Continue Shopping',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                width: 1,
                height: 3.h,
                color: colorScheme.outline.withValues(alpha: 0.3),
              ),
              Expanded(
                child: SizedBox(
                  height: 5.h,
                  child: TextButton(
                    onPressed: () => _viewAllOrders(context),
                    style: TextButton.styleFrom(
                      foregroundColor: colorScheme.onSurfaceVariant,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'View All Orders',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _trackOrder(BuildContext context) {
    HapticFeedback.lightImpact();
    // Navigate to order tracking screen or show tracking modal
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        height: 70.h,
        padding: EdgeInsets.all(4.w),
        child: Column(
          children: [
            Container(
              width: 10.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .outline
                    .withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              'Live Order Tracking',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            SizedBox(height: 2.h),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomIconWidget(
                      iconName: 'delivery_dining',
                      color: Theme.of(context).colorScheme.primary,
                      size: 60,
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      'Your order is being prepared!',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      'Estimated delivery: 25-30 minutes',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _downloadReceipt(BuildContext context) {
    HapticFeedback.lightImpact();

    // Generate receipt content
    final receiptContent = _generateReceiptContent();

    // Show download confirmation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            CustomIconWidget(
              iconName: 'check_circle',
              color: Colors.white,
              size: 20,
            ),
            SizedBox(width: 2.w),
            const Text('Receipt downloaded successfully!'),
          ],
        ),
        backgroundColor: AppTheme.successLight,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  void _shareOrder(BuildContext context) {
    HapticFeedback.lightImpact();

    final shareText = '''
🎉 Just ordered delicious food from Vada Pav Express!

Order #$orderNumber
Total: ${orderData['totalAmount']}

Items:
${(orderData['items'] as List).map((item) => '• ${item['name']} x${item['quantity']}').join('\n')}

Download the app and try it yourself! 🍴
''';

    Share.share(
      shareText,
      subject: 'My Vada Pav Express Order',
    );
  }

  void _continueShopping(BuildContext context) {
    HapticFeedback.lightImpact();
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/product-catalog-screen',
      (route) => false,
    );
  }

  void _viewAllOrders(BuildContext context) {
    HapticFeedback.lightImpact();
    // Navigate to order history screen
    Navigator.pushNamed(context, '/order-confirmation-screen');
  }

  String _generateReceiptContent() {
    final items = (orderData['items'] as List).cast<Map<String, dynamic>>();
    final itemsText = items
        .map(
            (item) => '${item['name']} x${item['quantity']} - ${item['price']}')
        .join('\n');

    return '''
VADA PAV EXPRESS
Order Receipt

Order Number: $orderNumber
Date: ${DateTime.now().toString().split(' ')[0]}
Time: ${DateTime.now().toString().split(' ')[1].substring(0, 5)}

ITEMS ORDERED:
$itemsText

PAYMENT SUMMARY:
Subtotal: ${orderData['subtotal']}
Delivery Fee: ${orderData['deliveryFee']}
GST (5%): ${orderData['gst']}
Total Paid: ${orderData['totalAmount']}

Payment Method: ${orderData['paymentMethod']}

Thank you for choosing Vada Pav Express!
''';
  }
}
