// To parse this JSON data, do
//
//     final deliveryOrderHeadersResponse = deliveryOrderHeadersResponseFromJson(jsonString);

import 'dart:convert';

DeliveryOrderHeaderResponse deliveryOrderHeadersResponseFromJson(String str) => DeliveryOrderHeaderResponse.fromJson(json.decode(str));

String deliveryOrderHeadersResponseToJson(DeliveryOrderHeaderResponse data) => json.encode(data.toJson());

class DeliveryOrderHeaderResponse {
    DeliveryOrderHeaderResponse({
        this.deliveryOrderHeaders,
        this.returnCode,
        this.errorMessage,
    });

    List<DeliveryOrderHeader> deliveryOrderHeaders;
    String returnCode;
    ErrorMessage errorMessage;

    factory DeliveryOrderHeaderResponse.fromJson(Map<String, dynamic> json) => DeliveryOrderHeaderResponse(
        deliveryOrderHeaders: List<DeliveryOrderHeader>.from(json["deliveryOrderHeaders"].map((x) => DeliveryOrderHeader.fromJson(x))),
        returnCode: json["returnCode"],
        errorMessage: ErrorMessage.fromJson(json["errorMessage"]),
    );

    Map<String, dynamic> toJson() => {
        "deliveryOrderHeaders": List<dynamic>.from(deliveryOrderHeaders.map((x) => x.toJson())),
        "returnCode": returnCode,
        "errorMessage": errorMessage.toJson(),
    };
}

class DeliveryOrderHeader {
    DeliveryOrderHeader({
        this.iDohId,
        this.sClientCompCode,
        this.s3PlCompCode,
        this.iEmpId,
        this.iTotalBill,
        this.fTotalRiderPayfee,
        this.fTotalSupPayfee,
        this.fTotalServiceCharge,
        this.sRefPayfeeDocNo,
        this.dCheckin,
        this.dCheckout,
        this.iWorkDuration,
        this.dDelivery,
        this.iRId,
        this.dCreate,
        this.dChange,
        this.cStatus,
        this.employee,
        this.reason,
        this.confirmOrderStatusConfig,
        this.isStatus,
        this.statusMessages,
        this.totalBill,
        this.totalConfirmBill,
        this.sUserId,
        this.iCalPayfeeType,
        this.comment
    });

    int iDohId;
    String sClientCompCode;
    String s3PlCompCode;
    int iEmpId;
    int iTotalBill;
    double fTotalRiderPayfee;
    double fTotalSupPayfee;
    double fTotalServiceCharge;
    dynamic sRefPayfeeDocNo;
    DateTime dCheckin;
    DateTime dCheckout;
    int iWorkDuration;
    DateTime dDelivery;
    dynamic iRId;
    DateTime dCreate;
    DateTime dChange;
    String cStatus;
    Employee employee;
    Reason reason;
    dynamic confirmOrderStatusConfig;
    dynamic isStatus;
    dynamic statusMessages;
    int totalBill;
    int totalConfirmBill;
    String sUserId;
    dynamic iCalPayfeeType;
    dynamic comment;

