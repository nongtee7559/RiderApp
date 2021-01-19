import 'dart:io';
import 'package:intl/intl.dart';
import 'package:myapp/src/models/Leave2Response.dart';
import 'package:myapp/src/models/bodyNotConfirmOrder.dart';
import 'package:myapp/src/models/client_response.dart';
import 'package:http/http.dart' as http; // show , hide
import 'dart:async';
import 'dart:convert';
import 'package:async/async.dart';
import 'package:http_parser/http_parser.dart';
import 'package:myapp/src/services/Strings.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:myapp/src/utils/globals.dart' as globals;

class NetworkService {
  Future<String> ConvertSlip711(String value) async {
    final uri = Uri.parse(Strings.RootService + '/api/OCR/ConvertSlip711');
    final request = http.MultipartRequest("POST", uri);
    request.headers['Authorization'] = globals.token;
    request.fields['Value'] = value;
    String result;
    final response = await request.send();
    if (response.statusCode == 200) {
      await response.stream.transform(utf8.decoder).listen((value) {
        result = value;
      }).asFuture();
      return result;
    } else {
      throw Exception('Failed to ConvertSlip711');
    }
  }

  Future<String> postDeliveryOrder(
      File imageFile,String value) async {
    final stream =
        http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
    final length = await imageFile.length();
    final multipartFile = http.MultipartFile(
      'UploadFile', // key server
      stream,
      length,
      filename: basename(imageFile.path), // file name
      contentType: MediaType('image', 'png'), // media type
    );
    final uri = Uri.parse(Strings.RootService + '/api/transaction/delivery');
    final request = http.MultipartRequest("POST", uri);
    request.files.add(multipartFile);
    request.headers['Authorization'] = globals.token;
    request.fields['Value'] = value;
    String result;
    final response = await request.send();
    if (response.statusCode == 200) {
      print('xfghjkjhgfdsasf ${result.toString()}');
      return '200';
    }
    if (response.statusCode == 401) {
      print('xfghjkjhgfdsasf ${result.toString()}');
      return '401';
    }
    return '404';
  }

  Future<int> postStartStopWorking(
      File imageFile,  String value) async {
    try{
      final stream =
      http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
      final length = await imageFile.length();
      final multipartFile = http.MultipartFile(
        'UploadFile', // key server
        stream,
        length,
        filename: basename(imageFile.path), // file name
        contentType: MediaType('image', 'png'), // media type
      );
      final uri = Uri.parse(Strings.RootService + '/api/Transaction/timesheet');
      final request = http.MultipartRequest("POST", uri);
      request.files.add(multipartFile);
      request.headers['Authorization'] = globals.token;
      request.fields['Value'] = value;
      String result;
      var response =
      await request.send().timeout(Duration(minutes: 1));
      print('ResponsepostStartStopWorking : ' + response.toString());
      return response.statusCode;
    }on SocketException catch(e){
      return null;
    }on TimeoutException catch (e){
      return null;
    }
  }

  Future<String> postEditProfile(
      File imageFile,String value) async {
    var multipartFile;
    if (imageFile != null) {
      final stream =
          http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
      final length = await imageFile.length();
      multipartFile = http.MultipartFile(
        'UploadFile', // key server
        stream,
        length,
        filename: basename(imageFile.path), // file name
        contentType: MediaType('image', 'png'), // media type
      );
      print('sddcdccdcdcdcdcd');
    } else {}
    print('No Images imageFile');
    final uri = Uri.parse(Strings.RootService + '/api/users/profile');
    final request = http.MultipartRequest("PUT", uri);
    if (imageFile != null) {
      request.files.add(multipartFile);
    } else {}
    request.headers['Authorization'] = globals.token;
    request.fields['Value'] = value;
    String result;
    final response = await request.send();
    if (response.statusCode == 200) {
      return '200';
    }
    if (response.statusCode == 401) {
      print('xfghjkjhgfdsasf ${result.toString()}');
      return '401';
    }
    return '404';
  }

