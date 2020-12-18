import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:logger/logger.dart';
import 'package:myapp/src/models/Model_Store.dart';
import 'package:myapp/src/pages/launcher.dart';
import 'package:myapp/src/services/Strings.dart';
import 'package:myapp/src/services/network_service.dart';
import 'package:myapp/src/themes/login_theme.dart';
import 'package:myapp/src/themes/main_theme.dart';
import 'package:path_provider/path_provider.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart' as p;
import 'package:myapp/src/utils/globals.dart' as globals;
ProgressDialog pr;

class ProfileEdit extends StatefulWidget {
  static const routeName = '/ProfileEdit';

  @override
  State<StatefulWidget> createState() {
    return _ProfileEditState();
  }
}

class _ProfileEditState extends State<ProfileEdit> {
  int currentIndex = 0;
  File _imageFile;
  NetworkService networkService;
  dynamic _pickImageError;
  String _valTypeLeave;
  var logger = Logger();
  List Model_Store = [];
  List data = List(); //edited line
  String radioItem = 'Delivery Type';
  String radioItemType = 'WA';
  String extractText = '';
  String statusLeave = 'LG01';
  String typesubmit = '';
  String imagePath = '';
  bool Directory_Path1;
  final taxnoController = TextEditingController();
  final receiptNoController = TextEditingController();
  final datetimeEndController = TextEditingController();
  final datetimeStartController = TextEditingController();
  final discriptionController = TextEditingController();
  final Path_Imageheader = TextEditingController();

  final FnameController = TextEditingController();
  final LnameController = TextEditingController();
  final phoneController = TextEditingController();
  var _data = null;
  var txt_name = '';
  var txt_Lname = '';
  var txt_Fname = '';
  var txt_phone = '';
  final SumPriceController = TextEditingController();
  final StoreController = TextEditingController();
  final LatController = TextEditingController();
  final LongController = TextEditingController();

