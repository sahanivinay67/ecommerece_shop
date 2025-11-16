import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import 'widgets/address_input_widget.dart';
import 'widgets/delivery_address_widget.dart';
import 'widgets/delivery_time_widget.dart';
import 'widgets/order_details_widget.dart';
import 'widgets/order_summary_widget.dart';
import 'widgets/order_total_widget.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  bool _isOrderSummaryExpanded = false;
  bool _isLoading = false;
  String? _selectedTimeSlot;
  Map<String, dynamic>? _selectedAddress;
  String _selectedAddressType = 'Home';
  String? _contactNumberError;
  String? _addressError;

  final TextEditingController _specialInstructionsController =
      TextEditingController();
  final TextEditingController _contactNumberController =
      TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _landmarkController = TextEditingController();

  final List<Map<String, dynamic>> _cartItems = [
    {
      "id": 1,
      "name": "Classic Vada Pav",
      "description":
          "Mumbai's iconic street food with spicy potato fritter in soft pav bread, served with chutneys",
      "price": 25.0,
      "quantity": 2,
      "image":
          "https://images.unsplash.com/photo-1707958718719-530f11bd7e56",
      "semanticLabel":
          "Golden brown vada pav served on a white plate with green mint chutney and red garlic chutney on the side"
    },
    {
      "id": 2,
      "name": "Samosa",
      "description":
          "Crispy triangular pastry filled with spiced potatoes and peas, perfect tea-time snack",
      "price": 15.0,
      "quantity": 3,
      "image":
          "https://images.unsplash.com/photo-1706092949227-52062b5eb190",
      "semanticLabel":
          "Golden crispy samosas arranged on a wooden plate with green mint chutney and sliced onions"
    },
    {
      "id": 3,
      "name": "Aloo Patties",
      "description":
          "Crispy potato patties seasoned with Indian spices, served hot with tangy chutneys",
      "price": 20.0,
      "quantity": 1,
      "image":
          "https://images.unsplash.com/photo-1708782340351-25feb5640076",
      "semanticLabel":
          "Round golden potato patties garnished with fresh coriander leaves and served with colorful chutneys"
    }
  ];

  final List<Map<String, dynamic>> _savedAddresses = [
    {
      "id": 1,
      "type": "Home",
      "address":
          "A-204, Sunrise Apartments, Linking Road, Bandra West, Mumbai - 400050",
      "landmark": "Near Bandra Station, Opposite McDonald's"
    },
    {
      "id": 2,
      "type": "Work",
      "address": "Office No. 15, Tech Park, Andheri East, Mumbai - 400069",
      "landmark": "Next to Metro Station, Behind Coffee Day"
    }
  ];

  @override
  void initState() {
    super.initState();
    _contactNumberController.text = "+91 9876543210";
    _selectedAddress =
        _savedAddresses.isNotEmpty ? _savedAddresses.first : null;
    _selectedTimeSlot = 'asap';
  }

  @override
  void dispose() {
    _specialInstructionsController.dispose();
    _contactNumberController.dispose();
    _addressController.dispose();
    _landmarkController.dispose();
    super.dispose();
  }

  bool get _isFormValid {
    return _selectedAddress != null &&
        _selectedTimeSlot != null &&
        _contactNumberController.text.isNotEmpty &&
        _contactNumberError == null;
  }

  void _validateContactNumber(String value) {
    setState(() {
      if (value.isEmpty) {
        _contactNumberError = 'Contact number is required';
      } else if (!RegExp(r'^\+91\s?[6-9]\d{9}$').hasMatch(value)) {
        _contactNumberError = 'Please enter a valid Indian mobile number';
      } else {
        _contactNumberError = null;
      }
    });
  }

  void _validateAddress(String value) {
    setState(() {
      if (value.isEmpty) {
        _addressError = 'Address is required';
      } else if (value.length < 10) {
        _addressError = 'Please enter a complete address';
      } else {
        _addressError = null;
      }
    });
  }

  void _showAddressBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => AddressInputWidget(
          addressController: _addressController,
          landmarkController: _landmarkController,
          selectedAddressType: _selectedAddressType,
          onAddressTypeChanged: (type) {
            setModalState(() {
              _selectedAddressType = type;
            });
          },
          onSaveAddress: () {
            _validateAddress(_addressController.text);
            if (_addressError == null && _addressController.text.isNotEmpty) {
              setState(() {
                _selectedAddress = {
                  "id": DateTime.now().millisecondsSinceEpoch,
                  "type": _selectedAddressType,
                  "address": _addressController.text,
                  "landmark": _landmarkController.text.isEmpty
                      ? "No landmark provided"
                      : _landmarkController.text,
                };
              });
              Navigator.pop(context);
              _addressController.clear();
              _landmarkController.clear();
              _selectedAddressType = 'Home';
            }
          },
          onCancel: () {
            Navigator.pop(context);
            _addressController.clear();
            _landmarkController.clear();
            _selectedAddressType = 'Home';
          },
          addressError: _addressError,
        ),
      ),
    );
  }

  void _showAddressSelectionBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Select Address',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: CustomIconWidget(
                    iconName: 'close',
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    size: 24,
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            ..._savedAddresses.map((address) => _buildAddressOption(address)),
            SizedBox(height: 2.h),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  _showAddressBottomSheet();
                },
                icon: CustomIconWidget(
                  iconName: 'add',
                  color: AppTheme.lightTheme.primaryColor,
                  size: 20,
                ),
                label: Text(
                  'Add New Address',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: AppTheme.lightTheme.primaryColor,
                      ),
                ),
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                  side: BorderSide(
                    color: AppTheme.lightTheme.primaryColor,
                    width: 1,
                  ),
                ),
              ),
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  Widget _buildAddressOption(Map<String, dynamic> address) {
    final bool isSelected = _selectedAddress?['id'] == address['id'];

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedAddress = address;
        });
        Navigator.pop(context);
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 2.h),
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1)
              : Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected
                ? AppTheme.lightTheme.primaryColor
                : Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 5.w,
              height: 5.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected
                    ? AppTheme.lightTheme.primaryColor
                    : Colors.transparent,
                border: Border.all(
                  color: isSelected
                      ? AppTheme.lightTheme.primaryColor
                      : Theme.of(context)
                          .colorScheme
                          .outline
                          .withValues(alpha: 0.5),
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 2.w,
                        height: 2.w,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                      ),
                    )
                  : null,
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    address['type'] as String,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    address['address'] as String,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _placeOrder() async {
    if (!_isFormValid) {
      _validateContactNumber(_contactNumberController.text);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        _isLoading = false;
      });

      HapticFeedback.lightImpact();
      Navigator.pushNamed(context, '/payment-screen');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            HapticFeedback.lightImpact();
            Navigator.pop(context);
          },
          icon: CustomIconWidget(
            iconName: 'arrow_back_ios',
            color: colorScheme.onSurface,
            size: 24,
          ),
        ),
        title: Text(
          'Checkout',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: theme.brightness == Brightness.light
              ? Brightness.dark
              : Brightness.light,
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.only(bottom: 2.h),
                child: Column(
                  children: [
                    OrderSummaryWidget(
                      cartItems: _cartItems,
                      isExpanded: _isOrderSummaryExpanded,
                      onToggleExpanded: () {
                        setState(() {
                          _isOrderSummaryExpanded = !_isOrderSummaryExpanded;
                        });
                      },
                    ),
                    DeliveryAddressWidget(
                      selectedAddress: _selectedAddress,
                      onChangeAddress: _showAddressSelectionBottomSheet,
                      onAddNewAddress: _showAddressBottomSheet,
                    ),
                    DeliveryTimeWidget(
                      selectedTimeSlot: _selectedTimeSlot,
                      onTimeSlotSelected: (timeSlot) {
                        setState(() {
                          _selectedTimeSlot = timeSlot;
                        });
                      },
                    ),
                    OrderDetailsWidget(
                      specialInstructionsController:
                          _specialInstructionsController,
                      contactNumberController: _contactNumberController,
                      contactNumberError: _contactNumberError,
                    ),
                    OrderTotalWidget(
                      cartItems: _cartItems,
                    ),
                  ],
                ),
              ),
            ),
            Container(
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
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isFormValid && !_isLoading ? _placeOrder : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isFormValid
                        ? AppTheme.lightTheme.primaryColor
                        : colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: _isFormValid ? 2 : 0,
                  ),
                  child: _isLoading
                      ? SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                      : Text(
                          'Place Order',
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
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
