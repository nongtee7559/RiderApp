import 'dart:convert';
import 'dart:io';

import 'package:flutter/rendering.dart';
import 'package:get_version/get_version.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myapp/src/pages/login_page.dart';
import 'package:myapp/src/services/network_service.dart';
import 'package:myapp/src/themes/main_theme.dart';
import 'package:myapp/src/utils/Constant.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:myapp/src/my_app.dart';
import 'package:myapp/src/themes/login_theme.dart';
import 'package:myapp/src/models/CheckAppVersionResource.dart';
import 'package:ota_update/ota_update.dart';
import 'package:myapp/src/pages/splashscreen.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class AutoUpdate extends StatefulWidget {
  @override
  _AutoUpdateState createState() => _AutoUpdateState();
}

class _AutoUpdateState extends State<AutoUpdate> {
  bool status = false;
  CheckAppVersionResource resource = new CheckAppVersionResource();
  OtaEvent currentEvent;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    resource.hasUpdate = true;
    _listenForPermissionStatus();
  }

  void _listenForPermissionStatus() async {
    bool isGranted = await Permission.storage.isGranted;
    await Permission.storage.request();
    if (!await Permission.storage.isGranted)
      openAppSettings();
    else
      await _buildCheckAppVersion();
    setState(() {
      status = isGranted;
    });
  }

  Future _buildCheckAppVersion() async {
    var AppVersion = await GetVersion.projectVersion;
    await NetworkService().GetCheckAppVersion(AppVersion).then((value) async {
      var json = jsonDecode(value);
      var errorMessage = json['errorMessage'];
      if (errorMessage['isError'] == false) {
        final responseJson = jsonDecode(value.toString());
        var data = CheckAppVersionResource.fromJson(responseJson);

        setState(() {
          resource = data;
          if (resource.hasUpdate) tryOtaUpdate(resource.path);
          return Center(
            child: RefreshProgressIndicator(),
          );
        });
      } else {
        showDialogMsg(errorMessage['errorText']);
      }
      return Center(
        child: RefreshProgressIndicator(),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    if (resource.hasUpdate) {
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
                  height: 200,
                ),
                Padding(
                  padding: EdgeInsets.all(15.0),
                  child: new LinearPercentIndicator(
                    width: MediaQuery.of(context).size.width - 50,
                    lineHeight: 20.0,
                    percent: currentEvent == null
                        ? 0
                        : int.parse(currentEvent.value,
                                onError: (source) => 100) /
                            100,
                    center: Text(
                        currentEvent == null
                            ? "Check Version..."
                            : currentEvent.status == OtaStatus.INSTALLING
                                ? "Success"
                                : "${currentEvent.value}%",
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'KanitRegular')),
                    linearStrokeCap: LinearStrokeCap.roundAll,
                    progressColor: Colors.indigo,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
    return  LoginPage();
  }

  void showDialogMsg(String message) {
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

  Future<void> tryOtaUpdate(String url) async {
    try {
      //LINK CONTAINS APK OF FLUTTER HELLO WORLD FROM FLUTTER SDK EXAMPLES
      OtaUpdate().execute(url).listen(
        (OtaEvent event) {
          setState(() => currentEvent = event);
        },
      );
    } catch (e) {
      showDialogMsg(e);
    }
  }
}
