import 'dart:convert';

class CompanyCodeResponse {
  final String code;
  final List<String> message;
  final dynamic data;
  final int totalRecords;

  CompanyCodeResponse({
    required this.code,
    required this.message,
    this.data,
    required this.totalRecords,
  });

  factory CompanyCodeResponse.fromJson(Map<String, dynamic> json) {
    return CompanyCodeResponse(
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
  final String clientCode;
  final String accessKey;

  Data({
    required this.clientCode,
    required this.accessKey,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      clientCode: json['clientcode'],
      accessKey: json['accesskey'],
    );
  }
}
