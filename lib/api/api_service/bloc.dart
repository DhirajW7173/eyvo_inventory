import 'package:eyvo_inventory/api/api_service/api_service.dart';
import 'package:eyvo_inventory/api/response_models/company_code_response.dart';
import 'package:eyvo_inventory/api/response_models/default_api_response.dart';
import 'package:eyvo_inventory/api/response_models/item_details_response.dart';
import 'package:eyvo_inventory/api/response_models/item_list_response.dart';
import 'package:eyvo_inventory/api/response_models/load_login_response.dart';
import 'package:eyvo_inventory/api/response_models/location_response.dart';
import 'package:eyvo_inventory/api/response_models/login_response.dart';
import 'package:eyvo_inventory/api/response_models/received_items_response.dart';
import 'package:eyvo_inventory/api/response_models/update_good_receive_response.dart';
import 'package:eyvo_inventory/log_data.dart/logger_data.dart';
import 'package:flutter/material.dart';

class GlobalBloc {
  final ApiService apiService = ApiService();

  //-------------Sign In User Without Scan------------//
  Future<LoginResponse> doSignInUser(BuildContext context,
      {String? userName, String? password}) async {
    Map<String, dynamic> bodyData = {
      'userid': userName,
      'password': password,
    };

    try {
      final res =
          await apiService.postRequest(context, ApiService.login, bodyData);
      LoggerData.dataLog(
          "doSignInUser BodyData : $bodyData -- Response : $res");

      final response = LoginResponse.fromJson(res!);
      return response;
    } catch (e) {
      LoggerData.dataLog("Something went Wrong In doSignInUser :$e");
      throw "Something went Wrong In doSignInUser :$e";
    }
  }

  //-------------Sign In User with BarCode scanner------------//
  Future<LoginResponse> doSignInUserWithBarcode(BuildContext context,
      {String? userId, String? mode}) async {
    Map<String, dynamic> bodyData = {
      'uid': userId,
      'mode': mode,
    };

    try {
      final res =
          await apiService.postRequest(context, ApiService.login, bodyData);
      LoggerData.dataLog(
          "doSignInUserWithBarcode BodyData : $bodyData -- Response : $res");

      final response = LoginResponse.fromJson(res!);
      return response;
    } catch (e) {
      LoggerData.dataLog("Something went Wrong In doSignInUserWithBarcode :$e");
      throw "Something went Wrong In doSignInUserWithBarcode :$e";
    }
  }

  //-------------Fetch Login User Data ------------//
  Future<LoadLoginResponse> doFetchLoginUserData(
      BuildContext context, String uid) async {
    Map<String, dynamic> bodyData = {'uid': uid};

    try {
      final res =
          await apiService.postRequest(context, ApiService.loadLogin, bodyData);
      LoggerData.dataLog(
          "doFetchLoginUserData BodyData : $bodyData -- Response : $res");

      final response = LoadLoginResponse.fromJson(res!);
      return response;
    } catch (e) {
      LoggerData.dataLog("Something went Wrong In doFetchLoginUserData :$e");
      throw "Something went Wrong In doFetchLoginUserData :$e";
    }
  }

  //-------------Fetch Data After Fill Up Company Code ------------//
  Future<CompanyCodeResponse> afterFillCompanyCodeApi(
      BuildContext context, String clientCode) async {
    Map<String, dynamic> bodyData = {'clientcode': clientCode};

    try {
      final res = await apiService.postRequest(
          context, ApiService.clientCode, bodyData);
      LoggerData.dataLog(
          "afterFillCompanyCodeApi BodyData : $bodyData -- Response : $res");

      final response = CompanyCodeResponse.fromJson(res!);
      return response;
    } catch (e) {
      LoggerData.dataLog("Something went Wrong In afterFillCompanyCodeApi :$e");
      throw "Something went Wrong In afterFillCompanyCodeApi :$e";
    }
  }

  //-------------Do Change User Password------------//
  Future<CompanyCodeResponse> doChangeUserPassword(
    BuildContext context, {
    String? uID,
    String? oldPassword,
    String? password,
    String? userSession,
  }) async {
    Map<String, dynamic> bodyData = {
      'uid': uID,
      'oldpassword': oldPassword,
      'password': password,
      'usersession': userSession
    };

    try {
      final res = await apiService.postRequest(
          context, ApiService.changePassword, bodyData);
      LoggerData.dataLog(
          "doChangeUserPassword BodyData : $bodyData -- Response : $res");

      final response = CompanyCodeResponse.fromJson(res!);
      return response;
    } catch (e) {
      LoggerData.dataLog("Something went Wrong In doChangeUserPassword :$e");
      throw "Something went Wrong In doChangeUserPassword :$e";
    }
  }

