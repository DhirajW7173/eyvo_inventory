import 'dart:convert';

class ListItem {
  int itemId;
  String itemCode;
  String outline;
  String imageName;
  String itemImage;
  String categoryCode;
  double stockCount;

  ListItem({
    required this.itemId,
    required this.itemCode,
    required this.outline,
    required this.imageName,
    required this.itemImage,
    required this.categoryCode,
    required this.stockCount,
  });

  factory ListItem.fromJson(Map<String, dynamic> json) {
    return ListItem(
      itemId: json['itemid'],
      itemCode: json['itemcode'],
      outline: json['outline'],
      imageName: json['imagename'],
      itemImage: json['itemimage'],
      categoryCode: json['categorycode'],
      stockCount: json['stockcount'],
    );
  }
}

class ItemListResponse {
  String code;
  List<String> message;
  final dynamic data;
  int totalRecords;

  ItemListResponse({
    required this.code,
    required this.message,
    this.data,
    required this.totalRecords,
  });

  factory ItemListResponse.fromJson(Map<String, dynamic> json) {
    var dataList = [];
    List<ListItem> items = [];
    if (json['data'] != null) {
      dataList = jsonDecode(json['data']) as List;
      items = dataList.map((i) => ListItem.fromJson(i)).toList();
    }
    return ItemListResponse(
      code: json['code'],
      message: List<String>.from(json['message']),
      data: json['data'] == null ? json['data'] : items,
      totalRecords: json['totalrecords'],
    );
  }
}
