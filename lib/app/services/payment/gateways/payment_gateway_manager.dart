// lib/app/services/payment/payment_gateway_manager.dart
import 'fib_payment_gateway.dart';

class PaymentGatewayManager {
  static Map<String, dynamic> getAvailableGateways() {
    return {
      'FIB': {
        'name': 'First Iraqi Bank',
        'className': 'FIBPaymentGateway',
        'image': 'assets/images/fib_logo.png',
        'type': 'online',
        'currencies': ['IQD'],
        'isActive': true,
      },
    };
  }

  static Future<Map<String, dynamic>> processPayment({
    required String gatewayName,
    required double amount,
    required String callbackUrl,
    Map<String, dynamic>? additionalData,
  }) async {
    switch (gatewayName) {
      case 'FIB':
        return await FIBPaymentGateway.createPayment(
          amount: amount,
          callbackUrl: callbackUrl,
        );
      
      default:
        return {
          'success': false,
          'error': 'Payment gateway not found: $gatewayName'
        };
    }
  }

  static Future<Map<String, dynamic>> checkPaymentStatus({
    required String gatewayName,
    required String paymentId,
  }) async {
    switch (gatewayName) {
      case 'FIB':
        return await FIBPaymentGateway.checkPaymentStatus(paymentId);
      
      default:
        return {
          'success': false,
          'error': 'Payment gateway not found: $gatewayName'
        };
    }
  }
}