  Future<String> postRegisterPin(String EmpId, String UserId,
      String IMEI, String Pin) async {
    var url = Strings.RootService + '/api/auth/pin';
    print('login postRegisterPin');
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Authorization': globals.token
    };
    var bodys = json.encode({
      'EmpId': EmpId,
      'UserId': UserId,
      'IMEI': IMEI,
      'Pin': Pin,
    });
    var response = await http.post(url, body: bodys, headers: headers);
    print('response postRegisterPin body: ${response.body}');
    if (response.statusCode == 200) {
      print('Response postRegisterPin status: ${response.statusCode}');
      print('Response postRegisterPin body: ${response.body}');
    } else {
//      throw Exception('Failed to Login');
    }
    return response.body;
  }

  Future<String> postCheckLoginPin(String pin, String IMEI,
      String Device, String Serial, String Lat, String Long) async {
    var url = Strings.RootService + '/api/auth/login/pin';
    print('login CheckLoginPin');
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Authorization': globals.token
    };
    var bodys = json.encode({
      'pin': pin,
      'IMEI': IMEI,
      'Device': Device,
      'Serial': Serial,
      'Lat': Lat,
      'Long': Long
    });
    print("bodys CheckLoginPin ${bodys.toString()}");
    var response = await http.post(url, body: bodys, headers: headers);
    print('response CheckLoginPin body: ${response.body}');
    if (response.statusCode == 200) {
      print('Response CheckLoginPin status: ${response.statusCode}');
      print('Response CheckLoginPin body: ${response.body}');
    } else {}
    return response.body;
  }

  Future<String> postcheckpin(String imei, String empId, String userid) async {
    var response;
    try {
      var url = Strings.RootService + '/api/auth/pin/check';
      print('login postcheckpin');
      Map<String, String> headers = {
        'Content-type': 'application/json',
        'Authorization': globals.token
      };
      var bodys = json.encode({'imei': imei, 'empId': empId, 'userid': userid});
      print("bodys postcheckhaspin ${bodys.toString()}");
      response = await http.post(url, body: bodys, headers: headers);
      print('response postcheckpin body: ${response.body}');
      if (response.statusCode == 200) {
        print('Response postcheckpin status: ${response.statusCode}');
        print('Response postcheckpin body: ${response.body}');
      } else {}
    } on Exception catch (exception) {
      print('Exception postcheckpin: ${exception}');
      return exception.toString();
    } catch (error) {
      print('error postcheckpin: ${error}');
    }
    return response.body;
  }

  Future<String> postlogin(String username, String password, String lat,
      String long, String deviceid, String Serial, String IMEI) async {
    var response;
    try {
      var url = Strings.RootService + '/api/auth/login';
      print('login request');
      Map<String, String> headers = {'Content-type': 'application/json'};

      var bodys = json.encode({
        'userId': username,
        'password': password,
        'IMEI': IMEI,
        'Device': deviceid,
        'Serial': Serial,
        'Lat': lat,
        'Long': long
      });
      response = await http.post(url, body: bodys, headers: headers);
      print('response.body: ${response.body}');
      if (response.statusCode == 200) {
        print('Response login status: ${response.statusCode}');
        print('Response login body: ${response.body}');
      }
    } on Exception catch (exception) {
      print('Exception : ${exception}');
      return exception.toString();
    } catch (error) {
      print('error : ${error}');
    }
    return response.body;
  }

  Future<int> PostLeave_Type_Sub(
    String EmpId,
    String EmpLeaveId,
    bool IsConfirm,
    String s_USER_ID,
    String discription,
    String typesubmit,
  ) async {
    var url = Strings.RootService + '/api/employees/leave';
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Authorization': globals.token
    };

    var bodys = json.encode({
      'EmpId': EmpId,
      'EmpLeaveId': EmpLeaveId,
      'IsConfirm': IsConfirm,
      'UserId': s_USER_ID,
      'Reason': discription,
      'ActivityCode': typesubmit,
    });
    print('Json bodys: ${bodys}');

    var response = await http.put(url, body: bodys, headers: headers);
    print('Response bodys1: ${response.body}');

    if (response.statusCode == 200) {
      print('Response PostLeaveType status: ${response.statusCode}');
      print('Response PostLeaveType body: ${response.body}');
    } else {
      //throw Exception('Failed to sum');
    }
    return response.statusCode;
  }

  Future<String> checkPin(String empId, String imei) async {
    var url = Strings.RootService + '/api/auth/pin/check';
//    var response = await http.get(url);
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Authorization': ""
    };

    var bodys = json.encode({'imei': imei, 'empId': empId});
    print('Json bodys: ${bodys}');

    var response = await http.post(url, body: bodys, headers: headers);
    print('Response bodys2: ${response.body}');

    if (response.statusCode == 200) {
      print('Response checkpin status: ${response.statusCode}');
      print('Response checkpin body: ${response.body}');
    } else {
      //throw Exception('Failed to sum');
    }
    return response.body;
  }

  Future<String> PostLeaveType(
      String I_EMP_ID,
      String leaveStartDate,
      String leaveEndDate,
      String leaveStartTime,
      String leaveEndTime,
      String leaveType,
      String leaveGroup,
      String activityType,
      String userId,
      String reason) async {
    var url = Strings.RootService + '/api/employees/leave';
//    var response = await http.get(url);
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Authorization': globals.token
    };

    var bodys = json.encode({
      'empId': I_EMP_ID,
      'leaveStartDate': leaveStartDate,
      'leaveEndDate': leaveEndDate,
      'leaveStartTime': leaveStartTime,
      'leaveEndTime': leaveEndTime,
      'leaveType': leaveType,
      'leaveGroup': leaveGroup,
      'activityType': activityType,
      'userId': userId,
      'reason': reason
    });
    print('Json bodys: ${bodys}');

    var response = await http.post(url, body: bodys, headers: headers);
    print('Response bodys3: ${response.body}');

    if (response.statusCode == 200) {
      print('Response PostLeaveType status: ${response.statusCode}');
      print('Response PostLeaveType body: ${response.body}');
    } else {
      //throw Exception('Failed to sum');
    }
    return response.body;
  }

  Future<String> postsummary( String I_EMP_ID, String S_STORE_NO,
      String D_DO_START, String D_DO_END) async {
    var url = Strings.RootService + '/api/transaction/rider-summary';
//    var response = await http.get(url);
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Authorization': globals.token
    };

    var bodys = json.encode(
        {'empId': I_EMP_ID, 'startDate': D_DO_START, 'endDate': D_DO_END});

    var response = await http.post(url, body: bodys, headers: headers);