  //-------------Forgot User Password------------//
  Future<DefaultAPIResponse> forgotUserPassword(
    BuildContext context, {
    String? email,
    String? userID,
  }) async {
    Map<String, dynamic> bodyData = {
      'email': email,
      'resend': false,
      'userid': userID
    };

    try {
      final res = await apiService.postRequest(
          context, ApiService.forgotPassword, bodyData);
      LoggerData.dataLog(
          "forgotUserPassword BodyData : $bodyData -- Response : $res");

      final response = DefaultAPIResponse.fromJson(res!);
      return response;
    } catch (e) {
      LoggerData.dataLog("Something went Wrong In forgotUserPassword :$e");
      throw "Something went Wrong In forgotUserPassword :$e";
    }
  }

  //-------------Forgot User Id------------//
  Future<DefaultAPIResponse> forgotUserId(
      BuildContext context, String email) async {
    Map<String, dynamic> bodyData = {
      'email': email,
    };

    try {
      final res = await apiService.postRequest(
          context, ApiService.forgotUserID, bodyData);
      LoggerData.dataLog(
          "forgotUserId BodyData : $bodyData -- Response : $res");

      final response = DefaultAPIResponse.fromJson(res!);
      return response;
    } catch (e) {
      LoggerData.dataLog("Something went Wrong In forgotUserId :$e");
      throw "Something went Wrong In forgotUserId :$e";
    }
  }

  //-------------Forgot User Id------------//
  Future<Map<String, dynamic>?> doFetchDashboardItem(
      BuildContext context, String uID) async {
    Map<String, dynamic> bodyData = {
      'uid': uID,
    };

    try {
      final res =
          await apiService.postRequest(context, ApiService.dashboard, bodyData);
      LoggerData.dataLog(
          "doFetchDashboardItem BodyData : $bodyData -- Response : $res");

      // final response = DashboardResponse.fromJson(res!);
      return res;
    } catch (e) {
      LoggerData.dataLog("Something went Wrong In doFetchDashboardItem :$e");
      throw "Something went Wrong In doFetchDashboardItem :$e";
    }
  }

  //-------------Do Fetch Item List------------//
  Future<ItemListResponse> doFetchItemList(
    BuildContext context, {
    int? locationId,
    int? regionId,
    String? search,
    int? pageNo,
    int? pageSize,
  }) async {
    Map<String, dynamic> bodyData = {
      "regionid": regionId,
      "locationid": locationId,
      "search": search,
      'pageno': pageNo,
      'pagesize': pageSize,
    };

    try {
      final res = await apiService.postRequest(
          context, ApiService.itemsListing, bodyData);
      LoggerData.dataLog(
          "doFetchItemList BodyData : $bodyData -- Response : $res");

      final response = ItemListResponse.fromJson(res!);
      return response;
    } catch (e) {
      LoggerData.dataLog("Something went Wrong In doFetchItemList :$e");
      throw "Something went Wrong In doFetchItemList :$e";
    }
  }

  //-------------Do Fetch Item Details------------//
  Future<ItemDetailsResponse> doFetchItemDetails(
    BuildContext context, {
    String? itemId,
    int? locationId,
    int? regionId,
    String? uID,
  }) async {
    Map<String, dynamic> bodyData = {
      "itemid": itemId,
      "locationid": locationId,
      'regionid': regionId,
      "uid": uID,
    };

    try {
      final res = await apiService.postRequest(
          context, ApiService.itemDetails, bodyData);
      LoggerData.dataLog(
          "doFetchDashboardItem BodyData : $bodyData -- Response : $res");

      final response = ItemDetailsResponse.fromJson(res!);
      return response;
    } catch (e) {
      LoggerData.dataLog("Something went Wrong In doFetchDashboardItem :$e");
      throw "Something went Wrong In doFetchDashboardItem :$e";
    }
  }

