import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:intl/intl.dart';
import 'package:myapp/src/models/Leave2Response.dart';
import 'package:myapp/src/models/DeliveryOrderHeaders_Response.dart';
import 'package:myapp/src/models/summary_response.dart';
import 'package:myapp/src/pages/launcher.dart';
import 'package:myapp/src/services/Strings.dart';
import 'package:myapp/src/services/network_service.dart';
import 'package:myapp/src/themes/login_theme.dart';
import 'package:myapp/src/themes/main_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:myapp/src/utils/globals.dart' as globals;

class MyChromeSafariBrowser extends ChromeSafariBrowser {
  MyChromeSafariBrowser({browserFallback}) : super(bFallback: browserFallback);
}

class Home extends StatefulWidget {
  static const routeName = '/home';
  final ChromeSafariBrowser browser =
      MyChromeSafariBrowser(browserFallback: InAppBrowser());

  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  final txtSummoney = TextEditingController();
  final txtSumDelivery = TextEditingController();
  final dateSum = TextEditingController();
  InAppWebViewController webView;
  String url = "";
  double progress = 0;
  bool StatusReplace = false;
  NetworkService networkService;
  final txtSumPending = TextEditingController();
  final txtSumLeaveAlert = TextEditingController();
  var Client;

  @override
  void initState() {
    networkService = NetworkService();
    txtSumPending.text = '0';
    txtSumLeaveAlert.text = '0';
    txtSummoney.text = '0.00';
    txtSumDelivery.text = '0';
    _buildProfile();
    _buildGetdata();
    if (!globals.isRider)
      _buildGetdataLeave();
    else
      _buildSummary();
    _buildCheckStatusSubstitute();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 750, height: 1334, allowFontScaling: false);
    return Scaffold(
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(gradient: MainTheme.gradient),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              if (globals.isRider)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 0, right: 0, top: 0, bottom: 0),
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 20),
                        Container(
                          width: 350,
                          height: 125,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                            gradient: LinearGradient(
                              colors: [
                                MainTheme.HomebeginColor,
                                MainTheme.HomeendColor,
                              ],
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 10, right: 10, top: 0, bottom: 0),
                            child: Column(
                              children: <Widget>[
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Column(children: <Widget>[
                                        Image.asset(
                                          'assets/images/logo_home.png',
                                          height: 120,
                                          width: 120,
                                        ),
                                      ]),
                                      Container(
                                          height: 90,
                                          width: 10,
                                          child: VerticalDivider(
                                              color: Colors.white)),
                                      SizedBox(width: 16),
                                      Column(children: <Widget>[
                                        Text(
                                          'รวม',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 27,
                                              fontFamily: 'KanitRegular'),
                                        ),
                                        Text(
                                          txtSumDelivery.text + " เที่ยว",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 27,
                                              fontFamily: 'KanitRegular'),
                                        ),
                                        Text(
                                          'วันที่ ' + dateSum.text,
                                          style: TextStyle(
                                              //fontWeight: FontWeight.bold
                                              color: Colors.white,
                                              fontSize: 13,
                                              fontFamily: 'KanitRegular'),
                                        ),
                                      ]),
                                    ]),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[],
                                )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Card(
                          color: MainTheme.ColorBgAlert,
                          margin: EdgeInsets.only(
                              left: 0, right: 0, top: 0, bottom: 0),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0.0)),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 22, right: 22, top: 22, bottom: 30),
                            child: Column(
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
//                width: 100,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                        gradient: LinearGradient(
                                          colors: [
                                            LoginTheme.btncolor,
                                            LoginTheme.btncolor,
                                          ],
                                        ),
                                      ),
                                      child: new Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
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
                                                  '    กดยืนยันงานที่คุณทำเมื่อวาน',
                                                  style: TextStyle(
                                                      fontSize: 17,
                                                      color: Colors.black87,
                                                      fontFamily:
                                                          'KanitRegular'),
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
                                      height: 50,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                        gradient: LinearGradient(
                                          colors: [
                                            LoginTheme.btncolor,
                                            LoginTheme.btncolor,
                                          ],
                                        ),
                                      ),
                                      child: new Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
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
                                                    color: Colors.black87,
                                                    size: 36),
                                                SizedBox(width: 30),
                                                new Text(
                                                  'ลงเวลา                    ',
                                                  style: TextStyle(
                                                      fontSize: 17,
                                                      color: Colors.black87,
                                                      fontFamily:
                                                          'KanitRegular'),
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
                                      height: 50,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                        gradient: LinearGradient(
                                          colors: [
                                            LoginTheme.btncolor,
                                            LoginTheme.btncolor,
                                          ],
                                        ),
                                      ),
                                      child: new Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
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
                                                    color: Colors.black87,
                                                    size: 36),
                                                SizedBox(width: 30),
                                                new Text(
                                                  Strings.txt_savetime +
                                                      '               ',
                                                  style: TextStyle(
                                                      fontSize: 17,
                                                      color: Colors.black87,
                                                      fontFamily:
                                                          'KanitRegular'),
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
                                      height: 50,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                        gradient: LinearGradient(
                                          colors: [
                                            LoginTheme.btncolor,
                                            LoginTheme.btncolor,
                                          ],
                                        ),
                                      ),
                                      child: new Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          new FlatButton(
                                            onPressed: () {
                                              final BottomNavigationBar
                                                  navigationBar =
                                                  navBarGlobalKey.currentWidget;
                                              navigationBar.onTap(15);
                                            },
                                            child: new Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                StatusReplace
                                                    ? new Icon(
                                                        Icons
                                                            .radio_button_checked,
                                                        color:
                                                            Color(0xffc32c37),
                                                        size: 36)
                                                    : new Icon(
                                                        Icons
                                                            .radio_button_checked,
                                                        color: Colors.green,
                                                        size: 36),
                                                SizedBox(width: 30),
                                                new Text(
                                                  Strings.txt_ready +
                                                      '          ',
                                                  style: TextStyle(
                                                      fontSize: 17,
                                                      color: Colors.black87,
                                                      fontFamily:
                                                          'KanitRegular'),
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
              if (globals.isSup)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 0, right: 0, top: 0, bottom: 0),
                    child: Column(
                      children: <Widget>[
                        Card(
                          color: MainTheme.ColorBgAlert,
                          margin: EdgeInsets.only(
                              left: 0, right: 0, top: 0, bottom: 0),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0.0)),
                          child: SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 22, right: 22, top: 22, bottom: 30),
                              child: Column(
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
                                        height: 50,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
                                          gradient: LinearGradient(
                                            colors: [
                                              LoginTheme.btncolor,
                                              LoginTheme.btncolor,
                                            ],
                                          ),
                                        ),
                                        child: new Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            new FlatButton(
                                              onPressed: () {
                                                final BottomNavigationBar
                                                    navigationBar =
                                                    navBarGlobalKey
                                                        .currentWidget;
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
                                                  new Text(
                                                    '       ยืนยันใบลาของ Rider     ',
                                                    style: TextStyle(
                                                        fontSize: 17,
                                                        color: Colors.black87,
                                                        fontFamily:
                                                            'KanitRegular'),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              if (globals.isAdmin)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 0, right: 0, top: 0, bottom: 0),
                    child: Column(
                      children: <Widget>[
                        Card(
                          color: MainTheme.ColorBgAlert,
                          margin: EdgeInsets.only(
                              left: 0, right: 0, top: 0, bottom: 0),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0.0)),
                          child: SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 22, right: 22, top: 22, bottom: 30),
                              child: Column(
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
                                        height: 50,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
                                          gradient: LinearGradient(
                                            colors: [
                                              LoginTheme.btncolor,
                                              LoginTheme.btncolor,
                                            ],
                                          ),
                                        ),
                                        child: new Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            new FlatButton(
                                              onPressed: () {
                                                final BottomNavigationBar
                                                    navigationBar =
                                                    navBarGlobalKey
                                                        .currentWidget;
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
                                                  new Text(
                                                    '       ยืนยันใบลาของ Rider     ',
                                                    style: TextStyle(
                                                        fontSize: 17,
                                                        color: Colors.black87,
                                                        fontFamily:
                                                            'KanitRegular'),
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
                        ),
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

  Future<void> _buildProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      Client = prefs.getString('Client');
      DateTime now2 = DateTime.now();
      final now3 = DateTime(now2.year, now2.month, now2.day - 1);
      String formattedDateNOW = DateFormat('dd/MM/yyyy').format(now3);
      dateSum.text = formattedDateNOW;
    });
    print("fkingnoob${Client}${globals.onlyToken}${globals.i_EMP_ID}");
  }

  Future<void> _buildSummary() async {
    DateTime now1 = DateTime.now();
    final now = DateTime(now1.year, now1.month, now1.day - 1);
    String dateend = DateFormat('yyyy-MM-dd').format(now);
    String dateendplus = dateend + ' 23:59:59';
    String datestart = DateFormat('yyyy-MM-dd').format(now);
    String datestartplus = datestart + ' 00:00:00';
    String S_STORE_NO = '';
    NetworkService()
        .postsummary(globals.i_EMP_ID, S_STORE_NO, datestartplus, dateendplus)
        .then(
      (value) async {
        var json = jsonDecode(value);
        var errorMessage = json['errorMessage'];
        if (errorMessage['isError'] == false) {
          final Map parsed = jsonDecode(value);
          final SummaryResponse1 = SummaryResponse.fromJson(parsed);
          if (SummaryResponse1.deliveryOrders.isNotEmpty) {
            if (this.mounted) {
              setState(() {
                txtSummoney.text = SummaryResponse1.sumAmount.toString();
                txtSumDelivery.text = SummaryResponse1.sumDelivery.toString();
              });
            }
          }
          return Center(
            child: RefreshProgressIndicator(),
          );
        }
        return Center(
          child: RefreshProgressIndicator(),
        );
      },
    );
  }

  Future<void> _buildGetdata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var client = prefs.getString('Client');

    NetworkService().postGetdataDOH(globals.i_EMP_ID, client, '').then(
      (value) async {
        var json = jsonDecode(value);
        var errorMessage = json['errorMessage'];
        if (errorMessage['isError'] == false) {
          final responseJson = jsonDecode(value.toString());
          var data = DeliveryOrderHeaderResponse.fromJson(responseJson);
          if (data.deliveryOrderHeaders.length == 0) {
          } else {
            if (this.mounted) {
              setState(() {
                txtSumPending.text =
                    data.deliveryOrderHeaders.length.toString();
              });
            }
          }
          return Center(
            child: RefreshProgressIndicator(),
          );
        } else {
          showDialogInvid(errorMessage['errorText']);
        }
        return Center(
          child: RefreshProgressIndicator(),
        );
      },
    );
  }

  Future<void> _buildCheckStatusSubstitute() async {
    DateTime now1 = DateTime.now();
    final now = DateTime(now1.year, now1.month, now1.day + 1);
    String date = DateFormat('yyyy-MM-dd').format(now);
    try {
      NetworkService().postCheckStatusSubstitute(globals.i_EMP_ID, date).then(
        (value) async {
          var json = jsonDecode(value);
          var errorMessage = json['errorMessage'];
          if (errorMessage['isError'] == false) {
            if (this.mounted) {
              setState(() {
                StatusReplace = json['isWait'];
              });
            }
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

  Future<void> _buildGetdataLeave() async {
    NetworkService().postGetdataSumLeave(globals.i_EMP_ID).then(
      (value) async {
        var json = jsonDecode(value);
        var errorMessage = json['errorMessage'];
        if (errorMessage['isError'] == false) {
          final responseJson = jsonDecode(value.toString());
          var EmployeeAlert = Leave2Response.fromJson(responseJson);
          if (EmployeeAlert.employeeLeaveAlerts.isEmpty) {
          } else {
            if (this.mounted) {
              setState(() {
                txtSumLeaveAlert.text =
                    EmployeeAlert.employeeLeaveAlerts.length.toString();
              });
            }
          }
          return Center(
            child: RefreshProgressIndicator(),
          );
        } else {
          showDialogInvid(errorMessage['errorText']);
        }
        return Center(
          child: RefreshProgressIndicator(),
        );
      },
    );
  }

  Widget myAppBarIcon() {
    return Container(
      width: 20,
      height: 33,
      child: Stack(
        children: [
          Icon(
            Icons.notifications,
            color: Colors.black87,
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

  Widget myAppBarIconZero() {
    return Container(
      width: 20,
      height: 33,
      child: Stack(
        children: [
          Icon(
            Icons.notifications,
            color: Colors.black87,
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

  Widget IconAlert() {
    return Container(
      width: 20,
      height: 33,
      child: Stack(
        children: [
          Icon(
            Icons.date_range,
            color: Colors.black87,
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

  Widget IconAlertZero() {
    return Container(
      width: 20,
      height: 33,
      child: Stack(
        children: [
          Icon(
            Icons.date_range,
            color: Colors.black87,
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
}
