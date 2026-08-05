import 'dart:convert';

import 'package:http/http.dart';
import '../../models/cart_model.dart';
import '../../models/checkout_model.dart';
import '../../providers/user_provider.dart';
import '../../../common/components.dart';
import '../../../common/utils/app_text.dart';
import '../../../common/utils/error_handler.dart';
import '../../../locator.dart';
import 'package:http/http.dart' as http;

import '../../../common/enums/error_enum.dart';
import '../../../common/utils/constants.dart';
import '../../../common/utils/http_handler.dart';

class CartService {
  static Future<CartModel?> getCart() async {
    try {
      String url = '${Constants.baseUrl}panel/cart/list';

      Response res =
          await httpGetWithToken(url, isRedirectingStatusCode: false);

      var jsonResponse = jsonDecode(res.body);

      if (jsonResponse['success']) {
        print("cart: $jsonResponse");
        locator<UserProvider>().setCartData(
            CartModel.fromJson(jsonResponse['data']?['cart'] ?? {}));
        return CartModel.fromJson(jsonResponse['data']?['cart'] ?? {});
      } else {
        ErrorHandler()
            .showError(ErrorEnum.error, jsonResponse, readMessage: true);
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static Future<String?> webCheckout() async {
    try {
      String url = '${Constants.baseUrl}panel/cart/web_checkout';

      Response res =
          await httpPostWithToken(url, {}, isRedirectingStatusCode: false);

      var jsonResponse = jsonDecode(res.body);

      if (jsonResponse['success']) {
        print("cart1: $jsonResponse");

        return jsonResponse['data']['link'];
      } else {
        ErrorHandler()
            .showError(ErrorEnum.error, jsonResponse, readMessage: true);
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static Future validateCoupon(String coupon) async {
    try {
      String url = '${Constants.baseUrl}panel/cart/coupon/validate';

      Response res = await httpPostWithToken(url, {"coupon": coupon},
          isRedirectingStatusCode: false);

      var jsonResponse = jsonDecode(res.body);

      if (jsonResponse['success']) {
        return {
          'amount': Amounts.fromJson(jsonResponse['data']['amounts']),
          'discount_id': jsonResponse['data']['discount']['id']
        };
      } else {
        ErrorHandler()
            .showError(ErrorEnum.error, jsonResponse, readMessage: true);
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static Future<bool> store(int courseId, int ticketId) async {
    try {
      String url = '${Constants.baseUrl}panel/cart/store';

      Response res = await httpPostWithToken(url,
          {"webinar_id": courseId.toString(), "ticket_id": ticketId.toString()},
          isRedirectingStatusCode: false);

      var jsonResponse = jsonDecode(res.body);

      if (jsonResponse['success']) {
        getCart();
        showSnackBar(ErrorEnum.success, appText.successAddToCartDesc);
        return true;
      } else {
        ErrorHandler()
            .showError(ErrorEnum.error, jsonResponse, readMessage: true);
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  static Future<dynamic> payRequest(int gatewayId, int orderId) async {
    try {
      String url = '${Constants.baseUrl}panel/payments/request';
      Response res = await httpPostWithToken(url,
          {"gateway_id": gatewayId.toString(), "order_id": orderId.toString()},
          isRedirectingStatusCode: false);

      var jsonResponse;
      try {
        jsonResponse = jsonDecode(res.body.toString());
      } catch (e) {}
      // print(res.statusCode);
      print(res.body);

      if (jsonResponse?['success'] ?? true) {
        return res.body;
      } else {
        ErrorHandler().showError(ErrorEnum.error, jsonResponse);
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static Future<bool> credit(int orderId) async {
    try {
      final response = await http.post(
        Uri.parse('${Constants.baseUrl}/credit'),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Accept': 'application/json',
        },
        body: {
          'order_id': orderId.toString(),
          'payment_gateway': 'fib',
        },
      );

      print('Credit response: ${response.body}');
      final data = jsonDecode(response.body);

      // REMOVE THE OVERRIDE - Let it return actual result
      return data['success'] == true;
    } catch (e) {
      print('Credit system error: $e');
      return false;
    }
  }

  static Future<bool> confirmFIBPayment(
      int orderId, String fibPaymentId) async {
    try {
      final response = await http.post(
        Uri.parse('${Constants.baseUrl}/payments/fib/confirm'),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Accept': 'application/json',
        },
        body: {
          'order_id': orderId.toString(),
          'fib_payment_id': fibPaymentId,
          'status': 'paid',
          'verified': 'true',
        },
      );

      print('FIB Payment Confirmation response: ${response.body}');

      final data = jsonDecode(response.body);
      return data['success'] == true;
    } catch (e) {
      print('FIB confirmation endpoint may not exist: $e');
      return false;
    }
  }

  static Future<bool> forceClearCart() async {
    try {
      // Get current cart to see what items need to be removed
      final cart = await getCart();
      if (cart?.items != null) {
        for (final item in cart!.items!) {
          await deleteCourse(item.id!);
        }
      }
      return true;
    } catch (e) {
      print('Error forcing cart clear: $e');
      return false;
    }
  }

  static Future<bool> subscribeApplay(int courseId) async {
    try {
      String url = '${Constants.baseUrl}panel/subscribe/apply';

      Response res = await httpPostWithToken(
          url,
          {
            "webinar_id": courseId.toString(),
          },
          isRedirectingStatusCode: false);

      var jsonResponse = jsonDecode(res.body);

      if (jsonResponse['success']) {
        return true;
      } else {
        ErrorHandler()
            .showError(ErrorEnum.error, jsonResponse, readMessage: true);
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  static Future<bool> add(
      String itemId, String itemName, String? specifications) async {
    try {
      String url = '${Constants.baseUrl}panel/cart';

      Response res = await httpPostWithToken(
          url,
          {
            "item_id": itemId,
            "item_name": itemName,
            "specifications": specifications,
            "quantity": "1"
          },
          isRedirectingStatusCode: false);

      var jsonResponse = jsonDecode(res.body);
      print(jsonResponse);

      if (jsonResponse['success']) {
        getCart();
        showSnackBar(ErrorEnum.success, appText.successAddToCartDesc);
        return true;
      } else {
        ErrorHandler()
            .showError(ErrorEnum.error, jsonResponse, readMessage: true);
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  static Future<bool> deleteCourse(int id) async {
    try {
      String url = '${Constants.baseUrl}panel/cart/$id';

      Response res =
          await httpDeleteWithToken(url, {}, isRedirectingStatusCode: false);

      var jsonResponse = jsonDecode(res.body);

      if (jsonResponse['success']) {
        return true;
      } else {
        ErrorHandler()
            .showError(ErrorEnum.error, jsonResponse, readMessage: true);
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  static Future<CheckoutModel?> checkout() async {
    try {
      String url = '${Constants.baseUrl}panel/cart/checkout';

      Response res =
          await httpPostWithToken(url, {}, isRedirectingStatusCode: false);

      var jsonResponse = jsonDecode(res.body);

      if (jsonResponse['success']) {
        return CheckoutModel.fromJson(jsonResponse['data']);
      } else {
        ErrorHandler()
            .showError(ErrorEnum.error, jsonResponse, readMessage: true);
        return null;
      }
    } catch (e) {
      return null;
    }
  }

// In your CartService class, add this method
  static Future<Map<String, String>> getHeaders() async {
    // If you have user authentication, include the token
    // If not, use basic headers
    return {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Accept': 'application/json',
      // Add authorization header if needed:
      // 'Authorization': 'Bearer $token',
    };
  }

  static Future<bool> completePurchase(
      int orderId, String paymentMethod) async {
    try {
      print(
          'Completing purchase for order: $orderId with payment: $paymentMethod');

      // Call the checkout method and store in a differently named variable
      final checkoutResponse = await checkout();
      if (checkoutResponse == null || checkoutResponse.order?.id != orderId) {
        print('Checkout data invalid or order ID mismatch');
        return false;
      }

      final response = await http.post(
        Uri.parse('${Constants.baseUrl}/checkout/complete'),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Accept': 'application/json',
        },
        body: {
          'order_id': orderId.toString(),
          'payment_method': paymentMethod,
          'payment_status': 'paid',
          'gateway': 'fib',
        },
      );

      print(
          'Complete purchase response: ${response.statusCode} - ${response.body}');

      final data = jsonDecode(response.body);

      if (data['success'] == true) {
        print('Purchase completed successfully!');
        await clearCart();
        return true;
      } else {
        print('Purchase completion failed: ${data['message']}');
        return false;
      }
    } catch (e) {
      print('Complete purchase error: $e');
      return false;
    }
  }

  // In CartService - Replace the payment request method
  static Future<Map<String, dynamic>> requestFIBPayment(int orderId) async {
    try {
      // First, get available payment channels
      final channels = await getPaymentChannels();
      final fibChannelId = findFIBPaymentChannel(channels ?? []);

      if (fibChannelId == null) {
        return {'success': false, 'error': 'FIB payment channel not found'};
      }

      print('Using FIB Channel ID: $fibChannelId for order: $orderId');

      // Make payment request through your Laravel system
      String url = '${Constants.baseUrl}payments/request';

      Response res = await httpPostWithToken(
        url,
        {
          "gateway": fibChannelId,
          "order_id": orderId.toString(),
        },
        isRedirectingStatusCode: false,
      );

      print('Payment Request Response: ${res.statusCode} - ${res.body}');

      var jsonResponse;
      try {
        jsonResponse = jsonDecode(res.body);
      } catch (e) {
        // If it's a redirect URL, handle it
        if (res.body.contains('http')) {
          return {
            'success': true,
            'redirect_url': res.body,
            'payment_method': 'laravel_redirect'
          };
        }
        return {'success': false, 'error': 'Invalid response format'};
      }

      if (jsonResponse?['success'] ?? false) {
        return {
          'success': true,
          'data': jsonResponse['data'],
          'payment_method': 'laravel_api'
        };
      } else {
        return {
          'success': false,
          'error': jsonResponse?['msg'] ?? 'Payment request failed'
        };
      }
    } catch (e) {
      print('Payment request error: $e');
      return {'success': false, 'error': 'Payment request failed: $e'};
    }
  }

// In CartService - Add payment verification
  static Future<Map<String, dynamic>> verifyPayment(int orderId) async {
    try {
      String url = '${Constants.baseUrl}payments/verify';

      Response res = await httpPostWithToken(
        url,
        {
          "order_id": orderId.toString(),
        },
        isRedirectingStatusCode: false,
      );

      print('Payment Verify Response: ${res.statusCode} - ${res.body}');

      var jsonResponse = jsonDecode(res.body);

      if (jsonResponse['success']) {
        return {
          'success': true,
          'order': jsonResponse['data']['order'],
          'message': 'Payment verified successfully'
        };
      } else {
        return {
          'success': false,
          'error': jsonResponse['msg'] ?? 'Payment verification failed'
        };
      }
    } catch (e) {
      print('Payment verification error: $e');
      return {'success': false, 'error': 'Verification failed: $e'};
    }
  }

  static Future<bool> clearCart() async {
    try {
      final cart = await getCart();
      if (cart?.items == null || cart!.items!.isEmpty) {
        return true;
      }

      for (final item in cart.items!) {
        if (item.id != null) {
          await deleteCourse(item.id!);
        }
      }

      print('Cart cleared successfully');
      return true;
    } catch (e) {
      print('Clear cart error: $e');
      return false;
    }
  }

  // In CartService - Add this method
  static Future<List<dynamic>?> getPaymentChannels() async {
    try {
      String url = '${Constants.baseUrl}panel/payments/channels';

      Response res =
          await httpGetWithToken(url, isRedirectingStatusCode: false);

      var jsonResponse = jsonDecode(res.body);

      if (jsonResponse['success']) {
        print("Payment Channels: $jsonResponse");
        return jsonResponse['data'] ?? [];
      } else {
        ErrorHandler()
            .showError(ErrorEnum.error, jsonResponse, readMessage: true);
        return null;
      }
    } catch (e) {
      print('Error getting payment channels: $e');
      return null;
    }
  }

// Find FIB payment channel ID
  static String? findFIBPaymentChannel(List<dynamic> channels) {
    for (var channel in channels) {
      String title = channel['title']?.toString().toLowerCase() ?? '';
      String className = channel['class_name']?.toString().toLowerCase() ?? '';

      if (title.contains('fib') ||
          title.contains('first iraqi') ||
          className.contains('fib')) {
        return channel['id']?.toString();
      }
    }
    return null;
  }

  static Future<bool> processCartPurchase(String fibPaymentId) async {
    try {
      print('Processing direct cart purchase with FIB payment: $fibPaymentId');

      final cartData = await getCart();
      if (cartData?.items == null || cartData!.items!.isEmpty) {
        print('No items in cart to purchase');
        return false;
      }

      final checkoutInfo = await checkout();
      if (checkoutInfo == null) {
        print('No checkout data available');
        return false;
      }

      final response = await http.post(
        Uri.parse('${Constants.baseUrl}/purchase/fib'),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Accept': 'application/json',
        },
        body: {
          'fib_payment_id': fibPaymentId,
          'amount': checkoutInfo.amounts?.total?.toString(),
          'currency': 'IQD',
          'items': jsonEncode(cartData.items!.map((item) => item.id).toList()),
        },
      );

      print(
          'Direct purchase response: ${response.statusCode} - ${response.body}');

      final data = jsonDecode(response.body);

      if (data['success'] == true) {
        print('Direct purchase completed successfully!');
        await clearCart();
        return true;
      } else {
        print('Direct purchase failed: ${data['message']}');
        return false;
      }
    } catch (e) {
      print('Direct purchase error: $e');
      return false;
    }
  }

  // Debug methods
  static Future<void> debugCartState() async {
    try {
      final cart = await getCart();
      print('=== CART DEBUG INFO ===');
      print('Cart items count: ${cart?.items?.length ?? 0}');
      print('Cart amounts: ${cart?.amounts?.toJson()}');
      print('=====================');
    } catch (e) {
      print('Cart debug error: $e');
    }
  }

  static Future<void> debugCheckoutState() async {
    try {
      final checkoutData = await checkout();
      print('=== CHECKOUT DEBUG INFO ===');
      print('Checkout order ID: ${checkoutData?.order?.id}');
      print('Checkout order status: ${checkoutData?.order?.status}');
      print('Checkout amounts: ${checkoutData?.amounts?.toJson()}');
      print('========================');
    } catch (e) {
      print('Checkout debug error: $e');
    }
  }
}
