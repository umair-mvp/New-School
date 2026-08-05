// lib/app/services/php_payment_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class PHPPaymentService {
  static const String baseUrl = 'http://10.0.2.2:8000/public/fib';
  // static const String baseUrl = 'https://newschool.academy/public/fib';

  // Call your existing check_payment_status.php to process payment and run SQL queries
  // Use GET request instead of POST
  static Future<Map<String, dynamic>> processPaymentWithPHP({
    required String paymentId,
    required int userId,
  }) async {
    try {
      print('🚀 CALLING PHP via GET: check_payment_status.php');
      print('📤 Payment: $paymentId, User: $userId');

      // Use GET with query parameters
      final uri = Uri.parse('$baseUrl/mob_check_payment_status.php').replace(
        queryParameters: {
          'payment_id': paymentId,
          'user_id': userId.toString(),
        },
      );

      final response = await http.get(uri);

      print('📡 PHP Response Status: ${response.statusCode}');
      print('📡 PHP Response Body: ${response.body}');

      if (response.statusCode == 200) {
        try {
          final data = jsonDecode(response.body);

          // Check if payment was PAID and database was updated
          if (data['status'] == 'PAID') {
            final dbSuccess = data['dbUpdateResult'] ?? false;

            return {
              'success': true,
              'status': data['status'],
              'dbUpdateResult': dbSuccess,
              'paymentData': data,
              'message': dbSuccess
                  ? 'Payment processed and courses purchased successfully!'
                  : 'Payment successful but database update failed',
            };
          } else {
            return {
              'success': false,
              'status': data['status'],
              'error': 'Payment not completed: ${data['status']}'
            };
          }
        } catch (e) {
          print('❌ JSON Parse Error: $e');
          return {'success': false, 'error': 'Invalid response from server'};
        }
      } else {
        return {
          'success': false,
          'error': 'Server returned: ${response.statusCode} - ${response.body}'
        };
      }
    } catch (e) {
      print('❌ PHP Service Error: $e');
      return {'success': false, 'error': 'Network error: $e'};
    }
  }

  // Simple direct method
  static Future<bool> triggerPurchase(String paymentId, int userId) async {
    final result = await processPaymentWithPHP(
      paymentId: paymentId,
      userId: userId,
    );
    return result['success'] == true;
  }
}
