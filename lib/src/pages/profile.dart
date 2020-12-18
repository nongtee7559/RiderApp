import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myapp/src/pages/splashscreen.dart';
import 'package:myapp/src/themes/login_theme.dart';
import 'package:myapp/src/themes/main_theme.dart';
import 'package:myapp/src/utils/Constant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'choose_client_page.dart';
import 'launcher.dart';
import 'package:myapp/src/utils/globals.dart' as globals;

class Profile extends StatefulWidget {
  static const routeName = '/home';

  @override
  State<StatefulWidget> createState() {
    return _ProfileState();
  }
}

class _ProfileState extends State<Profile> {
  String ClientName = '';
  @override
  void initState() {
    _buildProfile();
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
    return Scaffold(
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(gradient: MainTheme.gradient),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(height: 15),
              Card(
                color: Constant.BG_WHITE_COLOR,
                margin:
                    EdgeInsets.only(left: 10, right: 10, top: 0, bottom: 10),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 0, right: 0, top: 22, bottom: 30),
                  child: Column(
                    children: <Widget>[
                      Stack(children: <Widget>[
                        Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(width: 20),
                              Stack(
                                overflow: Overflow.visible,
                                alignment: Alignment.bottomCenter,
                                children: <Widget>[
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(100)),
                                      gradient: LinearGradient(
                                        colors: [
                                          MainTheme.white,
                                          MainTheme.white,
                                        ],
                                      ),
                                    ),
                                    child: FlatButton(
                                      textColor: Colors.white,
                                      child: CircleAvatar(
                                        backgroundColor: Colors.grey,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          child: globals.user_Path == null
                                              ? Image.asset(
                                                  globals.Path_ImageProfile,
                                                  width: 70,
                                                  height: 70,
                                                  fit: BoxFit.fill)
                                              : Image.file(File(globals.user_Path),
                                                  width: 70,
                                                  height: 70,
                                                  fit: BoxFit.fill),
                                        ),
                                        radius: 40,
                                      ),
                                      onPressed: () async {
                                        print('click Upload');
                                      },
                                    ),
                                  ),
                                  new Positioned(
                                      top: 55,
                                      left: 100,
                                      child: Text(
                                        '   ลูกค้า : ' + ClientName,
                                        style: TextStyle(
                                            color: Colors.black87,
                                            fontSize: 17,
                                            fontFamily: 'KanitRegular'),
                                      )),
                                ],
                              ),
                              Text(
                                ' โปรไฟล์',
                                style: new TextStyle(
                                    fontSize: 23,
                                    color: Colors.black87,
//                                  fontWeight: FontWeight.w200,
                                    fontFamily: 'KanitRegular'),
                              ),
                            ]),
                      ]),
                      SizedBox(height: 20),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              '   ตั้งค่าความปลอดภัย',
                              style: new TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey,
//                                  fontWeight: FontWeight.w200,
                                  fontFamily: 'KanitRegular'),
                            ),
                          ]),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Stack(
                            overflow: Overflow.visible,
                            alignment: Alignment.bottomCenter,
                            children: <Widget>[
                              Container(
                                width: 290,
                                height: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20.0),
                                    topRight: Radius.circular(20.0),
                                    bottomLeft: Radius.zero,
                                    bottomRight: Radius.zero,
                                  ),
                                  gradient: LinearGradient(
                                    colors: [
                                      LoginTheme.bg_btnProfile,
                                      LoginTheme.bg_btnProfile,
                                    ],
                                  ),
                                ),
                                child: FlatButton(
                                  textColor: Colors.white,
                                  child: new Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      new Text(
                                        'ตั้งรหัสผ่าน                ',
                                        style: TextStyle(
                                            fontSize: 17,
                                            color: Colors.grey,
                                            fontFamily: 'KanitRegular'),
                                      ),
                                      new Icon(Icons.navigate_next,
                                          color: Colors.grey, size: 36),
                                    ],
                                  ),
                                  onPressed: () async {},
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                      _buildDivider1(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Stack(
                            overflow: Overflow.visible,
                            alignment: Alignment.bottomCenter,
                            children: <Widget>[
                              Container(
                                width: 290,
                                height: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.zero,
                                    topRight: Radius.zero,
                                    bottomLeft: Radius.circular(20.0),
                                    bottomRight: Radius.circular(20.0),
                                  ),
                                  gradient: LinearGradient(
                                    colors: [
                                      LoginTheme.bg_btnProfile,
                                      LoginTheme.bg_btnProfile,
                                    ],
                                  ),
                                ),
                                child: FlatButton(
                                  textColor: Colors.white,
                                  child: new Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      new Text(
                                        'ตั้งค่า Pin Code           ',
                                        style: TextStyle(
                                            fontSize: 17,
                                            color: Colors.grey,
                                            fontFamily: 'KanitRegular'),
                                      ),
                                      new Icon(Icons.navigate_next,
                                          color: Colors.grey, size: 36),
                                    ],
                                  ),
                                  onPressed: () async {
                                    print('click Upload');
                                  },
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Stack(
                            overflow: Overflow.visible,
                            alignment: Alignment.bottomCenter,
                            children: <Widget>[
                              Container(
                                width: 290,
                                height: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10.0),
                                    topRight: Radius.circular(10.0),
                                    bottomLeft: Radius.circular(10.0),
                                    bottomRight: Radius.circular(10.0),
                                  ),
                                  gradient: LinearGradient(
                                    colors: [
                                      LoginTheme.bg_btnProfile,
                                      LoginTheme.bg_btnProfile,
                                    ],
                                  ),
                                ),
                                child: FlatButton(
                                  textColor: Colors.white,
                                  child: new Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      new Text(
                                        'เปลี่ยนแปลงลูกค้า           ',
                                        style: TextStyle(
                                            fontSize: 17,
                                            color: Colors.grey,
                                            fontFamily: 'KanitRegular'),
                                      ),
                                      new Icon(Icons.navigate_next,
                                          color: Colors.grey, size: 33),
                                    ],
                                  ),
                                  onPressed: () async {
                                    Navigator.of(context, rootNavigator: false)
                                        .push(MaterialPageRoute(
                                            builder: (context) =>
                                                ChooseClient(),
                                            maintainState: false));
                                  },
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                      SizedBox(height: 5),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              '   เกี่ยวกับ',
                              style: new TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey,
