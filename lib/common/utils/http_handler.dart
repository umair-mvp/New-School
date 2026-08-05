import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import '../../app/pages/introduction_page/ip_empty_state_page.dart';
import '../../app/pages/introduction_page/maintenance_page.dart';
import '../data/app_language.dart';
import 'constants.dart';

import '../../app/pages/authentication_page/login_page.dart';
import '../../locator.dart';
import '../common.dart';
import '../data/app_data.dart';

Future<http.Response> httpGet(String url,
    {Map<String, String> headers = const {},
    bool isRedirectingStatusCode = true,
    bool isMaintenance = false,
    bool isSendToken = false}) async {
  try {
    // Check if device has internet connection
    // try {
    //   await InternetAddress.lookup('newschool.academy');
    // } on SocketException catch (_) {
    //   throw SocketException('No internet connection or DNS failure');
    // }

    if (headers.isEmpty) {
      String token = await AppData.getAccessToken();
      headers = {
        if (isSendToken) ...{
          "Authorization": "Bearer $token",
        },
        "Content-Type": "application/json",
        'Accept': 'application/json',
        'x-api-key': Constants.apiKey,
        'x-locale': locator<AppLanguage>().currentLanguage.toLowerCase(),
      };
    }

    print('Making request to: $url');
    print('Headers: $headers');

    var response = await http
        .get(
          Uri.parse(url),
          headers: headers,
        )
        .timeout(const Duration(seconds: 30));

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    return _handleResponse(response, isMaintenance);
  } on SocketException catch (e) {
    print('SocketException: $e');
    // Show user-friendly error
    _showErrorDialog('Connection Error',
        'Please check your internet connection and try again.');
    rethrow;
  } on HttpException catch (e) {
    print('HttpException: $e');
    _showErrorDialog('Server Error', 'Unable to connect to the server.');
    rethrow;
  } on FormatException catch (e) {
    print('FormatException: $e');
    _showErrorDialog('Data Error', 'Invalid response from server.');
    rethrow;
  } on TimeoutException catch (e) {
    print('TimeoutException: $e');
    _showErrorDialog('Timeout', 'Request timed out. Please try again.');
    rethrow;
  } catch (e) {
    print('Unexpected error: $e');
    _showErrorDialog('Error', 'An unexpected error occurred.');
    rethrow;
  }
}

http.Response _handleResponse(http.Response response, bool isMaintenance) {
  try {
    var data = jsonDecode(response.body);

    if (data['status'] == 'restriction') {
      if (!isNavigatedIpPage) {
        nextRoute(IpEmptyStatePage.pageName,
            arguments: data['data'], isClearBackRoutes: true);
      }
      return response;
    }

    if (response.statusCode == 401) {
      nextRoute(LoginPage.pageName, isClearBackRoutes: true);
      return response;
    }

    if (isMaintenance && data['status'] == 'maintenance') {
      nextRoute(MaintenancePage.pageName,
          isClearBackRoutes: true, arguments: data['data']);
    }

    return response;
  } catch (e) {
    // If JSON decoding fails, return the original response
    return response;
  }
}

void _showErrorDialog(String title, String message) {
  // Use your preferred dialog implementation
  // For example with fluttertoast:
  // Fluttertoast.showToast(msg: message, toastLength: Toast.LENGTH_LONG);

  print('$title: $message');
}

Future<Response> httpPost(String url, dynamic body,
    {Map<String, String> headers = const {},
    bool isRedirectingStatusCode = true}) async {
  var myBody = json.encode(body);

  if (headers.isEmpty) {
    headers = {
      'x-api-key': Constants.apiKey,
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'x-locale': locator<AppLanguage>().currentLanguage.toLowerCase(),
    };
  }

  var request = http.Request(
    'POST',
    Uri.parse(url),
  );

  request.body = myBody;
  request.headers.addAll(headers);
  http.StreamedResponse response =
      await request.send().timeout(const Duration(seconds: 30));

  http.Response res =
      http.Response(await response.stream.bytesToString(), response.statusCode);

  if (res.statusCode == 401) {
    if (isRedirectingStatusCode) {
      nextRoute(LoginPage.pageName, isClearBackRoutes: true);
    }
    return res;
  } else {
    return res;
  }
}

Future<Response> httpDelete(String url, dynamic body,
    {Map<String, String> headers = const {},
    bool isRedirectingStatusCode = true}) async {
  var myBody = json.encode(body);

  if (headers.isEmpty) {
    headers = {
      'x-api-key': Constants.apiKey,
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'x-locale': locator<AppLanguage>().currentLanguage.toLowerCase(),
    };
  }

  var request = http.Request(
    'DELETE',
    Uri.parse(url),
  );

  request.body = myBody;
  request.headers.addAll(headers);
  http.StreamedResponse response =
      await request.send().timeout(const Duration(seconds: 30));

  http.Response res =
      http.Response(await response.stream.bytesToString(), response.statusCode);

  if (res.statusCode == 401) {
    if (isRedirectingStatusCode) {
      nextRoute(LoginPage.pageName, isClearBackRoutes: true);
    }
    return res;
  } else {
    return res;
  }
}

