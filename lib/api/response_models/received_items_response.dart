import 'dart:convert';

class ReceivedItemsResponse {
  final String code;
  final List<String> message;
  final dynamic data;
  final int totalRecords;
  final bool print;

  ReceivedItemsResponse(
      {required this.code,
      required this.message,
      this.data,
      required this.totalRecords,
      required this.print});

  factory ReceivedItemsResponse.fromJson(Map<String, dynamic> json) {
    return ReceivedItemsResponse(
      code: json['code'],
      message: List<String>.from(json['message']),
      data: json['data'] == null
          ? json['data']
          : List<OrderData>.from(
              jsonDecode(json['data']).map((item) => OrderData.fromJson(item))),
      totalRecords: json['totalrecords'],
      print: json['print'],
    );
  }
}

class OrderData {
  final int orderId;
  final int orderLineId;
  final int itemId;
  final String? itemCode;
  final String description;
  final String imageName;
  final String itemImage;
  final double quantity;
  final double receivedQuantity;
  final double bookInQuantity;
  final int regionId;
  final int itemType;
  final bool isStock;
  final int itemOrder;
  late double updatedQuantity;
  late bool isSelected;
  late bool isEdited;

  OrderData(
      {required this.orderId,
      required this.orderLineId,
      required this.itemId,
      this.itemCode,
      required this.description,
      required this.imageName,
      required this.itemImage,
      required this.quantity,
      required this.receivedQuantity,
      required this.bookInQuantity,
      required this.regionId,
      required this.itemType,
      required this.isStock,
      required this.itemOrder,
      this.updatedQuantity = 0.0,
      this.isSelected = false,
      this.isEdited = false});

  factory OrderData.fromJson(Map<String, dynamic> json) {
    return OrderData(
        orderId: json['orderid'],
        orderLineId: json['orderlineid'],
        itemId: json['itemid'],
        itemCode: json['itemcode'],
        description: json['description'],
        imageName: json['imagename'] ?? '',
        itemImage: json['itemimage'],
        quantity: json['quantity'],
        receivedQuantity: json['receivedquantity'],
        bookInQuantity: json['bookinquantity'],
        regionId: json['regionid'],
        itemType: json['itemtype'],
        isStock: json['isstock'],
        itemOrder: json['itemorder'],
        updatedQuantity: json['receivedquantity'],
        isEdited: false,
        isSelected: false);
  }
}
