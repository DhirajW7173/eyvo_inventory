import 'dart:convert';

class LoadLoginResponse {
  final String code;
  final List<String> message;
  final dynamic data;
  final int totalrecords;

  LoadLoginResponse(
      {required this.code,
      required this.message,
      this.data,
      required this.totalrecords});

  factory LoadLoginResponse.fromJson(Map<String, dynamic> json) {
    return LoadLoginResponse(
        code: json['code'] as String,
        message: List<String>.from(json['message']),
        data: json['data'] == null
            ? json['data']
            : Data.fromJson(jsonDecode(json['data'])),
        totalrecords: json['totalrecords'] as int);
  }
}

class Data {
  final bool isLoginWithScan;

  Data({
    required this.isLoginWithScan,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      isLoginWithScan: json['scanlogin'] as bool,
    );
  }
}
