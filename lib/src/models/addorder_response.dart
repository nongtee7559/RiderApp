// To parse this JSON data, do
//
//     final addorderResponse = addorderResponseFromJson(jsonString);

import 'dart:convert';

AddorderResponse addorderResponseFromJson(String str) => AddorderResponse.fromJson(json.decode(str));

String addorderResponseToJson(AddorderResponse data) => json.encode(data.toJson());

class AddorderResponse {
  DeliveryOrder deliveryOrder;
  String returnCode;
  ErrorMessage errorMessage;

  AddorderResponse({
    this.deliveryOrder,
    this.returnCode,
    this.errorMessage,
  });

  factory AddorderResponse.fromJson(Map<String, dynamic> json) => AddorderResponse(
    deliveryOrder: DeliveryOrder.fromJson(json["deliveryOrder"]),
    returnCode: json["returnCode"],
    errorMessage: ErrorMessage.fromJson(json["errorMessage"]),
  );

  Map<String, dynamic> toJson() => {
    "deliveryOrder": deliveryOrder.toJson(),
    "returnCode": returnCode,
    "errorMessage": errorMessage.toJson(),
  };
}

class DeliveryOrder {
  int iTranId;
  String sDoNo;
  DateTime dDo;
  DateTime dDelivery;
  String sDeliveryType;
  String sStoreNo;
  dynamic sReceiptId;
  int iEmpId;
  dynamic dReceipt;
  dynamic fTotalAmount;
  dynamic sDoOriginLat;
  dynamic sDoOriginLong;
  dynamic sDoShiptoLat;
  dynamic sDoShiptoLong;
  String sRefPath;
  dynamic sRefText;
  dynamic cStatus;
  dynamic dCreate;
  dynamic dChange;

  DeliveryOrder({
    this.iTranId,
    this.sDoNo,
    this.dDo,
    this.dDelivery,
    this.sDeliveryType,
    this.sStoreNo,
    this.sReceiptId,
    this.iEmpId,
    this.dReceipt,
    this.fTotalAmount,
    this.sDoOriginLat,
    this.sDoOriginLong,
    this.sDoShiptoLat,
    this.sDoShiptoLong,
    this.sRefPath,
    this.sRefText,
    this.cStatus,
    this.dCreate,
    this.dChange,
  });

  factory DeliveryOrder.fromJson(Map<String, dynamic> json) => DeliveryOrder(
    iTranId: json["i_TRAN_ID"],
    sDoNo: json["s_DO_NO"],
    dDo: DateTime.parse(json["d_DO"]),
    dDelivery: DateTime.parse(json["d_DELIVERY"]),
    sDeliveryType: json["s_DELIVERY_TYPE"],
    sStoreNo: json["s_STORE_NO"],
    sReceiptId: json["s_RECEIPT_ID"],
    iEmpId: json["i_EMP_ID"],
    dReceipt: json["d_RECEIPT"],
    fTotalAmount: json["f_TOTAL_AMOUNT"],
    sDoOriginLat: json["s_DO_ORIGIN_LAT"],
    sDoOriginLong: json["s_DO_ORIGIN_LONG"],
    sDoShiptoLat: json["s_DO_SHIPTO_LAT"],
    sDoShiptoLong: json["s_DO_SHIPTO_LONG"],
    sRefPath: json["s_REF_PATH"],
    sRefText: json["s_REF_TEXT"],
    cStatus: json["c_STATUS"],
    dCreate: json["d_CREATE"],
    dChange: json["d_CHANGE"],
  );

  Map<String, dynamic> toJson() => {
    "i_TRAN_ID": iTranId,
    "s_DO_NO": sDoNo,
    "d_DO": dDo.toIso8601String(),
    "d_DELIVERY": dDelivery.toIso8601String(),
    "s_DELIVERY_TYPE": sDeliveryType,
    "s_STORE_NO": sStoreNo,
    "s_RECEIPT_ID": sReceiptId,
    "i_EMP_ID": iEmpId,
    "d_RECEIPT": dReceipt,
    "f_TOTAL_AMOUNT": fTotalAmount,
    "s_DO_ORIGIN_LAT": sDoOriginLat,
    "s_DO_ORIGIN_LONG": sDoOriginLong,
    "s_DO_SHIPTO_LAT": sDoShiptoLat,
    "s_DO_SHIPTO_LONG": sDoShiptoLong,
    "s_REF_PATH": sRefPath,
    "s_REF_TEXT": sRefText,
    "c_STATUS": cStatus,
    "d_CREATE": dCreate,
    "d_CHANGE": dChange,
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
