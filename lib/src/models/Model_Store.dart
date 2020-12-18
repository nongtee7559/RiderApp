// To parse this JSON data, do
//
//     final modelStore = modelStoreFromJson(jsonString);

import 'dart:convert';

List<ModelStore> modelStoreFromJson(String str) => List<ModelStore>.from(json.decode(str).map((x) => ModelStore.fromJson(x)));

String modelStoreToJson(List<ModelStore> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ModelStore {
  String sSmLocationCode;
  String sName;

  ModelStore({
    this.sSmLocationCode,
    this.sName,
  });

  factory ModelStore.fromJson(Map<String, dynamic> json) => ModelStore(
    sSmLocationCode: json["S_SM_LOCATION_CODE"],
    sName: json["S_NAME"],
  );

  Map<String, dynamic> toJson() => {
    "S_SM_LOCATION_CODE": sSmLocationCode,
    "S_NAME": sName,
  };
}
