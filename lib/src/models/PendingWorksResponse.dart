// To parse this JSON data, do
//
//     final pendingWorksResponse = pendingWorksResponseFromJson(jsonString);

import 'dart:convert';

PendingWorksResponse pendingWorksResponseFromJson(String str) => PendingWorksResponse.fromJson(json.decode(str));

String pendingWorksResponseToJson(PendingWorksResponse data) => json.encode(data.toJson());

class PendingWorksResponse {
  int sumPendingWork;
  List<PendingWork> pendingWorks;
  String returnCode;
  ErrorMessage errorMessage;

  PendingWorksResponse({
    this.sumPendingWork,
    this.pendingWorks,
    this.returnCode,
    this.errorMessage,
  });

  factory PendingWorksResponse.fromJson(Map<String, dynamic> json) => PendingWorksResponse(
    sumPendingWork: json["sumPendingWork"],
    pendingWorks: List<PendingWork>.from(json["pendingWorks"].map((x) => PendingWork.fromJson(x))),
    returnCode: json["returnCode"],
    errorMessage: ErrorMessage.fromJson(json["errorMessage"]),
  );

  Map<String, dynamic> toJson() => {
    "sumPendingWork": sumPendingWork,
    "pendingWorks": List<dynamic>.from(pendingWorks.map((x) => x.toJson())),
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

class PendingWork {
  DateTime deliveryDate;
  String empNo;
  int empId;
  String empName;
  int sumTrip;
  String reason;




  PendingWork({
    this.deliveryDate,
    this.empNo,
    this.empId,
    this.empName,
    this.sumTrip,
    this.reason,

  });

  factory PendingWork.fromJson(Map<String, dynamic> json) => PendingWork(
    deliveryDate: DateTime.parse(json["deliveryDate"]),
    empNo: json["empNo"],
    empId: json["empId"],
    empName: json["empName"],
    sumTrip: json["sumTrip"],
    reason: json["reason"],

  );

  Map<String, dynamic> toJson() => {
    "deliveryDate": deliveryDate.toIso8601String(),
    "empNo": empNo,
    "empId": empId,
    "empName": empName,
    "sumTrip": sumTrip,
    "reason": reason,

  };
}
