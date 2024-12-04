import 'dart:convert';

class TokenResponse {
  final String code;
  final List<String> message;
  final dynamic data;
  final int totalrecords;

  TokenResponse({
    required this.code,
    required this.message,
    this.data,
    required this.totalrecords,
  });

  factory TokenResponse.fromJson(Map<String, dynamic> json) {
    return TokenResponse(
      code: json['code'] as String,
      message: List<String>.from(json['message']),
      data: json['data'] == null
          ? json['data']
          : Data.fromJson(jsonDecode(json['data'])),
      totalrecords: json['totalrecords'] as int,
    );
  }
}

class Data {
  final String jwttoken;
  final String jwtrefreshtoken;

  Data({required this.jwttoken, required this.jwtrefreshtoken});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
        jwttoken: json['jwttoken'] as String,
        jwtrefreshtoken: json['jwtrefreshtoken'] as String);
  }
}