  final Path_ImageProfile = TextEditingController();
  final datePre = TextEditingController();
  final timePre = TextEditingController();
  final format = DateFormat("dd/MM/yyyy HH:mm");
  final formatTime = DateFormat("HH:mm");
  final Fname = TextEditingController();
  final Lname = TextEditingController();
  final phoneNo = TextEditingController();
  final UserID = TextEditingController();
  List<ModelStore> StoreList = [];
  var datestartService = null;
  var dateendService = null;
  var datestart = null;
  var timestart = null;
  var dateend = null;
  var timeend = null;
  bool chacklocalImage;
  @override
  void initState() {
    networkService = NetworkService();
    String datestart1 = DateFormat('yyyy-MM-dd').format(DateTime.now());
    String datestartplus = datestart1 + ' 08:00';
    String dateend1 = DateFormat('yyyy-MM-dd').format(DateTime.now());
    String dateendplus = dateend1 + ' 18:00';
    datestart = DateTime.parse(datestartplus);
    dateend = DateTime.parse(dateendplus);
    _buildGetTypeLeave();
    super.initState();
  }
  @override
  void setState(fn) {
    if(mounted) {
      super.setState(fn);
    }
  }
  int id = 1;
  @override
  Widget build(BuildContext context) {
    pr = ProgressDialog(context,type: ProgressDialogType.Normal, isDismissible: false, showLogs: false);
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
                EdgeInsets.only(left: 10, right: 10, top: 15, bottom: 18),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 13, right: 13, top: 22, bottom: 40),
                  child: Column(
                    children: <Widget>[
                      Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Stack(
                              overflow: Overflow.visible,
                              alignment: Alignment.bottomCenter,
                              children: <Widget>[
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(100)),
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
                                        borderRadius: BorderRadius.circular(
                                            100),
                                        child: globals.user_Path == null ?
                                        Image.asset(
                                            globals.Path_ImageProfile,
                                            width: 70,
                                            height: 70,
                                            fit: BoxFit.fill
                                        ) :
                                        Image.file(File(globals.user_Path),width: 70,
                                            height: 70,
                                            fit: BoxFit.fill),
                                      ),
                                      radius: 40,
                                    ),
                                    onPressed: () async {
                                     await _pickImage(ImageSource.camera);
                                    },
                                  ),
                                ),
                                Positioned(
                                  left: 70,
                                  right: 0,
                                  bottom: 0,
                                  top: 35,
                                  child: Icon(
                                      Icons.camera_alt,
                                      color: Colors.black, size: 25
                                  ),),
                              ],
                            ),
                            Text(
                              ' เปลี่ยนรูปโปรไฟล์',
                              style: new TextStyle(
                                  fontSize: 21,
                                  color: Colors.black87,
                                  fontFamily: 'KanitRegular'),
                            ),
                          ]),
                      SizedBox(height: 10),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.start
                          ,
                          children: <Widget>[
                            Text(
                              'ชื่อ',
                              style: new TextStyle(
                                  fontSize: 18,
                                  color: Colors.black87,
                                  fontFamily: 'KanitRegular'),
                            ),
                          ]),
                      TextField(
                        controller: FnameController,
                        keyboardType: TextInputType.text,
                        style: new TextStyle(
                            fontSize: 15,
                            color: Colors.black87,
                            fontFamily: 'KanitRegular'),
                        decoration: InputDecoration(
                          hintText: '',
                        ),
                      ),
                      SizedBox(height: 5),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'สกุล',
                              style: new TextStyle(
                                  fontSize: 18,
                                  color: Colors.black87,
//                                  fontWeight: FontWeight.w200,
                                  fontFamily: 'KanitRegular'),
                            ),
                          ]),
                      TextField(
                        controller: LnameController,
                        keyboardType: TextInputType.text,
                        style: new TextStyle(
                            fontSize: 15,
                            color: Colors.black87,
                            fontFamily: 'KanitRegular'),
                        decoration: InputDecoration(
                          hintText: '',
                        ),
                      ),
                      SizedBox(height: 5),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.start
                          ,
                          children: <Widget>[
                            Text(
                              'เบอร์โทร',
                              style: new TextStyle(
                                  fontSize: 18,
                                  color: Colors.black87,
                                  fontFamily: 'KanitRegular'),
                            ),
                          ]),
                      TextField(
                        controller: phoneController,
                        keyboardType: TextInputType.number,
                        maxLength: 10,
                        style: new TextStyle(
                            fontSize: 15,
                            color: Colors.black87,
                            fontFamily: 'KanitRegular'),
                        decoration: InputDecoration(
                          hintText: '',
                        ),
                      ),
                      SizedBox(height: 15),
                      Column(children: <Widget>[
                        SizedBox(height: 15),
                      ]),
                      SizedBox(height: 20),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Column(children: <Widget>[
                              _buildBtnSubmit(context),
                            ]),
                            SizedBox(width: 5),
                            Column(children: <Widget>[
                              _buildBtncancle(context),
                            ]),
                          ]),
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
  _pickImage(ImageSource source) {
    ImagePicker.pickImage(
      source: source,
      imageQuality: 15,
      maxHeight: 5500,
      maxWidth: 5500,
    ).then((value) async {
      if (value != null) {
          _imageFile = value;
       await _cropImage();
      }
    }).catchError((error) {
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
      compressQuality: 15,
      maxWidth: 5500,
      maxHeight: 5500,
      //circleShape: true
    ).then((file) {
      if (file != null) {
        setState(() {
          _imageFile = file;
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
                final BottomNavigationBar navigationBar = navBarGlobalKey.currentWidget;
                navigationBar.onTap(9);
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

  void showDialog_Success(String message) {
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
              Strings.btn_Submit,
              style: TextStyle(fontSize: 22, fontFamily: 'KanitRegular'),
            ),
            onPressed: () async {
              if (FnameController.text != null &&
                  LnameController.text != null &&
                  phoneController.text != null) {
                if (_imageFile != null) {
                  print('ข้อมูลครบ มี รูป');
                  pr.show();
                  await buildPostEditProfile();
                  pr.hide();
                }else{
                  showDialogInvid('กรุณาเลือกรูป');
                }
              } else {
                print('ข้อมูลไม่ครบ');
                showDialogInvid('กรุณากรอกข้อมูลให้ครบถ้วน');
              }
              print('click Upload');
            },
          ),
        ),
      ],
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
              Strings.btn_Cancel,
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
              show_Dialog('คุณต้องการยกเลิกใช่หรือไม่');
            },
          ),
        ),
      ],
    );
  }
  Future<void> _buildGetTypeLeave() async {
    NetworkService().postGetTypeLeave().then(
          (value) async {
        print('response postGetTypeLeave : ${value}');
        var json = jsonDecode(value);
        var errorMessage = json['errorMessage'];

        if (errorMessage['isError'] == false) {
          if (json['values'] != "") {
            var resBody = json['values'];
            setState(() {
              data = resBody;
            });
          }
        }
      },
    );
  }

  Future<void> buildPostEditProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> toJson() =>
        {
          'I_EMP_ID': '"' + globals.i_EMP_ID + '"',
          'S_USER_FNAME': '"' + FnameController.text + '"',
          'S_USER_LNAME': '"' + LnameController.text + '"',
          'S_PHONE_NO': '"' + phoneController.text + '"',
        };
   await NetworkService().postEditProfile(
       _imageFile,
        toJson().toString()).then(
          (value) async {
        if ('200' == value) {
          Directory appDocDir = await getApplicationDocumentsDirectory();
          String path = appDocDir.path;
          final fileName = p.basename(_imageFile.path);
          await prefs.setString('Directory_Path', path+'/');
          await prefs.setBool('Directory_Path_bool', true);
          await prefs.setBool('localImage_bool', true);
          final File localImage = await _imageFile.copy('$path/$fileName');
          await prefs.setString('localImage', localImage.path);
          await prefs.setString('user_localImage${globals.s_User_ID}', localImage.path);
          globals.Fname = FnameController.text;
          globals.Lname = LnameController.text;
          globals.sPhoneNo = phoneController.text;
          var localImage1;
          bool chacklocalImage;
          bool Directory_Path;
          Directory_Path = prefs.getBool('Directory_Path_bool');
          if (Directory_Path != null) {
            chacklocalImage = prefs.getBool('localImage_bool');
            localImage1 = prefs.getString('localImage').toString();
            globals.user_Path = prefs.getString('user_localImage${globals.s_User_ID}');
            if (globals.user_Path == null) {
              globals.user_Path = "assets/images/Profile_1.jpg";
            }
          } else {
            chacklocalImage = prefs.getBool('localImage_bool');
          }
          var employeeType = prefs.getString('employeeType');
          if (employeeType.toString() != 'Supplier') {
            chacklocalImage == null
                ? globals.Path_ImageProfile = "assets/images/Profile_1.jpg"
                : globals.Path_ImageProfile = localImage.toString();
            globals.Path_Imageheader = "assets/images/header_main.jpg";
          } else {
            chacklocalImage == null
                ? globals.Path_ImageProfile = "assets/images/Profile_Store.jpg"
                : globals.Path_ImageProfile = localImage1;
            globals.Path_Imageheader = "assets/images/header_main_admin.jpg";
          }
          pr.hide();
            showDialog_Success('ดำเนินการเสร็จสิ้น');
        } else {
          pr.hide();
          showDialogInvid('พบข้อผิดพลาดกรุณาลองใหม่อีกครั้ง');
        }
        return Center(
          child: RefreshProgressIndicator(),
        );
      },
    );
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
  Datareq({this.S_STORE_NO,
    this.D_DO,
    this.D_DELIVERY,
    this.S_DELIVERY_TYPE,
    this.S_RECEIPT_ID,
    this.F_TOTAL_AMOUNT,
    this.I_EMP_ID});
}