//    SummaryResponse responsesummary = SummaryResponse.fromJson(response.body);
    if (response.statusCode == 200) {
      print('Response summary status: ${response.statusCode}');
      print('Response summary body: ${response.body}');
    } else {
      //throw Exception('Failed to sum');
    }
    print('Response summary body: ${response.body}');
    return response.body;
  }

  Future<String> postGetdataDataDetail( String DOH) async {
    var url = Strings.RootService + '/api/order/pending/details';
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Authorization': globals.token
    };
    var bodys = json.encode({'deliveryOrderHeaderId': DOH});
    var response = await http.post(url, body: bodys, headers: headers);
//    SummaryResponse responsesummary = SummaryResponse.fromJson(response.body);
    if (response.statusCode == 200) {
      // print('Response postGetdataDataDetail status: ${response.statusCode}');
      // print('Response postGetdataDataDetail body: ${response.body}');
    } else {
      //throw Exception('Failed to sum');
    }
    // print('Response postGetdataDataDetail body: ${response.body}');
    return response.body;
  }

  Future<String> postGetdataPendingDetail(
       String I_EMP_ID, String DATE_DEL) async {
    var url = Strings.RootService + '/api/Transaction/pending-detail';
//    var response = await http.get(url);
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Authorization': globals.token
    };

    var bodys = json.encode({'empid': I_EMP_ID, 'OrderDate': DATE_DEL});

    var response = await http.post(url, body: bodys, headers: headers);
