// To parse this JSON data, do
//
//     final loginResponse = loginResponseFromJson(jsonString);

import 'dart:convert';

LoginResponse loginResponseFromJson(String str) => LoginResponse.fromJson(json.decode(str));

String loginResponseToJson(LoginResponse data) => json.encode(data.toJson());

class LoginResponse {
  LoginResponse({
    this.userProfile,
    this.token,
    this.returnCode,
    this.errorMessage,
  });

  UserProfile userProfile;
  Token token;
  String returnCode;
  ErrorMessage errorMessage;

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
    userProfile: UserProfile.fromJson(json["userProfile"]),
    token: Token.fromJson(json["token"]),
    returnCode: json["returnCode"],
    errorMessage: ErrorMessage.fromJson(json["errorMessage"]),
  );

  Map<String, dynamic> toJson() => {
    "userProfile": userProfile.toJson(),
    "token": token.toJson(),
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

class Token {
  Token({
    this.token,
    this.expiration,
  });

  String token;
  DateTime expiration;

  factory Token.fromJson(Map<String, dynamic> json) => Token(
    token: json["token"],
    expiration: DateTime.parse(json["expiration"]),
  );

  Map<String, dynamic> toJson() => {
    "token": token,
    "expiration": expiration.toIso8601String(),
  };
}

class UserProfile {
  UserProfile({
    this.sUserId,
    this.companyId,
    this.companyName,
    this.iEmpId,
    this.sEmpNo,
    this.sUserFname,
    this.sUserLname,
    this.sUserGender,
    this.sPhoneNo,
    this.sEmail,
    this.sEmpType,
    this.employeeType,
    this.menus,
    this.clients,
  });

  String sUserId;
  String companyId;
  String companyName;
  int iEmpId;
  String sEmpNo;
  String sUserFname;
  String sUserLname;
  String sUserGender;
  String sPhoneNo;
  String sEmail;
  String sEmpType;
  String employeeType;
  List<Menu> menus;
  List<Client> clients;

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
    sUserId: json["s_USER_ID"],
    companyId: json["companyId"],
    companyName: json["companyName"],
    iEmpId: json["i_EMP_ID"],
    sEmpNo: json["s_EMP_NO"],
    sUserFname: json["s_USER_FNAME"],
    sUserLname: json["s_USER_LNAME"],
    sUserGender: json["s_USER_GENDER"],
    sPhoneNo: json["s_PHONE_NO"],
    sEmail: json["s_EMAIL"],
    sEmpType: json["s_EMP_TYPE"],
    employeeType: json["employeeType"],
    menus: List<Menu>.from(json["menus"].map((x) => Menu.fromJson(x))),
    clients: List<Client>.from(json["clients"].map((x) => Client.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "s_USER_ID": sUserId,
    "companyId": companyId,
    "companyName": companyName,
    "i_EMP_ID": iEmpId,
    "s_EMP_NO": sEmpNo,
    "s_USER_FNAME": sUserFname,
    "s_USER_LNAME": sUserLname,
    "s_USER_GENDER": sUserGender,
    "s_PHONE_NO": sPhoneNo,
    "s_EMAIL": sEmail,
    "s_EMP_TYPE": sEmpType,
    "employeeType": employeeType,
    "menus": List<dynamic>.from(menus.map((x) => x.toJson())),
    "clients": List<dynamic>.from(clients.map((x) => x.toJson())),
  };
}

class Client {
  Client({
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

  factory Client.fromJson(Map<String, dynamic> json) => Client(
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

class Menu {
  Menu({
    this.isSelect,
    this.isAdd,
    this.isEdit,
    this.isDelete,
    this.sMenuId,
    this.sParentMenuId,
    this.sNameTh,
    this.sNameEn,
    this.sUrl,
    this.sIconTag,
    this.iLevel,
    this.iSequence,
    this.sSystem,
    this.cStatus,
    this.dCreate,
    this.dChange,
  });

  bool isSelect;
  bool isAdd;
  bool isEdit;
  bool isDelete;
  String sMenuId;
  String sParentMenuId;
  String sNameTh;
  String sNameEn;
  String sUrl;
  String sIconTag;
  int iLevel;
  int iSequence;
  dynamic sSystem;
  String cStatus;
  DateTime dCreate;
  DateTime dChange;

  factory Menu.fromJson(Map<String, dynamic> json) => Menu(
    isSelect: json["isSelect"],
    isAdd: json["isAdd"],
    isEdit: json["isEdit"],
    isDelete: json["isDelete"],
    sMenuId: json["s_MENU_ID"],
    sParentMenuId: json["s_PARENT_MENU_ID"],
    sNameTh: json["s_NAME_TH"],
    sNameEn: json["s_NAME_EN"],
    sUrl: json["s_URL"] == null ? null : json["s_URL"],
    sIconTag: json["s_ICON_TAG"] == null ? null : json["s_ICON_TAG"],
    iLevel: json["i_LEVEL"],
    iSequence: json["i_SEQUENCE"],
    sSystem: json["s_SYSTEM"],
    cStatus: json["c_STATUS"],
    dCreate: DateTime.parse(json["d_CREATE"]),
    dChange: DateTime.parse(json["d_CHANGE"]),
  );

  Map<String, dynamic> toJson() => {
    "isSelect": isSelect,
    "isAdd": isAdd,
    "isEdit": isEdit,
    "isDelete": isDelete,
    "s_MENU_ID": sMenuId,
    "s_PARENT_MENU_ID": sParentMenuId,
    "s_NAME_TH": sNameTh,
    "s_NAME_EN": sNameEn,
    "s_URL": sUrl == null ? null : sUrl,
    "s_ICON_TAG": sIconTag == null ? null : sIconTag,
    "i_LEVEL": iLevel,
    "i_SEQUENCE": iSequence,
    "s_SYSTEM": sSystem,
    "c_STATUS": cStatus,
    "d_CREATE": dCreate.toIso8601String(),
    "d_CHANGE": dChange.toIso8601String(),
  };
}
