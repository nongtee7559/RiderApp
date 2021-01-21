// To parse this JSON data, do
//
//     final messageResource = messageResourceFromJson(jsonString);

import 'dart:convert';

MessageResource messageResourceFromJson(String str) => MessageResource.fromJson(json.decode(str));

String messageResourceToJson(MessageResource data) => json.encode(data.toJson());

class MessageResource {
  MessageResource({
    this.msg,
    this.returnCode,
    this.errorMessage,
  });

  List<Msg> msg;
  String returnCode;
  ErrorMessage errorMessage;

  factory MessageResource.fromJson(Map<String, dynamic> json) => MessageResource(
    msg: List<Msg>.from(json["msg"].map((x) => Msg.fromJson(x))),
    returnCode: json["returnCode"],
    errorMessage: ErrorMessage.fromJson(json["errorMessage"]),
  );

  Map<String, dynamic> toJson() => {
    "msg": List<dynamic>.from(msg.map((x) => x.toJson())),
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

class Msg {
  Msg({
    this.sMsgCode,
    this.sMsgType,
    this.sMsg,
    this.cStatus,
    this.dCreate,
    this.dChange,
  });

  String sMsgCode;
  String sMsgType;
  String sMsg;
  String cStatus;
  DateTime dCreate;
  DateTime dChange;

  factory Msg.fromJson(Map<String, dynamic> json) => Msg(
    sMsgCode: json["s_MSG_CODE"],
    sMsgType: json["s_MSG_TYPE"],
    sMsg: json["s_MSG"],
    cStatus: json["c_STATUS"],
    dCreate: DateTime.parse(json["d_CREATE"]),
    dChange: DateTime.parse(json["d_CHANGE"]),
  );

  Map<String, dynamic> toJson() => {
    "s_MSG_CODE": sMsgCode,
    "s_MSG_TYPE": sMsgType,
    "s_MSG": sMsg,
    "c_STATUS": cStatus,
    "d_CREATE": dCreate.toIso8601String(),
    "d_CHANGE": dChange.toIso8601String(),
  };
}
