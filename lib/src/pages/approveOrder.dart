import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:myapp/src/models/DeliveryOrderHeaders_Response.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:logger/logger.dart';
import 'package:myapp/src/models/DeliveryOrderDetails_Response.dart';
import 'package:myapp/src/models/Model_Store.dart';
import 'package:myapp/src/models/PendingdetailResponse.dart';
//import 'package:myapp/src/models/DeliveryOrderDetails_Response.dart';
import 'package:myapp/src/my_app.dart';
import 'package:myapp/src/pages/jobalert.dart';
import 'package:myapp/src/pages/launcher.dart';
import 'package:myapp/src/services/network_service.dart';
import 'package:myapp/src/themes/login_theme.dart';
import 'package:myapp/src/themes/main_theme.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tesseract_ocr/tesseract_ocr.dart';
import 'package:path/path.dart' as p;
import 'package:myapp/src/themes/custom_expansion_tile.dart' as custom;

import 'package:myapp/src/utils/globals.dart' as globals;
ProgressDialog pr;

class ApproveOrder extends StatefulWidget {
  static const routeName = '/approveOrder';
  // final String orderID;
  // final String dateOrder;

  // ApproveOrder({this.orderID, this.dateOrder});
  @override
  State<StatefulWidget> createState() {
    return _ApproveOrderState();
  }
}

class _ApproveOrderState extends State<ApproveOrder> {
  int currentIndex = 0;
  String _valFriends;
  String _dateOrder = "";
  String _orderID;

  NetworkService networkService;
  List data = List(); //edited line

  bool isConfirm = false;

  final receiptNoController = TextEditingController();
  final SumPriceController = TextEditingController();
  final txtSumPending = TextEditingController();

