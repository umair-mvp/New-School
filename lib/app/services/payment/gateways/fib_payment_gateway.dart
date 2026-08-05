// lib/app/services/payment/gateways/fib_payment_gateway.dart
import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import '../../../../common/utils/constants.dart';

class FIBPaymentGateway {
  static const String gatewayName = 'FIB';
  static const bool isTestMode = false;
  
  static String get baseUrl => isTestMode 
      ? 'https://fib.stage.fib.iq' 
      : 'https://fib.prod.fib.iq';
  
  static const String clientId = 'protime-terminal-school';
  static const String clientSecret = 'cd43b9ff-43c3-4006-be16-1720b110d5a1';

  // Get access token from FIB
  static Future<Map<String, dynamic>> getAccessToken() async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/realms/fib-online-shop/protocol/openid-connect/token'),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'grant_type': 'client_credentials',
          'client_id': clientId,
          'client_secret': clientSecret,
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {'success': true, 'token': data['access_token']};
      } else {
        log('FIB Token Error: ${response.statusCode} - ${response.body}');
        return {
          'success': false, 
          'error': 'Failed to get token: ${response.statusCode}'
        };
      }
    } catch (e) {
      log('FIB Token Exception: $e');
      return {'success': false, 'error': 'Token error: $e'};
    }
  }

  // Create payment with FIB
  static Future<Map<String, dynamic>> createPayment({
    required double amount,
    required String callbackUrl,
    String description = "Webinar Payment",
  }) async {
    try {
      final tokenResult = await getAccessToken();
      if (!tokenResult['success']) {
        return tokenResult;
      }

      final token = tokenResult['token'];
      
      final response = await http.post(
        Uri.parse('$baseUrl/protected/v1/payments'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          "monetaryValue": {
            "amount": amount,
            "currency": "IQD"
          },
          "statusCallbackUrl": callbackUrl,
          "description": description,
          "expiresIn": "PT12H",
        }),
      );

      log('FIB Payment Creation Response: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'paymentId': data['paymentId'],
          'qrCode': data['qrCode'],
          'personalAppLink': data['personalAppLink'],
          'status': data['status'],
        };
      } else {
        return {
          'success': false, 
          'error': 'Payment creation failed: ${response.statusCode} - ${response.body}'
        };
      }
    } catch (e) {
      log('FIB Payment Creation Exception: $e');
      return {'success': false, 'error': 'Payment error: $e'};
    }
  }

  // Check payment status
  static Future<Map<String, dynamic>> checkPaymentStatus(String paymentId) async {
    try {
      final tokenResult = await getAccessToken();
      if (!tokenResult['success']) {
        return tokenResult;
      }

      final token = tokenResult['token'];
      
      final response = await http.get(
        Uri.parse('$baseUrl/protected/v1/payments/$paymentId'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      log('FIB Status Check Response: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true, 
          'status': data['status'],
          'paymentData': data
        };
      } else {
        return {
          'success': false, 
          'error': 'Status check failed: ${response.statusCode}'
        };
      }
    } catch (e) {
      log('FIB Status Check Exception: $e');
      return {'success': false, 'error': 'Status check error: $e'};
    }
  }

  // Verify payment (additional verification if needed)
  static Future<Map<String, dynamic>> verifyPayment(String paymentId) async {
    return await checkPaymentStatus(paymentId);
  }
}