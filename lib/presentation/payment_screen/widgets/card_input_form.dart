import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CardInputForm extends StatefulWidget {
  final Function(Map<String, String>) onCardDetailsChanged;

  const CardInputForm({
    super.key,
    required this.onCardDetailsChanged,
  });

  @override
  State<CardInputForm> createState() => _CardInputFormState();
}

class _CardInputFormState extends State<CardInputForm> {
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _expiryController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  String _cardType = '';
  bool _isCardNumberValid = false;
  bool _isExpiryValid = false;
  bool _isCvvValid = false;
  bool _isNameValid = false;

  @override
  void initState() {
    super.initState();
    _cardNumberController.addListener(_onCardNumberChanged);
    _expiryController.addListener(_onExpiryChanged);
    _cvvController.addListener(_onCvvChanged);
    _nameController.addListener(_onNameChanged);
  }

  @override
  void dispose() {
    _cardNumberController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _onCardNumberChanged() {
    final cardNumber = _cardNumberController.text.replaceAll(' ', '');
    setState(() {
      _cardType = _getCardType(cardNumber);
      _isCardNumberValid = _validateCardNumber(cardNumber);
    });
    _updateCardDetails();
  }

  void _onExpiryChanged() {
    setState(() {
      _isExpiryValid = _validateExpiry(_expiryController.text);
    });
    _updateCardDetails();
  }

  void _onCvvChanged() {
    setState(() {
      _isCvvValid = _validateCvv(_cvvController.text);
    });
    _updateCardDetails();
  }

  void _onNameChanged() {
    setState(() {
      _isNameValid = _validateName(_nameController.text);
    });
    _updateCardDetails();
  }

  void _updateCardDetails() {
    widget.onCardDetailsChanged({
      'cardNumber': _cardNumberController.text,
      'expiry': _expiryController.text,
      'cvv': _cvvController.text,
      'name': _nameController.text,
      'cardType': _cardType,
      'isValid':
          (_isCardNumberValid && _isExpiryValid && _isCvvValid && _isNameValid)
              .toString(),
    });
  }

  String _getCardType(String cardNumber) {
    if (cardNumber.startsWith('4')) return 'Visa';
    if (cardNumber.startsWith('5') || cardNumber.startsWith('2'))
      return 'Mastercard';
    if (cardNumber.startsWith('6')) return 'RuPay';
    if (cardNumber.startsWith('3')) return 'American Express';
    return '';
  }

  bool _validateCardNumber(String cardNumber) {
    return cardNumber.length >= 13 && cardNumber.length <= 19;
  }

  bool _validateExpiry(String expiry) {
    if (expiry.length != 5) return false;
    final parts = expiry.split('/');
    if (parts.length != 2) return false;

    final month = int.tryParse(parts[0]);
    final year = int.tryParse('20${parts[1]}');

    if (month == null || year == null) return false;
    if (month < 1 || month > 12) return false;

    final now = DateTime.now();
    final expiryDate = DateTime(year, month);
    return expiryDate.isAfter(now);
  }

  bool _validateCvv(String cvv) {
    return cvv.length >= 3 && cvv.length <= 4;
  }

  bool _validateName(String name) {
    return name.trim().length >= 2;
  }

  @override
  Widget build(BuildContext context) {
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
              Text(
                "Card Details",
                style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                ),
              ),
              const Spacer(),
              if (_cardType.isNotEmpty) ...[
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.primary
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    _cardType,
                    style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
              SizedBox(width: 2.w),
              CustomIconWidget(
                iconName: 'security',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 20,
              ),
            ],
          ),
          SizedBox(height: 3.h),
          TextFormField(
            controller: _cardNumberController,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(19),
              _CardNumberInputFormatter(),
            ],
            decoration: InputDecoration(
              labelText: 'Card Number',
              hintText: '1234 5678 9012 3456',
              prefixIcon: CustomIconWidget(
                iconName: 'credit_card',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 20,
              ),
              suffixIcon: _isCardNumberValid
                  ? CustomIconWidget(
                      iconName: 'check_circle',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 20,
                    )
                  : null,
            ),
          ),
          SizedBox(height: 2.h),
          TextFormField(
            controller: _nameController,
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(
              labelText: 'Cardholder Name',
              hintText: 'John Doe',
              prefixIcon: CustomIconWidget(
                iconName: 'person',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 20,
              ),
              suffixIcon: _isNameValid
                  ? CustomIconWidget(
                      iconName: 'check_circle',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 20,
                    )
                  : null,
            ),
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _expiryController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(4),
                    _ExpiryDateInputFormatter(),
                  ],
                  decoration: InputDecoration(
                    labelText: 'Expiry Date',
                    hintText: 'MM/YY',
                    prefixIcon: CustomIconWidget(
                      iconName: 'calendar_today',
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 20,
                    ),
                    suffixIcon: _isExpiryValid
                        ? CustomIconWidget(
                            iconName: 'check_circle',
                            color: AppTheme.lightTheme.colorScheme.primary,
                            size: 20,
                          )
                        : null,
                  ),
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: TextFormField(
                  controller: _cvvController,
                  keyboardType: TextInputType.number,
                  obscureText: true,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(4),
                  ],
                  decoration: InputDecoration(
                    labelText: 'CVV',
                    hintText: '123',
                    prefixIcon: CustomIconWidget(
                      iconName: 'lock',
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 20,
                    ),
                    suffixIcon: _isCvvValid
                        ? CustomIconWidget(
                            iconName: 'check_circle',
                            color: AppTheme.lightTheme.colorScheme.primary,
                            size: 20,
                          )
                        : null,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              CustomIconWidget(
                iconName: 'info',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 16,
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: Text(
                  'Your card details are encrypted and secure',
                  style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CardNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text.replaceAll(' ', '');
    final buffer = StringBuffer();

    for (int i = 0; i < text.length; i++) {
      if (i > 0 && i % 4 == 0) {
        buffer.write(' ');
      }
      buffer.write(text[i]);
    }

    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.length),
    );
  }
}

class _ExpiryDateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;

    if (text.length == 2 && oldValue.text.length == 1) {
      return TextEditingValue(
        text: '$text/',
        selection: const TextSelection.collapsed(offset: 3),
      );
    }

    return newValue;
  }
}
