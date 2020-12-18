// To parse this JSON data, do
//
//     final modelReturnStatusResponse = modelReturnStatusResponseFromJson(jsonString);

import 'dart:convert';

ModelReturnStatusResponse modelReturnStatusResponseFromJson(String str) => ModelReturnStatusResponse.fromJson(json.decode(str));

String modelReturnStatusResponseToJson(ModelReturnStatusResponse data) => json.encode(data.toJson());

class ModelReturnStatusResponse {
  String returnCode;
  ErrorMessage errorMessage;

  ModelReturnStatusResponse({
    this.returnCode,
    this.errorMessage,
  });

  factory ModelReturnStatusResponse.fromJson(Map<String, dynamic> json) => ModelReturnStatusResponse(
    returnCode: json["returnCode"],
    errorMessage: ErrorMessage.fromJson(json["errorMessage"]),
  );

  Map<String, dynamic> toJson() => {
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
