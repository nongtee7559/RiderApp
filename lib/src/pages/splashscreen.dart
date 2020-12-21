import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:get_version/get_version.dart';
import 'package:myapp/src/pages/login_page.dart';
import 'package:myapp/src/pages/pincode_page.dart';
import 'package:myapp/src/services/network_service.dart';
import 'package:myapp/src/themes/login_theme.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:myapp/src/utils/globals.dart' as globals;
ProgressDialog pr;

class SplashscreenPage extends StatefulWidget {
  @override
  _SplashscreenPageState createState() => _SplashscreenPageState();
}

class _SplashscreenPageState extends State<SplashscreenPage> {
  NetworkService networkService;
  String AppVersion = '...';
  @override
  void initState() {
    networkService = NetworkService();
    _buildCheckhasPin();
    super.initState();
  }
  @override
  void setState(fn) {
    if(mounted) {
      super.setState(fn);
    }
  }
  Future<void> _buildCheckhasPin() async {
    print('start checkIsLogin');
    AppVersion = await GetVersion.projectVersion;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var imei;
    if (Platform.isAndroid) {
      var androidInfo = await DeviceInfoPlugin().androidInfo;
      var androidId = androidInfo.androidId;
      print('androidIdandroidIdandroidId : ${androidId}');
      var device = androidInfo.device;
      print('device : ${device}');
      imei = androidId;
      // Android 9 (SDK 28), Xiaomi Redmi Note 7
    }
    if (Platform.isIOS) {
      var iosInfo = await DeviceInfoPlugin().iosInfo;
      var systemName = iosInfo.systemName;
      var version = iosInfo.systemVersion;
      var name = iosInfo.name;
      var model = iosInfo.model;
      print('$systemName $version, $name $model');
      // iOS 13.1, iPhone 11 Pro Max iPhone
    }
    String checkhasuser = await prefs.getString('s_USER_ID') ?? null;
    if (checkhasuser == null) {
      pr.hide();
      Navigator.pushAndRemoveUntil(
          context,
          PageRouteBuilder(pageBuilder: (BuildContext context,
              Animation animation, Animation secondaryAnimation) {
            return LoginPage();
          }, transitionsBuilder: (BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              Widget child) {
            return new SlideTransition(
              position: new Tween<Offset>(
                begin: const Offset(1.0, 0.0),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            );
          }),
          (Route route) => false);
    } else {
      var i_EMP_ID = await prefs.getString('i_EMP_ID');
      var s_USER_ID = await prefs.getString('s_USER_ID');
      pr.show();
      NetworkService()
          .postcheckpin(imei, i_EMP_ID, s_USER_ID)
          .then(
        (value) async {
          print('response CheclHasPin : ${value}');
          try {
            var hasPin;
            if (value != null) {
              var json = jsonDecode(value);
              var errorMessage = json['errorMessage'];
              hasPin = json['hasPin'];
              print('errorMessagevvvvvvvvvvvvvvv : ${errorMessage['isError']}');
              if (errorMessage['isError'] == false) {
                print("hasPin : $hasPin");
                if (hasPin == true) {
                  await prefs.setString('hasPin', "true");
                  print("asdfasdfasdfsdf");
                  pr.hide();
                  Navigator.pushAndRemoveUntil(
                      context,
                      PageRouteBuilder(pageBuilder: (BuildContext context,
                          Animation animation, Animation secondaryAnimation) {
                        return PincodePage();
                      }, transitionsBuilder: (BuildContext context,
                          Animation<double> animation,
                          Animation<double> secondaryAnimation,
                          Widget child) {
                        return new SlideTransition(
                          position: new Tween<Offset>(
                            begin: const Offset(1.0, 0.0),
                            end: Offset.zero,
                          ).animate(animation),
                          child: child,
                        );
                      }),
                          (Route route) => false);
                } else {
                  pr.hide();
                  Navigator.pushAndRemoveUntil(
                      context,
                      PageRouteBuilder(pageBuilder: (BuildContext context,
                          Animation animation, Animation secondaryAnimation) {
                        return LoginPage();
                      }, transitionsBuilder: (BuildContext context,
                          Animation<double> animation,
                          Animation<double> secondaryAnimation,
                          Widget child) {
                        return new SlideTransition(
                          position: new Tween<Offset>(
                            begin: const Offset(1.0, 0.0),
                            end: Offset.zero,
                          ).animate(animation),
                          child: child,
                        );
                      }),
                          (Route route) => false);
                }
              } else {
                var json = jsonDecode(value);
                var errorMessage = json['errorMessage'];
                print('errorMessage : ${errorMessage['errorText']}');
//            showDialogInvid("Login",errorMessage['errorText']);
              }
              pr.hide();
            }
            return hasPin;
          } on FormatException catch (e) {
            pr.hide();
            showDialogInvid(e.toString());
          }
        },
      );
      pr.hide();
    }
  }

  @override
  Widget build(BuildContext context) {
    pr = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false, showLogs: false);
    pr.style(message: 'Please Wait...');
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(gradient: LoginTheme.gradient),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 150,
              ),
              Image.asset(
                'assets/images/header_1.gif',
                height: 95,
              ),
              SizedBox(
                height: 50,
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Version $AppVersion",
                      style: new TextStyle(
                          fontSize: 15,
                          color: Colors.white,
//                                  fontWeight: FontWeight.w200,
                          fontFamily: 'KanitRegular'),
                    ),
                  ]),
            ],
          ),
        ),
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
