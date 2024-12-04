import 'dart:convert';

class ItemDetails {
  final int itemId;
  final int itemType;
  final double stockCount;
  final double basePrice;
  final bool itemEdit;
  final bool isStock;
  final String itemCode;
  final String outline;
  final String description;
  final String imageName;
  final String itemImage;
  final String categoryCode;
  final String note;

  ItemDetails({
    required this.itemId,
    required this.itemType,
    required this.stockCount,
    required this.basePrice,
    required this.itemEdit,
    required this.isStock,
    required this.itemCode,
    required this.outline,
    required this.description,
    required this.imageName,
    required this.itemImage,
    required this.categoryCode,
    required this.note,
  });

  factory ItemDetails.fromJson(Map<String, dynamic> json) {
    return ItemDetails(
      itemId: json['itemid'],
      itemType: json['item_type'],
      stockCount: json['stockcount'],
      basePrice: json['baseprice'],
      itemEdit: json['itemedit'],
      isStock: json['isstock'],
      itemCode: json['itemcode'],
      outline: json['outline'],
      description: json['description'],
      imageName: json['imagename'],
      itemImage: json['itemimage'],
      categoryCode: json['categorycode'],
      note: json['note'],
    );
  }
}

class ItemDetailsResponse {
  String code;
  List<String> message;
  final dynamic data;
  int totalRecords;

  ItemDetailsResponse({
    required this.code,
    required this.message,
    this.data,
    required this.totalRecords,
  });

  factory ItemDetailsResponse.fromJson(Map<String, dynamic> json) {
    var dataList = [];
    List<ItemDetails> items = [];
    if (json['data'] != null) {
      dataList = jsonDecode(json['data']) as List;
      items = dataList.map((i) => ItemDetails.fromJson(i)).toList();
    }
    return ItemDetailsResponse(
      code: json['code'],
      message: List<String>.from(json['message']),
      data: json['data'] == null ? json['data'] : items,
      totalRecords: json['totalrecords'],
    );
  }
}