    factory DeliveryOrderHeader.fromJson(Map<String, dynamic> json) => DeliveryOrderHeader(
        iDohId: json["i_DOH_ID"],
        sClientCompCode: json["s_CLIENT_COMP_CODE"],
        s3PlCompCode: json["s_3PL_COMP_CODE"],
        iEmpId: json["i_EMP_ID"],
        iTotalBill: json["i_TOTAL_BILL"],
        fTotalRiderPayfee: json["f_TOTAL_RIDER_PAYFEE"],
        fTotalSupPayfee: json["f_TOTAL_SUP_PAYFEE"],
        fTotalServiceCharge: json["f_TOTAL_SERVICE_CHARGE"],
        sRefPayfeeDocNo: json["s_REF_PAYFEE_DOC_NO"],
        dCheckin: json["d_CHECKIN"]==null?null:DateTime.parse(json["d_CHECKIN"]),
        dCheckout: json["d_CHECKOUT"]==null?null:DateTime.parse(json["d_CHECKOUT"]),
        iWorkDuration: json["i_WORK_DURATION"],
        dDelivery: json["d_DELIVERY"]==null?null:DateTime.parse(json["d_DELIVERY"]),
        iRId: json["i_R_ID"],
        dCreate: DateTime.parse(json["d_CREATE"]),
        dChange: DateTime.parse(json["d_CHANGE"]),
        cStatus: json["c_STATUS"],
        employee: Employee.fromJson(json["employee"]),
        reason: json["reason"] == null ? null : Reason.fromJson(json["reason"]),
        confirmOrderStatusConfig: json["confirmOrderStatusConfig"],
        isStatus: json["isStatus"],
        statusMessages: json["statusMessages"],
        totalBill: json["totalBill"],
        totalConfirmBill: json["totalConfirmBill"],
        sUserId: json["s_USER_ID"],
        iCalPayfeeType: json["i_CAL_PAYFEE_TYPE"],
        comment: json["comment"] == null ? "":json["comment"]
    );

    Map<String, dynamic> toJson() => {
        "i_DOH_ID": iDohId,
        "s_CLIENT_COMP_CODE": sClientCompCode,
        "s_3PL_COMP_CODE": s3PlCompCode,
        "i_EMP_ID": iEmpId,
        "i_TOTAL_BILL": iTotalBill,
        "f_TOTAL_RIDER_PAYFEE": fTotalRiderPayfee,
        "f_TOTAL_SUP_PAYFEE": fTotalSupPayfee,
        "f_TOTAL_SERVICE_CHARGE": fTotalServiceCharge,
        "s_REF_PAYFEE_DOC_NO": sRefPayfeeDocNo,
        "d_CHECKIN": dCheckin.toIso8601String(),
        "d_CHECKOUT": dCheckout.toIso8601String(),
        "i_WORK_DURATION": iWorkDuration,
        "d_DELIVERY": dDelivery.toIso8601String(),
        "i_R_ID": iRId,
        "d_CREATE": dCreate.toIso8601String(),
        "d_CHANGE": dChange.toIso8601String(),
        "c_STATUS": cStatus,
        "employee": employee.toJson(),
        "reason": reason == null ? null: reason.toJson(),
        "confirmOrderStatusConfig": confirmOrderStatusConfig,
        "isStatus": isStatus,
        "statusMessages": statusMessages,
        "totalBill": totalBill,
        "totalConfirmBill": totalConfirmBill,
        "s_USER_ID":sUserId,
        "i_CAL_PAYFEE_TYPE":iCalPayfeeType,
        "comment":comment
    };
}

class Employee {
    Employee({
        this.iEmpId,
        this.s3PlCompCode,
        this.sEmpNo,
        this.sEmpType,
        this.sRefMngId,
        this.sUserFname,
        this.sUserLname,
        this.sUserFnameEng,
        this.sUserLnameEng,
        this.sUserGender,
        this.dBirthday,
        this.sBpNo,
        this.sEmail,
        this.sPhoneNo,
        this.sDistrict,
        this.sSubDistrict,
        this.sProvince,
        this.iZipcode,
        this.sAddress,
        this.sPicturePath,
        this.dCreate,
        this.dChange,
        this.cStatus,
        this.orderNo,
    });

    int iEmpId;
    String s3PlCompCode;
    String sEmpNo;
    String sEmpType;
    String sRefMngId;
    String sUserFname;
    String sUserLname;
    dynamic sUserFnameEng;
    dynamic sUserLnameEng;
    String sUserGender;
    dynamic dBirthday;
    String sBpNo;
    dynamic sEmail;
    dynamic sPhoneNo;
    dynamic sDistrict;
    dynamic sSubDistrict;
    dynamic sProvince;
    dynamic iZipcode;
    dynamic sAddress;
    dynamic sPicturePath;
    DateTime dCreate;
    DateTime dChange;
    String cStatus;
    List<dynamic> orderNo;

