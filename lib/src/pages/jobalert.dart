import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:logger/logger.dart';
import 'package:myapp/src/models/Model_Store.dart';
import 'package:myapp/src/models/PendingWorksResponse.dart';
import 'package:myapp/src/models/DeliveryOrderHeaders_Response.dart';
import 'package:myapp/src/my_app.dart';
import 'package:myapp/src/pages/launcher.dart';
import 'package:myapp/src/services/network_service.dart';
import 'package:myapp/src/themes/main_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:myapp/src/themes/custom_expansion_tile.dart' as custom;
import 'package:myapp/src/utils/globals.dart' as globals;


class Jobalert extends StatefulWidget {
  static const routeName = '/jobalert';

  @override
  State<StatefulWidget> createState() {
    return _JobalertState();
  }
}

class _JobalertState extends State<Jobalert> {
  int currentIndex = 0;
  NetworkService networkService;
  var logger = Logger();
  List Model_Store = [];
  List data = List(); //edited line
  String radioItem = 'Delivery Type';
  String radioItemType = 'WA';
  String extractText = '';
  String imagePath = '';
  String Status_Ri = '';
  bool Directory_Path1;
  final txtSumPending = TextEditingController();
  final taxnoController = TextEditingController();
  final receiptNoController = TextEditingController();
  final SumPriceController = TextEditingController();
  final StoreController = TextEditingController();
  final LatController = TextEditingController();
  final LongController = TextEditingController();
  List<ModelStore> StoreList = [];

  @override
  void initState() {
    networkService = NetworkService();
    receipt.clear();
    _buildGetdata();
    txtSumPending.text = '0';
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
                      left: 0, right: 22, top: 10, bottom: 15),
                  child: Column(
                    children: <Widget>[
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            new Text(
                              "กรุณายืนยันงานของคุณ",
                              style: new TextStyle(
                                  fontSize: 25,
                                  color: Colors.black,
                                  fontFamily: 'KanitRegular'),
                            ),
                          ]),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            new Text(
                              txtSumPending.text + " งาน",
                              style: new TextStyle(
                                  fontSize: 25,
                                  color: Colors.black,
                                  fontFamily: 'KanitRegular'),
                            ),
                          ]),
                    ],
                  ),
                ),
              ),
              new Container(
                height: 490,
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
              SizedBox(height: 15),
            ],
          ),
        ),
      ),
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
                  Navigator.of(context).pushReplacement(
                      new MaterialPageRoute(builder: (context) => MyApp()));
                }
              },
            ),
          ],
        );
      },
    );
  }


  _buildExpandableContent(Vehicle vehicle) {
    List<Widget> columnContent = [];
    for (Text content in vehicle.contents)
      columnContent.add(
        new ListTile(
          title: content,
          onTap: () async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.setString('orderID', vehicle.dohid.toString());
            await prefs.setString('dateOrder', vehicle.date.toString());
            final BottomNavigationBar navigationBar =
                navBarGlobalKey.currentWidget;
            navigationBar.onTap(14);
          },
          leading: new Icon(vehicle.icon),
        ),
      );

    return columnContent;
  }

  Future<void> _buildGetdata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var client = prefs.getString('Client');

    NetworkService()
        .postGetdataDOH(globals.i_EMP_ID, client, '')
        .then((value) async {
      var json = jsonDecode(value);

      var errorMessage = json['errorMessage'];
      if (errorMessage['isError'] == false) {
        final responseJson = jsonDecode(value.toString());
        var data = DeliveryOrderHeaderResponse.fromJson(responseJson);
        txtSumPending.text = data.deliveryOrderHeaders.length.toString();
        setState(() {
          AddJsonToListDOH(data.deliveryOrderHeaders);
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
    });
  }
}

class Vehicle {
  final String title;
  final String date;
  final String empid;
  final String dohid;

  List<Text> contents = [];
  final IconData icon;

  Vehicle(
      this.title, this.date, this.empid, this.dohid, this.contents, this.icon);
}

List<Vehicle> receipt = new List<Vehicle>();
Widget AddJsonToListDOH(List<DeliveryOrderHeader> data) {
  receipt.clear();
  //print("data : ${data.toString()}");
  for (var i = 0; i < data.length; i++) {
//    receipt.add(new Text(strings[i]));
    if (data[i].reason == null) {
      data[i].reason = new Reason(sReason: "");
    }
    receipt.add(new Vehicle(
      'กรุณายืนยันใบเสร็จ          ' +
          DateFormat('dd/MM/yyyy')
              .format(DateTime.parse(data[i].dDelivery.toString())),
      DateFormat('yyyy-MM-dd')
          .format(DateTime.parse(data[i].dDelivery.toString())),
      data[i].iEmpId.toString(),
      data[i].iDohId.toString(),
      [
        Text('ชื่อ ${data[i].employee.sUserFname.toString()} ${data[i].employee.sUserLname.toString()}'
              ),
        Text('จำนวน ${data[i].iTotalBill.toString()} ออเดอร์'),
        Text('เหตุผล ${data[i].reason.sReason}'),
        Text('หมายเหตุ ${data[i].comment}',style: TextStyle(color: Colors.red))
      ],
      Icons.star,
    ));
    if(data[i].comment == "") receipt[i].contents.removeLast();
  }
}

Widget AddJsonToList(List<PendingWork> data) {
  receipt.clear();
  for (var i = 0; i < data.length; i++) {
    receipt.add(new Vehicle(
      'กรุณายืนยันออเดอร์          ' +
          DateFormat('dd/MM/yyyy')
              .format(DateTime.parse(data[i].deliveryDate.toString())),
      DateFormat('yyyy-MM-dd')
          .format(DateTime.parse(data[i].deliveryDate.toString())),
      data[i].empId.toString(),
      data[i].empId.toString(),
      [Text('จำนวน ' + data[i].sumTrip.toString() + ' ออเดอร์')],
      Icons.star,
    ));
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