  void initState() {
    networkService = NetworkService();
    receipt.clear();
    _buildGetdata();
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
  TextEditingController _textFieldController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    pr = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false, showLogs: false);
    pr.style(message: 'โปรดรอสักครู่...');
    return Scaffold(
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(gradient: MainTheme.gradient),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Card(
                margin: EdgeInsets.only(left: 0, right: 0, top: 0, bottom: 10),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0.0)),
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 10, right: 10, top: 10, bottom: 10),
                  child: Column(
                    children: <Widget>[
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            new Text(
                              "กรุณายืนยันออเดอร์จำนวน ",
                              style: new TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                  fontFamily: 'KanitRegular'),
                            ),
                          ]),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          new Text(txtSumPending.text,
                              style: new TextStyle(
                                  fontSize: 20,
                                  color: Colors.red,
                                  fontFamily: 'KanitRegular')),
                          new Text(
                            " ออเดอร์",
                            style: new TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                                fontFamily: 'KanitRegular'),
                          )
                        ],
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            new Text(
                              'ในวันที่ ' + _dateOrder,
                              style: new TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                  fontFamily: 'KanitRegular'),
                            ),
                          ]),
                    ],
                  ),
                ),
              ),
              new Container(
                height: 400.0,
                child: new ListView.builder(
                  itemCount: receipt.length,
                  itemBuilder: (context, i) {
                    return new custom.ExpansionTile(
                      headerBackgroundColor: Colors.white,
                      iconColor: Colors.black87,
                      title: new Text(
                        receipt[i].title,
                        style: new TextStyle(
                            fontSize: 17.0,
                            color: Colors.black87,
                            fontFamily: 'KanitRegular'),
                      ),
                      children: <Widget>[
                        new Column(
                          children: _buildExpandableContent(receipt[i]),
                        ),
                      ],
                    );
                  },
                ),
              ),
              SizedBox(height: 10),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    _buildBtnSubmit(context),
                    SizedBox(width: 15),
                    _buildBtncancle(context),
                  ]),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  void show_Dialog(String message) {
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
                Navigator.of(dialogContext).pop(); // Dismiss alert dialog
              },
            ),
            FlatButton(
              child: Text('ตกลง'),
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Dismiss alert dialog
//                Navigator.of(context).pushReplacement(
////                    new MaterialPageRoute(builder: (context) => Launcher()));
                final BottomNavigationBar navigationBar =
                    navBarGlobalKey.currentWidget;
                navigationBar.onTap(13);
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

  void showDialogInvid(String message) {
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
                if (message != "กรุณากรอกข้อมูลให้ครบถ้วน") {
                  final BottomNavigationBar navigationBar =
                      navBarGlobalKey.currentWidget;
                  navigationBar.onTap(3);
                }
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
              isConfirm = true;
              showDialogConfirm('คุณเเน่ใจที่จะยืนยันจำนวนเออเดอร์ของคุณหรือไม่');
            },
          ),
        ),
      ],
    );
  }

  void showDialogConfirm(String message) {
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
                Navigator.of(dialogContext).pop(); // Dismiss alert dialog
              },
            ),
            FlatButton(
              child: Text('ตกลง'),
              onPressed: () async {
                Navigator.of(dialogContext).pop(); // Dismiss alert dialog
                await pr.show();
                await _buildUpdateBillStatusRider();
                _postPayfeeCalculate();
              },
            ),
          ],
        );
      },
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
              "ไม่ยืนยัน",
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
              "ไม่ยืนยัน",
              style: TextStyle(fontSize: 22, fontFamily: 'KanitRegular'),
            ),
            onPressed: () async {
              isConfirm = false;
              show_Dialog('คุณต้องการยกเลิกการยืนยันใช่หรือไม่');
            },
          ),
        ),
      ],
    );
  }

  _displayDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('กรุณาระบุเหตุผล'),
            content: TextField(
              controller: _textFieldController,
              decoration: InputDecoration(hintText: "เหตุผลการไม่ยอมรับ"),
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text('ยกเลิก'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              new FlatButton(
                child: new Text('ตกลง'),
                onPressed: () async {
                  //Navigator.of(context).pop();
                  await pr.show();
                  await _buildUpdateBillStatusRider();
                  await pr.hide();
                },
              )
            ],
          );
        });
  }

  _buildExpandableContent(Vehicle vehicle) {
    List<Widget> columnContent = [];
    for (String content in vehicle.contents)
      columnContent.add(
        new ListTile(
          title: new Text(
            content,
            style: new TextStyle(fontSize: 18.0, fontFamily: 'KanitRegular'),
          ),
          leading: new Icon(vehicle.icon),
        ),
      );
    return columnContent;
  }



  Future<void> _buildConvert(String extract_Text) async {
    NetworkService().ConvertSlip711(extract_Text).then(
      (value) async {
        print('response ConvertSlip711 : ${value}');
        var json = jsonDecode(value);
        receiptNoController.text = json['receiptNo'] ?? '';
        SumPriceController.text = json['netPrice'] ?? '';
        print(
            'response ConvertSlip711 receiptNoController : ${receiptNoController.text}');
        print(
            'response ConvertSlip711 receiptNoController : ${SumPriceController.text}');
        if (json['storeNo'] != "") {
          var myList = data.toString();
          print('response ConvertSlip711 myListstore : ${myList}');
          var checkstoreinlist = myList.contains(json['storeNo'].toString());
          if (checkstoreinlist) {
            setState(() {
              _valFriends = json['storeNo'];
            });
            print('มีร้านในโปรไฟล');
          } else {
            print('ไม่มีร้านในโปรไฟล');
          }
        }
      },
    );
  }

  Future<void> _buildGetdata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _orderID = prefs.getString('orderID');
    setState(() {
      _dateOrder = prefs.getString('dateOrder');
    });

    NetworkService()
        .postGetdataDataDetail(_orderID)
        .then((value) async {
      var json = jsonDecode(value);
      var errorMessage = json['errorMessage'];
      if (errorMessage['isError'] == false) {
        final responseJson = jsonDecode(value.toString());
        var data = DeliveryOrderDetailResponse.fromJson(responseJson);
        if (data.deliveryOrderDetails.isEmpty) {
          showDialogAcceap('ไม่พบข้อมูลออเดอร์');
        } else {
          receipt.clear();
            setState(() {
              txtSumPending.text = data.deliveryOrderDetails.length.toString();
              AddJsonToListOrderDetail(data.deliveryOrderDetails);
            });
        }

          return Center(
            child: RefreshProgressIndicator(),
          );
      } else {
        showDialogInvid(errorMessage['errorText']);
      }
      return Center(
        child: RefreshProgressIndicator(),
      );
    });
  }

  Future<void> _buildUpdateBillStatusRider() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var client = prefs.getString('Client');
    _orderID = prefs.getString('orderID');
    List<int> listDOH = new List<int>();
    listDOH.add(int.parse(_orderID));

    NetworkService()
        .postUpdateBillStatusRider(client, listDOH, "CONFIRM",
            globals.s_User_ID, true, false, false, "SPC", null)
        .then((value) async {
      var json = jsonDecode(value);
      var errorMessage = json['errorMessage'];

      if (errorMessage['isError'] == false) {
        await pr.hide();
        showDialogInvid('ดำเนินการเสร็จสิ้น');
        setState(() {
          return Center(
            child: RefreshProgressIndicator(),
          );
        });
      } else {
        await pr.hide();
        showDialogInvid(errorMessage['errorText']);
      }
      return Center(
        child: RefreshProgressIndicator(),
      );
    });

  }

  Future<void> _postPayfeeCalculate() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var client = prefs.getString('Client');
    _orderID = prefs.getString('orderID');

    NetworkService()
        .PostPayfeeCalulate(client, int.parse(_orderID))
        .then((value) async {
        setState(() {
          return Center(
            child: RefreshProgressIndicator(),
          );
        });
      return Center(
        child: RefreshProgressIndicator(),
      );
    });
  }

}

class Vehicle {
  final String title;
  List<String> contents = [];
  final IconData icon;
  Vehicle(this.title, this.contents, this.icon);
}

List<Vehicle> receipt = new List<Vehicle>();
Widget AddJsonToListOrderDetail(List<DeliveryOrderDetail> data) {
  receipt.clear();
  var n = 1;
  for (var i = 0; i < data.length; i++) {
    receipt.add(new Vehicle(
      'ลำดับที่ ' +
          n.toString() +
          ' เลขที่ออเดอร์ #' +
          data[i].sOrderNo.toString(),
      [
        'รหัสร้าน   ' + data[i].sLocationCode.toString(),
        'ราคาสุทธิ   ' + data[i].fTotalPrice.toString() + ' บาท',
        'ประเภท   ' + data[i].deliveryType.name.toString(),
      ],
      Icons.star,
    ));
    n++;
  }
}
// Widget AddJsonToList(List<Order> data) {
//   receipt.clear();
//   var n = 1;
//   for (var i = 0; i < data.length; i++) {
//     receipt.add(new Vehicle(
//       'ลำดับที่ ' +
//           n.toString() +
//           ' เลขที่ใบเสร็จ #' +
//           data[i].orderId.toString(),
//       [
//         'รหัสร้าน   ' + data[i].storeNo.toString(),
//         'ราคาสุทธิ   ' + data[i].amount.toString() + ' บาท',
//         'ประเภท   ' + data[i].shipmentType.toString()
//       ],
//       Icons.star,
//     ));
//     n++;
//   }
// }

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
