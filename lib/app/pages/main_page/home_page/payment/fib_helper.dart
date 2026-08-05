import 'dart:convert';
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:dio/dio.dart' as diox;

import 'package:http/http.dart' as http;
import '../../../../models/fib_response_model.dart';
import '../home_page.dart';
import '../../main_page.dart';
import '../../../../../common/utils/constants.dart';

bool istestmode = false;
dynamic token;
dynamic applink;
dynamic qrCode;
dynamic paymentID;
doAuth(dynamic amountCTRL) async {
  var headers = {'Content-Type': 'application/x-www-form-urlencoded'};
  var request = http.Request(
    'POST',
    istestmode
        ? Uri.parse(
            'https://fib.stage.fib.iq/auth/realms/fib-online-shop/protocol/openid-connect/token')
        : Uri.parse(
            'https://fib.prod.fib.iq/auth/realms/fib-online-shop/protocol/openid-connect/token'),
  );
  request.bodyFields = {
    'grant_type': 'client_credentials',
    'client_id': istestmode ? 'pg-protime' : 'protime-terminal-flix',
    'client_secret': istestmode
        ? 'e0ec496b-32bf-4a81-aec7-9e202f741f5c'
        : '18a9fba3-3588-4ca2-bee0-65eb7f66ff63'
  };

  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {
    var data = await response.stream.bytesToString();
    token = jsonDecode(data)['access_token'];

    log(token);
    await createPayment(amountCTRL);
  } else {
    print(response.reasonPhrase);
  }
}

createPayment(dynamic amount) async {
  var headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token'
  };
  var request = http.Request(
      'POST',
      istestmode
          ? Uri.parse('https://fib.stage.fib.iq/protected/v1/payments')
          : Uri.parse('https://fib.prod.fib.iq/protected/v1/payments'));
  request.body = json.encode({
    "monetaryValue": {"amount": amount, "currency": "IQD"},
    "statusCallbackUrl": "",
    "description": "Pay with FIB",
    "expiresIn": "PT12H",
    "refundableFor": ""
  });
  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();

  if (response.statusCode == 201) {
    var data = await response.stream.bytesToString();
    log(data);
    applink = jsonDecode(data)['personalAppLink'];
    var qr = jsonDecode(data)['qrCode'];
    paymentID = jsonDecode(data)['paymentId'];
    Uint8List imageBytes = Base64Decoder().convert(qr.split(',').last);
    qrCode = imageBytes;
    print(applink);
  } else {
    print(response.reasonPhrase);
  }
}

openLink(String url) async {
  if (await canLaunchUrl(Uri.parse(url))) {
    await launchUrl(Uri.parse(url));
  } else {
    throw 'Could not launch $url';
  }
}

Future<Map<String, dynamic>> checkPaymentStatus(
    int userId, double amount, bool isSingleitem, int itemId) async {
  var headers = {'Authorization': 'Bearer $token'};
  var request = http.Request(
    'GET',
    istestmode
        ? Uri.parse(
            'https://fib.stage.fib.iq/protected/v1/payments/$paymentID/status')
        : Uri.parse(
            'https://fib.prod.fib.iq/protected/v1/payments/$paymentID/status'),
  );
  request.headers.addAll(headers);

  try {
    http.StreamedResponse response = await request.send();
    final responseBody = await response.stream.bytesToString();
    final data = jsonDecode(responseBody);

    if (kDebugMode) {
      print('Payment Status Response: $data');
      print('Payment Status: ${data['status']}');
    }

    if (response.statusCode == 200) {
      if (data['status'] == "PAID") {
        if (isSingleitem) {
          await updateSubscriptionSingle(userId, itemId);
          //Get.find<HomeController>().getAllData();
          return {'bool': true, 'message': "Item purchased"};
        } else {
          SubscriptionResponse res =
              await updateSubscription(userId: userId, amount: amount);
          Get.to(HomePage());
          return {'bool': true, 'message': res.message};
        }
      }
      return {'bool': false, 'message': "Payment Failed!"};
    } else {
      if (kDebugMode) {
        print('Failed to check payment status: ${response.statusCode}');
      }
      throw Exception('Failed to check payment status: ${response.statusCode}');
    }
  } catch (e) {
    if (kDebugMode) {
      print('Error checking payment status: $e');
    }
    throw Exception('Error checking payment status: $e');
  }
}

Future<void> updateSubscriptionSingle(int userid, int itemId) async {
  final response = await http.post(
    Uri.parse(
        '${Constants.baseUrl}payment/Single_Item/fib/single_fib_payment_mobile.php'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'paymentId': 'payment123',
      'userId': userid,
      'itemId': itemId,
      'status': 'PAID'
    }),
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    print(data.toString());
    if (data['success']) {
      // Navigate to video using data['data']['videoUrl']
    }
  }
}

Future<SubscriptionResponse> updateSubscription({
  required int userId,
  required double amount,
}) async {
  try {
    final response = await http.post(
      Uri.parse('${Constants.baseUrl}payment/fib/fib_payment_mobile.php'),
      body: {
        'userid': userId.toString(),
        'amount': amount.toString(),
      },
    );

    if (response.statusCode == 200) {
      dynamic message = jsonDecode(response.body);
      print(message);
      return SubscriptionResponse.fromJson(message);
    } else {
      return SubscriptionResponse(
        success: false,
        message:
            'Error: Server responded with status code ${response.statusCode}',
      );
    }
  } catch (e) {
    return SubscriptionResponse(
      success: false,
      message: 'Error: ${e.toString()}',
    );
  }
}
