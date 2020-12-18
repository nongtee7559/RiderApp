import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:myapp/src/models/Leave2Response.dart';
import 'package:myapp/src/models/Model_Store.dart';
import 'package:myapp/src/pages/launcher.dart';
import 'package:myapp/src/services/Strings.dart';
import 'package:myapp/src/services/network_service.dart';
import 'package:myapp/src/themes/login_theme.dart';
import 'package:myapp/src/themes/main_theme.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:myapp/src/utils/globals.dart' as globals;

ProgressDialog pr;

class LeaveApprove extends StatefulWidget {
  static const routeName = '/LeaveApprove';

  @override
  State<StatefulWidget> createState() {
    return _LeaveApproveState();
  }
}

class _LeaveApproveState extends State<LeaveApprove> {
  int currentIndex = 0;
  NetworkService networkService;
  String _valTypeLeave;
  String _valStore;
  File _imageFileprofile;
  bool Directory_Path1;
  var logger = Logger();
  List Model_Store = [];
  List data = List(); //edited line
  List data1 = List(); //edited line
  String radioItem = 'Delivery Type';
  String radioItemType = 'WA';
  String extractText = '';
  String statusLeave = 'LG01';
  String typesubmit = '';
  final taxnoController = TextEditingController();
  final receiptNoController = TextEditingController();
  final datetimeEndController = TextEditingController();
  final datetimeStartController = TextEditingController();
  final discriptionController = TextEditingController();
  final textFieldDialogController = TextEditingController();
  final SumPriceController = TextEditingController();
  final StoreController = TextEditingController();
  final datePre = TextEditingController();
  final timePre = TextEditingController();
  final format = DateFormat("dd/MM/yyyy HH:mm");
  final formatTime = DateFormat("HH:mm");
  var txt_name = '';
  var EmpLeaveId = '';
  bool IsConfirm;
  var txt_phone = '';
  var date_start = DateTime.now();
  var date_end = DateTime.now();
  var time_start = '';
  var time_end = '';
  var leave_Type = '';
  var leave_Group = '';
  var reason = '';
  var processing = '';
  var _data = null;
  List<ModelStore> StoreList = [];
  var datestartService = null;
  var dateendService = null;
  var datestart = null;
  var timestart = null;
  var dateend = null;
  var timeend = null;
  @override
  void initState() {
    _buildProfile();
    networkService = NetworkService();
    super.initState();
  }

