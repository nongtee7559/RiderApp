// To parse this JSON data, do
//
//     final summaryResponse = summaryResponseFromJson(jsonString);

import 'dart:convert';

SummaryResponse summaryResponseFromJson(String str) => SummaryResponse.fromJson(json.decode(str));

String summaryResponseToJson(SummaryResponse data) => json.encode(data.toJson());

class SummaryResponse {
  SummaryResponse({
    this.sumAmount,
    this.sumDelivery,
    this.deliveryOrders,
    this.returnCode,
    this.errorMessage,
  });

  double sumAmount;
  int sumDelivery;
  List<DeliveryOrder> deliveryOrders;
  String returnCode;
  ErrorMessage errorMessage;

  factory SummaryResponse.fromJson(Map<String, dynamic> json) => SummaryResponse(
    sumAmount: json["sumAmount"],
    sumDelivery: json["sumDelivery"],
    deliveryOrders: List<DeliveryOrder>.from(json["deliveryOrders"].map((x) => DeliveryOrder.fromJson(x))),
    returnCode: json["returnCode"],
    errorMessage: ErrorMessage.fromJson(json["errorMessage"]),
  );

  Map<String, dynamic> toJson() => {
    "sumAmount": sumAmount,
    "sumDelivery": sumDelivery,
    "deliveryOrders": List<dynamic>.from(deliveryOrders.map((x) => x.toJson())),
    "returnCode": returnCode,
    "errorMessage": errorMessage.toJson(),
  };
}

class DeliveryOrder {
  DeliveryOrder({
    this.sDeliveryType,
    this.sDeliveryTypeName,
    this.count,
  });

  String sDeliveryType;
  String sDeliveryTypeName;
  int count;

  factory DeliveryOrder.fromJson(Map<String, dynamic> json) => DeliveryOrder(
    sDeliveryType: json["sDeliveryType"],
    sDeliveryTypeName: json["sDeliveryTypeName"],
    count: json["count"],
  );

  Map<String, dynamic> toJson() => {
    "sDeliveryType": sDeliveryType,
    "sDeliveryTypeName": sDeliveryTypeName,
    "count": count,
  };
}

class ErrorMessage {
  ErrorMessage({
    this.errorMessages,
    this.isError,
    this.errorText,
  });

  List<dynamic> errorMessages;
  bool isError;
  String errorText;

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
