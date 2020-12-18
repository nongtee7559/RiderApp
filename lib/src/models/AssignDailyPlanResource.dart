// To parse this JSON data, do
//
//     final assignDailyPlanResource = assignDailyPlanResourceFromJson(jsonString);

import 'dart:convert';

AssignDailyPlanResource assignDailyPlanResourceFromJson(String str) => AssignDailyPlanResource.fromJson(json.decode(str));

String assignDailyPlanResourceToJson(AssignDailyPlanResource data) => json.encode(data.toJson());

class AssignDailyPlanResource {
  AssignDailyPlanResource({
    this.data,
    this.isLeave,
    this.returnCode,
    this.errorMessage,
  });

  List<AssignDailyPlanResponse> data;
  bool isLeave;
  String returnCode;
  ErrorMessage errorMessage;

  factory AssignDailyPlanResource.fromJson(Map<String, dynamic> json) => AssignDailyPlanResource(
    data: List<AssignDailyPlanResponse>.from(json["data"].map((x) => AssignDailyPlanResponse.fromJson(x))),
    isLeave: json["isLeave"],
    returnCode: json["returnCode"],
    errorMessage: ErrorMessage.fromJson(json["errorMessage"]),
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "isLeave":isLeave,
    "returnCode": returnCode,
    "errorMessage": errorMessage.toJson(),
  };
}

class AssignDailyPlanResponse {
  AssignDailyPlanResponse({
    this.sLocationCode,
    this.tStart,
    this.tFinish,
    this.diffTime,
  });

  String sLocationCode;
  String tStart;
  String tFinish;
  String diffTime;

  factory AssignDailyPlanResponse.fromJson(Map<String, dynamic> json) => AssignDailyPlanResponse(
    sLocationCode: json["s_LOCATION_CODE"],
    tStart: json["t_START"],
    tFinish: json["t_FINISH"],
    diffTime: json["diffTime"],
  );

  Map<String, dynamic> toJson() => {
    "s_LOCATION_CODE": sLocationCode,
    "t_START": tStart,
    "t_FINISH": tFinish,
    "diffTime": diffTime,
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
