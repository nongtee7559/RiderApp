// To parse this JSON data, do
//
//     final checkAppVersionResource = checkAppVersionResourceFromJson(jsonString);

import 'dart:convert';

CheckAppVersionResource checkAppVersionResourceFromJson(String str) => CheckAppVersionResource.fromJson(json.decode(str));

String checkAppVersionResourceToJson(CheckAppVersionResource data) => json.encode(data.toJson());

class CheckAppVersionResource {
  CheckAppVersionResource({
    this.hasUpdate,
    this.path,
    this.returnCode,
    this.errorMessage,
  });

  bool hasUpdate;
  String path;
  String returnCode;
  ErrorMessage errorMessage;

  factory CheckAppVersionResource.fromJson(Map<String, dynamic> json) => CheckAppVersionResource(
    hasUpdate: json["hasUpdate"],
    path: json["path"],
    returnCode: json["returnCode"],
    errorMessage: ErrorMessage.fromJson(json["errorMessage"]),
  );

  Map<String, dynamic> toJson() => {
    "hasUpdate": hasUpdate,
    "path": path,
    "returnCode": returnCode,
    "errorMessage": errorMessage.toJson(),
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
