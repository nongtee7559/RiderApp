import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:logger/logger.dart';
import 'package:myapp/src/models/Model_Store.dart';
import 'package:myapp/src/pages/launcher.dart';
import 'package:myapp/src/services/Strings.dart';
import 'package:myapp/src/services/network_service.dart';
import 'package:myapp/src/themes/login_theme.dart';
import 'package:myapp/src/themes/main_theme.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart' as p;
import 'package:myapp/src/utils/globals.dart' as globals;

ProgressDialog pr;

class RiderApproveReady extends StatefulWidget {
  static const routeName = '/RiderApproveReady';

  @override
  State<StatefulWidget> createState() {
    return _RiderApproveReady();
  }
}

class _RiderApproveReady extends State<RiderApproveReady> {
  int currentIndex = 0;
  int _counter = 0;
  NetworkService networkService;
  String _valFriends;
  List data = List(); //edited line
  var datestart = null;
  final format = DateFormat("dd/MM/yyyy");
  final datePre = TextEditingController();
  final timePre = TextEditingController();
  var datestartService = null;
  bool StatusReplace = false;
  var timestart = null;
  List<ModelStore> StoreList = [];


  void initState() {
    networkService = NetworkService();
    DateTime now1 = DateTime.now();
    final now = DateTime(now1.year, now1.month, now1.day + 1);
    String datestart1 = DateFormat('yyyy-MM-dd').format(now);
//    String datestartplus = datestart1+' 08:00';
    datestart = DateTime.parse(datestart1);
    datePre.text = DateFormat('dd/MM/yyyy').format(DateTime.now()).toString();
    timePre.text = DateFormat('kk:mm:ss').format(DateTime.now()).toString();
    _buildCheckStatusSubstitute(datestart1);
    super.initState();
  }

  // Group Value for Radio Button.
  int id = 1;
  ValueNotifier<DateTime> _dateTimeNotifier =
  ValueNotifier<DateTime>(DateTime.now());

  @override
  Widget build(BuildContext context) {
//    pr = new ProgressDialog(context);
    pr = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false, showLogs: false);
    pr.style(message: 'Please wait...');

    return Scaffold(
//    appBar: AppBar(
//        title: Text('Register Order'),
//      ),
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(gradient: MainTheme.gradient),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Card(
                margin:
                EdgeInsets.only(left: 15, right: 15, top: 150, bottom: 18),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 22, right: 22, top: 40, bottom: 40),
                  child: Column(
                    children: <Widget>[
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            new Text(
                              "ยืนยันความพร้อมวิ่งประจำวันที่",
                              style: new TextStyle(
                                  fontSize: 18,
                                  color: Colors.black87,
//                                  fontWeight: FontWeight.w200,
                                  fontFamily: 'KanitRegular'),
                            ),
                          ]),
                      Column(children: <Widget>[
                        _buildDatePickerStart(context, _dateTimeNotifier),
                      ]),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 150),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
//                            SizedBox(height: 20),

                    Column(children: <Widget>[
                      _buildBtnSubmit(context),
                    ]),

