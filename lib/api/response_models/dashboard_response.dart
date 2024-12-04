import 'dart:convert';

class DashboardResponse {
  final String code;
  final List<String> message;
  final List<Data> data;
  final int totalRecords;

  DashboardResponse({
    required this.code,
    required this.message,
    required this.data,
    required this.totalRecords,
  });

  factory DashboardResponse.fromJson(Map<String, dynamic> json) {
    var dataList = json['data'] as String;
    List<Data> data =
        (jsonDecode(dataList) as List).map((i) => Data.fromJson(i)).toList();

    return DashboardResponse(
      code: json['code'],
      message: List<String>.from(json['message']),
      data: data,
      totalRecords: json['totalrecords'],
    );
  }
}

class Data {
  final bool region;
  final String regionLabelName;
  final String regionName;
  final int regionId;
  final bool regionEdit;
  final bool location;
  final String locationLabelName;
  final String locationName;
  final int locationId;
  final bool locationEdit;
  final bool scanYourItem;
  final bool listAllItems;
  final bool gr;
  final int decimalPlaces;

  Data({
    required this.region,
    required this.regionLabelName,
    required this.regionName,
    required this.regionId,
    required this.regionEdit,
    required this.location,
    required this.locationLabelName,
    required this.locationName,
    required this.locationId,
    required this.locationEdit,
    required this.scanYourItem,
    required this.listAllItems,
    required this.gr,
    required this.decimalPlaces,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      region: json['region'],
      regionLabelName: json['regionlabelname'],
      regionName: json['regionname'],
      regionId: json['regionid'],
      regionEdit: json['regionedit'],
      location: json['location'],
      locationLabelName: json['locationlabelname'],
      locationName: json['locationname'],
      locationId: json['locationid'],
      locationEdit: json['locationedit'],
      scanYourItem: json['scanyouritem'],
      listAllItems: json['listallitems'],
      gr: json['gr'],
      decimalPlaces: json['decimalplaces'],
    );
  }
}