//                                  fontWeight: FontWeight.w200,
                                  fontFamily: 'KanitRegular'),
                            ),
                          ]),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Stack(
                            overflow: Overflow.visible,
                            alignment: Alignment.bottomCenter,
                            children: <Widget>[
                              Container(
                                width: 290,
                                height: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20.0),
                                    topRight: Radius.circular(20.0),
                                    bottomLeft: Radius.zero,
                                    bottomRight: Radius.zero,
                                  ),
                                  gradient: LinearGradient(
                                    colors: [
                                      LoginTheme.bg_btnProfile,
                                      LoginTheme.bg_btnProfile,
                                    ],
                                  ),
                                ),
                                child: FlatButton(
                                  textColor: Colors.white,
                                  child: new Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      new Text(
                                        'โปรไฟล์                     ',
                                        style: TextStyle(
                                            fontSize: 17,
                                            color: Colors.grey,
                                            fontFamily: 'KanitRegular'),
                                      ),
                                      new Icon(Icons.navigate_next,
                                          color: Colors.grey, size: 36),
                                    ],
                                  ),
                                  onPressed: () async {
                                    final BottomNavigationBar navigationBar =
                                        navBarGlobalKey.currentWidget;
                                    navigationBar.onTap(9);
                                  },
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                      _buildDivider1(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Stack(
                            overflow: Overflow.visible,
                            alignment: Alignment.bottomCenter,
                            children: <Widget>[
                              Container(
                                width: 290,
                                height: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.zero,
                                    topRight: Radius.zero,
                                    bottomLeft: Radius.circular(20.0),
                                    bottomRight: Radius.circular(20.0),
                                  ),
                                  gradient: LinearGradient(
                                    colors: [
                                      LoginTheme.bg_btnProfile,
                                      LoginTheme.bg_btnProfile,
                                    ],
                                  ),
                                ),
                                child: FlatButton(
                                  textColor: Colors.white,
                                  child: new Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      new Text(
                                        'คู่มือการใช้งาน              ',
                                        style: TextStyle(
                                            fontSize: 17,
                                            color: Colors.grey,
                                            fontFamily: 'KanitRegular'),
                                      ),
                                      new Icon(Icons.navigate_next,
                                          color: Colors.grey, size: 36),
                                    ],
                                  ),
                                  onPressed: () async {
                                    print('click Upload');
                                  },
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                      SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Stack(
                            overflow: Overflow.visible,
                            alignment: Alignment.bottomCenter,
                            children: <Widget>[
                              Container(
                                width: 290,
                                height: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10.0),
                                    topRight: Radius.circular(10.0),
                                    bottomLeft: Radius.circular(10.0),
                                    bottomRight: Radius.circular(10.0),
                                  ),
                                  gradient: LinearGradient(
                                    colors: [
                                      LoginTheme.bg_btnProfile,
                                      LoginTheme.bg_btnProfile,
                                    ],
                                  ),
                                ),
                                child: FlatButton(
                                  textColor: Colors.white,
                                  child: new Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      new Text(
                                        'ออกจากระบบ                ',
                                        style: TextStyle(
                                            fontSize: 17,
                                            color: Colors.grey,
                                            fontFamily: 'KanitRegular'),
                                      ),
                                      new Icon(Icons.exit_to_app,
                                          color: Colors.grey, size: 33),
                                    ],
                                  ),
                                  onPressed: () async {
                                    print('click Upload');
                                    show_Dialog_logout(
                                        'คุณต้องการออกจากระบบหรือไม่');
                                  },
                                ),
                              ),
                            ],
                          )
                        ],
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
      ClientName = prefs.getString('ClientName');
    });
  }

  Row _buildDivider1() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: const [Colors.grey, Colors.grey],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.0, 1.0],
            ),
          ),
          width: 290,
          height: 1,
        )
      ],
    );
  }

  void show_Dialog_logout(String message) {
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          content: Text(message),
          actions: <Widget>[
            FlatButton(
              child: Text('ยกเลิก'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            FlatButton(
              child: Text('ตกลง'),
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.getKeys();
                Navigator.of(dialogContext).pop();
                Navigator.pushAndRemoveUntil(
                    context,
                    PageRouteBuilder(pageBuilder: (BuildContext context,
                        Animation animation, Animation secondaryAnimation) {
                      return SplashscreenPage();
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
              },
            ),
          ],
        );
      },
    );
  }
}
