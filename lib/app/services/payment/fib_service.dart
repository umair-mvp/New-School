import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import '../../pages/main_page/home_page/payment/fib_helper.dart';
import '../../../common/data/app_data.dart';
import '../../../common/utils/constants.dart';

class FIBPaymentService {
  static const bool isTestMode = false;

  static String get baseUrl =>
      isTestMode ? 'https://fib.stage.fib.iq' : 'https://fib.prod.fib.iq';

  static const String clientId = 'pg-protime-newschool';
  static const String clientSecret = '74633b06-bd6a-4e19-acaf-4555403ce1a4';


  static Future<Map<String, dynamic>> getAccessToken() async {
    try {
      final response = await http.post(
        Uri.parse(
            '$baseUrl/auth/realms/fib-online-shop/protocol/openid-connect/token'),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Authorization': 'Bearer $token',
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
        return {
          'success': false,
          'error': 'Failed to get token: ${response.statusCode}'
        };
      }
    } catch (e) {
      return {'success': false, 'error': 'Token error: $e'};
    }
  }

  static Future<Map<String, dynamic>> createPayment({
    required double amount,
    required String callbackUrl,
  }) async {
    try {
      final tokenResult = await getAccessToken();
      if (!tokenResult['success']) {
        return tokenResult;
      }

      final token = tokenResult['token'];
      print("token: $token");

      final response = await http.post(
        Uri.parse('$baseUrl/protected/v1/payments'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          "monetaryValue": {"amount": amount, "currency": "IQD"},
          "statusCallbackUrl": callbackUrl,
          "description": "Webinar Payment",
          "expiresIn": "PT12H",
        }),
      );

      log('FIB Payment Response: ${response.statusCode} - ${response.body}');

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
          'error':
              'Payment creation failed: ${response.statusCode} - ${response.body}'
        };
      }
    } catch (e) {
      return {'success': false, 'error': 'Payment error: $e'};
    }
  }

  static Future<Map<String, dynamic>> checkPaymentStatus(
      String paymentId) async {
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
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {'success': true, 'status': data['status']};
      } else {
        return {
          'success': false,
          'error': 'Status check failed: ${response.statusCode}'
        };
      }
    } catch (e) {
      return {'success': false, 'error': 'Status check error: $e'};
    }
  }

  static Future<Map<String, dynamic>> confirmPurchase(
      String paymentId, String orderId, String token) async {
    try {
      final domain = Constants.dommain;

      // Use Laravel API route
      final url = '${domain}/fib/mob-confirm-purchase';

      log('🔔 Confirming purchase via Laravel API');
      log('URL: $url');
      log('Payment ID: $paymentId');
      log('Order ID: $orderId');
      log('Api Key: $token');

      final response = await http
          .post(
            Uri.parse(url),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer $token',
            },
            body: jsonEncode({
              'payment_id': paymentId,
              'order_id': int.tryParse(orderId) ?? 0,
              'status': 'PAID'
            }),
          )
          .timeout(Duration(seconds: 30));

      log('📦 API Response - Status: ${response.statusCode}');
      log('Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
      } else if (response.statusCode == 422) {
        // Laravel validation error
        final errorData = jsonDecode(response.body);
        final errors = errorData['errors'] ?? {};
        return {'success': false, 'error': 'Validation error: $errors'};
      } else {
        return {
          'success': false,
          'error': 'HTTP ${response.statusCode}: ${response.body}'
        };
      }
    } catch (e) {
      log('💥 Purchase confirmation error: $e');
      return {'success': false, 'error': 'Network error: $e'};
    }
  }
}