//    SummaryResponse responsesummary = SummaryResponse.fromJson(response.body);
    if (response.statusCode == 200) {
      print('Response postGetdataPendingDetail status: ${response.statusCode}');
      print('Response postGetdataPendingDetail body: ${response.body}');
    } else {
      //throw Exception('Failed to sum');
    }
    print('Response postGetdataPendingDetail body: ${response.body}');
    return response.body;
  }

  Future<String> postGetTypeLeave() async {
    var url = Strings.RootService + '/api/config/leave-type';
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Authorization': globals.token
    };
    var response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      print('Response postGetTypeLeave status: ${response.statusCode}');
      print('Response postGetTypeLeave body: ${response.body}');
    } else {
      //throw Exception('Failed to sum');
    }
    print('Response postGetTypeLeave body: ${response.body}');
    return response.body;
  }

  Future<String> postGetTypeLeaveFilter() async {
    var url = Strings.RootService + '/api/config/leave-processing';
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Authorization': globals.token
    };
    var response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      print('Response postGetTypeLeaveFilter status: ${response.statusCode}');
      print('Response postGetTypeLeaveFilter body: ${response.body}');
    } else {
      //throw Exception('Failed to sum');
    }
    print('Response postGetTypeLeaveFilter body: ${response.body}');
    return response.body;
  }

  Future<List<EmployeeLeaveAlert>> postGetLeave2data(
      String I_EMP_ID, String _valTypeLeave) async {
    var url;
    if (_valTypeLeave != null) {
      url = Strings.RootService +
          '/api/employees/leave/' +
          I_EMP_ID +
          '/' +
          _valTypeLeave;
    } else {
      url = Strings.RootService + '/api/employees/leave/' + I_EMP_ID;
    }
    print('URL ${url}');
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Authorization': globals.token
    };
    var response = await http.get(url, headers: headers);
    print('Response postGetLeave2data body: ${response.body}');
    final responseJson = jsonDecode(response.body.toString());
    var data = Leave2Response.fromJson(responseJson);
    return data.employeeLeaveAlerts;
  }

  Future<String> postGetdata(
      String I_EMP_ID, String D_DO_START, String D_DO_END) async {
    var url = Strings.RootService + '/api/Transaction/pending-header';
//    var response = await http.get(url);
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Authorization': globals.token
    };

    var bodys = json.encode(
        {'empid': I_EMP_ID, 'startDate': D_DO_START, 'endDate': D_DO_END});

    var response = await http.post(url, body: bodys, headers: headers);
