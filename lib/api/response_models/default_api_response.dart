class DefaultAPIResponse {
  final String code;
  final List<String> message;
  final dynamic data;
  final int totalRecords;

  DefaultAPIResponse({
    required this.code,
    required this.message,
    this.data,
    required this.totalRecords,
  });

  factory DefaultAPIResponse.fromJson(Map<String, dynamic> json) {
    return DefaultAPIResponse(
      code: json['code'],
      message: List<String>.from(json['message']),
      data: json['data'],
      totalRecords: json['totalrecords'],
    );
  }
}
