// To parse this JSON data, do
//
//     final deliveryOrderDetailResponse = deliveryOrderDetailResponseFromJson(jsonString);

import 'dart:convert';

DeliveryOrderDetailResponse deliveryOrderDetailResponseFromJson(String str) => DeliveryOrderDetailResponse.fromJson(json.decode(str));

String deliveryOrderDetailResponseToJson(DeliveryOrderDetailResponse data) => json.encode(data.toJson());

class DeliveryOrderDetailResponse {
    DeliveryOrderDetailResponse({
        this.deliveryOrderDetails,
        this.returnCode,
        this.errorMessage,
    });

    List<DeliveryOrderDetail> deliveryOrderDetails;
    String returnCode;
    ErrorMessage errorMessage;

    factory DeliveryOrderDetailResponse.fromJson(Map<String, dynamic> json) => DeliveryOrderDetailResponse(
        deliveryOrderDetails: List<DeliveryOrderDetail>.from(json["deliveryOrderDetails"].map((x) => DeliveryOrderDetail.fromJson(x))),
        returnCode: json["returnCode"],
        errorMessage: ErrorMessage.fromJson(json["errorMessage"]),
    );

    Map<String, dynamic> toJson() => {
        "deliveryOrderDetails": List<dynamic>.from(deliveryOrderDetails.map((x) => x.toJson())),
        "returnCode": returnCode,
        "errorMessage": errorMessage.toJson(),
    };
}

class DeliveryOrderDetail {
    DeliveryOrderDetail({
        this.iDodId,
        this.iDohId,
        this.sOrderNo,
        this.iDeliveryType,
        this.sLocationType,
        this.sLocationCode,
        this.fRiderPayfee,
        this.fSupPayfee,
        this.fServiceCharge,
        this.fAmount,
        this.fDiscount,
        this.fTotalPrice,
        this.iRId,
        this.sCmd,
        this.dOrderTime,
        this.dCreate,
        this.dChange,
        this.cStatus,
        this.reason,
        this.deliveryType,
        this.sRefSvcDocNo,
        this.sUserId,
        this.dAssignOrder
    });

    int iDodId;
    int iDohId;
    String sOrderNo;
    int iDeliveryType;
    String sLocationType;
    String sLocationCode;
    double fRiderPayfee;
    double fSupPayfee;
    double fServiceCharge;
    double fAmount;
    double fTotalPrice;
    double fDiscount;
    dynamic iRId;
    dynamic sCmd;
    DateTime dOrderTime;
    DateTime dCreate;
    DateTime dChange;
    String cStatus;
    dynamic reason;
    DeliveryType deliveryType;
    dynamic sRefSvcDocNo;
    String sUserId;
    DateTime dAssignOrder;

    factory DeliveryOrderDetail.fromJson(Map<String, dynamic> json) => DeliveryOrderDetail(
        iDodId: json["i_DOD_ID"],
        iDohId: json["i_DOH_ID"],
        sOrderNo: json["s_ORDER_NO"],
        iDeliveryType: json["i_DELIVERY_TYPE"],
        sLocationType: json["s_LOCATION_TYPE"],
        sLocationCode: json["s_LOCATION_CODE"],
        fRiderPayfee: json["f_RIDER_PAYFEE"],
        fSupPayfee: json["f_SUP_PAYFEE"],
        fServiceCharge: json["f_SERVICE_CHARGE"],
        fAmount: json["f_AMOUNT"],
        fTotalPrice: json["f_TOTAL_PRICE"],
        fDiscount: json["f_DISCOUNT"],
        iRId: json["i_R_ID"],
        sRefSvcDocNo: json["s_REF_SVC_DOC_NO"],
        sCmd: json["s_CMD"],
        dOrderTime: DateTime.parse(json["d_ORDER_TIME"]),
        dCreate: DateTime.parse(json["d_CREATE"]),
        dChange: DateTime.parse(json["d_CHANGE"]),
        cStatus: json["c_STATUS"],
        reason: json["reason"],
        deliveryType: DeliveryType.fromJson(json["deliveryType"]),
        sUserId: json["s_USER_ID"],
        dAssignOrder: json["d_ASSIGN_ORDER"]==null?null:DateTime.parse(json["d_ASSIGN_ORDER"])
    );

    Map<String, dynamic> toJson() => {
        "i_DOD_ID": iDodId,
        "i_DOH_ID": iDohId,
        "s_ORDER_NO": sOrderNo,
        "i_DELIVERY_TYPE": iDeliveryType,
        "s_LOCATION_TYPE": sLocationType,
        "s_LOCATION_CODE": sLocationCode,
        "f_RIDER_PAYFEE": fRiderPayfee,
        "f_SUP_PAYFEE": fSupPayfee,
        "f_SERVICE_CHARGE": fServiceCharge,
        "f_AMOUNT": fAmount,
        "f_TOTAL_PRICE": fTotalPrice,
        "s_REF_SVC_DOC_NO": sRefSvcDocNo,
        "f_DISCOUNT":fDiscount,
        "i_R_ID": iRId,
        "s_CMD": sCmd,
        "d_ORDER_TIME": dOrderTime.toIso8601String(),
        "d_CREATE": dCreate.toIso8601String(),
        "d_CHANGE": dChange.toIso8601String(),
        "c_STATUS": cStatus,
        "reason": reason,
        "deliveryType": deliveryType.toJson(),
        "s_User_ID":sUserId,
        "d_ASSIGN_ORDER":dAssignOrder.toIso8601String()
    };
}

class DeliveryType {
    DeliveryType({
        this.deliveryTypeId,
        this.shortName,
        this.name,
    });

    int deliveryTypeId;
    String shortName;
    String name;

    factory DeliveryType.fromJson(Map<String, dynamic> json) => DeliveryType(
        deliveryTypeId: json["deliveryTypeId"],
        shortName: json["shortName"],
        name: json["name"],
    );

    Map<String, dynamic> toJson() => {
        "deliveryTypeId": deliveryTypeId,
        "shortName": shortName,
        "name": name,
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
