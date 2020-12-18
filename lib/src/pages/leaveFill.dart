import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:myapp/src/models/Model_Store.dart';
import 'package:myapp/src/pages/launcher.dart';
import 'package:myapp/src/services/Strings.dart';
import 'package:myapp/src/services/network_service.dart';
import 'package:myapp/src/themes/login_theme.dart';
import 'package:myapp/src/themes/main_theme.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:myapp/src/utils/globals.dart' as globals;

ProgressDialog pr;

class LeaveFill extends StatefulWidget {
  static const routeName = '/LeaveFill';

  @override
  State<StatefulWidget> createState() {
    return _LeaveFillState();
  }
}

class _LeaveFillState extends State<LeaveFill> {
  int currentIndex = 0;
  NetworkService networkService;
  String _valTypeLeave;
  var logger = Logger();
  List Model_Store = [];
  List data = List(); //edited line
  String radioItem = 'Delivery Type';
  String radioItemType = 'WA';
  String extractText = '';
  String statusLeave = 'LG01';
  String typesubmit = '';
  bool Directory_Path1;
  final taxnoController = TextEditingController();
  final receiptNoController = TextEditingController();
  final datetimeEndController = TextEditingController();
  final datetimeStartController = TextEditingController();
  final discriptionController = TextEditingController();
  final SumPriceController = TextEditingController();
  final StoreController = TextEditingController();
  final datePre = TextEditingController();
  final timePre = TextEditingController();
  final format = DateFormat("dd/MM/yyyy HH:mm");
  final formatTime = DateFormat("HH:mm");
  var _dateEndKey = GlobalKey<FormState>();
  List<ModelStore> StoreList = [];
  var datestartService = null;
  var dateendService = null;
  var datestart = null;
  var timestart = null;
  var dateend = null;
  var timeend = null;
  @override
  void initState() {
    networkService = NetworkService();
    String datestart1 = DateFormat('yyyy-MM-dd').format(DateTime.now());
    String datestartplus = datestart1 + ' 08:00';
    String dateend1 = DateFormat('yyyy-MM-dd').format(DateTime.now());
    String dateendplus = dateend1 + ' 18:00';
    datestart = DateTime.parse(datestartplus);
    dateend = DateTime.parse(dateendplus);
    datePre.text = DateFormat('dd/MM/yyyy').format(DateTime.now()).toString();
    timePre.text = DateFormat('hh:mm:ss').format(DateTime.now()).toString();
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
  ValueNotifier<DateTime> _dateTimeNotifier =
      ValueNotifier<DateTime>(DateTime.now());

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
                      EdgeInsets.only(left: 5, right: 5, top: 15, bottom: 18),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 12, right: 12, top: 22, bottom: 40),
                    child: Column(
                      children: <Widget>[
                        Text(
                          Strings.txt_savetime,
                          style: new TextStyle(
                              fontSize: 24,
                              color: Colors.black87,
                              fontFamily: 'KanitRegular'),
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                Strings.txt_savetime_1 + ' : ',
                                style: new TextStyle(
                                    fontSize: 18,
                                    color: Colors.black87,
                                    fontFamily: 'KanitRegular'),
                              ),
                              DropdownButton(
                                hint: Text(" กรุณาเลือก "),
                                value: _valTypeLeave,
                                items: data.map((value) {
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
                            ]),
                        SizedBox(height: 15),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                Strings.txt_savetime_2 + ' : ',
                                style: new TextStyle(
                                    fontSize: 18,
                                    color: Colors.black87,
                                    fontFamily: 'KanitRegular'),
                              ),
                              ToggleSwitch(
                                  minWidth: 78.0,
                                  cornerRadius: 40,
                                  activeBgColor: Colors.white,
                                  activeTextColor: Colors.white,
                                  inactiveBgColor: Colors.grey,
                                  inactiveTextColor: Colors.white,
                                  labels: [
                                    Strings.txt_savetime_3,
                                    Strings.txt_savetime_4
                                  ],
                                  activeColors: [
                                    MainTheme.bgcamera,
                                    MainTheme.bgcamera
                                  ],
                                  onToggle: (index) {
                                    if (index == 0) {
                                      statusLeave = "LG01";
                                      print('switched 0 to: $index');
                                    } else {
                                      statusLeave = "LG02";
                                      print('switched 1 to: $index');
                                    }
                                  }),
                            ]),
                        SizedBox(height: 10),
                        Column(children: <Widget>[
                          _buildDatePickerStart(context, _dateTimeNotifier),
                        ]),
                        Column(children: <Widget>[
                          _buildDatePickerEnd(context, _dateTimeNotifier),
                        ]),
                        SizedBox(height: 15),
                        Row(
                          children: <Widget>[
                            Text(
                              Strings.txt_savetime_5 + '     ',
                              style: new TextStyle(
                                  fontSize: 18,
                                  color: Colors.black87,
//                                  fontWeight: FontWeight.w200,
                                  fontFamily: 'KanitRegular'),
                            ),
                          ],
                        ),
                        Column(children: <Widget>[
                          SizedBox(height: 15),
                          TextField(
                            minLines: 5,
                            maxLines: 5,
                            autocorrect: false,
                            maxLength: 500,
                            controller: discriptionController,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: MainTheme.White400,
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                                borderSide: BorderSide(color: Colors.white),
                              ),
                            ),
                          ),
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

