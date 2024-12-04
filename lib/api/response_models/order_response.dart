import 'dart:convert';

class Order {
  int orderId;
  int regionId;
  String orderNumber;

  Order(
      {required this.orderId,
      required this.regionId,
      required this.orderNumber});

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
        orderId: json['orderid'],
        regionId: json['regionid'],
        orderNumber: json['ordernumber']);
  }
}

class OrderResponse {
  String code;
  List<String> message;
  final dynamic data;
  int totalRecords;

  OrderResponse({
    required this.code,
    required this.message,
    this.data,
    required this.totalRecords,
  });

  factory OrderResponse.fromJson(Map<String, dynamic> json) {
    var dataList = [];
    List<Order> orders = [];
    if (json['data'] != null) {
      dataList = jsonDecode(json['data']) as List;
      orders = dataList.map((i) => Order.fromJson(i)).toList();
    }

    return OrderResponse(
      code: json['code'],
      message: List<String>.from(json['message']),
      data: json['data'] == null ? json['data'] : orders,
      totalRecords: json['totalrecords'],
    );
  }
}
