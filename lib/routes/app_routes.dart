import 'package:ecommerece_shop/splash_screen.dart';
import 'package:flutter/material.dart';
import '../presentation/payment_catalog_screen/payment_catalog_screen.dart';
import '../presentation/payment_screen/payment_screen.dart';
import '../presentation/checkout_screen/checkout_screen.dart';
import '../presentation/order_confirmation_screen/order_confirmation_screen.dart';
import '../presentation/product_details_screen/product_details_screen.dart';
import '../presentation/shopping_cart_screen.dart/shopping_cart_screen.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String splash= '/splash';
   static const String initial = '/';
  static const String productDetail = '/product-detail-screen';
  static const String payment = '/payment-screen';
  static const String shoppingCart = '/shopping-cart-screen';
  static const String checkout = '/checkout-screen';
  static const String productCatalog = '/product-catalog-screen';
  static const String orderConfirmation = '/order-confirmation-screen';

  static Map<String, WidgetBuilder> routes = {
    splash: (context) =>  SplashScreen(),
    initial: (context) => const ProductCatalogScreen(),
    productDetail: (context) => const ProductDetailScreen(),
    payment: (context) => const PaymentScreen(),
    shoppingCart: (context) => const ShoppingCartScreen(),
    checkout: (context) => const CheckoutScreen(),
    productCatalog: (context) => const ProductCatalogScreen(),
    orderConfirmation: (context) => const OrderConfirmationScreen(),
    // TODO: Add your other routes here
  };
}
