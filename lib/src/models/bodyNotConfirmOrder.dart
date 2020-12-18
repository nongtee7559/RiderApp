// To parse this JSON data, do
//
//     final bodyNotConfirmOrder = bodyNotConfirmOrderFromJson(jsonString);

import 'dart:convert';

BodyNotConfirmOrder bodyNotConfirmOrderFromJson(String str) => BodyNotConfirmOrder.fromJson(json.decode(str));

String bodyNotConfirmOrderToJson(BodyNotConfirmOrder data) => json.encode(data.toJson());

class BodyNotConfirmOrder {
  BodyNotConfirmOrder({
    this.doh,
    this.reasonId,
    this.dOrder,
    this.listDods,
    this.isProcess,
    this.UserID
  });

  String doh;
  String reasonId;
  DateTime dOrder;
  List<ListDod> listDods;
  bool isProcess;
  String UserID;

  factory BodyNotConfirmOrder.fromJson(Map<String, dynamic> json) => BodyNotConfirmOrder(
    doh: json["DOH"],
    reasonId: json["ReasonID"],
    dOrder: DateTime.parse(json["DOrder"]),
    listDods: List<ListDod>.from(json["ListDODS"].map((x) => ListDod.fromJson(x))),
    isProcess: json["isProcess"],
    UserID: json["UserId"]
  );

  Map<String, dynamic> toJson() => {
    "DOH": doh,
    "ReasonID": reasonId,
    "DOrder": "${dOrder.year.toString().padLeft(4, '0')}-${dOrder.month.toString().padLeft(2, '0')}-${dOrder.day.toString().padLeft(2, '0')}",
    "ListDODS": List<dynamic>.from(listDods.map((x) => x.toJson())),
    "isProcess":isProcess,
    "UserId":UserID
  };
}

class ListDod {
  ListDod({
    this.orderId,
    this.locationCode,
    this.statusDod,
    this.reasonDod,
    this.deliveryType,
  });

  String orderId;
  String locationCode;
  String statusDod;
  String reasonDod;
  dynamic deliveryType;

  factory ListDod.fromJson(Map<String, dynamic> json) => ListDod(
    orderId: json["OrderID"],
    locationCode: json["LocationCode"],
    statusDod: json["StatusDOD"],
    reasonDod: json["ReasonDOD"],
    deliveryType: json["DeliveryType"],
  );

  Map<String, dynamic> toJson() => {
    "OrderID": orderId,
    "LocationCode": locationCode,
    "StatusDOD": statusDod,
    "ReasonDOD": reasonDod,
    "DeliveryType": deliveryType,
  };
}