Future<Response> httpPut(String url, dynamic body,
    {Map<String, String> headers = const {},
    bool isRedirectingStatusCode = true}) async {
  var myBody;
  if (body.runtimeType != String) {
    myBody = json.encode(body);
  } else {
    myBody = body;
  }

  if (headers.isEmpty) {
    headers = {
      "Content-Type": "application/json",
      'Accept': 'application/json',
      'x-api-key': Constants.apiKey,
      'x-locale': locator<AppLanguage>().currentLanguage.toLowerCase(),
    };
  }

  var request = http.Request(
    'PUT',
    Uri.parse(url),
  );

  request.body = myBody;
  request.headers.addAll(headers);
  http.StreamedResponse response =
      await request.send().timeout(const Duration(seconds: 30));

  http.Response res =
      http.Response(await response.stream.bytesToString(), response.statusCode);

  if (res.statusCode == 401) {
    if (isRedirectingStatusCode) {
      nextRoute(LoginPage.pageName, isClearBackRoutes: true);
    }
    return res;
  } else {
    return res;
  }
}

Future<Response> httpPostWithToken(dynamic url, dynamic body,
    {bool isRedirectingStatusCode = true}) async {
  String token = await AppData.getAccessToken();

  Map<String, String> headers = {
    "Authorization": "Bearer $token",
    "Content-Type": "application/json",
    'Accept': 'application/json',
    'x-api-key': Constants.apiKey,
    'x-locale': locator<AppLanguage>().currentLanguage.toLowerCase(),
  };

  return httpPost(url, body,
      headers: headers, isRedirectingStatusCode: isRedirectingStatusCode);
}

Future<Response> httpDeleteWithToken(dynamic url, dynamic body,
    {bool isRedirectingStatusCode = true}) async {
  String token = await AppData.getAccessToken();

  Map<String, String> headers = {
    "Authorization": "Bearer $token",
    "Content-Type": "application/json",
    'Accept': 'application/json',
    'x-api-key': Constants.apiKey,
    'x-locale': locator<AppLanguage>().currentLanguage.toLowerCase(),
  };

  return httpDelete(url, body,
      headers: headers, isRedirectingStatusCode: isRedirectingStatusCode);
}

Future<Response> httpPutWithToken(dynamic url, dynamic body,
    {bool isRedirectingStatusCode = true}) async {
  String token = await AppData.getAccessToken();

  Map<String, String> headers = {
    "Authorization": "Bearer $token",
    "content-type": "application/json",
    "Accept": "application/json",
    'x-api-key': Constants.apiKey,
    'x-locale': locator<AppLanguage>().currentLanguage.toLowerCase(),
  };

  return httpPut(url, body,
      headers: headers, isRedirectingStatusCode: isRedirectingStatusCode);
}

Future<Response> httpGetWithToken(dynamic url,
    {bool isRedirectingStatusCode = true}) async {
  String token = await AppData.getAccessToken();
  // print(token);
  Map<String, String> headers = {
    "Authorization": "Bearer $token",
    "Accept": "application/json",
    'x-api-key': Constants.apiKey,
    'x-locale': locator<AppLanguage>().currentLanguage.toLowerCase(),
  };

  return httpGet(url,
      headers: headers, isRedirectingStatusCode: isRedirectingStatusCode);
}

Future<dio.Response> dioPost(String url, dynamic body,
    {Map<String, String> headers = const {},
    bool isRedirectingStatusCode = true}) async {
  // var myBody = body;
  // if(body.runtimeType is! dio.FormData){
  //   // try{
  //   //   myBody = json.encode(body);
  //   // }catch(e){}
  // }

  if (headers.isEmpty) {
    headers = {
      "Content-Type": "application/json",
      'Accept': 'application/json',
      'x-api-key': Constants.apiKey,
      'x-locale': locator<AppLanguage>().currentLanguage.toLowerCase(),
    };
  }

  var res = await locator<dio.Dio>()
      .post(url, data: body, options: dio.Options(headers: headers))
      .timeout(const Duration(seconds: 30));

  // print(res.data.toString());
  // log(utf8.decode(res.bodyBytes));

  if (res.statusCode == 401) {
    if (isRedirectingStatusCode) {
      nextRoute(LoginPage.pageName, isClearBackRoutes: true);
    }
    return res;
  } else {
    return res;
  }
}

Future<dio.Response> dioPostWithToken(dynamic url, dynamic body,
    {bool isRedirectingStatusCode = true}) async {
  String token = await AppData.getAccessToken();

  Map<String, String> headers = {
    "Authorization": "Bearer $token",
    "Content-Type": "application/json",
    'Accept': 'application/json',
    'x-api-key': Constants.apiKey,
    'x-locale': locator<AppLanguage>().currentLanguage.toLowerCase(),
  };

  return dioPost(url, body,
      headers: headers, isRedirectingStatusCode: isRedirectingStatusCode);
}