  //-------------Do Fetch Item In-OUT Api------------//
  Future<DefaultAPIResponse> doFetchItemInOutAPI(
    BuildContext context, {
    int? itemId,
    int? itemType,
    int? locationId,
    int? regionId,
    double? quantity,
    double? price,
    String? adjustDate,
    String? comment,
    String? uID,
    bool? isStock,
    String? mode,
  }) async {
    Map<String, dynamic> bodyData = {
      "itemid": itemId,
      "itemtype": itemType,
      "locationid": locationId,
      "quantity": quantity,
      "price": price,
      "isstock": isStock,
      "adjustmentDate": adjustDate,
      "comments": comment,
      "uid": uID,
      "pageMode": mode,
    };

    try {
      final res = await apiService.postRequest(
          context, ApiService.itemDetails, bodyData);
      LoggerData.dataLog(
          "doFetchItemInOutAPI BodyData : $bodyData -- Response : $res");

      final response = DefaultAPIResponse.fromJson(res!);
      return response;
    } catch (e) {
      LoggerData.dataLog("Something went Wrong In doFetchItemInOutAPI :$e");
      throw "Something went Wrong In doFetchItemInOutAPI :$e";
    }
  }

  //-------------Do Fetch User Location------------//
  Future<LocationResponse> doFetchUserLocationThroughApi(
      BuildContext context, String uID) async {
    Map<String, dynamic> bodyData = {'uid': uID};

    try {
      final res = await apiService.postRequest(
          context, ApiService.locationList, bodyData);
      LoggerData.dataLog(
          "doFetchUserLocationThroughApi BodyData : $bodyData -- Response : $res");

      final response = LocationResponse.fromJson(res!);
      return response;
    } catch (e) {
      LoggerData.dataLog(
          "Something went Wrong In doFetchUserLocationThroughApi :$e");
      throw "Something went Wrong In doFetchUserLocationThroughApi :$e";
    }
  }

  //-------------Do Fetch User Location------------//
  Future<DefaultAPIResponse> doFetchPdfData(BuildContext context,
      {int? orderId, String? grNo}) async {
    Map<String, dynamic> bodyData = {'orderid': orderId, 'grnno': grNo};

    try {
      final res = await apiService.postRequest(
          context, ApiService.goodReceivePrint, bodyData);
      LoggerData.dataLog(
          "doFetchPdfData BodyData : $bodyData -- Response : $res");

      final response = DefaultAPIResponse.fromJson(res!);
      return response;
    } catch (e) {
      LoggerData.dataLog("Something went Wrong In doFetchPdfData :$e");
      throw "Something went Wrong In doFetchPdfData :$e";
    }
  }

  //-------------Do Fetch Order Items------------//
  Future<ReceivedItemsResponse> doFetchOrderItem(
      BuildContext context, String orderId) async {
    Map<String, dynamic> bodyData = {'orderid': orderId};

    try {
      final res = await apiService.postRequest(
          context, ApiService.goodReceiveItemList, bodyData);
      LoggerData.dataLog(
          "doFetchOrderItem BodyData : $bodyData -- Response : $res");

      final response = ReceivedItemsResponse.fromJson(res!);
      return response;
    } catch (e) {
      LoggerData.dataLog("Something went Wrong In doFetchOrderItem :$e");
      throw "Something went Wrong In doFetchOrderItem :$e";
    }
  }

  //-------------Do Fetch Confirm Receive Goods------------//
  Future<UpdateGoodReceiveResponse> doFetchConfirmReceiveGoods(
    BuildContext context, {
    int? orderId,
    String? orderNumber,
    String? uID,
    int? selectedLocationID,
    int? selectedRegionID,
    String? userSession,
    List<dynamic>? itemList,
  }) async {
    Map<String, dynamic> bodyData = {
      "orderid": orderId,
      "ordernumber": orderNumber,
      "uid": uID,
      "locationid": selectedLocationID,
      "regionid": selectedRegionID,
      "usersession": userSession,
      "items": itemList,
    };

    try {
      final res = await apiService.postRequest(
          context, ApiService.goodReceiveUpdate, bodyData);
      LoggerData.dataLog(
          "doFetchConfirmReceiveGoods BodyData : $bodyData -- Response : $res");

      final response = UpdateGoodReceiveResponse.fromJson(res!);
      return response;
    } catch (e) {
      LoggerData.dataLog(
          "Something went Wrong In doFetchConfirmReceiveGoods :$e");
      throw "Something went Wrong In doFetchConfirmReceiveGoods :$e";
    }
  }
}

GlobalBloc globalBloc = GlobalBloc();
