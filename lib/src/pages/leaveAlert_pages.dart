import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:logger/logger.dart';
import 'package:myapp/src/models/Leave2Response.dart';
import 'package:myapp/src/models/Model_Store.dart';
import 'package:myapp/src/pages/launcher.dart';
import 'package:myapp/src/services/network_service.dart';
import 'package:myapp/src/themes/main_theme.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:myapp/src/utils/globals.dart' as globals;

ProgressDialog pr;

class LeaveAlert extends StatefulWidget {
  static const routeName = '/leavealert';

  @override
  State<StatefulWidget> createState() {
    return _LeaveAlertState();
  }
}

class _LeaveAlertState extends State<LeaveAlert> {
  int currentIndex = 0;
  NetworkService networkService;
  String _valFriends;
  var logger = Logger();
  List Model_Store = [];
  List data = List(); //edited line
  List datastatus = List(); //edited line
  String radioItem = 'Delivery Type';
  String radioItemType = 'WA';
  String _valTypeLeave;
  String extractText = '';
  String Status_Ri = '';
  List<ModelStore> StoreList = [];
  @override
  void initState() {
    networkService = NetworkService();
    _buildGetTypeLeaveFilter();
    super.initState();
  }
  @override
  void setState(fn) {
    if(mounted) {
      super.setState(fn);
    }
  }
  int id = 1;
  TextEditingController _textFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    pr = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false, showLogs: false);
    pr.style(message: 'Please wait...');
    return Scaffold(
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(gradient: MainTheme.gradient),
        child: new Theme(
          data: Theme.of(context).copyWith(
            canvasColor: MainTheme.HomeendTripColor,
          ),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    DropdownButton(
                      hint: Text(
                        " ทั้งหมด ",
                        style: new TextStyle(
                            fontSize: 18,
                            color: Colors.black87,
                            fontFamily: 'KanitRegular'),
                      ),
                      value: _valTypeLeave,
                      items: datastatus.map((value) {
                        return DropdownMenuItem(
                          child: Text(
                            value['name'],
                            style: new TextStyle(
                                fontSize: 18,
                                color: Colors.black87,
                                fontFamily: 'KanitRegular'),
                          ),
                          value: value['value'],
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _valTypeLeave =
                              value; //Untuk memberitahu _valTypeLeave bahwa isi nya akan diubah sesuai dengan value yang kita pilih
                          print('_valTypeLeave : ${_valTypeLeave}');
                        });
                      },
                    ),
                    SizedBox(width: 10),
                  ],
                ),
                new Container(
                  height: MediaQuery.of(context).size.height,
                  padding: EdgeInsets.only(
                      left: 0.0, right: 0.0, top: 0.0, bottom: 280),
                  child: _buildContent(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  FutureBuilder<List<EmployeeLeaveAlert>> _buildContent() {
    return FutureBuilder<List<EmployeeLeaveAlert>>(
      future: networkService.postGetLeave2data(
          globals.i_EMP_ID, _valTypeLeave),
      builder: (BuildContext context,
          AsyncSnapshot<List<EmployeeLeaveAlert>> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data != null) {
            return _buildListView(snapshot.data);
          }
          return Text("error");
        }
        return Center();
      },
    );
  }

  Future<void> _buildGetTypeLeaveFilter() async {
    NetworkService().postGetTypeLeaveFilter().then(
      (value) async {
        var json = jsonDecode(value);
        var errorMessage = json['errorMessage'];
        if (errorMessage['isError'] == false) {
          if (json['values'] != "") {
            var resBody = json['values'];
            setState(() {
              datastatus = resBody;
            });
          }
        }
      },
    );
  }
}

Widget _buildListView(List<EmployeeLeaveAlert> data) {
  return ListView.builder(
    padding: EdgeInsets.only(top: 10, bottom: 10),
    itemBuilder: (BuildContext context, int position) {
      final item = data[position];
      return Card(
        margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
        child: Column(
          children: <Widget>[
            new FlatButton(
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.setString('data_to_LeaveApprove',
                    (json.encode(data[position].toJson())));
                print(
                    'data_to_LeaveApprove ${await prefs.getString('data_to_LeaveApprove')}');
                final BottomNavigationBar navigationBar =
                    navBarGlobalKey.currentWidget;
                navigationBar.onTap(8);
              },
              child: _buildHeaderCard(item),
            ),
          ],
        ),
      );
    },
    itemCount: data.length,
  );
}