//    SummaryResponse responsesummary = SummaryResponse.fromJson(response.body);
    if (response.statusCode == 200) {
      print('Response postGetdata status: ${response.statusCode}');
      print('Response postGetdata body: ${response.body}');
    } else {
      //throw Exception('Failed to sum');
    }
    print('Response postGetdata body: ${response.body}');
    return response.body;
  }

  Future<String> postGetdataDOH( String I_EMP_ID,
      String ClientCode, String OrderDate) async {
    var url = Strings.RootService + '/api/order/pending/headers/';
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Authorization': globals.token
    };

    var bodys = json.encode({
      'EmpId': I_EMP_ID,
      'ClientCode': ClientCode,
      'DeliveryDate': OrderDate
    });
    var response = await http.post(url, body: bodys, headers: headers);
    return response.body;
  }

  Future<String> postGetdataSumLeave(String I_EMP_ID) async {
    var url = Strings.RootService + '/api/employees/leave/' + I_EMP_ID;
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Authorization': globals.token
    };
    var response = await http.get(url, headers: headers);
    return response.body;
  }

  Future<String> postCheckLocation(
      String I_EMP_ID, String Lat, String Long) async {
    var url = Strings.RootService + '/api/Transaction/GetlocationMapStore';
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Authorization': globals.token
    };
    var bodys = json.encode({'lat': Lat, 'long': Long, 'emp_id': I_EMP_ID});
    var response = await http
        .post(url, body: bodys, headers: headers)
        .timeout(Duration(minutes: 1));
    return response.body;
  }

  Future<String> postUpdateStatusRider(String I_EMP_ID,
      bool isConfirm, String date_Approve, String Reason) async {
    var url = Strings.RootService + '/api/Transaction/pending-header';
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Authorization': globals.token
    };

    var bodys = json.encode({
      'empid': I_EMP_ID,
      'orderDate': date_Approve,
      'isConfirm': isConfirm,
      'reason': Reason
    });
    var response = await http.put(url, body: bodys, headers: headers);
    return response.body;
  }

  Future<String> postUpdateBillStatusRider(
      String clientCode,
      List<int> deliveryOrderHeaderIds,
      String commandName,
      String userId,
      bool isManage,
      bool isNext,
      bool isBack,
      String manageStatus,
      int reason) async {
    var url = Strings.RootService + '/api/order/process/';
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Authorization': globals.token
    };

    var bodys = json.encode({
      'ClientCode': clientCode,
      'DeliveryOrderHeaderIds': deliveryOrderHeaderIds,
      'CommandName': commandName,
      'UserId': userId,
      'IsManage': isManage,
      'IsNext': isNext,
      'IsBack': isBack,
      'ManageStatus': manageStatus,
      'Reason': reason
    });
    var response = await http.post(url, body: bodys, headers: headers);
    return response.body;
  }

  Future<String> postCheckStatusSubstitute(
      String I_EMP_ID, String END_DATE) async {
    var url = Strings.RootService + '/api/assign/check/wait';
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Authorization': globals.token
    };
    var bodys = json.encode({
      'EmpId': I_EMP_ID,
      'StartAssignDate': DateFormat('yyyy-MM-dd').format(DateTime.now()),
      'EndAssignDate': END_DATE
    });
    print('CheckStatusSubstitute Json bodys: ${bodys}');
    var response = await http.post(url, body: bodys, headers: headers);
    return response.body;
  }

  Future<dynamic> PostRiderApproveReady(
      String I_EMP_ID, String Date, String storeNo, String stId) async {
    var url = Strings.RootService + '/api/assign/confirm';
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Authorization': globals.token
    };

    var bodys = json.encode({'EmpId': I_EMP_ID, 'AssignDate': Date,'storeNo':storeNo,'stId':stId});
    var response = await http.put(url, body: bodys, headers: headers);
    return response.body;
  }

  Future<List<ClientData>> GetDataClient() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final responseJson = jsonDecode(
        '{"clients":' + prefs.getString('clientList') + '}'.toString());
    var data = ClientsRespose.fromJson(responseJson);
    return data.clients;
  }

  Future<String> PostMasterDropdownList(
      String table, String groupReason, {String storeNo = "", String date = ""}) async {
    var url = Strings.RootService + '/api/master/dropdownlist';
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Authorization': globals.token
    };
    var bodys = json.encode({'table': table, 'groupReason': groupReason,'StoreNo':storeNo,'Date':date});
    print(bodys);
    var response = await http.post(url, body: bodys, headers: headers);
    return response.body;
  }

  Future<String> postUpdateNotConfirmBillRider(
      BodyNotConfirmOrder bodys) async {
    var url = Strings.RootService + '/api/order/rider/notconfirmorder';
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Authorization': globals.token
    };
    var body = json.encode(bodys);
    var response = await http.post(url, body: body, headers: headers);
    return response.body;
  }

  Future PostPayfeeCalulate(
      String companyCode, int headerId) async {
    var url = Strings.RootService + '/api/Transaction/calulate/payfee';
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Authorization': globals.token
    };
    var bodys = json.encode({'companyCode': companyCode, 'headerId': headerId});
    await http.post(url, body: bodys, headers: headers);
  }

  Future<String> PostAssignDailyPlan(
      int empId, DateTime dPlan) async {
    var url = Strings.RootService + '/api/employees/rider/assignplan';
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Authorization': globals.token
    };
    var bodys = json.encode({'empId': empId, 'dPlan': dPlan.toIso8601String()});
    var response = await http.post(url, body: bodys, headers: headers);
    return response.body;
  }

  Future<String> GetCheckAppVersion(String version) async
  {
    var url = Strings.RootService + '/api/config/app/'+ version;
    Map<String, String> headers = {
      'Content-type': 'application/json',
    };
    var response = await http.get(url, headers: headers);
    return response.body;
  }
}
