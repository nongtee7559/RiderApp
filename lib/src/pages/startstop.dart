import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:logger/logger.dart';
import 'package:myapp/src/models/CheckLocationResponse.dart';
import 'package:myapp/src/models/Model_Store.dart';
import 'package:myapp/src/my_app.dart';
import 'package:myapp/src/pages/launcher.dart';
import 'package:myapp/src/services/network_service.dart';
import 'package:myapp/src/themes/login_theme.dart';
import 'package:myapp/src/themes/main_theme.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart' as p;
import 'package:toggle_switch/toggle_switch.dart';
import 'package:myapp/src/utils/globals.dart' as globals;

ProgressDialog pr;

class Startstop extends StatefulWidget {
  static const routeName = '/Startstop';

  @override
  State<StatefulWidget> createState() {
    return _StartstopState();
  }
}

class _StartstopState extends State<Startstop> {
  int currentIndex = 0;
  File _imageFile;
  dynamic _pickImageError;
  NetworkService networkService;
  String _valFriends;
  File _imageFileprofile;
  bool Directory_Path1;
  var logger = Logger();
  List Model_Store = [];
  List data = List(); //edited line
  String radioItem = 'Delivery Type';
  String radioItemType = 'WA';
  String extractText = '';
  String statusInOut = 'IN';
  String S_CLIENT_COMP_CODE = '';
  String S_3PL_COMP_CODE = '';
  String S_LOCATION_CODE = '';
  String S_LOCATION_TYPE = '';

  bool StatusReplace = false;

  String imagePath = '';
  final taxnoController = TextEditingController();
  final receiptNoController = TextEditingController();
  final SumPriceController = TextEditingController();
  final StoreController = TextEditingController();
  final LatController = TextEditingController();
  final LongController = TextEditingController();
  final Path_Imageheader = TextEditingController();
  final Path_ImageProfile = TextEditingController();
  final datePre = TextEditingController();
  final timePre = TextEditingController();
  List<ModelStore> StoreList = [];
  @override
  void initState() {
    networkService = NetworkService();
    datePre.text = DateFormat('dd/MM/yyyy').format(DateTime.now()).toString();
    timePre.text = DateFormat('kk:mm:ss').format(DateTime.now()).toString();
    trackingLocation();
    _buildCheckStatusSubstitute();
    super.initState();
  }
  @override
  void setState(fn) {
    if(mounted) {
      super.setState(fn);
    }
  }
  // Group Value for Radio Button.
  int id = 1;

  @override
  Widget build(BuildContext context) {
    pr = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false, showLogs: false);
    pr.style(message: 'Please wait...');

    return Scaffold(
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(gradient: MainTheme.gradient),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Card(
                margin:
                    EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 18),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 22, right: 22, top: 22, bottom: 40),
                  child: Column(
                    children: <Widget>[
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            FloatingActionButton(
                              heroTag: "a1",
                              backgroundColor: MainTheme.bgcamera,
                              onPressed: () async {
                                await pr.update(message: "กำลังค้นหาตำเเหน่ง");
                                await pr.show();
                                try {
                                  await trackingLocation();
                                } catch (e) {
                                  showDialogException("trackingLocation", e);
                                }
                                await _buildCheckLocation();
                                await pr.hide();
                              },
                              child: Icon(
                                Icons.camera_alt,
                                color: Colors.black87,
                                size: 40.0,
                              ),
                            ),
                          ]),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            new Text(
                              "กรุณาถ่ายภาพ",
                              style: new TextStyle(
                                  fontSize: 18,
                                  color: Colors.black87,
//                                  fontWeight: FontWeight.w200,
                                  fontFamily: 'KanitRegular'),
                            ),
                          ]),

                      //_buildPassword(),
                    ],
                  ),
                ),
              ),
              ToggleSwitch(
                  minWidth: 150.0,
                  cornerRadius: 0,
                  activeBgColor: Colors.white,
                  activeTextColor: Colors.white,
                  inactiveBgColor: Colors.grey,
                  inactiveTextColor: Colors.white,
                  labels: ['เวลาเข้างาน', 'เวลาเลิกงาน'],

//                  icons: [FontAwesomeIcons.locationArrow, FontAwesomeIcons.locationArrow],
                  activeColors: [MainTheme.bgcamera, MainTheme.bgcamera],
                  onToggle: (index) {
                    if (index == 0) {
                      statusInOut = "IN";
                    } else {
                      statusInOut = "OUT";
                    }
                    print('switched to: $index');
                  }),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