_buildHeaderCard(EmployeeLeaveAlert item) {
  var _value = '';
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    children: <Widget>[
      new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 10),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              SizedBox(width: 5),
              item.processing == "02"
                  ? new Icon(Icons.radio_button_checked,
                      color: Colors.orange, size: 20)
                  : item.processing == "03"
                      ? new Icon(Icons.radio_button_checked,
                          color: Colors.green, size: 22)
                      : item.processing == "01"
                          ? new Icon(Icons.radio_button_checked,
                              color: Colors.red, size: 22)
                          : item.processing == "99"
                              ? new Icon(Icons.radio_button_checked,
                                  color: Colors.indigo, size: 22)
                              : SizedBox(),
              SizedBox(width: 5),
              new Text(
                item.leaveProcessingDescription.toString(),
                style: TextStyle(
                    fontSize: 15,
                    color: Colors.black87,
                    fontFamily: 'KanitRegular'),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(width: 5),
              new Icon(Icons.date_range, color: Colors.black87, size: 36),
              SizedBox(width: 5),
              new Text(
                item.leaveTypeDescription.toString(),
                style: TextStyle(
                    fontSize: 17,
                    color: Colors.black87,
                    fontFamily: 'KanitRegular'),
              ),
              new Text(
                item.leaveStartDate.toString() == item.leaveEndDate.toString()
                    ? ' ' +
                        DateFormat('dd/MM/yyyy')
                            .format(item.leaveStartDate)
                            .toString()
                    : ' ' +
                        DateFormat('dd/MM/yyyy')
                            .format(item.leaveStartDate)
                            .toString(),
                style: TextStyle(
                    fontSize: 17,
                    color: Colors.black87,
                    fontFamily: 'KanitRegular'),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              new Text(
                item.leaveStartDate.toString() == item.leaveEndDate.toString()
                    ? ''
                    : '       ถึง',
                style: TextStyle(
                    fontSize: 17,
                    color: Colors.black87,
                    fontFamily: 'KanitRegular'),
              ),
              new Text(
                item.leaveStartDate.toString() != item.leaveEndDate.toString()
                    ? ' ' +
                        DateFormat('dd/MM/yyyy')
                            .format(item.leaveEndDate)
                            .toString()
                    : ' ',
                style: TextStyle(
                    fontSize: 17,
                    color: Colors.black87,
                    fontFamily: 'KanitRegular'),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(width: 10),
              new Text(
                'ชื่อ : ',
                style: TextStyle(
                    fontSize: 17,
                    color: Colors.black87,
                    fontFamily: 'KanitRegular'),
              ),
              new Text(
                item.name.toString(),
                style: TextStyle(
                    fontSize: 17,
                    color: Colors.black87,
                    fontFamily: 'KanitRegular'),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(width: 10),
              new Text(
                'เบอร์โทร : ' + item.phoneNo.toString(),
                style: TextStyle(
                    fontSize: 17,
                    color: Colors.black87,
                    fontFamily: 'KanitRegular'),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(width: 10),
              new Text(
                'รหัสร้าน :  ',
                style: TextStyle(
                    fontSize: 17,
                    color: Colors.black87,
                    fontFamily: 'KanitRegular'),
              ),
              new DropdownButton<String>(
                hint: Text(
                  item.stores[0],
                  style: TextStyle(
                      fontSize: 17,
                      color: Colors.black87,
                      fontFamily: 'KanitRegular'),
                ),
                items: item.stores.map((String _value) {
                  return new DropdownMenuItem<String>(
                    value: _value,
                    child: new Text(_value),
                  );
                }).toList(),
                onChanged: (value) {
                  _value = value;
                },
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 15),
            ],
          )
        ],
      ),
    ],
  );
}
