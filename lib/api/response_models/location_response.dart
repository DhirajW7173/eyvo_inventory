import 'dart:convert';

class Location {
  int locationId;
  String locationCode;

  Location({
    required this.locationId,
    required this.locationCode,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      locationId: json['locationid'],
      locationCode: json['locationcode'],
    );
  }
}

class LocationResponse {
  String code;
  List<String> message;
  List<Location> data;
  int totalRecords;

  LocationResponse({
    required this.code,
    required this.message,
    required this.data,
    required this.totalRecords,
  });

  factory LocationResponse.fromJson(Map<String, dynamic> json) {
    var dataList = jsonDecode(json['data']) as List;
    List<Location> locations =
        dataList.map((i) => Location.fromJson(i)).toList();

    return LocationResponse(
      code: json['code'],
      message: List<String>.from(json['message']),
      data: locations,
      totalRecords: json['totalrecords'],
    );
  }
}
