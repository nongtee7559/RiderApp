import 'dart:convert';

MasterDropdownList masterDropdownListFromJson(String str) => MasterDropdownList.fromJson(json.decode(str));

String masterDropdownListToJson(MasterDropdownList data) => json.encode(data.toJson());

class MasterDropdownList {
  MasterDropdownList({
    this.masterddl,
    this.returnCode,
    this.errorMessage,
  });

  List<Masterddl> masterddl;
  String returnCode;
  ErrorMessage errorMessage;

  factory MasterDropdownList.fromJson(Map<String, dynamic> json) => MasterDropdownList(
    masterddl: List<Masterddl>.from(json["masterddl"].map((x) => Masterddl.fromJson(x))),
    returnCode: json["returnCode"],
    errorMessage: ErrorMessage.fromJson(json["errorMessage"]),
  );

  Map<String, dynamic> toJson() => {
    "masterddl": List<dynamic>.from(masterddl.map((x) => x.toJson())),
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

class Masterddl {
  Masterddl({
    this.value,
    this.name,
  });

  String value;
  String name;

  factory Masterddl.fromJson(Map<String, dynamic> json) => Masterddl(
    value: json["value"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "value": value,
    "name": name,
  };

}
