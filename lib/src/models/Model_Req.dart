// To parse this JSON data, do
//
//     final modelDerivery = modelDeriveryFromJson(jsonString);

import 'dart:convert';

ModelDerivery modelDeriveryFromJson(String str) => ModelDerivery.fromJson(json.decode(str));

String modelDeriveryToJson(ModelDerivery data) => json.encode(data.toJson());

class ModelDerivery {
  int iTranId;
  String sDoNo;
  DateTime dDo;
  DateTime dDelivery;
  String sDeliveryType;
  String sStoreNo;
  String sReceiptId;
  int iEmpId;
  dynamic dReceipt;
  dynamic fTotalAmount;
  dynamic sDoOriginLat;
  dynamic sDoOriginLong;
  dynamic sDoShiptoLat;
  dynamic sDoShiptoLong;
  String sRefPath;
  dynamic sRefText;
  dynamic sStatus;
  dynamic sCreate;
  dynamic sChange;

  ModelDerivery({
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
    this.sStatus,
    this.sCreate,
    this.sChange,
  });

  factory ModelDerivery.fromJson(Map<String, dynamic> json) => ModelDerivery(
    iTranId: json["I_TRAN_ID"],
    sDoNo: json["S_DO_NO"],
    dDo: DateTime.parse(json["D_DO"]),
    dDelivery: DateTime.parse(json["D_DELIVERY"]),
    sDeliveryType: json["S_DELIVERY_TYPE"],
    sStoreNo: json["S_STORE_NO"],
    sReceiptId: json["S_RECEIPT_ID"],
    iEmpId: json["I_EMP_ID"],
    dReceipt: json["D_RECEIPT"],
    fTotalAmount: json["F_TOTAL_AMOUNT"],
    sDoOriginLat: json["S_DO_ORIGIN_LAT"],
    sDoOriginLong: json["S_DO_ORIGIN_LONG"],
    sDoShiptoLat: json["S_DO_SHIPTO_LAT"],
    sDoShiptoLong: json["S_DO_SHIPTO_LONG"],
    sRefPath: json["S_REF_PATH"],
    sRefText: json["S_REF_TEXT"],
    sStatus: json["S_STATUS"],
    sCreate: json["S_CREATE"],
    sChange: json["S_CHANGE"],
  );

  Map<String, dynamic> toJson() => {
    "I_TRAN_ID": iTranId,
    "S_DO_NO": sDoNo,
    "D_DO": dDo.toIso8601String(),
    "D_DELIVERY": dDelivery.toIso8601String(),
    "S_DELIVERY_TYPE": sDeliveryType,
    "S_STORE_NO": sStoreNo,
    "S_RECEIPT_ID": sReceiptId,
    "I_EMP_ID": iEmpId,
    "D_RECEIPT": dReceipt,
    "F_TOTAL_AMOUNT": fTotalAmount,
    "S_DO_ORIGIN_LAT": sDoOriginLat,
    "S_DO_ORIGIN_LONG": sDoOriginLong,
    "S_DO_SHIPTO_LAT": sDoShiptoLat,
    "S_DO_SHIPTO_LONG": sDoShiptoLong,
    "S_REF_PATH": sRefPath,
    "S_REF_TEXT": sRefText,
    "S_STATUS": sStatus,
    "S_CREATE": sCreate,
    "S_CHANGE": sChange,
  };
}
