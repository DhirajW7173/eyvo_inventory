import 'dart:convert';

class LoginResponse {
  final String code;
  final List<String> message;
  final dynamic data;
  final int totalrecords;

  LoginResponse(
      {required this.code,
      required this.message,
      this.data,
      required this.totalrecords});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
        code: json['code'] as String,
        message: List<String>.from(json['message']),
        data: json['data'] == null
            ? json['data']
            : Data.fromJson(jsonDecode(json['data'])),
        totalrecords: json['totalrecords'] as int);
  }
}

class Data {
  final String uid;
  final String username;
  final String jwttoken;
  final String jwtrefreshtoken;
  final String userSession;

  Data(
      {required this.uid,
      required this.username,
      required this.jwttoken,
      required this.jwtrefreshtoken,
      required this.userSession});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      uid: json['uid'] as String,
      username: json['username'] as String,
      jwttoken: json['jwttoken'] as String,
      jwtrefreshtoken: json['jwtrefreshtoken'] as String,
      userSession: json['usersession'] as String,
    );
  }
}