//                            SizedBox(height: 20),

                    Column(children: <Widget>[
                      SizedBox(height: 25),
                      _buildImagePreview(),
                    ]),

                    SizedBox(width: 16),
                    Column(children: <Widget>[
                      Text(
                        'วันที่ ' + datePre.text,
                        style: TextStyle(
                            //fontWeight: FontWeight.bold
                            color: MainTheme.txtcolor,
                            fontSize: 20,
                            fontFamily: 'KanitRegular'),
                      ),
                      _buildDivider1(),
                      Text(
                        'เวลา ' + timePre.text + 'น.',
                        style: TextStyle(
                            color: MainTheme.txtcolor,
                            fontSize: 20,
                            fontFamily: 'KanitRegular'),
                      ),
                      _buildDivider1(),
                    ]),
                  ]),
              SizedBox(height: 50),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
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

  _pickImage(ImageSource source) {
    setState(() {
      datePre.text = DateFormat('dd/MM/yyyy').format(DateTime.now()).toString();
      timePre.text = DateFormat('kk:mm:ss').format(DateTime.now()).toString();
    });
    ImagePicker.pickImage(
      source: source,
      imageQuality: 40,
      maxWidth: 300,
      maxHeight: 300,
    ).then((value) {
      if (value != null) {
        setState(() {
          _imageFile = value;
          imagePath = _imageFile.path;
        });
        // _cropImage();
      }
    }).catchError((error) {
      showDialogException("error image_picker", error);
      setState(() {
        _pickImageError = error;
      });
    });
  }

  _cropImage() {
    ImageCropper.cropImage(
      sourcePath: _imageFile.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ],
      androidUiSettings: AndroidUiSettings(
          toolbarTitle: 'Cropper',
          toolbarColor: Colors.blue,
          toolbarWidgetColor: Colors.white,
          statusBarColor: Colors.black,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false),
      iosUiSettings: IOSUiSettings(
        minimumAspectRatio: 1.0,
      ),
      compressQuality: 40,
      maxWidth: 300,
      maxHeight: 300,
      //circleShape: true
    ).then((file) {
      if (file != null) {
        setState(() {
          _imageFile = file;
          imagePath = _imageFile.path;
        });
      }
    });
  }

  void show_Dialog(String message) {
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      // false = user must tap button, true = tap outside dialog
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          content: Text(message),
          actions: <Widget>[
            FlatButton(
              child: Text('ยกเลิก'),
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Dismiss alert dialog
              },
            ),
            FlatButton(
              child: Text('ตกลง'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
                Navigator.of(context).pushReplacement(
                    new MaterialPageRoute(builder: (context) => Launcher()));
              },
            ),
          ],
        );
      },
    );
  }

  void showDialogCheckLocation(String message) {
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
              },
            ),
          ],
        );
      },
    );
  }

  void showDialogSuccess(String message, String status) {
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
                final BottomNavigationBar navigationBar =
                    navBarGlobalKey.currentWidget;
                navigationBar.onTap(0);
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
              onPressed: () async {
                await pr.hide();
                Navigator.of(dialogContext).pop(); // Dismiss alert dialog
                Navigator.of(context).pushReplacement(
                    new MaterialPageRoute(builder: (context) => Launcher()));
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
                Navigator.of(dialogContext).pop(); // Dismiss alert dialog
                if (message != "กรุณากรอกข้อมูลให้ครบถ้วน") {
                  final BottomNavigationBar navigationBar =
                      navBarGlobalKey.currentWidget;
                  navigationBar.onTap(0);
                }

//                Navigator.pushReplacementNamed(context, Constant.HOME_ROUTE);
              },
            ),
          ],
        );
      },
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
              final recriptNO = receiptNoController.text;
              final sumpri = SumPriceController.text;

              if (_imageFile != null && statusInOut != null) {
                await pr.show();
                await _buildStartstop();
              } else {
                showDialogInvid('กรุณากรอกข้อมูลให้ครบถ้วน');
              }

              print('click Upload');
            },
          ),
        ),
      ],
    );
  }

  Widget _buildImagePreview() {
    print("_buildImagePreviewsssaacas");

    if (_imageFile == null) {
      return Image.asset(
        'assets/images/person.png',
        height: 170,
        width: 170,
        fit: BoxFit.cover,
      );
    }
    return Image.file(
      _imageFile,
      height: 170,
      width: 170,
//      width: double.infinity,
      fit: BoxFit.cover,
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
              setState(() {});
              return;
            },
          ),
        ),
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
              print('Click Cancel');
              show_Dialog('คุณต้องการยกเลิกการเริ่มงานหรือไม่');
            },
          ),
        ),
      ],
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
            setState(() {
              StatusReplace = json['isWait'];
            });
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
    } catch (e) {
      showDialogInvid(e.toString());
    }
  }

  Future<void> _buildStartstop() async {
    await pr.update(message: "กำลังบันทึกข้อมูล...");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final store = StoreController.text;
    final recriptNO = receiptNoController.text;
    final sumpri = SumPriceController.text;
    var lat = LatController.text;
    var long = LongController.text;
    var ClientCode = prefs.getString('Client');
    Map<String, dynamic> toJson() => {
          'I_EMP_ID': '"' + globals.i_EMP_ID + '"',
          'S_TYPE': '"' + statusInOut + '"',
          'S_LAT': '"' + lat + '"',
          'S_LONG': '"' + long + '"',
          'S_CLIENT_COMP_CODE': '"' + ClientCode + '"',
          'S_3PL_COMP_CODE': '"' + globals.companyId + '"',
          'S_LOCATION_CODE': '"' + S_LOCATION_CODE + '"',
          'S_LOCATION_TYPE': '"' + S_LOCATION_TYPE + '"',
          'S_LOCATION_COMP_CODE': '"' + S_3PL_COMP_CODE + '"',
        };
    try {
      await NetworkService()
          .postStartStopWorking(_imageFile, toJson().toString())
          .then(
        (value) async {
          if (value == 400) {
            await pr.hide();
            showDialogCheckLocation('กรุณาเลือกเข้างานก่อน');
          } else {
            await pr.hide();
            if (value == 200) {
              showDialogSuccess('ดำเนินการเสร็จสิ้น', statusInOut);
            } else if (value == null) {
              showDialogInvid('พบข้อผิดพลาดเกี่ยวกับอินเตอร์เน็ต');
            } else {
              showDialogInvid('$value พบข้อผิดพลาดกรุณาลองใหม่อีกครั้ง');
            }
          }
          return Center(
            child: RefreshProgressIndicator(),
          );
        },
      );
    } catch (e) {
      await pr.hide();
      showDialogInvid(e.toString());
    }
  }

  _buildCheckLocation() async {
    await pr.update(message: "ตรวจสอบตำเเหน่งกับร้าน");
    try {
      NetworkService()
          .postCheckLocation(
              globals.i_EMP_ID, LatController.text, LongController.text)
          .then(
        (value) async {
          var json = jsonDecode(value);
          var errorMessage = json['errorMessage'];
          if (errorMessage['isError'] == false) {
            final responseJson = jsonDecode(value.toString());
            var data = CheckLocationResponse.fromJson(responseJson);
            if (data.responsemaster.isEmpty) {
              await pr.hide();
              showDialogCheckLocation(
                  'ขณะนี้คุณอยู่นอกพื้นที่กรุณาขยับให้อยู่ในเขตพื้นที่ร้าน');
            } else {
              S_3PL_COMP_CODE = data.responsemaster[0].plCompcode.toString();
              S_LOCATION_CODE = data.responsemaster[0].storeCode.toString();
              S_LOCATION_TYPE = data.responsemaster[0].locationType.toString();
              await pr.hide();
              _pickImage(ImageSource.camera);
            }
            setState(() {
              return Center(
                child: RefreshProgressIndicator(),
              );
            });
          } else {
            await pr.hide();
            showDialogAcceap('ไม่พบตำเเหน่งกรุณาลองใหม่');
          }
          return Center(
            child: RefreshProgressIndicator(),
          );
        },
      );
    } catch (e) {
      await pr.hide();
      showDialogInvid(e);
    }
  }

  trackingLocation() async {
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
        if (await _locationService.requestPermission() ==
            PermissionStatus.GRANTED) {
          _locationService.onLocationChanged().listen(
            (LocationData result) async {
              LatController.text = result.latitude.toString();
              LongController.text = result.longitude.toString();
            },
          );
        }
      }
    } on Exception catch (exception) {
      showDialogException('Exception : ', exception.toString());
    } catch (error) {
      showDialogException('Error : ', error.toString());
    }
  }
}

class DeliveryTypeList {
  String name;
  String value;
  int index;

  DeliveryTypeList({this.name, this.index, this.value});
}

class Datareq {
  String S_STORE_NO;
  DateTime D_DO;
  DateTime D_DELIVERY;
  String S_DELIVERY_TYPE;
  String S_RECEIPT_ID;
  Double F_TOTAL_AMOUNT;
  int I_EMP_ID;

  Datareq(
      {this.S_STORE_NO,
      this.D_DO,
      this.D_DELIVERY,
      this.S_DELIVERY_TYPE,
      this.S_RECEIPT_ID,
      this.F_TOTAL_AMOUNT,
      this.I_EMP_ID});
}

Row _buildDivider1() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: const [MainTheme.bgcamera, MainTheme.bgcamera],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.0, 1.0],
          ),
        ),
        width: 150,
        height: 2,
      )
    ],
  );
}
