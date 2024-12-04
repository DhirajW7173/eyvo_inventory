import 'dart:convert';

class Region {
  int regionId;
  String regionCode;

  Region({
    required this.regionId,
    required this.regionCode,
  });

  factory Region.fromJson(Map<String, dynamic> json) {
    return Region(
      regionId: json['regionid'],
      regionCode: json['regioncode'],
    );
  }
}

class RegionResponse {
  String code;
  List<String> message;
  List<Region> data;
  int totalRecords;

  RegionResponse({
    required this.code,
    required this.message,
    required this.data,
    required this.totalRecords,
  });

  factory RegionResponse.fromJson(Map<String, dynamic> json) {
    var dataList = jsonDecode(json['data']) as List;
    List<Region> regions = dataList.map((i) => Region.fromJson(i)).toList();

    return RegionResponse(
      code: json['code'],
      message: List<String>.from(json['message']),
      data: regions,
      totalRecords: json['totalrecords'],
    );
  }
}
