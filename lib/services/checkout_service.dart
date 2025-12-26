import 'package:flutter/foundation.dart';

class CheckoutService extends ChangeNotifier {
  // Shipping Address
  String? _name;
  String? _zipCode;
  String? _country;
  String? _state;
  String? _city;
  String? _fullAddress;
  bool _saveAddress = false;

  // Payment Method
  String _paymentMethod = 'Credit Card';
  String? _cardNumber;
  String? _cardHolderName;
  String? _expiryDate;
  String? _cvv;

  // Coupon
  String? _couponCode;
  double _discount = 0.0;

  // Getters - Shipping Address
  String? get name => _name;
  String? get zipCode => _zipCode;
  String? get country => _country;
  String? get state => _state;
  String? get city => _city;
  String? get fullAddress => _fullAddress;
  bool get saveAddress => _saveAddress;

  // Getters - Payment
  String get paymentMethod => _paymentMethod;
  String? get cardNumber => _cardNumber;
  String? get cardHolderName => _cardHolderName;
  String? get expiryDate => _expiryDate;
  String? get cvv => _cvv;

  // Getters - Coupon
  String? get couponCode => _couponCode;
  double get discount => _discount;

  // Setters - Shipping Address
  void setShippingAddress({
    required String name,
    required String zipCode,
    required String country,
    required String state,
    required String city,
    String? fullAddress,
    bool saveAddress = false,
  }) {
    _name = name;
    _zipCode = zipCode;
    _country = country;
    _state = state;
    _city = city;
    _fullAddress = fullAddress;
    _saveAddress = saveAddress;
    notifyListeners();
  }

  // Setters - Payment Method
  void setPaymentMethod(String method) {
    _paymentMethod = method;
    notifyListeners();
  }

  void setCreditCardInfo({
    required String cardNumber,
    required String cardHolderName,
    required String expiryDate,
    required String cvv,
  }) {
    _cardNumber = cardNumber;
    _cardHolderName = cardHolderName;
    _expiryDate = expiryDate;
    _cvv = cvv;
    notifyListeners();
  }

  // Setters - Coupon
  void applyCoupon(String code, double discountAmount) {
    _couponCode = code;
    _discount = discountAmount;
    notifyListeners();
  }

  void removeCoupon() {
    _couponCode = null;
    _discount = 0.0;
    notifyListeners();
  }

  // Get delivery address as Map for API
  Map<String, dynamic> getDeliveryAddressMap() {
    return {
      'name': _name ?? '',
      'zipCode': _zipCode ?? '',
      'country': _country ?? '',
      'state': _state ?? '',
      'city': _city ?? '',
      'fullAddress': _fullAddress ?? '$_city, $_state, $_country $_zipCode',
    };
  }

  // Validate shipping address
  bool isShippingAddressValid() {
    return _name != null &&
        _name!.isNotEmpty &&
        _zipCode != null &&
        _zipCode!.isNotEmpty &&
        _country != null &&
        _country!.isNotEmpty &&
        _state != null &&
        _state!.isNotEmpty &&
        _city != null &&
        _city!.isNotEmpty;
  }

  // Validate payment method
  bool isPaymentMethodValid() {
    if (_paymentMethod == 'Credit Card') {
      return _cardNumber != null &&
          _cardNumber!.isNotEmpty &&
          _cardHolderName != null &&
          _cardHolderName!.isNotEmpty &&
          _expiryDate != null &&
          _expiryDate!.isNotEmpty &&
          _cvv != null &&
          _cvv!.isNotEmpty;
    }
    return true; // Other payment methods don't require validation yet
  }

  // Reset checkout data
  void reset() {
    _name = null;
    _zipCode = null;
    _country = null;
    _state = null;
    _city = null;
    _fullAddress = null;
    _saveAddress = false;
    _paymentMethod = 'Credit Card';
    _cardNumber = null;
    _cardHolderName = null;
    _expiryDate = null;
    _cvv = null;
    _couponCode = null;
    _discount = 0.0;
    notifyListeners();
  }
}
