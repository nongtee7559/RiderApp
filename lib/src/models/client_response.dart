// To parse this JSON data, do
//
//     final clientsRespose = clientsResposeFromJson(jsonString);

import 'dart:convert';

ClientsRespose clientsResposeFromJson(String str) => ClientsRespose.fromJson(json.decode(str));

String clientsResposeToJson(ClientsRespose data) => json.encode(data.toJson());

class ClientsRespose {
  ClientsRespose({
    this.clients,
  });

  List<ClientData> clients;

  factory ClientsRespose.fromJson(Map<String, dynamic> json) => ClientsRespose(
    clients: List<ClientData>.from(json["clients"].map((x) => ClientData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "clients": List<dynamic>.from(clients.map((x) => x.toJson())),
  };
}

class ClientData {
  ClientData({
    this.sClientCompCode,
    this.sCompPrefix,
    this.sLogoSrc,
    this.sNameTh,
    this.sNameEn,
    this.sShortName,
  });

  String sClientCompCode;
  String sCompPrefix;
  String sLogoSrc;
  String sNameTh;
  String sNameEn;
  String sShortName;

  factory ClientData.fromJson(Map<String, dynamic> json) => ClientData(
    sClientCompCode: json["s_CLIENT_COMP_CODE"],
    sCompPrefix: json["s_COMP_PREFIX"],
    sLogoSrc: json["s_LOGO_SRC"],
    sNameTh: json["s_NAME_TH"],
    sNameEn: json["s_NAME_EN"],
    sShortName: json["s_SHORT_NAME"],
  );

  Map<String, dynamic> toJson() => {
    "s_CLIENT_COMP_CODE": sClientCompCode,
    "s_COMP_PREFIX": sCompPrefix,
    "s_LOGO_SRC": sLogoSrc,
    "s_NAME_TH": sNameTh,
    "s_NAME_EN": sNameEn,
    "s_SHORT_NAME": sShortName,
  };
}
