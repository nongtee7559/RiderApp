// To parse this JSON data, do
//
//     final leave2Response = leave2ResponseFromJson(jsonString);

import 'dart:convert';

Leave2Response leave2ResponseFromJson(String str) => Leave2Response.fromJson(json.decode(str));

String leave2ResponseToJson(Leave2Response data) => json.encode(data.toJson());

class Leave2Response {
  List<EmployeeLeaveAlert> employeeLeaveAlerts;
  String returnCode;
  ErrorMessage errorMessage;

  Leave2Response({
    this.employeeLeaveAlerts,
    this.returnCode,
    this.errorMessage,
  });

  factory Leave2Response.fromJson(Map<String, dynamic> json) => Leave2Response(
    employeeLeaveAlerts: List<EmployeeLeaveAlert>.from(json["employeeLeaveAlerts"].map((x) => EmployeeLeaveAlert.fromJson(x))),
    returnCode: json["returnCode"],
    errorMessage: ErrorMessage.fromJson(json["errorMessage"]),
  );

  Map<String, dynamic> toJson() => {
    "employeeLeaveAlerts": List<dynamic>.from(employeeLeaveAlerts.map((x) => x.toJson())),
    "returnCode": returnCode,
    "errorMessage": errorMessage.toJson(),
  };
}

class EmployeeLeaveAlert {
  int empId;
  int empLeaveId;
  String name;
  List<String> stores;
  String phoneNo;
  DateTime leaveStartDate;
  DateTime leaveEndDate;
  String leaveStartTime;
  String leaveEndTime;
  String leaveType;
  String leaveGroup;
  String leaveTypeDescription;
  String leaveGroupDescription;
  String reason;
  String leaveProcessingDescription;
  String processing;


  EmployeeLeaveAlert({
    this.empId,
    this.empLeaveId,
    this.name,
    this.stores,
    this.phoneNo,
    this.leaveStartDate,
    this.leaveEndDate,
    this.leaveStartTime,
    this.leaveEndTime,
    this.leaveType,
    this.leaveGroup,
    this.leaveTypeDescription,
    this.leaveGroupDescription,
    this.reason,
    this.leaveProcessingDescription,
    this.processing,
  });

  factory EmployeeLeaveAlert.fromJson(Map<String, dynamic> json) => EmployeeLeaveAlert(
    empId: json["empId"],
    empLeaveId: json["empLeaveId"],
    name: json["name"],
    stores: List<String>.from(json["stores"].map((x) => x)),
    phoneNo: json["phoneNo"],
    leaveStartDate: DateTime.parse(json["leaveStartDate"]),
    leaveEndDate: DateTime.parse(json["leaveEndDate"]),
    leaveStartTime: json["leaveStartTime"],
    leaveEndTime: json["leaveEndTime"],
    leaveType: json["leaveType"],
    leaveGroup: json["leaveGroup"],
    leaveTypeDescription: json["leaveTypeDescription"],
    leaveGroupDescription: json["leaveGroupDescription"] == null ? null : json["leaveGroupDescription"],
    reason: json["reason"],
    leaveProcessingDescription: json["leaveProcessingDescription"],
    processing: json["processing"],


  );

  Map<String, dynamic> toJson() => {
    "empId": empId,
    "empLeaveId": empLeaveId,
    "name": name,
    "stores": List<dynamic>.from(stores.map((x) => x)),
    "phoneNo": phoneNo,
    "leaveStartDate": leaveStartDate.toIso8601String(),
    "leaveEndDate": leaveEndDate.toIso8601String(),
    "leaveStartTime": leaveStartTime,
    "leaveEndTime": leaveEndTime,
    "leaveType": leaveType,
    "leaveGroup": leaveGroup,
    "leaveTypeDescription": leaveTypeDescription,
    "leaveGroupDescription": leaveGroupDescription == null ? null : leaveGroupDescription,
    "reason": reason,
    "leaveProcessingDescription": leaveProcessingDescription,
    "processing": processing,
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
