import 'package:flutter/material.dart';
import 'package:myapp/src/my_app.dart';

void main() => runApp(MyApp());




































//
//import 'package:flutter/material.dart';
//import 'package:ota_update/ota_update.dart';
//
//import 'package:simple_permissions/simple_permissions.dart';
//void main() => runApp(MyApp1());
//
//class MyApp1 extends StatefulWidget {
//  @override
//  _MyApp1State createState() => _MyApp1State();
//}
//
//class _MyApp1State extends State<MyApp1> {
//  OtaEvent currentEvent;
//
//  @override
//  void initState() {
//    super.initState();
//    tryOtaUpdate();
//  }
//
//  Future<void> tryOtaUpdate() async {
//
//    bool permissionStatus = await SimplePermissions.checkPermission(Permission.WriteExternalStorage);
//    if(!permissionStatus) permissionStatus = (await SimplePermissions.requestPermission(Permission.WriteExternalStorage)) == PermissionStatus.authorized;
//
//
//    try {
//      //LINK CONTAINS APK OF FLUTTER HELLO WORLD FROM FLUTTER SDK EXAMPLES
//      OtaUpdate()
//          .execute('http://27.254.189.188:5003/api/config/app/0.0.0', destinationFilename: '1.1.apk')
//          .listen(
//            (OtaEvent event) {
//          setState(() => currentEvent = event);
//        },
//      );
//    } catch (e) {
//      print('Failed to make OTA update. Details: $e');
//    }
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    if (currentEvent == null) {
//      return Container();
//    }
//    return MaterialApp(
//      home: Scaffold(
//        appBar: AppBar(
//          title: const Text('Plugin example app'),
//        ),
//        body: Center(
//          child: Text(
//              'OTA status: ${currentEvent.status} : ${currentEvent.value} \n'),
//        ),
//      ),
//    );
//  }
//}