    factory Employee.fromJson(Map<String, dynamic> json) => Employee(
        iEmpId: json["i_EMP_ID"],
        s3PlCompCode: json["s_3PL_COMP_CODE"],
        sEmpNo: json["s_EMP_NO"],
        sEmpType: json["s_EMP_TYPE"],
        sRefMngId: json["s_REF_MNG_ID"],
        sUserFname: json["s_USER_FNAME"],
        sUserLname: json["s_USER_LNAME"],
        sUserFnameEng: json["s_USER_FNAME_ENG"],
        sUserLnameEng: json["s_USER_LNAME_ENG"],
        sUserGender: json["s_USER_GENDER"],
        dBirthday: json["d_BIRTHDAY"],
        sBpNo: json["s_BP_NO"],
        sEmail: json["s_EMAIL"],
        sPhoneNo: json["s_PHONE_NO"],
        sDistrict: json["s_DISTRICT"],
        sSubDistrict: json["s_SUB_DISTRICT"],
        sProvince: json["s_PROVINCE"],
        iZipcode: json["i_ZIPCODE"],
        sAddress: json["s_ADDRESS"],
        sPicturePath: json["s_PICTURE_PATH"],
        dCreate: DateTime.parse(json["d_CREATE"]),
        dChange: DateTime.parse(json["d_CHANGE"]),
        cStatus: json["c_STATUS"],
        orderNo: List<dynamic>.from(json["orderNo"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "i_EMP_ID": iEmpId,
        "s_3PL_COMP_CODE": s3PlCompCode,
        "s_EMP_NO": sEmpNo,
        "s_EMP_TYPE": sEmpType,
        "s_REF_MNG_ID": sRefMngId,
        "s_USER_FNAME": sUserFname,
        "s_USER_LNAME": sUserLname,
        "s_USER_FNAME_ENG": sUserFnameEng,
        "s_USER_LNAME_ENG": sUserLnameEng,
        "s_USER_GENDER": sUserGender,
        "d_BIRTHDAY": dBirthday,
        "s_BP_NO": sBpNo,
        "s_EMAIL": sEmail,
        "s_PHONE_NO": sPhoneNo,
        "s_DISTRICT": sDistrict,
        "s_SUB_DISTRICT": sSubDistrict,
        "s_PROVINCE": sProvince,
        "i_ZIPCODE": iZipcode,
        "s_ADDRESS": sAddress,
        "s_PICTURE_PATH": sPicturePath,
        "d_CREATE": dCreate.toIso8601String(),
        "d_CHANGE": dChange.toIso8601String(),
        "c_STATUS": cStatus,
        "orderNo": List<dynamic>.from(orderNo.map((x) => x)),
    };
}

class Reason {
    Reason({
        this.iRId,
        this.sGroup,
        this.sReason,
        this.dCreate,
        this.dChange,
        this.cStatus,
    });

    dynamic iRId;
    String sGroup;
    String sReason;
    DateTime dCreate;
    DateTime dChange;
    String cStatus;

    factory Reason.fromJson(Map<String, dynamic> json) => Reason(
        iRId: json["i_R_ID"],
        sGroup: json["s_GROUP"],
        sReason: json["s_REASON"],
        dCreate: DateTime.parse(json["d_CREATE"]),
        dChange: DateTime.parse(json["d_CHANGE"]),
        cStatus: json["c_STATUS"],
    );

    Map<String, dynamic> toJson() => {
        "i_R_ID": iRId,
        "s_GROUP": sGroup,
        "s_REASON": sReason,
        "d_CREATE": dCreate.toIso8601String(),
        "d_CHANGE": dChange.toIso8601String(),
        "c_STATUS": cStatus,
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
