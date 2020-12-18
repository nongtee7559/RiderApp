// To parse this JSON data, do
//
//     final checkLocationResponse = checkLocationResponseFromJson(jsonString);

import 'dart:convert';

CheckLocationResponse checkLocationResponseFromJson(String str) => CheckLocationResponse.fromJson(json.decode(str));

String checkLocationResponseToJson(CheckLocationResponse data) => json.encode(data.toJson());

class CheckLocationResponse {
  List<Responsemaster> responsemaster;
  String returnCode;
  ErrorMessage errorMessage;

  CheckLocationResponse({
    this.responsemaster,
    this.returnCode,
    this.errorMessage,
  });

  factory CheckLocationResponse.fromJson(Map<String, dynamic> json) => CheckLocationResponse(
    responsemaster: List<Responsemaster>.from(json["responsemaster"].map((x) => Responsemaster.fromJson(x))),
    returnCode: json["returnCode"],
    errorMessage: ErrorMessage.fromJson(json["errorMessage"]),
  );

  Map<String, dynamic> toJson() => {
    "responsemaster": List<dynamic>.from(responsemaster.map((x) => x.toJson())),
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

class Responsemaster {
  String storeCode;
  String storeName;
  String locationName;
  String provNamT;
  String ampNamT;
  String tamNamT;
  String provNamE;
  String ampNamE;
  String tamNamE;
  String zipCode;
  String latitude;
  String longitude;
  String plCompcode;
  String locationCode;
  String locationType;
  String renovate;

  Responsemaster({
    this.storeCode,
    this.storeName,
    this.locationName,
    this.provNamT,
    this.ampNamT,
    this.tamNamT,
    this.provNamE,
    this.ampNamE,
    this.tamNamE,
    this.zipCode,
    this.latitude,
    this.longitude,
    this.plCompcode,
    this.locationCode,
    this.locationType,
    this.renovate,
  });

  factory Responsemaster.fromJson(Map<String, dynamic> json) => Responsemaster(
    storeCode: json["storeCode"],
    storeName: json["storeName"],
    locationName: json["locationName"],
    provNamT: json["provNamT"],
    ampNamT: json["ampNamT"],
    tamNamT: json["tamNamT"],
    provNamE: json["provNamE"],
    ampNamE: json["ampNamE"],
    tamNamE: json["tamNamE"],
    zipCode: json["zipCode"],
    latitude: json["latitude"],
    longitude: json["longitude"],
    plCompcode: json["plCompcode"],
    locationCode: json["locationCode"],
    locationType: json["locationType"],
    renovate: json["renovate"],
  );

  Map<String, dynamic> toJson() => {
    "storeCode": storeCode,
    "storeName": storeName,
    "locationName": locationName,
    "provNamT": provNamT,
    "ampNamT": ampNamT,
    "tamNamT": tamNamT,
    "provNamE": provNamE,
    "ampNamE": ampNamE,
    "tamNamE": tamNamE,
    "zipCode": zipCode,
    "latitude": latitude,
    "longitude": longitude,
    "plCompcode": plCompcode,
    "locationCode": locationCode,
    "locationType": locationType,
    "renovate": renovate,
  };
}
