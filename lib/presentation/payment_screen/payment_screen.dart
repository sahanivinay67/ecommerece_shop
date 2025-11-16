import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import 'widgets/card_input_form.dart';
import 'widgets/order_summary_card.dart';
import 'widgets/payment_method_card.dart';
import 'widgets/security_badge.dart';
import 'widgets/upi_apps_grid.dart';

enum PaymentMethod { upi, card, wallet, cod }

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  PaymentMethod _selectedPaymentMethod = PaymentMethod.upi;
  String _selectedUpiApp = '';
  Map<String, String> _cardDetails = {};
  bool _isProcessingPayment = false;
  
  // Mock order data
  final List<Map<String, dynamic>> _orderItems = [
{ "id": 1,
"name": "Vada Pav",
"price": 25.0,
"quantity": 2,
"image": "https://images.unsplash.com/photo-1624374053855-39a5a1a41402",
"semanticLabel": "Traditional vada pav with golden fried potato dumpling in soft bread bun with green chutney",
},
{ "id": 2,
"name": "Samosa",
"price": 20.0,
"quantity": 3,
"image": "https://images.unsplash.com/photo-1638690239774-2fcf6ad3db02",
"semanticLabel": "Crispy golden triangular samosas filled with spiced potato and peas mixture",
},
{ "id": 3,
"name": "Jalebi",
"price": 30.0,
"quantity": 1,
"image": "https://images.unsplash.com/photo-1706785743444-e1ccf0373193",
"semanticLabel": "Sweet orange spiral-shaped jalebi dessert dripping with sugar syrup",
},
];

  double get _subtotal {
    return _orderItems.fold(0.0, (sum, item) => 
        sum + ((item["price"] as double) * (item["quantity"] as int)));
  }

  double get _deliveryFee => 40.0;
  double get _gst => _subtotal * 0.18;
  double get _total => _subtotal + _deliveryFee + _gst;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: _buildAppBar(),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SecurityBadge(),
                    SizedBox(height: 3.h),
                    OrderSummaryCard(
                      orderItems: _orderItems,
                      subtotal: _subtotal,
                      deliveryFee: _deliveryFee,
                      gst: _gst,
                      total: _total,
                    ),
                    SizedBox(height: 3.h),
                    Text(
                      'Choose Payment Method',
                      style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppTheme.lightTheme.colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    _buildPaymentMethods(),
                    SizedBox(height: 3.h),
                    _buildPaymentMethodDetails(),
                    SizedBox(height: 10.h), // Space for bottom button
                  ],
                ),
              ),
            ),
            _buildPaymentButton(),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      elevation: 0,
      leading: IconButton(
        icon: CustomIconWidget(
          iconName: 'arrow_back_ios',
          color: AppTheme.lightTheme.colorScheme.onSurface,
          size: 24,
        ),
        onPressed: () {
          HapticFeedback.lightImpact();
          Navigator.pop(context);
        },
      ),
      title: Text(
        'Payment',
        style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w600,
          color: AppTheme.lightTheme.colorScheme.onSurface,
        ),
      ),
      actions: [
        Container(
          margin: EdgeInsets.only(right: 4.w),
          padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomIconWidget(
                iconName: 'currency_rupee',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 16,
              ),
              SizedBox(width: 1.w),
              Text(
                _total.toStringAsFixed(0),
                style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppTheme.lightTheme.colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentMethods() {
    return Column(
      children: [
        PaymentMethodCard(
          title: 'UPI Payment',
          subtitle: 'Pay using PhonePe, Google Pay, Paytm & more',
          iconName: 'qr_code_scanner',
          isSelected: _selectedPaymentMethod == PaymentMethod.upi,
          onTap: () => _selectPaymentMethod(PaymentMethod.upi),
          trailing: Container(
            padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              'Instant',
              style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        PaymentMethodCard(
          title: 'Credit/Debit Card',
          subtitle: 'Visa, Mastercard, RuPay supported',
          iconName: 'credit_card',
          isSelected: _selectedPaymentMethod == PaymentMethod.card,
          onTap: () => _selectPaymentMethod(PaymentMethod.card),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomIconWidget(
                iconName: 'security',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 16,
              ),
              SizedBox(width: 1.w),
              Text(
                'Secure',
                style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        PaymentMethodCard(
          title: 'Digital Wallet',
          subtitle: 'Paytm, Mobikwik, Amazon Pay',
          iconName: 'account_balance_wallet',
          isSelected: _selectedPaymentMethod == PaymentMethod.wallet,
          onTap: () => _selectPaymentMethod(PaymentMethod.wallet),
        ),
        PaymentMethodCard(
          title: 'Cash on Delivery',
          subtitle: 'Pay when your order arrives',
          iconName: 'local_shipping',
          isSelected: _selectedPaymentMethod == PaymentMethod.cod,
          onTap: () => _selectPaymentMethod(PaymentMethod.cod),
          trailing: Container(
            padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.secondary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              '₹10 extra',
              style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.secondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentMethodDetails() {
    switch (_selectedPaymentMethod) {
      case PaymentMethod.upi:
        return UpiAppsGrid(
          onUpiAppSelected: (appName) {
            setState(() {
              _selectedUpiApp = appName;
            });
            HapticFeedback.selectionClick();
          },
        );
      case PaymentMethod.card:
        return CardInputForm(
          onCardDetailsChanged: (details) {
            setState(() {
              _cardDetails = details;
            });
          },
        );
      case PaymentMethod.wallet:
        return _buildWalletOptions();
      case PaymentMethod.cod:
        return _buildCodDetails();
    }
  }

  Widget _buildWalletOptions() {
    final wallets = [
      {'name': 'Paytm Wallet', 'balance': '₹1,250', 'icon': 'account_balance_wallet'},
      {'name': 'Mobikwik', 'balance': '₹850', 'icon': 'account_balance_wallet'},
      {'name': 'Amazon Pay', 'balance': '₹2,100', 'icon': 'account_balance_wallet'},
    ];

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select Wallet',
            style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 2.h),
          ...wallets.map((wallet) => Container(
            margin: EdgeInsets.only(bottom: 1.h),
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Container(
                width: 10.w,
                height: 10.w,
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: CustomIconWidget(
                    iconName: wallet['icon'] as String,
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 20,
                  ),
                ),
              ),
              title: Text(
                wallet['name'] as String,
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                ),
              ),
              subtitle: Text(
                'Balance: ${wallet['balance']}',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
              trailing: Radio<String>(
                value: wallet['name'] as String,
                groupValue: _selectedUpiApp,
                onChanged: (value) {
                  setState(() {
                    _selectedUpiApp = value ?? '';
                  });
                  HapticFeedback.selectionClick();
                },
                activeColor: AppTheme.lightTheme.colorScheme.primary,
              ),
              onTap: () {
                setState(() {
                  _selectedUpiApp = wallet['name'] as String;
                });
                HapticFeedback.selectionClick();
              },
            ),
          )).toList(),
        ],
      ),
    );
  }

  Widget _buildCodDetails() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'info',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 20,
              ),
              SizedBox(width: 2.w),
              Text(
                'Cash on Delivery Details',
                style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          _buildCodDetailRow('Total Amount', '₹${(_total + 10).toStringAsFixed(0)}'),
          SizedBox(height: 1.h),
          _buildCodDetailRow('COD Charges', '₹10'),
          SizedBox(height: 1.h),
          _buildCodDetailRow('Exact Change Required', 'Yes'),
          SizedBox(height: 2.h),
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.secondary.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppTheme.lightTheme.colorScheme.secondary.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'warning',
                  color: AppTheme.lightTheme.colorScheme.secondary,
                  size: 16,
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: Text(
                    'Please keep exact change ready. Our delivery partner may not carry change.',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.secondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCodDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
        ),
        Text(
          value,
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
            color: AppTheme.lightTheme.colorScheme.onSurface,
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentButton() {
    final isButtonEnabled = _isPaymentMethodValid();
    final buttonText = _getPaymentButtonText();
    
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        height: 6.h,
        child: ElevatedButton(
          onPressed: isButtonEnabled && !_isProcessingPayment ? _processPayment : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: isButtonEnabled 
                ? AppTheme.lightTheme.colorScheme.primary
                : AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
            foregroundColor: Colors.white,
            elevation: isButtonEnabled ? 2 : 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: _isProcessingPayment
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 5.w,
                      height: 5.w,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                    SizedBox(width: 3.w),
                    Text(
                      'Processing...',
                      style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomIconWidget(
                      iconName: _selectedPaymentMethod == PaymentMethod.cod 
                          ? 'local_shipping' 
                          : 'payment',
                      color: Colors.white,
                      size: 20,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      buttonText,
                      style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  void _selectPaymentMethod(PaymentMethod method) {
    setState(() {
      _selectedPaymentMethod = method;
      _selectedUpiApp = '';
      _cardDetails.clear();
    });
    HapticFeedback.selectionClick();
  }

  bool _isPaymentMethodValid() {
    switch (_selectedPaymentMethod) {
      case PaymentMethod.upi:
        return _selectedUpiApp.isNotEmpty;
      case PaymentMethod.card:
        return _cardDetails['isValid'] == 'true';
      case PaymentMethod.wallet:
        return _selectedUpiApp.isNotEmpty;
      case PaymentMethod.cod:
        return true;
    }
  }

  String _getPaymentButtonText() {
    final amount = _selectedPaymentMethod == PaymentMethod.cod 
        ? (_total + 10).toStringAsFixed(0)
        : _total.toStringAsFixed(0);
    
    switch (_selectedPaymentMethod) {
      case PaymentMethod.upi:
        return 'Pay ₹$amount';
      case PaymentMethod.card:
        return 'Pay ₹$amount';
      case PaymentMethod.wallet:
        return 'Pay ₹$amount';
      case PaymentMethod.cod:
        return 'Place COD Order';
    }
  }

  Future<void> _processPayment() async {
    setState(() {
      _isProcessingPayment = true;
    });

    HapticFeedback.mediumImpact();

    // Simulate payment processing
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        _isProcessingPayment = false;
      });

      // Show success feedback
      HapticFeedback.heavyImpact();
      
      // Navigate to order confirmation
      Navigator.pushReplacementNamed(context, '/order-confirmation-screen');
    }
  }
}