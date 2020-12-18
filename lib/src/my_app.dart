import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myapp/src/pages/jobalert.dart';
import 'package:myapp/src/pages/approveOrder.dart';
import 'package:myapp/src/pages/choose_client_page.dart';
import 'package:myapp/src/pages/googlemap_page.dart';
import 'package:myapp/src/pages/home.dart';
import 'package:myapp/src/pages/launcher.dart';
import 'package:myapp/src/pages/login_page.dart';
import 'package:myapp/src/pages/pincode_page.dart';
import 'package:myapp/src/pages/splashscreen.dart';
import 'package:myapp/src/services/network_service.dart';
import 'package:myapp/src/themes/main_theme.dart';
import 'package:myapp/src/utils/Constant.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:myapp/src/checkPermission.dart';

class MyApp extends StatelessWidget {
  NetworkService networkService;
  final _route = <String, WidgetBuilder>{
    Constant.HOME_ROUTE: (context) => Home(),
    Constant.LOGIN_ROUTE: (context) => LoginPage(),
    Constant.MAP_ROUTE: (context) => GoogleMapPage(),
    Constant.MAIN_LAUNCHER: (context) => Launcher(),
    Constant.MYAPP_ROUTE: (context) => MyApp(),
    Constant.APPROVEORDER_ROUTE: (context) => ApproveOrder(),
    Constant.JOBALERT_ROUTE: (context) => Jobalert(),
  };
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
      return  MaterialApp(
          color: Color(0xFF0D47A1),
          theme: ThemeData(
            fontFamily: 'KanitRegular',
            primaryColor: MainTheme.HomeendTripColor,
//          primarySwatch: Colors.blue,
            canvasColor: MainTheme.HomebeginColor,
            accentColor: Colors.purple,
            textTheme: TextTheme(body1: TextStyle(color: Colors.red)),
            scaffoldBackgroundColor: const Color(0xFFE8EAF6),
          ),
          title: 'ALL NOW',
          initialRoute: "/", // สามารถใช้ home แทนได้
          home: FutureBuilder(
            future:  checkIsLogin(),
            builder: (context, snapshot) {
              return CheckPermission();
            },
          )
      );
    }
  Future<bool> checkIsLogin() async {

  }

  void checkPermission() async{
  }


}


