import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:get_version/get_version.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:location/location.dart';
import 'package:myapp/src/models/MessageResource.dart';
// import 'package:myapp/src/models/MessageResource.dart';
import 'package:myapp/src/my_app.dart';
import 'package:myapp/src/pages/pincode_page.dart';
import 'package:myapp/src/services/Strings.dart';
import 'package:myapp/src/services/network_service.dart';
import 'package:myapp/src/themes/login_theme.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:myapp/src/utils/globals.dart' as globals;

ProgressDialog pr;

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final usernameController = TextEditingController();
  NetworkService networkService;
  final passwordController = TextEditingController();
  final LatController = TextEditingController();
  final LongController = TextEditingController();
  StreamSubscription<LocationData> _locationSubscription;
  String passwordError;
  String usernameError;
  String DeviceID;
  String IMEI;
  String Serial;
  String AppVersion;

  @override
  void initState() {
    trackingLocation();
    networkService = NetworkService();
    super.initState();
  }

  @override
  void setState(fn) {
    if (mounted) {
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
              SizedBox(height: 30),
              _buildSignIn(context),
              SizedBox(height: 50),
              Container(
                width: 320,
                height: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(0)),
                  gradient: LinearGradient(
                    colors: [
                      LoginTheme.LoginendColor,
                      LoginTheme.LoginendColor,
                    ],
                  ),
                ),
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    FlatButton(
                      textColor: Colors.white,
                      child: Text(
                        "ลืมรหัสผ่าน ?",
                        style: TextStyle(fontFamily: 'KanitRegular'),
                      ),
                      onPressed: () {
                        //todo
                      },
                    ),
                    _buildDivider(),
                    FlatButton(
                      textColor: Colors.white,
                      child: Text(
                        "สมัคร",
                        style: TextStyle(fontFamily: 'KanitRegular'),
                      ),
                      onPressed: () {
                        //todo
                      },
                    ),
                  ],
                ),
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
                          fontFamily: 'KanitRegular'),
                    ),
                  ]),
              SizedBox(
                height: 90,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Stack _buildSignIn(BuildContext context) {
    return Stack(
      overflow: Overflow.visible,
      alignment: Alignment.bottomCenter,
      children: <Widget>[
        Card(
          margin: EdgeInsets.symmetric(horizontal: 32, vertical: 22),
          child: Padding(
            padding:
                const EdgeInsets.only(left: 22, right: 22, top: 22, bottom: 40),
            child: Column(
              children: <Widget>[
                _buildUsername(),
                Divider(
                  indent: 20,
                  endIndent: 20,
                  height: 22,
                ),
                _buildPassword(),
              ],
            ),
          ),
        ),
        Container(
          width: 150,
          height: 45,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            gradient: LinearGradient(
              colors: [
                LoginTheme.LoginendColor,
                LoginTheme.LoginbeginColor,
              ],
            ),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: LoginTheme.LoginbeginColor,
                offset: Offset(1.0, 6.0),
                blurRadius: 20.0,
              ),
              BoxShadow(
                color: LoginTheme.LoginendColor,
                offset: Offset(1.0, 6.0),
                blurRadius: 20.0,
              ),
            ],
          ),
          child: FlatButton(
            textColor: Colors.white,
            child: Text(
              Strings.txt_login,
              style: TextStyle(fontSize: 22, fontFamily: 'KanitRegular'),
            ),
            onPressed: () async {
              final username = usernameController.text;
              final password = passwordController.text;
              if (username.length <= 1) {
                usernameError = "กรุณาระบุชื่อผู้ใช้";
                setState(() {});
                return;
              }
              if (password.length <= 1) {
                passwordError = "กรุณาระบุรหัสผ่าน";
                setState(() {});
                return;
              }
              setState(() {});
              if (username != "" && password != "") {
                await _buildLogin(username, password);
              } else {
                print('__caselogin No');
                showDialogInvid("Login", "กรุณกรอกชื่อผู้ใช้เเละรหัสผ่าน");
              }
              print(username + password);
            },
          ),
        ),
      ],
    );
  }

  _buildUsername() {
    return TextField(
      controller: usernameController,
      decoration: InputDecoration(
        errorText: usernameError,
        hintText: "ชื่อผู้ใช้",
        icon: Icon(Icons.person_outline),
        labelText: "ชื่อผู้ใช้",
        border: InputBorder.none,
      ),
      keyboardType: TextInputType.emailAddress,
    );
  }

  _buildPassword() {
    return TextField(
      controller: passwordController,
      decoration: InputDecoration(
        errorText: passwordError,
        icon: Icon(Icons.lock),
        labelText: "รหัสผ่าน",
      ),
      obscureText: true,
    );
  }

  Row _buildDivider() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: const [Colors.white, Colors.white],
              begin: Alignment.topCenter,
              stops: [0.0, 1.0],
            ),
          ),
          width: 120,
          height: 1,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            "หรือ",
            style: TextStyle(color: Colors.white, fontFamily: 'KanitRegular'),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: const [Colors.white, Colors.white],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.0, 1.0],
            ),
          ),
          width: 120,
          height: 1,
        )
      ],
    );
  }

  void showDialogLogin() {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('Login'),
          content: Text('ชื่อผู้ใช้หรือรหัสผ่านไม่ถูกต้อง'),
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

  void showDialogException(String txttitle, String message) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      // false = user must tap button, true = tap outside dialog
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(txttitle),
          content: Text(message),
          actions: <Widget>[
            FlatButton(
              child: Text('Close'),
              onPressed: () async{
                await pr.hide();
                Navigator.of(dialogContext).pop(); // Dismiss alert dialog
                Navigator.of(context).pushReplacement(
                    new MaterialPageRoute(builder: (context) => MyApp()));
              },
            ),
          ],
        );
      },
    );
  }

  void showDialogInvid(String txttitle, String message) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      // false = user must tap button, true = tap outside dialog
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(txttitle),
          content: Text(message),
          actions: <Widget>[
            FlatButton(
              child: Text('Close'),
              onPressed: () async{
                await pr.hide();
                Navigator.of(dialogContext).pop(); // Dismiss alert dialog
              },
            ),
          ],
        );
      },
    );
  }

  void _buildLogin(String username, String password) async{
    await pr.show();
    NetworkService()
        .postlogin(username, password, LatController.text, LongController.text,
            DeviceID, Serial, '')
        .then(
      (value) async {
        try {
          if (value != null) {
            var json = jsonDecode(value);
            var token = json['token'];
            var errorMessage = json['errorMessage'];
            if (errorMessage['isError'] == false) {
              if (json['returnCode'] == "0000") {
                if (token['token'] != null) {
                  var expiration = token['expiration'];
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  var payload = Jwt.parseJwt(token['token']);
                  var storelist = payload['stores'];
                  var userProfile = json['userProfile'];
                  await prefs.setString(
                      's_USER_GENDER', userProfile['s_USER_GENDER'].toString());
                  await prefs.setString('user_Profile', userProfile.toString());
                  await prefs.setString(
                      'clientList', jsonEncode(userProfile['clients']));
                  await prefs.setString(
                      'i_EMP_ID', userProfile['i_EMP_ID'].toString());
                  await prefs.setString('s_USER_ID', userProfile['s_USER_ID']);
                  await prefs.setString('expiration', expiration);
                  ////////////////////////////////////////////////////////////////
                  globals.token = 'Bearer ' + token['token'];
                  globals.onlyToken = token['token'];
                  globals.companyId = userProfile['companyId'];
                  globals.i_EMP_ID = userProfile['i_EMP_ID'].toString();
                  globals.employeeType = userProfile['employeeType'];
                  globals.sPhoneNo = userProfile['s_PHONE_NO'];
                  globals.s_EMP_TYPE = userProfile['s_EMP_TYPE'];
                  globals.listStores = jsonDecode(storelist);
                  globals.Fname = userProfile['s_USER_FNAME'];
                  globals.Lname = userProfile['s_USER_LNAME'];
                  globals.s_User_ID = userProfile['s_USER_ID'];
                  globals.s_EMP_NO = userProfile['s_EMP_NO'];
                  _GetMessage();
                  var localImage;
                  bool chacklocalImage;
                  bool Directory_Path;
                  Directory_Path = prefs.getBool('Directory_Path_bool');
                  if (Directory_Path != null) {
                    chacklocalImage = prefs.getBool('localImage_bool');
                    localImage = prefs.getString('localImage').toString();
                    globals.user_Path =
                        prefs.getString('user_localImage${globals.s_User_ID}');
                    if (globals.user_Path == null) {
                      globals.user_Path = "assets/images/Profile_1.jpg";
                    }
                  } else {
                    chacklocalImage = prefs.getBool('localImage_bool');
                  }
                  if (globals.employeeType != 'Supplier') {
                    if (globals.s_EMP_TYPE == 'ET00') {
                      globals.isAdmin = true;
                      globals.isRider = false;
                      globals.isSup = false;
                    } else {
                      globals.isAdmin = false;
                      globals.isSup = false;
                      globals.isRider = true;
                    }
                    chacklocalImage == null
                        ? globals.Path_ImageProfile =
                            "assets/images/Profile_1.jpg"
                        : globals.Path_ImageProfile = localImage.toString();
                    globals.Path_Imageheader = "assets/images/header_main.jpg";
                  } else {
                    globals.isAdmin = false;
                    globals.isRider = false;
                    globals.isSup = true;
                    chacklocalImage == null
                        ? globals.Path_ImageProfile =
                            "assets/images/Profile_Store.jpg"
                        : globals.Path_ImageProfile = localImage;
                    globals.Path_Imageheader =
                        "assets/images/header_main_admin.jpg";
                  }
                  ////////////////////////////////////////////////////////////////
                  await NetworkService()
                      .postcheckpin(Serial, globals.i_EMP_ID, globals.s_User_ID)
                      .then(
                    (value) async {
                      print('response CheclHasPin : ${value}');
                      try {
                        var hasPin;
                        if (value != null) {
                          var json = jsonDecode(value);
                          var token = json['token'];
                          var errorMessage = json['errorMessage'];
                          hasPin = json['hasPin'];
                          print(
                              'errorMessagevvvvvvvvvvvvvvv : ${errorMessage['isError']}');
                          if (errorMessage['isError'] == false) {
                            print("hasPin : $hasPin");
                            if (hasPin == true) {
                              await pr.hide();
                              await prefs.setString('hasPin', "true");
                              print("asdfasdfasdfsdf");
                              await Navigator.pushAndRemoveUntil(
                                  context,
                                  PageRouteBuilder(pageBuilder:
                                      (BuildContext context,
                                          Animation animation,
                                          Animation secondaryAnimation) {
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
                              await prefs.remove('hasPin');
                              await pr.hide();
                              await Navigator.pushAndRemoveUntil(
                                  context,
                                  PageRouteBuilder(pageBuilder:
                                      (BuildContext context,
                                          Animation animation,
                                          Animation secondaryAnimation) {
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
                            }
                          } else {
                            print("dddddddddddddddddd");
                            var json = jsonDecode(value);
                            var errorMessage = json['errorMessage'];
                            print(
                                'errorMessage : ${errorMessage['errorText']}');
                          }
                          await pr.hide();
                        }
                        return hasPin;
                      } on FormatException catch (e) {
                        await pr.hide();
                        showDialogInvid('Error ', e.toString());
                      }
                    },
                  );
                  await pr.hide();
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
                }
              }
            } else {
              var json = jsonDecode(value);
              var errorMessage = json['errorMessage'];
              showDialogInvid("Login", errorMessage['errorText']);
            }
          }
          setState(() {});
        } on FormatException catch (e) {
          await pr.hide();
          showDialogInvid('Error ', e.toString());
        }
      },
    );
  }

  _GetMessage() async {
    networkService.GetMessage().then((value) async {
      var json = jsonDecode(value);
      var errorMessage = json['errorMessage'];
      if (errorMessage['isError'] == false) {
        final responseJson = jsonDecode(value.toString());
        var data = MessageResource.fromJson(responseJson);
        globals.listMessage = data.msg;
      }else{
        showDialogInvid('Error ', errorMessage['errorText']);
      }
    });

  }

  trackingLocation() async {
    AppVersion = await GetVersion.projectVersion;
    setState(() {});
    if (Platform.isAndroid) {
      var androidInfo = await DeviceInfoPlugin().androidInfo;
      var release = androidInfo.version.release;
      var sdkInt = androidInfo.version.sdkInt;
      var manufacturer = androidInfo.manufacturer;
      var model = androidInfo.model;
      var androidId = androidInfo.androidId;
      var device = androidInfo.device;
      DeviceID = 'Android $release (SDK $sdkInt), $manufacturer $model' +
          'Version ' +
          AppVersion;
      Serial = androidId;
    }
    if (Platform.isIOS) {
      var iosInfo = await DeviceInfoPlugin().iosInfo;
      var systemName = iosInfo.systemName;
      var version = iosInfo.systemVersion;
      var name = iosInfo.name;
      var model = iosInfo.model;
      print('$systemName $version, $name $model');
    }
    try {
      final Location _locationService = Location();
      await _locationService.changeSettings(
        accuracy: LocationAccuracy.HIGH,
        interval: 10000,
        distanceFilter: 100,
      ); // meters.
      if (await _locationService.serviceEnabled()) {
        var locationupdate = await _locationService.getLocation();
        LatController.text = locationupdate.latitude.toString();
        LongController.text = locationupdate.longitude.toString();
        print('_locationService.serviceEnabled');
        if (await _locationService.requestPermission() ==
            PermissionStatus.GRANTED) {
          print('_locationService.requestPermission');
          _locationSubscription = _locationService.onLocationChanged().listen(
            (LocationData result) async {
              final latLng = LatLng(result.latitude, result.longitude);
              LatController.text = result.latitude.toString();
              LongController.text = result.longitude.toString();
            },
          );
        } else {
          print('Permission denied');
        }
      } else {
        print('_locationService.serviceDisable');
        bool serviceStatusResult = await _locationService.requestService();
        print("Service status activated after request: $serviceStatusResult");
        if (serviceStatusResult) {
          // trackingLocation();
        } else {
          print('Service denied');
        }
      }
    } on Exception catch (exception) {
      showDialogException('Exception', exception.toString());
    } catch (error) {
      showDialogException('error', error.toString());
    }
  }
}
