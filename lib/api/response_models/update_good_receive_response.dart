import 'dart:convert';

class UpdateGoodReceiveResponse {
  final String code;
  final List<String> message;
  final dynamic data;
  final int totalRecords;

  UpdateGoodReceiveResponse({
    required this.code,
    required this.message,
    this.data,
    required this.totalRecords,
  });

  factory UpdateGoodReceiveResponse.fromJson(Map<String, dynamic> json) {
    return UpdateGoodReceiveResponse(
      code: json['code'],
      message: List<String>.from(json['message']),
      data: json['data'] == null
          ? json['data']
          : Data.fromJson(jsonDecode(json['data'])),
      totalRecords: json['totalrecords'],
    );
  }
}

class Data {
  final String grNumber;
  final bool print;

  Data({
    required this.grNumber,
    required this.print,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      grNumber: json['grnumber'],
      print: json['print'],
    );
  }
}