                    SizedBox(width: 16),
                    Column(children: <Widget>[
                      _buildBtncancle(context),
                    ]),
                  ]),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  void showDialogAcceap(String message) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      // false = user must tap button, true = tap outside dialog
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          content: Text(message),
          actions: <Widget>[
            FlatButton(
              child: Text('ตกลง'),
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Dismiss alert dialog

//                Navigator.pushReplacementNamed(context, Constant.HOME_ROUTE);
              },
            ),
          ],
        );
      },
    );
  }

  Column _buildDatePickerStart(
      BuildContext context, ValueNotifier<DateTime> _dateTimeNotifier) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        DateTimeField(
          format: format,
          initialValue: datestart,
          //Add this in your Code.
          decoration: InputDecoration(labelText: Strings.txt_date),
          style: TextStyle(
              fontSize: 17, fontFamily: 'KanitRegular', color: Colors.black87),

          onShowPicker: (context, currentValue) async {
            datestart = await showDatePicker(
              context: context,
              firstDate: DateTime(DateTime.now().year, DateTime.now().month,
                  DateTime.now().day),
              initialDate: _dateTimeNotifier.value ?? DateTime.now(),
              lastDate: DateTime(DateTime.now().year, DateTime.now().month,
                  DateTime.now().day + 1),
            ).then((DateTime dateTime) => _dateTimeNotifier.value = dateTime);

            if (datestart != null) {
              setState(() {
                DateTimeField.combine(datestart, timestart);
                _buildCheckStatusSubstitute(DateFormat('yyyy-MM-dd')
                    .format(DateTimeField.combine(datestart, timestart)));
              });
              datestartService =
                  DateTimeField.combine(datestart, timestart).toIso8601String();
              return DateTimeField.combine(datestart, timestart);
            } else {
              return currentValue;
            }
          },
        ),
      ],
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
                LoginTheme.btnSubmit,
                LoginTheme.btnSubmit,
              ],
            ),
          ),
          child: FlatButton(
            textColor: Colors.white,
            child: Text(
              "ยืนยัน",
              style: TextStyle(fontSize: 22, fontFamily: 'KanitRegular'),
            ),
            onPressed: () async {
              if (StatusReplace) {
                final datestart1 = datestartService == null
                    ? datestart.toString()
                    : datestartService.toString();
                final date_start =
                DateFormat('yyyy-MM-dd').format(DateTime.parse(datestart1));

                if (date_start != null && datestart != null) {
                  pr.show();
                  _PostRiderApproveReady(date_start);
                  print('click Upload');
                } else {
                  print('ข้อมูลไม่ครบ');
                  showDialogInvid('กรุณากรอกข้อมูลให้ครบถ้วน');
                }
              } else {
                showDialogInvid('สถานะของท่านไม่สามารถยืนยันความพร้อมได้');
              }
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
                LoginTheme.btncancel,
                LoginTheme.btncancel,
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
              Navigator.of(context).pushReplacement(
                  new MaterialPageRoute(builder: (context) => Launcher()));
            },
          ),
        ),
      ],
    );
  }
  Future<void> _buildCheckStatusSubstitute(String date) async {
    try {
      NetworkService()
          .postCheckStatusSubstitute(
          globals.i_EMP_ID, date)
          .then(
            (value) async {
          var json = jsonDecode(value);
          var errorMessage = json['errorMessage'];

          if (errorMessage['isError'] == false) {
            setState(() {
              StatusReplace = json['isWait'];
            });
          } else {
            showDialogInvid(errorMessage['errorText']);
          }
          return Center(
            child: RefreshProgressIndicator(),
          );
        },
      );
    } catch (e) {
      showDialogInvid(e.toString());
    }
  }

  Future<void> _PostRiderApproveReady(String now) async {
    // pr.update(message: "กำลังบันทึกข้อมูล...");
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // try {
    //   NetworkService()
    //       .PostRiderApproveReady(globals.i_EMP_ID, now)
    //       .then(
    //     (value) async {
    //       print('response PostRiderApproveReady : ${value}');
    //       pr.hide();
    //       if (value == 200) {
    //         showDialogInvid('ดำเนินการเสร็จสิ้น');
    //       } else {
    //         showDialogInvid('พบข้อผิดพลาด : $value');
    //       }
    //
    //       return Center(
    //         child: RefreshProgressIndicator(),
    //       );
    //     },
    //   );
    // } catch (e) {
    //   pr.hide();
    //   showDialogInvid(e.toString());
    // }
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
                pr.hide();
                Navigator.of(dialogContext).pop(); // Dismiss alert dialog
                final BottomNavigationBar navigationBar =
                    navBarGlobalKey.currentWidget;
                navigationBar.onTap(0);
//                Navigator.of(context).pushReplacement(
//                    new MaterialPageRoute(builder: (context) => MyApp()));
              },
            ),
          ],
        );
      },
    );
  }
}