  int id = 1;
  @override
  void setState(fn) {
    if(mounted) {
      super.setState(fn);
    }
  }
  @override
  Widget build(BuildContext context) {
    pr = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false, showLogs: false);
    pr.style(message: 'Please wait...');
    return Scaffold(
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(gradient: MainTheme.gradient),
        child: new Theme(
          data: Theme.of(context).copyWith(
            canvasColor: MainTheme.HomeendTripColor,
          ),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Card(
                  margin:
                      EdgeInsets.only(left: 10, right: 10, top: 15, bottom: 18),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 13, right: 13, top: 22, bottom: 40),
                    child: Column(
                      children: <Widget>[
                        Text(
                          'ข้อมูลการลา',
                          style: new TextStyle(
                              fontSize: 24,
                              color: Colors.black87,
//                                  fontWeight: FontWeight.w200,
                              fontFamily: 'KanitRegular'),
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                Strings.txt_name_user + ' : ',
                                style: new TextStyle(
                                    fontSize: 18,
                                    color: Colors.black87,
                                    fontFamily: 'KanitRegular'),
                              ),
                              Text(
                                txt_name,
                                style: new TextStyle(
                                    fontSize: 18,
                                    color: Colors.black87,
//                                  fontWeight: FontWeight.w200,
                                    fontFamily: 'KanitRegular'),
                              ),
                            ]),
                        SizedBox(height: 15),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'รหัสร้าน : ',
                                style: new TextStyle(
                                    fontSize: 18,
                                    color: Colors.black87,
//                                  fontWeight: FontWeight.w200,
                                    fontFamily: 'KanitRegular'),
                              ),
                              DropdownButton(
                                hint: Text(_valStore != null ? _valStore : ''),
                                value: _valStore,
                                items: data.map((value) {
                                  return DropdownMenuItem(
                                    child: Text(
                                      value,
                                      style: new TextStyle(
                                          fontSize: 18,
                                          color: Colors.black87,
                                          fontFamily: 'KanitRegular'),
                                    ),
                                    value: value,
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _valStore =
                                        value; //Untuk memberitahu _valTypeLeave bahwa isi nya akan diubah sesuai dengan value yang kita pilih
                                    print('_valTypeLeave : ${_valStore}');
                                  });
                                },
                              ),
                            ]),
                        SizedBox(height: 15),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'เบอร์โทร  :  ',
                                style: new TextStyle(
                                    fontSize: 18,
                                    color: Colors.black87,
//                                  fontWeight: FontWeight.w200,
                                    fontFamily: 'KanitRegular'),
                              ),
                              Text(
                                txt_phone,
                                style: new TextStyle(
                                    fontSize: 18,
                                    color: Colors.black87,
                                    fontFamily: 'KanitRegular'),
                              ),
                            ]),
                        SizedBox(height: 15),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'วันที่ลา : ',
                                style: new TextStyle(
                                    fontSize: 18,
                                    color: Colors.black87,
                                    fontFamily: 'KanitRegular'),
                              ),
                              Text(
                                date_start.toString() != date_end.toString()
                                    ? DateFormat('dd/MM/yyyy')
                                        .format(date_start)
                                        .toString()
                                    : DateFormat('dd/MM/yyyy')
                                        .format(date_start)
                                        .toString(),
                                style: new TextStyle(
                                    fontSize: 18,
                                    color: Colors.black87,
//                                  fontWeight: FontWeight.w200,
                                    fontFamily: 'KanitRegular'),
                              ),
                            ]),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                '    ถึง : ',
                                style: new TextStyle(
                                    fontSize: 18,
                                    color: Colors.black87,
//                                  fontWeight: FontWeight.w200,
                                    fontFamily: 'KanitRegular'),
                              ),
                              Text(
                                date_start.toString() != date_end.toString()
                                    ? DateFormat('dd/MM/yyyy')
                                        .format(date_end)
                                        .toString()
                                    : DateFormat('dd/MM/yyyy')
                                        .format(date_end)
                                        .toString(),
                                style: new TextStyle(
                                    fontSize: 18,
                                    color: Colors.black87,
                                    fontFamily: 'KanitRegular'),
                              ),
                            ]),
                        SizedBox(height: 15),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'เวลา : ',
                                style: new TextStyle(
                                    fontSize: 18,
                                    color: Colors.black87,
                                    fontFamily: 'KanitRegular'),
                              ),
                              Text(
                                time_start.toString() == time_end.toString()
                                    ? time_start.toString()
                                    : time_start.toString() +
                                        ' ถึง ' +
                                        time_end.toString(),
//                              date_start.toString(),
                                style: new TextStyle(
                                    fontSize: 18,
                                    color: Colors.black87,
                                    fontFamily: 'KanitRegular'),
                              ),
                            ]),
                        SizedBox(height: 15),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'ประเภทที่ลา : ',
                                style: new TextStyle(
                                    fontSize: 18,
                                    color: Colors.black87,
                                    fontFamily: 'KanitRegular'),
                              ),
                              Text(
                                leave_Type.toString(),
                                style: new TextStyle(
                                    fontSize: 18,
                                    color: Colors.black87,
                                    fontFamily: 'KanitRegular'),
                              ),
                            ]),
                        SizedBox(height: 15),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'หมายเหตุ',
                                style: new TextStyle(
                                    fontSize: 18,
                                    color: Colors.black87,
//                                  fontWeight: FontWeight.w200,
                                    fontFamily: 'KanitRegular'),
                              ),
                            ]),
                        Text(
                          reason.toString(),
                          style: new TextStyle(
                              fontSize: 18,
                              color: Colors.black87,
                              fontFamily: 'KanitRegular'),
                        ),
                        SizedBox(height: 10),
                        SizedBox(height: 60),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Column(children: <Widget>[
                                processing == "02" ||
                                        processing == "03" ||
                                        processing == "99"
                                    ? SizedBox()
                                    : _buildBtnSubmit(context),
                                processing == "02" &&
                                        globals.s_EMP_TYPE == 'ET04'
                                    ? _buildBtnSubmit(context)
                                    : SizedBox(),
                              ]),
                              SizedBox(width: 5),
                              Column(children: <Widget>[
                                processing == "02" ||
                                        processing == "03" ||
                                        processing == "99"
                                    ? processing == "02" &&
                                    globals.s_EMP_TYPE != 'ET04'
                                        ? _buildBtncancle(context)
                                        : SizedBox()
                                    : _buildBtncancle(context),
                                processing == "02" &&
                                    globals.s_EMP_TYPE == 'ET04'
                                    ? _buildBtncancle(context)
                                    : SizedBox(),
                              ]),
                            ]),
                        SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showDialogAcceap(String message) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          content: Text(message),
          actions: <Widget>[
            FlatButton(
              child: Text('ตกลง'),
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Dismiss alert dialog
              },
            ),
          ],
        );
      },
    );
  }

  void showDialogInvid(String message) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          content: Text(message),
          actions: <Widget>[
            FlatButton(
              child: Text('ตกลง'),
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Dismiss alert dialog
                if (message != "กรุณากรอกข้อมูลให้ครบถ้วน") {
                  final BottomNavigationBar navigationBar =
                      navBarGlobalKey.currentWidget;
                  navigationBar.onTap(0);
                }
              },
            ),
          ],
        );
      },
    );
  }

  Stack _buildBtnSubmit(BuildContext context) {
    return Stack(
      overflow: Overflow.visible,
      alignment: Alignment.bottomCenter,
      children: <Widget>[
        Container(
          width: 150,
          height: 45,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            gradient: LinearGradient(
              colors: [
                globals.s_EMP_TYPE != ''
                    ? LoginTheme.btnSubmit
                    : LoginTheme.btncolor,
                globals.s_EMP_TYPE != ''
                    ? LoginTheme.btnSubmit
                    : LoginTheme.btncolor,
              ],
            ),
          ),
          child: FlatButton(
            textColor: Colors.white,
            child: Text(
              Strings.btn_Submit,
              style: TextStyle(fontSize: 22, fontFamily: 'KanitRegular'),
            ),
            onPressed: () async {
              IsConfirm = true;
              typesubmit = 'AC01';
              _displayDialog(context);
              print('click Upload');
            },
          ),
        ),
      ],
    );
  }

  Stack _buildBtncancle(BuildContext context) {
    return Stack(
      overflow: Overflow.visible,
      alignment: Alignment.bottomCenter,
      children: <Widget>[
        Container(
          width: 150,
          height: 45,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            gradient: LinearGradient(
              colors: [
                globals.s_EMP_TYPE != ''
                    ? LoginTheme.btncancel
                    : LoginTheme.btncolor,
                globals.s_EMP_TYPE != ''
                    ? LoginTheme.btncancel
                    : LoginTheme.btncolor,
              ],
            ),
          ),
          child: FlatButton(
            textColor: Colors.white,
            child: Text(
              Strings.btn_Cancel,
              style: TextStyle(fontSize: 22, fontFamily: 'KanitRegular'),
            ),
            onPressed: () async {},
          ),
        ),
        Container(
          width: 150,
          height: 45,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            gradient: LinearGradient(
              colors: [
                globals.s_EMP_TYPE != ''
                    ? LoginTheme.btncancel
                    : LoginTheme.btncolor,
                globals.s_EMP_TYPE != ''
                    ? LoginTheme.btncancel
                    : LoginTheme.btncolor,
              ],
            ),
          ),
          child: FlatButton(
            textColor: Colors.white,
            child: Text(
              "ยกเลิก",
              style: TextStyle(fontSize: 22, fontFamily: 'KanitRegular'),
            ),
            onPressed: () async {
              print('Click Cancel');
              IsConfirm = false;
              typesubmit = 'AC02';
              _displayDialog(context);
            },
          ),
        ),
      ],
    );
  }

  _displayDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('กรุณาระบุเหตุผล'),
            content: TextField(
              minLines: 5,
              maxLines: 5,
              autocorrect: false,
              controller: textFieldDialogController,
              decoration: InputDecoration(
                filled: true,
                fillColor: MainTheme.nearlyWhite,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text('ยกเลิก'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              new FlatButton(
                child: new Text('ตกลง'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  await pr.show();
                  await _buildPostLeave_Type();
                  await pr.hide();
                },
              )
            ],
          );
        });
  }

  Future<void> _buildProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    datePre.text = DateFormat('dd/MM/yyyy').format(DateTime.now()).toString();
    timePre.text = DateFormat('hh:mm:ss').format(DateTime.now()).toString();
    var datalist = await prefs.getString('data_to_LeaveApprove');
    final responseJson = jsonDecode(datalist.toString());
    _data = EmployeeLeaveAlert.fromJson(responseJson);
    txt_name = _data.name.toString();
    txt_phone = _data.phoneNo.toString();
    date_start = _data.leaveStartDate;
    date_end = _data.leaveEndDate;
    time_start = _data.leaveStartTime.toString();
    time_end = _data.leaveEndTime.toString();
    leave_Type = _data.leaveTypeDescription.toString();
    leave_Group = _data.leaveGroupDescription.toString();
    reason = _data.reason.toString();
    processing = _data.processing.toString();
    EmpLeaveId = _data.empLeaveId.toString();
    setState(() {
      data = _data.stores;
      _valStore = _data.stores[0];
    });
  }

  Future<void> _buildPostLeave_Type() async {
    var discription = textFieldDialogController.text;
    NetworkService()
        .PostLeave_Type_Sub(
      globals.i_EMP_ID,
      EmpLeaveId,
      IsConfirm,
      globals.s_User_ID,
      discription,
      typesubmit,
    )
        .then(
      (value) async {
        if (200 == value) {
          showDialogInvid('ดำเนินการเสร็จสิ้น');
        } else {
          showDialogInvid('$value พบข้อผิดพลาดกรุณาลองใหม่อีกครั้ง');
        }
        return Center(
          child: RefreshProgressIndicator(),
        );
      },
    );
  }
}

class DeliveryTypeList {
  String name;
  String value;
  int index;

  DeliveryTypeList({this.name, this.index, this.value});
}

class Datareq {
  String S_STORE_NO;
  DateTime D_DO;
  DateTime D_DELIVERY;
  String S_DELIVERY_TYPE;
  String S_RECEIPT_ID;
  Double F_TOTAL_AMOUNT;
  int I_EMP_ID;

  Datareq(
      {this.S_STORE_NO,
      this.D_DO,
      this.D_DELIVERY,
      this.S_DELIVERY_TYPE,
      this.S_RECEIPT_ID,
      this.F_TOTAL_AMOUNT,
      this.I_EMP_ID});
}
