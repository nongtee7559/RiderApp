// To parse this JSON data, do
//
//     final pendingdetailResponse = pendingdetailResponseFromJson(jsonString);

import 'dart:convert';

PendingdetailResponse pendingdetailResponseFromJson(String str) => PendingdetailResponse.fromJson(json.decode(str));

String pendingdetailResponseToJson(PendingdetailResponse data) => json.encode(data.toJson());

class PendingdetailResponse {
  int sumOrder;
  DateTime orderDate;
  List<Order> orders;
  String returnCode;
  ErrorMessage errorMessage;

  PendingdetailResponse({
    this.sumOrder,
    this.orderDate,
    this.orders,
    this.returnCode,
    this.errorMessage,
  });

  factory PendingdetailResponse.fromJson(Map<String, dynamic> json) => PendingdetailResponse(
    sumOrder: json["sumOrder"],
    orderDate: DateTime.parse(json["orderDate"]),
    orders: List<Order>.from(json["orders"].map((x) => Order.fromJson(x))),
    returnCode: json["returnCode"],
    errorMessage: ErrorMessage.fromJson(json["errorMessage"]),
  );

  Map<String, dynamic> toJson() => {
    "sumOrder": sumOrder,
    "orderDate": orderDate.toIso8601String(),
    "orders": List<dynamic>.from(orders.map((x) => x.toJson())),
    "returnCode": returnCode,
    "errorMessage": errorMessage.toJson(),
  };
}

class ErrorMessage {
  List<dynamic> errorMessages;
  bool isError;
  String errorText;

  ErrorMessage({
    this.errorMessages,
    this.isError,
    this.errorText,
  });

  factory ErrorMessage.fromJson(Map<String, dynamic> json) => ErrorMessage(
    errorMessages: List<dynamic>.from(json["errorMessages"].map((x) => x)),
    isError: json["isError"],
    errorText: json["errorText"],
  );

  Map<String, dynamic> toJson() => {
    "errorMessages": List<dynamic>.from(errorMessages.map((x) => x)),
    "isError": isError,
    "errorText": errorText,
  };
}

class Order {
  String orderId;
  String storeNo;
  double amount;
  String shipmentType;

  Order({
    this.orderId,
    this.storeNo,
    this.amount,
    this.shipmentType,
  });

  factory Order.fromJson(Map<String, dynamic> json) => Order(
    orderId: json["orderId"],
    storeNo: json["storeNo"],
    amount: json["amount"],
    shipmentType: json["shipmentType"],
  );

  Map<String, dynamic> toJson() => {
    "orderId": orderId,
    "storeNo": storeNo,
    "amount": amount,
    "shipmentType": shipmentType,
  };
}
