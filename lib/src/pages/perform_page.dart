import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myapp/src/models/Leave2Response.dart';
import 'package:myapp/src/models/DeliveryOrderHeaders_Response.dart';
import 'package:myapp/src/services/Strings.dart';
import 'package:myapp/src/services/network_service.dart';
import 'package:myapp/src/themes/login_theme.dart';
import 'package:myapp/src/themes/main_theme.dart';
import 'package:myapp/src/utils/Constant.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'launcher.dart';
import 'package:myapp/src/utils/globals.dart' as globals;

ProgressDialog pr;

class Perform extends StatefulWidget {
  static const routeName = '/perform';

  @override
  State<StatefulWidget> createState() {
    return _PerformState();
  }
}

class _PerformState extends State<Perform> {
  bool isAscending = true;
  NetworkService networkService;
  final txtSumPending = TextEditingController();
  final txtSumLeaveAlert = TextEditingController();

  void initState() {
    networkService = NetworkService();
    txtSumPending.text = '0';
    txtSumLeaveAlert.text = '0';
    _buildGetdata();
    _buildGetdataLeave();
    super.initState();
  }
  @override
  void setState(fn) {
    if(mounted) {
      super.setState(fn);
    }
  }
  @override
  Widget build(BuildContext context) {
    pr = new ProgressDialog(context);
    pr.style(message: 'Please wait...');
    return Scaffold(
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(gradient: MainTheme.gradient),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(height: 15),
              if (globals.isRider)
                Card(
                  color: Constant.BG_WHITE_COLOR,
                  margin: EdgeInsets.only(
                      left: 10, right: 10, top: 0, bottom: 10),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0)),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 22, right: 22, top: 22, bottom: 22),
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              height: 85,
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                                gradient: LinearGradient(
                                  colors: [
                                    LoginTheme.LoginendColor,
                                    LoginTheme.LoginbeginColor,
                                  ],
                                ),
                              ),
                              child: new Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  new FlatButton(
                                    onPressed: () {
                                      final BottomNavigationBar
                                          navigationBar =
                                          navBarGlobalKey.currentWidget;
                                      navigationBar.onTap(3);
                                    },
                                    child: new Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        txtSumPending.text == '0'
                                            ? myAppBarIconZero()
                                            : myAppBarIcon(),
                                        new Text(
                                          globals.employeeType == 'Supplier'
                                              ? '     ข้อมูลความพร้อม Rider   '
                                              : '   กดยืนยันงานที่คุณทำเมื่อวาน',
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.white,
                                              fontFamily: 'KanitRegular'),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              height: 84,
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                                gradient: LinearGradient(
                                  colors: [
                                    LoginTheme.LoginendColor,
                                    LoginTheme.LoginbeginColor,
                                  ],
                                ),
                              ),
                              child: new Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  new FlatButton(
                                    onPressed: () {
                                      final BottomNavigationBar
                                          navigationBar =
                                          navBarGlobalKey.currentWidget;
                                      navigationBar.onTap(4);
                                    },
                                    child: new Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        new Icon(Icons.timer,
                                            color: Colors.white, size: 36),
                                        SizedBox(width: 30),
                                        new Text(
                                          '  ลงเวลา                 ',
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.white,
                                              fontFamily: 'KanitRegular'),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
//                            width: 320,
                              height: 84,
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                                gradient: LinearGradient(
                                  colors: [
                                    LoginTheme.LoginendColor,
                                    LoginTheme.LoginbeginColor,
                                  ],
                                ),
                              ),
                              child: new Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  new FlatButton(
                                    onPressed: () {
                                      final BottomNavigationBar
                                          navigationBar =
                                          navBarGlobalKey.currentWidget;
                                      navigationBar.onTap(7);
                                    },
                                    child: new Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        txtSumLeaveAlert.text == '0'
                                            ? IconAlertZero()
                                            : IconAlert(),
                                        SizedBox(width: 30),
                                        new Text(
                                          globals.employeeType == 'Supplier'
                                              ? 'ยืนยันใบลาของ Rider   '
                                              : '   ตรวจสอบสถานะใบลา   ',
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.white,
                                              fontFamily: 'KanitRegular'),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
//                            width: 320,
                              height: 84,
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                                gradient: LinearGradient(
                                  colors: [
                                    LoginTheme.LoginendColor,
                                    LoginTheme.LoginbeginColor,
                                  ],
                                ),
                              ),
                              child: new Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  new FlatButton(
                                    onPressed: () {
                                      final BottomNavigationBar
                                          navigationBar =
                                          navBarGlobalKey.currentWidget;
                                      navigationBar.onTap(6);
                                    },
                                    child: new Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        new Icon(Icons.edit,
                                            color: Colors.white, size: 36),
                                        SizedBox(width: 30),
                                        new Text(
                                          ' ' +
                                              Strings.txt_savetime +
                                              '            ',
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.white,
                                              fontFamily: 'KanitRegular'),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              if (globals.isSup)
                Card(
                  color: Constant.BG_WHITE_COLOR,
                  margin: EdgeInsets.only(
                      left: 10, right: 10, top: 0, bottom: 10),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0)),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 22, right: 22, top: 22, bottom: 22),
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
//                width: 320,
                              height: 85,
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                                gradient: LinearGradient(
                                  colors: [
                                    LoginTheme.LoginendColor,
                                    LoginTheme.LoginbeginColor,
                                  ],
                                ),
                              ),
                              child: new Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  new FlatButton(
                                    onPressed: () {
                                      final BottomNavigationBar
                                          navigationBar =
                                          navBarGlobalKey.currentWidget;
                                      navigationBar.onTap(3);
                                    },
                                    child: new Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        txtSumPending.text == '0'
                                            ? myAppBarIconZero()
                                            : myAppBarIcon(),
                                        new Text(
                                          globals.employeeType == 'Supplier'
                                              ? '     ข้อมูลความพร้อม Rider   '
                                              : '   กดยืนยันงานที่คุณทำเมื่อวาน',
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.white,
                                              fontFamily: 'KanitRegular'),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
//                            width: 320,
                              height: 84,
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                                gradient: LinearGradient(
                                  colors: [
                                    LoginTheme.LoginendColor,
                                    LoginTheme.LoginbeginColor,
                                  ],
                                ),
                              ),
                              child: new Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  new FlatButton(
                                    onPressed: () {
                                      final BottomNavigationBar
                                          navigationBar =
                                          navBarGlobalKey.currentWidget;
                                      navigationBar.onTap(7);
                                    },
                                    child: new Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        txtSumLeaveAlert.text == '0'
                                            ? IconAlertZero()
                                            : IconAlert(),
                                        SizedBox(width: 30),
                                        new Text(
                                          globals.employeeType == 'Supplier'
                                              ? 'ยืนยันใบลาของ Rider   '
                                              : 'ตรวจสอบสถานะใบลา   ',
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.white,
                                              fontFamily: 'KanitRegular'),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget IconAlert() {
    return Container(
      width: 20,
      height: 33,
      child: Stack(
        children: [
          Icon(
            Icons.date_range,
            color: Colors.white,
            size: 40,
          ),
          Container(
            width: 40,
            height: 40,
            alignment: Alignment.topRight,
            margin: EdgeInsets.only(top: 2),
            child: Container(
              width: 45,
              height: 25,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xffc32c37),
                  border: Border.all(color: Colors.white, width: 1)),
              child: Padding(
                padding: const EdgeInsets.all(0.0),
                child: Center(
                  child: Text(
                    txtSumLeaveAlert.text,
                    style: TextStyle(fontSize: 10, color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _buildGetdataLeave() async {
    await NetworkService().postGetdataSumLeave(globals.i_EMP_ID).then(
      (value) async {
        var json = jsonDecode(value);
        var errorMessage = json['errorMessage'];
        if (errorMessage['isError'] == false) {
          final responseJson = jsonDecode(value.toString());
          var EmployeeAlert = Leave2Response.fromJson(responseJson);
          if (EmployeeAlert.employeeLeaveAlerts.isEmpty) {
          } else {
            txtSumLeaveAlert.text =
                EmployeeAlert.employeeLeaveAlerts.length.toString();
          }
          setState(() {
            return Center(
              child: RefreshProgressIndicator(),
            );
          });
        } else {
          showDialogInvid(errorMessage['errorText']);
        }
        return Center(
          child: RefreshProgressIndicator(),
        );
      },
    );
  }

  Widget IconAlertZero() {
    return Container(
      width: 20,
      height: 33,
      child: Stack(
        children: [
          Icon(
            Icons.date_range,
            color: Colors.white,
            size: 40,
          ),
          Container(
            width: 40,
            height: 40,
            alignment: Alignment.topRight,
            margin: EdgeInsets.only(top: 2),
            child: Container(
              width: 45,
              height: 25,
            ),
          ),
        ],
      ),
    );
  }

  Widget myAppBarIcon() {
    return Container(
      width: 25,
      height: 33,
      child: Stack(
        children: [
          Icon(
            Icons.notifications,
            color: Colors.white,
            size: 40,
          ),
          Container(
            width: 40,
            height: 40,
            alignment: Alignment.topRight,
            margin: EdgeInsets.only(top: 2),
            child: Container(
              width: 45,
              height: 25,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xffc32c37),
                  border: Border.all(color: Colors.white, width: 1)),
              child: Padding(
                padding: const EdgeInsets.all(0.0),
                child: Center(
                  child: Text(
                    txtSumPending.text,
                    style: TextStyle(
                        fontSize: 10,
                        color: Colors.white,
                        fontFamily: 'KanitRegular'),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget myAppBarIconZero() {
    return Container(
      width: 20,
      height: 33,
      child: Stack(
        children: [
          Icon(
            Icons.notifications,
            color: Colors.white,
            size: 40,
          ),
          Container(
            width: 40,
            height: 40,
            alignment: Alignment.topRight,
            margin: EdgeInsets.only(top: 2),
            child: Container(
              width: 45,
              height: 25,
            ),
          ),
        ],
      ),
    );
  }

  void showDialogInvid(String message) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      // false = user must tap button, true = tap outside dialog
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(''),
          content: Text(message),
          actions: <Widget>[
            FlatButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Dismiss alert dialog
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _buildGetdata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var client = prefs.getString('Client');
    await NetworkService().postGetdataDOH(globals.i_EMP_ID, client, '').then(
      (value) async {
        var json = jsonDecode(value);
        var errorMessage = json['errorMessage'];
        if (errorMessage['isError'] == false) {
          final responseJson = jsonDecode(value.toString());
          var data = DeliveryOrderHeaderResponse.fromJson(responseJson);
          if (data.deliveryOrderHeaders.length == 0) {
          } else {
            txtSumPending.text = data.deliveryOrderHeaders.length.toString();
          }
          setState(() {
            return Center(
              child: RefreshProgressIndicator(),
            );
          });
        } else {
          showDialogInvid(errorMessage['errorText']);
        }
        return Center(
          child: RefreshProgressIndicator(),
        );
      },
    );
  }
}
