// import 'dart:async';
// import 'dart:convert';
// import 'dart:developer';
// import 'dart:ffi';
// import 'dart:io';
// import 'dart:typed_data';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:http/http.dart';
// import 'package:image_cropper/image_cropper.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:intl/intl.dart';
// import 'package:location/location.dart';
// import 'package:logger/logger.dart';
// import 'package:myapp/main.dart';
// import 'package:myapp/src/models/Model_Req.dart';
// import 'package:myapp/src/models/Model_Store.dart';
// import 'package:myapp/src/models/addorder_response.dart';
// import 'package:myapp/src/my_app.dart';
// import 'package:myapp/src/pages/home.dart';
// import 'package:myapp/src/pages/launcher.dart';
// import 'package:myapp/src/services/network_service.dart';
// import 'package:myapp/src/themes/login_theme.dart';
// import 'package:myapp/src/themes/main_theme.dart';
// import 'package:myapp/src/utils/Constant.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:tesseract_ocr/tesseract_ocr.dart';
// import 'package:path/path.dart' as p;
// import 'package:myapp/src/utils/globals.dart' as globals;
//
// class About extends StatefulWidget {
//   static const routeName = '/About';
//
//   @override
//   State<StatefulWidget> createState() {
//     return _AboutState();
//   }
// }
//
// class _AboutState extends State<About> {
//   int currentIndex = 0;
//   int _counter = 0;
//   File _imageFile;
//   dynamic _pickImageError;
//   NetworkService networkService;
//   String _valFriends;
//   var logger = Logger();
//   List Model_Store = [];
//   List data = List(); //edited line
//   String radioItem = 'Delivery Type';
//   String radioItemType = 'WA';
//   String extractText = '';
//   String imagePath = '';
//   final taxnoController = TextEditingController();
//   final receiptNoController = TextEditingController();
//   final SumPriceController = TextEditingController();
//   final StoreController = TextEditingController();
//   final LatController = TextEditingController();
//   final LongController = TextEditingController();
//   final Path_Imageheader = TextEditingController();
//
//   final Fname = TextEditingController();
//   final Lname = TextEditingController();
//   final UserID = TextEditingController();
//   List<ModelStore> StoreList = [];
//
//   final Location _locationService = Location();
//   StreamSubscription<LocationData> _locationSubscription;
//
//   void initState() {
//     networkService = NetworkService();
//     print('_locationService ${_locationService}');
//     _buildProfile();
//     trackingLocation();
//     super.initState();
//   }
//
//   int id = 1;
//   List<DeliveryTypeList> fList = [
//     DeliveryTypeList(
//       index: 1,
//       value: "WA",
//       name: "เดิน",
//     ),
//     DeliveryTypeList(
//       index: 2,
//       value: "BI",
//       name: "จักยาน",
//     ),
//     DeliveryTypeList(
//       index: 3,
//       value: "MO",
//       name: "มอเตอร์ไซค์",
//     ),
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         height: double.infinity,
//         decoration: BoxDecoration(gradient: MainTheme.gradient),
//         child: SingleChildScrollView(
//           child: Column(
//             children: <Widget>[
//               SizedBox(
//                 height: 16,
//               ),
//               Stack(children: <Widget>[
//                 Image.asset(
//                   Path_Imageheader.text,
//                   height: 140,
//                 ),
//                 new Positioned(
//                   top: 30,
//                   left: 10,
//                   child: Icon(
//                     Icons.account_circle,
//                     color: Colors.black87,
//                     size: 80.0,
//                     semanticLabel: 'Text to announce in accessibility modes',
//                   ), // or optionaly wrap the child in FractionalTranslation
//                 ),
//                 new Positioned(
//                     top: 36,
//                     left: 100,
//                     child: Text(
//                       'ยินดีต้อนรับ',
//                       style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold,
//                           fontFamily: 'KanitRegular'),
//                     )), //
//                 new Positioned(
//                     top: 63,
//                     left: 100,
//                     child: Text(
//                       Fname.text + ' ',
//                       style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 14,
//                           fontWeight: FontWeight.bold),
//                     )), //
//                 new Positioned(
//                     top: 83,
//                     left: 100,
//                     child: Text(
//                       'รหัสพนักงาน ' + UserID.text,
//                       style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 14,
//                           fontWeight: FontWeight.bold),
//                     )), //
//               ]),
//               Card(
//                 margin:
//                     EdgeInsets.only(left: 15, right: 15, top: 0, bottom: 18),
//                 shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10.0)),
//                 child: Padding(
//                   padding: const EdgeInsets.only(
//                       left: 22, right: 22, top: 22, bottom: 40),
//                   child: Column(
//                     children: <Widget>[
//                       Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: <Widget>[
//                             new Text(
//                               "อัพโหลด :  ",
//                               style: new TextStyle(
//                                   fontSize: 18,
//                                   color: Colors.indigo,
// //                                  fontWeight: FontWeight.w200,
//                                   fontFamily: 'KanitRegular'),
//                             ),
//                             FloatingActionButton(
//                               heroTag: "a3",
//                               backgroundColor: Colors.red,
//                               onPressed: () {
//                                 _pickImage(ImageSource.gallery);
//                               },
//                               child: Icon(Icons.photo_library),
//                             ),
//                             SizedBox(width: 10),
//                             FloatingActionButton(
//                               heroTag: "a1",
//                               backgroundColor: Constant.BG_CARD_HOME,
//                               onPressed: () {
//                                 _pickImage(ImageSource.camera);
//                               },
//                               child: Icon(Icons.camera_alt),
//                             ),
//                           ]),
//                       Divider(
//                         indent: 20,
//                         endIndent: 20,
//                         height: 22,
//                       ),
//                       SizedBox(height: 5),
//                       _buildImagePreview(),
//                       SizedBox(height: 5),
//                       Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: <Widget>[
//                             new Text(
//                               "รหัสร้าน :  ",
//                               style: new TextStyle(
//                                   fontSize: 18,
//                                   color: Colors.indigo,
//                                   fontFamily: "Roboto"),
//                             ),
//                             DropdownButton(
//                               hint: Text("กรุณาเลือก"),
//                               value: _valFriends,
//                               items: data.map((value) {
//                                 return DropdownMenuItem(
//                                   child: new Text(value['S_SM_LOCATION_CODE']),
//                                   value: value['S_SM_LOCATION_CODE'].toString(),
//                                 );
//                               }).toList(),
//                               onChanged: (value) {
//                                 setState(() {
//                                   _valFriends =
//                                       value; //Untuk memberitahu _valFriends bahwa isi nya akan diubah sesuai dengan value yang kita pilih
//                                 });
//                               },
//                             ),
//                           ]),
//                       TextField(
//                         controller: receiptNoController,
//                         keyboardType: TextInputType.number,
//                         decoration: InputDecoration(
//                           //  border: InputBorder.none,
//                           hintText: 'เลขที่ใบเสร็จ',
//                         ),
//                       ),
//                       TextField(
//                         controller: SumPriceController,
//                         keyboardType: TextInputType.number,
//                         decoration: InputDecoration(
//                           //  border: InputBorder.none,
//                           hintText: 'ราคาสุทธิ',
//                         ),
//                       ),
//                       SizedBox(height: 15),
//                       new Text(
//                         "ประเภทจัดส่ง",
//                         style: new TextStyle(
//                             fontSize: 18,
// //                                  color: const Color(0xFF000000),
//                             color: Colors.indigo,
// //                                  fontWeight: FontWeight.w200,
//                             fontFamily: "Roboto"),
//                       ),
//                       Column(
//                         children: fList
//                             .map((data) => RadioListTile(
//                                   title: Text("${data.name}"),
//                                   groupValue: id,
//                                   value: data.index,
//                                   onChanged: (val) {
//                                     setState(() {
//                                       radioItem = data.name;
//                                       radioItemType = data.value;
//                                       id = data.index;
//                                     });
//                                   },
//                                 ))
//                             .toList(),
//                       ),
//                       Divider(
//                         indent: 20,
//                         endIndent: 20,
//                         height: 22,
//                         color: MainTheme.nearlyDarkBlue,
//                       ),
//                       SizedBox(height: 15),
//                       _buildBtnSubmit(context),
//                       SizedBox(height: 10),
//                       _buildBtncancle(context),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: <Widget>[],
//                       )
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   _pickImage(ImageSource source) {
//     ImagePicker.pickImage(
//       source: source,
//       imageQuality: 100,
//       maxHeight: 5500,
//       maxWidth: 5500,
//     ).then((value) {
//       if (value != null) {
//         _imageFile = value;
//         _cropImage();
//       }
//     }).catchError((error) {
//       setState(() {
//         _pickImageError = error;
//       });
//     });
//   }
//
//   _cropImage() {
//     ImageCropper.cropImage(
//       sourcePath: _imageFile.path,
//       aspectRatioPresets: [
//         CropAspectRatioPreset.square,
//         CropAspectRatioPreset.ratio3x2,
//         CropAspectRatioPreset.original,
//         CropAspectRatioPreset.ratio4x3,
//         CropAspectRatioPreset.ratio16x9
//       ],
//       androidUiSettings: AndroidUiSettings(
//           toolbarTitle: 'Cropper',
//           toolbarColor: Colors.blue,
//           toolbarWidgetColor: Colors.white,
//           statusBarColor: Colors.black,
//           initAspectRatio: CropAspectRatioPreset.original,
//           lockAspectRatio: false),
//       iosUiSettings: IOSUiSettings(
//         minimumAspectRatio: 1.0,
//       ),
//       compressQuality: 100,
//       maxWidth: 5500,
//       maxHeight: 5500,
//       //circleShape: true
//     ).then((file) {
//       if (file != null) {
//         setState(() {
//           _imageFile = file;
//           imagePath = _imageFile.path;
//         });
//         ReadOcr();
//       }
//     });
//   }
//
//   void show_Dialog(String message) {
//     showDialog<void>(
//       context: context,
//       barrierDismissible: true,
//       builder: (BuildContext dialogContext) {
//         return AlertDialog(
//           content: Text(message),
//           actions: <Widget>[
//             FlatButton(
//               child: Text('ยกเลิก'),
//               onPressed: () {
//                 Navigator.of(dialogContext).pop(); // Dismiss alert dialog
//               },
//             ),
//             FlatButton(
//               child: Text('ตกลง'),
//               onPressed: () {
//                 Navigator.of(context).pushReplacement(
//                     new MaterialPageRoute(builder: (context) => MyApp()));
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   void showDialogInvid(String message) {
//     showDialog<void>(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext dialogContext) {
//         return AlertDialog(
//           content: Text(message),
//           actions: <Widget>[
//             FlatButton(
//               child: Text('ตกลง'),
//               onPressed: () {
//                 Navigator.of(dialogContext).pop(); // Dismiss alert dialog
//                 if (message != "กรุณากรอกข้อมูลให้ครบถ้วน") {
//                   Navigator.of(context).pushReplacement(
//                       new MaterialPageRoute(builder: (context) => MyApp()));
//                 }
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   Stack _buildBtnSubmit(BuildContext context) {
//     return Stack(
//       overflow: Overflow.visible,
//       alignment: Alignment.bottomCenter,
//       children: <Widget>[
//         Container(
//           width: 300,
//           height: 45,
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.all(Radius.circular(100)),
//             gradient: LinearGradient(
//               colors: [
//                 LoginTheme.btnSubmit,
//                 LoginTheme.btnSubmit,
//               ],
//             ),
//           ),
//           child: FlatButton(
//             textColor: Colors.white,
//             child: Text(
//               "ยืนยัน",
//               style: TextStyle(
//                 fontSize: 22,
//               ),
//             ),
//             onPressed: () async {
//               final recriptNO = receiptNoController.text;
//               final sumpri = SumPriceController.text;
//               if (_imageFile != null &&
//                   _valFriends != null &&
//                   radioItemType != null &&
//                   recriptNO != null &&
//                   sumpri != null) {
//                 _buildRegisOrder();
//               } else {
//                 showDialogInvid('กรุณากรอกข้อมูลให้ครบถ้วน');
//               }
//               print('click Upload');
//             },
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildImagePreview() {
//     if (_imageFile == null) {
//       return SizedBox();
//     }
//     return Image.file(
//       _imageFile,
//       width: double.infinity,
//       fit: BoxFit.cover,
//     );
//   }
//
//   Stack _buildBtncancle(BuildContext context) {
//     return Stack(
//       overflow: Overflow.visible,
//       alignment: Alignment.bottomCenter,
//       children: <Widget>[
//         Container(
//           width: 300,
//           height: 45,
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.all(Radius.circular(100)),
//             gradient: LinearGradient(
//               colors: [
//                 LoginTheme.btncancel,
//                 LoginTheme.btncancel,
//               ],
//             ),
//           ),
//           child: FlatButton(
//             textColor: Colors.white,
//             child: Text(
//               "ยกเลิก",
//               style: TextStyle(
//                 fontSize: 22,
//               ),
//             ),
//             onPressed: () async {
//               setState(() {});
//               return;
//             },
//           ),
//         ),
//         Container(
//           width: 150,
//           height: 45,
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.all(Radius.circular(5)),
//             gradient: LinearGradient(
//               colors: [
//                 LoginTheme.btncancel,
//                 LoginTheme.btncancel,
//               ],
//             ),
//           ),
//           child: FlatButton(
//             textColor: Colors.white,
//             child: Text(
//               "ยกเลิก",
//               style: TextStyle(
//                 fontSize: 22,
//               ),
//             ),
//             onPressed: () async {
//               print('Click Cancel');
//               show_Dialog('คุณต้องการยกเลิกใบเสร็จนี้หรือไม่');
//             },
//           ),
//         ),
//       ],
//     );
//   }
//
//   Future<void> _buildProfile() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     var s_USER_FNAME = prefs.getString('s_USER_FNAME');
//     var s_USER_LNAME = prefs.getString('s_USER_LNAME');
//     var i_EMP_ID = prefs.getString('s_EMP_NO');
//     Fname.text = s_USER_FNAME.toString();
//     Lname.text = s_USER_LNAME.toString();
//     UserID.text = i_EMP_ID.toString();
//     print('s_USER_FNAME ${s_USER_FNAME}');
//     print('s_USER_LNAME ${s_USER_LNAME}');
//     print('i_EMP_ID ${i_EMP_ID}');
//     var token_Bearer = prefs.getString('token_Bearer');
//     print('token_Bearer ${token_Bearer}');
//     var store_list = prefs.getString('store_list');
//     print('store_list ${store_list}');
//     var resBody = json.decode(store_list);
//     setState(() {
//       data = resBody;
//     });
//     print(resBody);
//   }
//
//   Future<void> _buildConvert(String extract_Text) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     var token_Bearer = prefs.getString('token_Bearer');
//     NetworkService().ConvertSlip711(token_Bearer, extract_Text).then(
//       (value) async {
//         print('response ConvertSlip711 : ${value}');
//         var json = jsonDecode(value);
//         receiptNoController.text = json['receiptNo'] ?? '';
//         SumPriceController.text = json['netPrice'] ?? '';
//         print(
//             'response ConvertSlip711 receiptNoController : ${receiptNoController.text}');
//         print(
//             'response ConvertSlip711 receiptNoController : ${SumPriceController.text}');
//         if (json['storeNo'] != "") {
//           var myList = data.toString();
//           print('response ConvertSlip711 myListstore : ${myList}');
//           var checkstoreinlist = myList.contains(json['storeNo'].toString());
//           if (checkstoreinlist) {
//             setState(() {
//               _valFriends = json['storeNo'];
//             });
//             print('มีร้านในโปรไฟล');
//           } else {
//             print('ไม่มีร้านในโปรไฟล');
//           }
//         }
//       },
//     );
//   }
//
//   Future<void> _buildRegisOrder() async {
//     await trackingLocation();
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     final store = StoreController.text;
//     final recriptNO = receiptNoController.text;
//     final sumpri = SumPriceController.text;
//     var lat = LatController.text;
//     var long = LongController.text;
//     log('latssssssssssss :${lat}');
//     log('longsssssssssssss :${long}');
//     var i_EMP_ID = prefs.getString('s_EMP_NO');
//     print('i_EMP_ID ${i_EMP_ID}');
//     var token_Bearer = prefs.getString('token_Bearer');
//     print('token_Bearer ${token_Bearer}');
//     DateTime now = DateTime.now();
//     String datenow = DateFormat('yyyy-MM-dd hh:mm:ss').format(now);
//     String dateend = DateFormat('yyyy-MM-dd hh:mm:ss').format(now);
//     String datestart = DateFormat('yyyy-MM-dd').format(now);
//     String datestartplus = datestart + ' 00:00:00';
//     print('datestart ${datestartplus}');
//     print('dateend ${dateend}');
//     var textocr = extractText.replaceAll('\\', '');
//     print('textocr : ${textocr}');
// //    String jsonall = '';
// //    try{
//     Map<String, dynamic> toJson() => {
//           'S_STORE_NO': '"' + _valFriends + '"',
//           'D_DO': '"' + datenow.toString() + '"',
//           'D_DELIVERY': '"' + datenow.toString() + '"',
//           'S_DELIVERY_TYPE': '"' + radioItemType + '"',
//           'I_EMP_ID': i_EMP_ID,
//           'S_RECEIPT_ID': '"' + recriptNO + '"',
//           'F_TOTAL_AMOUNT': sumpri,
//           'S_DO_ORIGIN_LAT': '"' + lat + '"',
//           'S_DO_ORIGIN_LONG': '"' + long + '"',
//           'S_DO_SHIPTO_LAT': '"' + lat + '"',
//           'S_DO_SHIPTO_LONG': '"' + long + '"',
//           'S_REF_TEXT': '"' + textocr + '"',
//         };
//     print('json regisOrder : ${toJson().toString()}');
//     print('jsonrequesttttttt : ${toJson()}');
//     NetworkService()
//         .postDeliveryOrder(_imageFile, token_Bearer, toJson().toString())
//         .then(
//       (value) async {
//         print('response postDeliveryOrder : ${value}');
//         if ('200' == value) {
//           showDialogInvid('ดำเนินการเสร็จสิ้น');
//         } else {
//           print("dddddddddddddddddd");
//           showDialogInvid('พบข้อผิดพลาดกรุณาลองใหม่อีกครั้ง');
//         }
//         return Center(
//           child: RefreshProgressIndicator(),
//         );
//       },
//     );
//   }
//
//   trackingLocation() async {
//     final Location _locationService = Location();
//     await _locationService.changeSettings(
//       accuracy: LocationAccuracy.HIGH,
//       interval: 10000,
//       distanceFilter: 100,
//     ); // meters.
//     if (await _locationService.serviceEnabled()) {
//       var locationupdate = await _locationService.getLocation();
//       LatController.text = locationupdate.latitude.toString();
//       LongController.text = locationupdate.longitude.toString();
//       print('latin____location ${LatController.text}');
//       print('long_____inlocation ${LongController.text}');
//       print('_locationService.serviceEnabled');
//       if (await _locationService.requestPermission() ==
//           PermissionStatus.GRANTED) {
//         print('_locationService.requestPermission');
//         _locationSubscription = _locationService.onLocationChanged().listen(
//           (LocationData result) async {
//             final latLng = LatLng(result.latitude, result.longitude);
//             LatController.text = result.latitude.toString();
//             LongController.text = result.longitude.toString();
//             print('latinlocation ${LatController.text}');
//             print('longinlocation ${LongController.text}');
//           },
//         );
//       } else {
//         print('Permission denied');
//       }
//     } else {
//       print('_locationService.serviceDisable');
//       bool serviceStatusResult = await _locationService.requestService();
//       print("Service status activated after request: $serviceStatusResult");
//     }
//   }
//
//   Future<Widget> ReadOcr() async {
//     print('ReadOcr Start');
//     if (_imageFile != null && extractText == '') {
//       print('ajksdhfiehfow ${imagePath}');
//       Uint8List byteData = new File(imagePath).readAsBytesSync();
//       ByteData data = ByteData.view(byteData.buffer);
//       final Uint8List bytes = data.buffer.asUint8List(
//         data.offsetInBytes,
//         data.lengthInBytes,
//       );
//       await File(imagePath).writeAsBytes(bytes);
//       print('extractTextsssssadas');
//       extractText = await TesseractOcr.extractText(imagePath, language: "Thai");
//       print(extractText);
//       _buildConvert(extractText);
//     }
//     return SizedBox();
//   }
// }
//
// class DeliveryTypeList {
//   String name;
//   String value;
//   int index;
//
//   DeliveryTypeList({this.name, this.index, this.value});
// }
//
// class Datareq {
//   String S_STORE_NO;
//   DateTime D_DO;
//   DateTime D_DELIVERY;
//   String S_DELIVERY_TYPE;
//   String S_RECEIPT_ID;
//   Double F_TOTAL_AMOUNT;
//   int I_EMP_ID;
//
//   Datareq(
//       {this.S_STORE_NO,
//       this.D_DO,
//       this.D_DELIVERY,
//       this.S_DELIVERY_TYPE,
//       this.S_RECEIPT_ID,
//       this.F_TOTAL_AMOUNT,
//       this.I_EMP_ID});
// }
