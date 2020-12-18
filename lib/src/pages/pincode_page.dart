import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_version/get_version.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:location/location.dart';
import 'package:myapp/src/models/client_response.dart';
import 'package:myapp/src/pages/launcher.dart';
import 'package:myapp/src/pages/splashscreen.dart';
import 'package:myapp/src/services/network_service.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'choose_client_page.dart';
import 'package:myapp/src/utils/globals.dart' as globals;
class PincodePage extends StatefulWidget {
  static const routeName = '/pincode';
  @override
  PincodePageState createState() => PincodePageState();
}
String txt_status = "";
String IMEI;
String hasPin;
final LatController = TextEditingController();
final LongController = TextEditingController();
StreamSubscription<LocationData> _locationSubscription;
String DeviceID;
String AppVersion;
String Serial;
int ClientSum = 0;
Future<void> _buildProfile() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String clientList = prefs.getString('clientList') ?? null;
  if (clientList.toString() != 'null') {
  final responseJson = jsonDecode('{"clients":'+prefs.getString('clientList')+'}'.toString());
  print('responseJsonClientClassProfile--- ${responseJson.toString()}');
  var data = ClientsRespose.fromJson(responseJson);
  ClientSum = data.clients.length;
  print('ClientSum--- ${ClientSum.toString()}');
  ClientSum == 1 ? prefs.setString('Client' , data.clients[0].sClientCompCode) : null;
  ClientSum == 1 ? prefs.setString('ClientName' , data.clients[0].sNameTh) : null;
  }
  txt_status = "สร้างรหัสผ่าน";
  hasPin = await prefs.getString('hasPin') ?? null;
  if(hasPin != null){
    txt_status = "เข้าสู่ระบบ";
  }
  print('StartGetVersion');
  AppVersion = await GetVersion.projectVersion;
  print('Appversion : ${AppVersion.toString()}' );
  if (Platform.isAndroid) {
    var androidInfo = await DeviceInfoPlugin().androidInfo;
    var release = androidInfo.version.release;
    var sdkInt = androidInfo.version.sdkInt;
    var manufacturer = androidInfo.manufacturer;
    var model = androidInfo.model;

    var androidId = androidInfo.androidId;
    print('androidIdandroidIdandroidId : ${androidId}' );
    var device = androidInfo.device;
    print('device : ${device}' );
    DeviceID = 'Android $release (SDK $sdkInt), $manufacturer $model' + 'Version ' + AppVersion;
    IMEI = androidId;
    Serial = androidId;
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
  final Location _locationService = Location();
  await _locationService.changeSettings(
    accuracy: LocationAccuracy.HIGH,
    interval: 10000,
    distanceFilter: 100,
  ); // meters.
  if (await _locationService.serviceEnabled()) {
    var locationupdate  = await _locationService.getLocation();
    LatController.text = locationupdate.latitude.toString();
    LongController.text = locationupdate.longitude.toString();
    print('_locationService.serviceEnabled');
    if (await _locationService.requestPermission() == PermissionStatus.GRANTED) {
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
}
class PincodePageState extends State<PincodePage> {
  final TextEditingController _pinPutController = TextEditingController();
  final FocusNode _pinPutFocusNode = FocusNode();
  List<String> countList = [
    "One",
    "Two",
    "Three",
    "Four",
    "Five",
    "Six",
    "Seven",
    "Eight",
    "Nine",
    "Ten",
    "Eleven",
    "Tweleve",
    "Thirteen",
    "Fourteen",
    "Fifteen",
    "Sixteen",
    "Seventeen",
    "Eighteen",
    "Nineteen",
    "Twenty"
  ];
  List<String> selectedCountList = [];
  BuildContext _context;
  final PageController _pageController = PageController(initialPage: 1);
  int _pageIndex = 0;
  int setpin_pageIndex = 0;
  String pinverify = "";
  String pinconfrim = "";
  ProgressDialog pr;
  NetworkService networkService;
  void initState() {
    networkService = NetworkService();
    _buildProfile();
    super.initState();
  }
  Widget darkRoundedPinPut() {
    pr = ProgressDialog(context,type: ProgressDialogType.Normal, isDismissible: false, showLogs: false);
    pr.style(message: 'กำลังบันทึกข้อมูล...');

    BoxDecoration pinPutDecoration = BoxDecoration(
      color: Colors.white,
      border: Border.all(color: Colors.black,width: 2),
      borderRadius: BorderRadius.circular(20),
    );
    BoxDecoration pinPutDecoration2 = BoxDecoration(
      color: Colors.black,
      border: Border.all(color: Colors.black,width: 2),
      borderRadius: BorderRadius.circular(20),
    );
    return PinPut(
      eachFieldWidth: 5,
      eachFieldHeight: 5,
      fieldsCount: 6,
      autofocus: true,
      focusNode: _pinPutFocusNode,
      controller: _pinPutController,
      inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
      keyboardType: TextInputType.numberWithOptions(signed: true, decimal: true),
      onSubmit: (String pin) => _showSnackBar(pin),
      submittedFieldDecoration: pinPutDecoration2,
      selectedFieldDecoration: pinPutDecoration,
      followingFieldDecoration: pinPutDecoration,
      pinAnimationType: PinAnimationType.scale,
      textStyle: TextStyle(color: Colors.black, fontSize: 0),

    );
  }

  Widget animatingBorders() {
    BoxDecoration pinPutDecoration = BoxDecoration(
      border: Border.all(color: Colors.blue),
      borderRadius: BorderRadius.circular(15),
    );
    return PinPut(
      fieldsCount: 6,
      eachFieldHeight: 5,
      onSubmit: (String pin) => _showSnackBar(pin),
      focusNode: _pinPutFocusNode,
      controller: _pinPutController,
      submittedFieldDecoration:
      pinPutDecoration.copyWith(borderRadius: BorderRadius.circular(20)),
      pinAnimationType: PinAnimationType.slide,
      selectedFieldDecoration: pinPutDecoration,
      followingFieldDecoration: pinPutDecoration.copyWith(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          color: Colors.deepPurpleAccent.withOpacity(.5),
        ),
      ),
    );
  }

  Widget boxedPinPutWithPreFilledSymbol() {
    BoxDecoration pinPutDecoration = BoxDecoration(
      color: Colors.red,
      borderRadius: BorderRadius.circular(5),
    );

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(3),
        border: Border.all(color: Colors.green),
      ),
      padding: EdgeInsets.all(20),
      child: PinPut(
        fieldsCount: 5,
        preFilledChar: '-',
        preFilledCharStyle: TextStyle(fontSize: 35, color: Colors.white),
        textStyle: TextStyle(fontSize: 25, color: Colors.white),
        eachFieldWidth: 50,
        eachFieldHeight: 50,
        onSubmit: (String pin) => _showSnackBar(pin),
        focusNode: _pinPutFocusNode,
        controller: _pinPutController,
        submittedFieldDecoration: pinPutDecoration,
        selectedFieldDecoration: pinPutDecoration.copyWith(color: Colors.white),
        followingFieldDecoration: pinPutDecoration,
        pinAnimationType: PinAnimationType.slide,
      ),
    );
  }

  Widget onlySelectedBorderPinPut() {

    BoxDecoration pinPutDecoration = BoxDecoration(
      color: Colors.lime,
      borderRadius: BorderRadius.circular(5),
    );

    return PinPut(
      fieldsCount: 6,
      textStyle: TextStyle(fontSize: 25, color: Colors.black),
      eachFieldWidth: 45,
      eachFieldHeight: 55,
      onSubmit: (String pin) => _showSnackBar(pin),
      focusNode: _pinPutFocusNode,
      controller: _pinPutController,
      submittedFieldDecoration: pinPutDecoration,
      selectedFieldDecoration: pinPutDecoration.copyWith(
          color: Colors.white,
          border: Border.all(
            width: 2,
            color: Color.fromRGBO(160, 215, 220, 1),
          )),
      followingFieldDecoration: pinPutDecoration,
      pinAnimationType: PinAnimationType.scale,
    );
  }

  Widget justRoundedCornersPinPut() {

    BoxDecoration pinPutDecoration = BoxDecoration(
        color: Color.fromRGBO(43, 46, 66, 1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Color.fromRGBO(126, 203, 224, 1)));

    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: PinPut(
        fieldsCount: 4,
        textStyle: TextStyle(fontSize: 25, color: Colors.white),
        eachFieldWidth: 40,
        eachFieldHeight: 55,
        onSubmit: (String pin) => _showSnackBar(pin),
        focusNode: _pinPutFocusNode,
        controller: _pinPutController,
        submittedFieldDecoration: pinPutDecoration,
        selectedFieldDecoration: pinPutDecoration,
        followingFieldDecoration: pinPutDecoration,
        pinAnimationType: PinAnimationType.fade,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    List<Widget> _pinPuts = [
      darkRoundedPinPut(),
    ];

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        platform: TargetPlatform.iOS,
      ),
      home: Scaffold(
//        backgroundColor: Colors.white,

        body: Stack(
          fit: StackFit.passthrough,

          children: <Widget>[
            SizedBox(height: 50),
            Image.asset(
              "assets/images/bg_pincode.jpg",
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover,
            ),
            Column(
                mainAxisAlignment: MainAxisAlignment.start
                ,
                children: <Widget>[
                  SizedBox(height: 55),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          globals.Fname,
                          style: new TextStyle(
                              fontSize: 30,
                              color: Colors.black87,
//                                  fontWeight: FontWeight.w200,
                              fontFamily: 'KanitRegular'),
                        ),
                      ]),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          txt_status,
                          style: new TextStyle(
                              fontSize: 20,
                              color: Colors.black87,
//                                  fontWeight: FontWeight.w200,
                              fontFamily: 'KanitRegular'),
                        ),
                      ]),
                  SizedBox(
                    height: 5,
                  ),
                  Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Text(
                          "Version $AppVersion",
                          style: new TextStyle(
                              fontSize: 15,
                              color: Colors.black,
//                                  fontWeight: FontWeight.w200,
                              fontFamily: 'KanitRegular'),
                        ),
                      ]),
                ]
            ),
            new Builder(
              builder: (context) {
                _context = context;
                SizedBox(height: 60);
                return AnimatedContainer(
//                  color: _bgColors[_pageIndex],
                  duration: Duration(milliseconds: 200),
                  padding: EdgeInsets.only(
                      left: 55, right: 55, top: 0, bottom: 20),
                  child: PageView(
                    scrollDirection: Axis.vertical,
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() {
                        _pageIndex = index;
                      });
                    },
                    children: _pinPuts.map((p) {
                      return FractionallySizedBox(
                        heightFactor: 1,
                        child: Center(child: p),
                      );
                    }).toList(),
                  ),
                );
              },
            ),
            _bottomAppBar,
          ],
        ),
      ),
    );
  }

  Widget get _bottomAppBar {
    _pinPutFocusNode.requestFocus();
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child:
      hasPin == null ? Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
           FlatButton(
             color: Colors.white,
            child: Text('ข้าม',style: TextStyle(
                color: Colors.black,
                fontSize: 15,
                fontWeight: FontWeight.bold,
                fontFamily: 'KanitRegular'),),
            onPressed: () =>
               ClientSum > 1 ? Navigator.pushAndRemoveUntil(
                    context,
                    PageRouteBuilder(pageBuilder: (BuildContext context, Animation animation,
                        Animation secondaryAnimation) {
                      return ChooseClient();
                    }, transitionsBuilder: (BuildContext context, Animation<double> animation,
                        Animation<double> secondaryAnimation, Widget child) {
                      return new SlideTransition(
                        position: new Tween<Offset>(
                          begin: const Offset(1.0, 0.0),
                          end: Offset.zero,
                        ).animate(animation),
                        child: child,
                      );
                    }),
                        (Route route) => false)
                    :
                Navigator.pushAndRemoveUntil(
                    context,
                    PageRouteBuilder(pageBuilder: (BuildContext context, Animation animation,
                        Animation secondaryAnimation) {
                      return Launcher();
                    }, transitionsBuilder: (BuildContext context, Animation<double> animation,
                        Animation<double> secondaryAnimation, Widget child) {
                      return new SlideTransition(
                        position: new Tween<Offset>(
                          begin: const Offset(1.0, 0.0),
                          end: Offset.zero,
                        ).animate(animation),
                        child: child,
                      );
                    }),
                        (Route route) => false),
          ),
          FlatButton(
            color: Colors.white,
            child: Text('ผู้ใช้ใหม่'
              ,style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'KanitRegular'),),
            onPressed: () async {
//                SharedPreferences prefs = await SharedPreferences.getInstance();
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.remove('s_USER_ID');
              await prefs.remove('i_EMP_ID');
              await prefs.remove('s_EMP_NO');
              await prefs.remove('s_USER_FNAME');
              await prefs.remove('s_USER_LNAME');
              await prefs.remove('s_USER_GENDER');
              await prefs.remove('user_Profile');
              await prefs.remove('token');
              await prefs.remove('token_Bearer');
              await prefs.remove('store_list');
              await prefs.remove('expiration');
              await prefs.remove('hasPin');
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
      ) : Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          FlatButton(
            color: Colors.white,
            child: Text('ผู้ใช้ใหม่'
              ,style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'KanitRegular'),),
            onPressed: () async {
//                SharedPreferences prefs = await SharedPreferences.getInstance();
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.remove('s_USER_ID');
              await prefs.remove('i_EMP_ID');
              await prefs.remove('s_EMP_NO');
              await prefs.remove('s_USER_FNAME');
              await prefs.remove('s_USER_LNAME');
              await prefs.remove('s_USER_GENDER');
              await prefs.remove('user_Profile');
              await prefs.remove('token');
              await prefs.remove('token_Bearer');
              await prefs.remove('store_list');
              await prefs.remove('expiration');
              await prefs.remove('hasPin');
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
      ),
    );
  }
  Future<void> clearAndCreateNewUser(String pin) async {
  }
  Future<void> _showSnackBar(String pin) async {
//  void _showSnackBar(String pin) {
    if(hasPin == null) {
      if (setpin_pageIndex == 0) {
        pinverify = pin;
        _pinPutController.text = '';
        setState(() {
          txt_status = 'ยืนยันรหัสผ่าน';
        });
        print('pinverify : ${pinverify}');
      } else {
        pinconfrim = pin;
        _pinPutController.text = '';
        print('pinconfrim : ${pinconfrim}');
      }
      if (setpin_pageIndex >= 1) {
        if (pinverify == pinconfrim) {
          pr.show();
          await _buildRegisterPin(globals.i_EMP_ID, globals.s_User_ID, IMEI, pinconfrim);
        } else {
          showDialogInvid('รหัสไม่ตรงกันกรุณาลองใหม่');
        }
      }
      setpin_pageIndex++;
    }else{
      pr.update(message: "กำลังตรวจสอบข้อมูล...");
      pr.show();
      await _buildCheckLoginPin(pin,IMEI,DeviceID,Serial,LatController.text,LongController.text);
    }
  }

  Future<void> _buildCheckLoginPin(String pin, String IMEI,String Device, String Serial,String Lat,String Long) async {
    try{
      NetworkService().postCheckLoginPin(pin,IMEI,Device,Serial,Lat,Long).then(
            (value) async {
          print('response CheckLoginPin : ${value}');

          if(value != null){
            var json = jsonDecode(value);
            var token = json['token'];
            var errorMessage = json['errorMessage'];
            var returnCode = json['returnCode'];

            if(errorMessage['isError'] == false && returnCode == "0000"){
              pr.hide();
              var expiration = token['expiration'];
              SharedPreferences prefs = await SharedPreferences.getInstance();
              var payload = Jwt.parseJwt(token['token']);
              print('payload StoreList ${payload}');
              var storelist = payload['stores'];
              var userProfile = json['userProfile'];
              await prefs.setString('s_USER_ID', userProfile['s_USER_ID'].toString());
              await prefs.setString('i_EMP_ID', userProfile['i_EMP_ID'].toString());
              await prefs.setString('s_EMP_NO', userProfile['s_EMP_NO'].toString());
              await prefs.setString('s_USER_FNAME', userProfile['s_USER_FNAME'].toString());
              await prefs.setString('s_USER_LNAME', userProfile['s_USER_LNAME'].toString());
              await prefs.setString('s_USER_GENDER', userProfile['s_USER_GENDER'].toString());
              await prefs.setString('s_PHONE_NO', userProfile['s_PHONE_NO'].toString());
              await prefs.setString('employeeType', userProfile['employeeType'].toString());
              await prefs.setString('s_EMP_TYPE', userProfile['s_EMP_TYPE'].toString());
              await prefs.setString('clientList', jsonEncode(userProfile['clients']));
              await prefs.setString('user_Profile', userProfile.toString());
              await prefs.setString('token', token['token']);
              await prefs.setString('token_Bearer', 'Bearer '+token['token']);
              await prefs.setString('token', token['token']);
              await prefs.setString('store_list', storelist);
              await prefs.setString('expiration', expiration);
              await prefs.setString('companyId', userProfile['companyId'].toString());
              final responseJson = jsonDecode('{"clients":'+prefs.getString('clientList')+'}'.toString());
              var data = ClientsRespose.fromJson(responseJson);
              ClientSum = data.clients.length;
              // ignore: unnecessary_statements
              ClientSum == 1 ? prefs.setString('Client' , data.clients[0].sClientCompCode) : null;
              ClientSum == 1 ? prefs.setString('ClientName' , data.clients[0].sNameTh) : null;
              ClientSum > 1 ? Navigator.pushAndRemoveUntil(
                  context,
                  PageRouteBuilder(pageBuilder: (BuildContext context, Animation animation,
                      Animation secondaryAnimation) {
                    return ChooseClient();
                  }, transitionsBuilder: (BuildContext context, Animation<double> animation,
                      Animation<double> secondaryAnimation, Widget child) {
                    return new SlideTransition(
                      position: new Tween<Offset>(
                        begin: const Offset(1.0, 0.0),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    );
                  }),
                      (Route route) => false)
                  :
              Navigator.pushAndRemoveUntil(
                  context,
                  PageRouteBuilder(pageBuilder: (BuildContext context, Animation animation,
                      Animation secondaryAnimation) {
                    return Launcher();
                  }, transitionsBuilder: (BuildContext context, Animation<double> animation,
                      Animation<double> secondaryAnimation, Widget child) {
                    return new SlideTransition(
                      position: new Tween<Offset>(
                        begin: const Offset(1.0, 0.0),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    );
                  }),
                      (Route route) => false);
            } else{
              pr.hide();
              var json = jsonDecode(value);
              var errorMessage = json['errorMessage'];
              print('errorMessage : ${errorMessage['errorText']}');
              showDialogInvid(errorMessage['errorText']);
            }
          }
          setState(() {});
        },
      );
    }catch (e){
      pr.hide();
      showDialogInvid(e.toString());
    }
  }
  Future<void> _buildRegisterPin(String EmpId, String UserId,String IMEI, String Pin) async {
    try{
      NetworkService().postRegisterPin(EmpId,UserId,IMEI,Pin).then(
            (value) async {
          print('response RegisterPin : ${value}');

          if(value != null){
            var json = jsonDecode(value);
            var errorMessage = json['errorMessage'];
            var returnCode = json['returnCode'];
            print('errorMessagevvvvvvvvvvvvvvv : ${errorMessage['isError']}');

            if(errorMessage['isError'] == false && returnCode == "0000"){
              pr.hide();
              showDialogSuccess("ตั้งรหัสสำเร็จ");
            } else{
              pr.hide();
              print("dddddddddddddddddd");
              var json = jsonDecode(value);
//                var token = json['token'];
              var errorMessage = json['errorMessage'];
              print('errorMessage : ${errorMessage['errorText']}');
              showDialogInvid(errorMessage['errorText']);
            }
          }
          setState(() {});
        },
      );
    }catch (e){
      pr.hide();
      showDialogInvid(e.toString());
    }
  }
  void showDialogSuccess(String message) {
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
                pr.hide();
                Navigator.of(dialogContext).pop(); // Dismiss alert dialog
                Navigator.pushAndRemoveUntil(
                    context,
                    PageRouteBuilder(pageBuilder: (BuildContext context, Animation animation,
                        Animation secondaryAnimation) {
                      return SplashscreenPage();
                    }, transitionsBuilder: (BuildContext context, Animation<double> animation,
                        Animation<double> secondaryAnimation, Widget child) {
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
                pr.hide();
                Navigator.of(dialogContext).pop(); // Dismiss alert dialog
                pinverify = null;
                pinconfrim = null;
                _pinPutController.text = '';
                setpin_pageIndex = 0;
                Navigator.pushAndRemoveUntil(
                    context,
                    PageRouteBuilder(pageBuilder: (BuildContext context, Animation animation,
                        Animation secondaryAnimation) {
                      return PincodePage();
                    }, transitionsBuilder: (BuildContext context, Animation<double> animation,
                        Animation<double> secondaryAnimation, Widget child) {
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