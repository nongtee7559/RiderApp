import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:myapp/src/pages/launcher.dart';
import 'package:myapp/src/services/Strings.dart';
import 'package:myapp/src/services/network_service.dart';
import 'package:myapp/src/themes/login_theme.dart';
import 'package:myapp/src/themes/main_theme.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:myapp/src/utils/globals.dart' as globals;

ProgressDialog pr;

class ProfilePreview extends StatefulWidget {
  static const routeName = '/ProfilePreview';

  @override
  State<StatefulWidget> createState() {
    return _ProfilePreviewState();
  }
}

class _ProfilePreviewState extends State<ProfilePreview> {
  int currentIndex = 0;
  NetworkService networkService;
  String _valTypeLeave;
  var logger = Logger();
  List Model_Store = [];
  List data = List(); //edited line
  List data1 = List(); //edited line
  @override
  void initState() {
    networkService = NetworkService();
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
    pr = new ProgressDialog(context);
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
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Stack(
                                overflow: Overflow.visible,
                                alignment: Alignment.bottomCenter,
                                children: <Widget>[
                                  Container(
//                              width: 300,
//                              height: 45,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(100)),
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
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          child: globals.user_Path == null
                                              ? Image.asset(
                                                  globals.Path_ImageProfile,
                                                  width: 70,
                                                  height: 70,
                                                  fit: BoxFit.fill)
                                              : Image.file(File(globals.user_Path),
                                                  width: 70,
                                                  height: 70,
                                                  fit: BoxFit.fill),
                                        ),
                                        radius: 40,
                                      ),
                                      onPressed: () async {
                                        print('click Upload');
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                ' โปรไฟล์',
                                style: new TextStyle(
                                    fontSize: 21,
                                    color: Colors.black87,
//                                  fontWeight: FontWeight.w200,
                                    fontFamily: 'KanitRegular'),
                              ),
                            ]),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Container(
//                            width: 320,
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                gradient: LinearGradient(
                                  colors: [
                                    LoginTheme.btncolor,
                                    LoginTheme.btncolor,
                                  ],
                                ),
                              ),

                              child: new Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  new FlatButton(
                                    onPressed: () {
                                      final BottomNavigationBar navigationBar =
                                          navBarGlobalKey.currentWidget;
                                      navigationBar.onTap(10);
                                    },
                                    child: new Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        new Text(
                                          'เเก้ไขโปรไฟล์   ',
                                          style: TextStyle(
                                              fontSize: 19,
                                              color: Colors.black87,
                                              fontFamily: 'KanitRegular'),
                                        ),
                                        new Icon(Icons.edit,
                                            color: Colors.black87, size: 30),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                Strings.txt_name_user + ' : ',
                                style: new TextStyle(
                                    fontSize: 18,
                                    color: Colors.black87,
//                                  fontWeight: FontWeight.w200,
                                    fontFamily: 'KanitRegular'),
                              ),
                              Text(
                                globals.Fname,
                                style: new TextStyle(
                                    fontSize: 18,
                                    color: Colors.black87,
//                                  fontWeight: FontWeight.w200,
                                    fontFamily: 'KanitRegular'),
                              ),
                            ]),
                        SizedBox(height: 15),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'สกุล' + ' : ',
                                style: new TextStyle(
                                    fontSize: 18,
                                    color: Colors.black87,
//                                  fontWeight: FontWeight.w200,
                                    fontFamily: 'KanitRegular'),
                              ),
                              Text(
                                globals.Lname,
                                style: new TextStyle(
                                    fontSize: 18,
                                    color: Colors.black87,
//                                  fontWeight: FontWeight.w200,
                                    fontFamily: 'KanitRegular'),
                              ),
                            ]),
                        SizedBox(height: 15),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'เบอร์โทรศัพท์  :  ',
                                style: new TextStyle(
                                    fontSize: 18,
                                    color: Colors.black87,
//                                  fontWeight: FontWeight.w200,
                                    fontFamily: 'KanitRegular'),
                              ),
                              Text(
                                globals.sPhoneNo ?? "-",
                                style: new TextStyle(
                                    fontSize: 18,
                                    color: Colors.black87,
//                                  fontWeight: FontWeight.w200,
                                    fontFamily: 'KanitRegular'),
                              ),
                            ]),
                        SizedBox(height: 15),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'รหัสร้าน : ',
                                style: new TextStyle(
                                    fontSize: 18,
                                    color: Colors.black87,
//                                  fontWeight: FontWeight.w200,
                                    fontFamily: 'KanitRegular'),
                              ),
                              DropdownButton(
                                hint: Text("    กรุณาเลือก       "),
                                value: _valTypeLeave,
                                items: globals.listStores.map((value) {
                                  return DropdownMenuItem(
                                    child: Text(
                                      value['S_SM_LOCATION_CODE'],
                                      style: new TextStyle(
                                          fontSize: 18,
                                          color: Colors.black87,
//                                  fontWeight: FontWeight.w200,
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
                            ]),
                        SizedBox(height: 15),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
