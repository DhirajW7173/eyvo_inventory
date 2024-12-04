// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:eyvo_inventory/api/response_models/default_api_response.dart';
import 'package:eyvo_inventory/api/response_models/token_response.dart';
import 'package:eyvo_inventory/app/app_prefs.dart';
import 'package:eyvo_inventory/core/resources/routes_manager.dart';
import 'package:eyvo_inventory/core/resources/strings_manager.dart';
import 'package:eyvo_inventory/core/utils.dart';
import 'package:eyvo_inventory/log_data.dart/logger_data.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "https://service.eyvo.net/eBA API 2.0";
  static const String clientCode = "login/clientcode";
  static const String loadLogin = "login/loadlogin";
  static const String externalLogin = "login/externalaunthenication";
  static const String login = "login/checkcredential";
  static const String forgotUserID = "login/forgetuserid";
  static const String forgotPassword = "login/forgetpassword";
  static const String verifyOTP = "login/verifyotp";
  static const String resetPassword = "login/resetpassword";
  static const String changePassword = "login/changepassword";
  static const String refreshToken = "login/refreshtoken";
  static const String dashboard = "dashboard/index";
  static const String regionList = "region/index";
  static const String locationList = "location/index";
  static const String goodReceiveOrderList = 'GoodsReceive/listing';
  static const String goodReceiveItemList = 'GoodsReceive/orderitemslisting';
  static const String goodReceivePrint = 'GoodsReceive/grprint';
  static const String goodReceiveUpdate = 'GoodsReceive/updategr';
  static const String itemsListing = 'Items/listing';
  static const String itemDetails = 'Items/details';
  static const String itemsInOut = 'Items/inout';

  Future<bool> updateToken(BuildContext context) async {
    Map<String, dynamic> data = {
      'jwttoken': SharedPrefs().jwtToken,
      'jwtrefreshtoken': SharedPrefs().refreshToken,
    };
    final jsonResponse =
        await postRequest(context, ApiService.refreshToken, data);
    if (jsonResponse != null) {
      final response = TokenResponse.fromJson(jsonResponse);
      if (response.code == '200') {
        debugPrint('PS:- token refreshed');
        SharedPrefs().jwtToken = response.data.jwttoken;
        SharedPrefs().refreshToken = response.data.jwtrefreshtoken;
        return true;
      } else {
        debugPrint('PS:- token refresh process failed');
        Navigator.pushNamedAndRemoveUntil(
            context, Routes.loginRoute, (Route<dynamic> route) => false);
        showSnackBar(context, response.message.join(', '));
        return false;
      }
    } else {
      return false;
    }
  }

  Future<Map<String, dynamic>?> getRequest(
      BuildContext context, String endpoint, Map<String, dynamic> data) async {
    final url = Uri.encodeFull('$baseUrl/$endpoint');
    debugPrint('PS:- URL: $url');
    final token = SharedPrefs().jwtToken;
    final headers = {
      'Content-Type': 'application/json',
      'clientcode': SharedPrefs().companyCode,
      'accessKey': SharedPrefs().accessKey,
      'Authorization': 'Bearer $token',
    };
    final body = json.encode(data);
    debugPrint('PS:- headers: $headers');
    debugPrint('PS:- body: $body');
    try {
      final response = await http.get(Uri.parse(url), headers: headers);
      return await processResponse(context, response);
    } catch (e) {
      debugPrint('Get request error: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> postRequest(
      BuildContext context, String endpoint, Map<String, dynamic> data) async {
    try {
      final url = Uri.encodeFull('$baseUrl/$endpoint');
      debugPrint('PS:- URL: $url');
      final token = SharedPrefs().jwtToken;
      final headers = endpoint == clientCode
          ? {
              'Content-Type': 'application/json',
              'GenericAccessKey': SharedPrefs().genericAccessKey
            }
          : (endpoint.contains('login') && !endpoint.contains('changepassword'))
              ? {
                  'Content-Type': 'application/json',
                  'clientcode': SharedPrefs().companyCode,
                  'accessKey': SharedPrefs().accessKey
                }
              : {
                  'Content-Type': 'application/json',
                  'clientcode': SharedPrefs().companyCode,
                  'accessKey': SharedPrefs().accessKey,
                  'Authorization': 'Bearer $token',
                };
      final body = json.encode(data);

      LoggerData.dataLog('Url : $url --body: $body'); //--Header : $headers

      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: body,
      );
      if (response.statusCode == 401) {
        if (response.body.isNotEmpty) {
          final jsonResponse =
              DefaultAPIResponse.fromJson(json.decode(response.body));
          final message = jsonResponse.message.join(', ');
          if (message == AppStrings.apiTokenExpired) {
            debugPrint('PS:- token expired called: $message');
            bool tokenRefreshed = await updateToken(context);
            if (tokenRefreshed) {
              postRequest(context, endpoint, data);
            }
          } else {
            return await processResponse(context, response);
          }
        } else {
          return await processResponse(context, response);
        }
      } else {
        return await processResponse(context, response);
      }
    } catch (e) {
      debugPrint('Post request error: $e');
    }
    return null;
  }

  Future<Map<String, dynamic>?> processResponse(
      BuildContext context, http.Response response) async {
    if (response.statusCode == 401) {
      if (response.body.isEmpty) {
        showSnackBar(context,
            'User is not authorized. Please login with authorized credentials.');
        return null;
      } else {
        return json.decode(response.body);
      }
    } else {
      final jsonResponse = json.decode(response.body);
      // debugPrint('PS:- jsonResponse: $jsonResponse');
      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonResponse;
      } else {
        if (response.body.isNotEmpty) {
          return jsonResponse;
        } else {
          debugPrint('Error: ${response.statusCode}, ${response.body}');
          throw Exception('Failed to process request: ${response.statusCode}');
        }
      }
    }
  }
}