  Future<void> showDialogAcceap(String message) async{
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
              },
            ),
          ],
        );
      },
    );
  }

  Column _buildDatePickerStart(
      BuildContext context, ValueNotifier<DateTime> _dateTimeNotifier) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        DateTimeField(
          format: format,
          initialValue: datestart,
          //Add this in your Code.
          decoration: InputDecoration(labelText: Strings.txt_savetime_start),
          style: TextStyle(
              fontSize: 17, fontFamily: 'KanitRegular', color: Colors.black87),
          onShowPicker: (context, currentValue) async {
            datestart = await showDatePicker(
              context: context,
              firstDate: DateTime(1900),
              initialDate: _dateTimeNotifier.value ?? DateTime.now(),
              lastDate: DateTime(2022),
            ).then((DateTime dateTime) => _dateTimeNotifier.value = dateTime);
            if (datestart != null) {
              timestart = await showTimePicker(
                context: context,
                initialTime:
                    TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
              );
              datestartService =
                  DateTimeField.combine(datestart, timestart).toIso8601String();
              print(
                  'asdasdassadasd : ${DateTimeField.combine(datestart, timestart).toIso8601String()}');
              return DateTimeField.combine(datestart, timestart);
            } else {
              return currentValue;
            }
          },
        ),
      ],
    );
  }

  Column _buildDatePickerEnd(
      BuildContext context, ValueNotifier<DateTime> _dateTimeNotifier) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        DateTimeField(
          format: format,
          key: _dateEndKey,
          initialValue: dateend,
          //Add this in your Code.
          onSaved: (value) {
            debugPrint(value.toString());
          },
          validator: (val) {
            if (val != null) {
              return null;
            } else {
              return 'Date Field is Empty';
            }
          },
          decoration: InputDecoration(labelText: Strings.txt_savetime_end),
          style: TextStyle(
              fontSize: 17, fontFamily: 'KanitRegular', color: Colors.black87),
          onShowPicker: (context, currentValue) async {
            dateend = await showDatePicker(
                context: context,
                firstDate: _dateTimeNotifier.value,
                initialDate: _dateTimeNotifier.value ?? DateTime.now(),
                lastDate: DateTime(2022));
            if (dateend != null) {
              timeend = await showTimePicker(
                context: context,
                initialTime:
                    TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
              );
              dateendService =
                  DateTimeField.combine(dateend, timeend).toIso8601String();
              return DateTimeField.combine(dateend, timeend);
            } else {
              return currentValue;
            }
          },
        ),
      ],
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
              final datestart1 = datestartService == null
                  ? datestart.toString()
                  : datestartService.toString();
              final date_start =
                  DateFormat('yyyy-MM-dd').format(DateTime.parse(datestart1));
              final timestart =
                  DateFormat('hh:mm').format(DateTime.parse(datestart1));
              print('date_start : ${date_start}');
              print('timestart : ${timestart}');
              final datestart2 = dateendService == null
                  ? dateend.toString()
                  : dateendService.toString();
              print('dateend111111sfdghj : ${datestart2}');
              final date_end =
                  DateFormat('yyyy-MM-dd').format(DateTime.parse(datestart2));
              final timeend =
                  DateFormat('hh:mm').format(DateTime.parse(datestart2));
              print('date_end : ${date_end}');
              print('timeend : ${timeend}');
              var discription = discriptionController.text;
              print('discription : ${discription}');
              typesubmit = 'AC01';
              if(!DateTime.parse(date_start).isBefore(DateTime.parse(date_end)) && !DateTime.parse(date_start).isAtSameMomentAs(DateTime.parse(date_end))){
                showDialogAcceap('กรุณากรอกวันที่ให้ถูกต้อง');
              }
              else if (date_start != null &&
                  timestart != null &&
                  date_end != null &&
                  timeend != null &&
                  _valTypeLeave != null &&
                  typesubmit != null &&
                  statusLeave != null &&
                  statusLeave != null &&
                  discription != null) {
                print('ข้อมูลครบ');
                await pr.show();
                await _buildPostLeaveType();
              }
              else {
                print('ข้อมูลไม่ครบ');
                showDialogAcceap('กรุณากรอกข้อมูลให้ครบถ้วน');
              }
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
              show_Dialog('คุณต้องการยกเลิกการเริ่มงานหรือไม่');
            },
          ),
        ),
      ],
    );
  }

  Future<void> _buildGetTypeLeave() async {
    await NetworkService().postGetTypeLeave().then(
      (value) async {
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
    showDialogAcceap(
        "ควรทำการลาก่อน 8.00 ของวันทำงาน ถ้าเกิน 8.00 จะถือว่าขาดงาน");
  }

  Future<void> _buildPostLeaveType() async {
    final datestart1 = datestartService == null
        ? datestart.toString()
        : datestartService.toString();
    final date_start =
        DateFormat('yyyy-MM-dd').format(DateTime.parse(datestart1));
    final timestart = DateFormat('kk:mm').format(DateTime.parse(datestart1));
    final dateend2 =
        dateendService == null ? dateend.toString() : dateendService.toString();
    final date_end = DateFormat('yyyy-MM-dd').format(DateTime.parse(dateend2));
    final timeend = DateFormat('kk:mm').format(DateTime.parse(dateend2));
    var discription = discriptionController.text;
    typesubmit = 'AC01';
    await NetworkService()
        .PostLeaveType(
            globals.i_EMP_ID,
            date_start,
            date_end,
            timestart,
            timeend,
            _valTypeLeave,
            statusLeave,
            typesubmit,
            globals.s_User_ID,
            discription)
        .then(
      (value) async {
        var json = jsonDecode(value);
        var errorMessage = json['errorMessage'];
        if (errorMessage['isError'] == false){
          await pr.hide();
          showDialogInvid('ดำเนินการเสร็จสิ้น');
        } else {
          await pr.hide();
          showDialogAcceap(errorMessage['errorText']);
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

  Datareq(
      {this.S_STORE_NO,
      this.D_DO,
      this.D_DELIVERY,
      this.S_DELIVERY_TYPE,
      this.S_RECEIPT_ID,
      this.F_TOTAL_AMOUNT,
      this.I_EMP_ID});
}
