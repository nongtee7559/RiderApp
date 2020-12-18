import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:myapp/src/models/MasterDropdownList.dart';
import 'package:myapp/src/services/network_service.dart';
import 'package:myapp/src/themes/login_theme.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:myapp/src/widgets/dropdown_formfield.dart';
import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:date_format/date_format.dart';
import 'package:myapp/src/models/AssignDailyPlanResource.dart';
import 'package:myapp/src/utils/globals.dart' as globals;

ProgressDialog pr;
NetworkService networkService;

class ApproveReady extends StatefulWidget {
  @override
  _ApproveReadyState createState() => _ApproveReadyState();
}

class _ApproveReadyState extends State<ApproveReady>
    with TickerProviderStateMixin {
  //declare variable
  bool confirm = false;
  TabController _tabController;

  DateTime date = DateTime.now();
  DateTime selectDate;
  bool isConfirm = false;
  int deliveryType;
  String store;
  String shifttime;
  AssignDailyPlanResource listAssignDailyPlan =
  AssignDailyPlanResource();
  List listShifttime = new List();

  final txtSumPending = TextEditingController();
  final List<DropdownMenuItem> items = [];
  final formKey = new GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    listAssignDailyPlan.data = new List<AssignDailyPlanResponse>();
    listAssignDailyPlan.isLeave = false;
    _buildGetAssignDailyPlan(date);
    _tabController = TabController(vsync: this, length: 7);
    _tabController.addListener(_handleTabSelection);
    super.initState();
  }
  @override
  void setState(fn) {
    if(mounted) {
      super.setState(fn);
    }
  }
  Future<void> _buildGetAssignDailyPlan(DateTime dPlan) async {
    await NetworkService()
        .PostAssignDailyPlan(int.parse(globals.i_EMP_ID), dPlan)
        .then((value) async {
      var json = jsonDecode(value);
      var errorMessage = json['errorMessage'];
      if (errorMessage['isError'] == false) {
        final responseJson = jsonDecode(value.toString());
        var data = AssignDailyPlanResource.fromJson(responseJson);
        setState(() {
          listAssignDailyPlan = data;
        });
      } else {
        showDialogMsg(errorMessage['errorText']);
      }
      return Center(
        child: RefreshProgressIndicator(),
      );
    });
  }

  Future<void> _buildGetShifttime(String storeNo, StateSetter setState) async {
    NetworkService()
        .PostMasterDropdownList("STORE_SHIFTTIME", "",
            storeNo: storeNo)
        .then((value) async {
      var json = jsonDecode(value);
      var errorMessage = json['errorMessage'];
      if (errorMessage['isError'] == false) {
        final responseJson = jsonDecode(value.toString());
        var data = MasterDropdownList.fromJson(responseJson);
        setState(() {
          listShifttime = data.masterddl;
          return Center(
            child: RefreshProgressIndicator(),
          );
        });
      } else {
        var json = jsonDecode(value);
        var errorMessage = json['errorMessage'];
        print('errorMessage : ${errorMessage['errorText']}');
        showDialogMsg(errorMessage['errorText']);
      }
      return Center(
        child: RefreshProgressIndicator(),
      );
    });
  }

  Future<void> _buildConfirmReady() async {
    await NetworkService()
        .PostRiderApproveReady(globals.i_EMP_ID,
            selectDate.toIso8601String(), store, shifttime)
        .then((value) async {
      var json = jsonDecode(value);
      var errorMessage = json['errorMessage'];
      confirm = !errorMessage['isError'];
      if (errorMessage['isError'] == false) {
        setState(() {
          return Center(
            child: RefreshProgressIndicator(),
          );
        });
      } else {
        await pr.hide();
        print('errorMessage : ${errorMessage['errorText']}');
        showDialogMsg(errorMessage['errorText']);
      }
      return Center(
        child: RefreshProgressIndicator(),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    pr = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false, showLogs: false);
    pr.style(message: 'โปรดรอสักครู่...');
    return Scaffold(
      body: Container(
        width: double.infinity,
        child: new DefaultTabController(
          initialIndex: 0,
          length: 7,
          child: Column(
            children: <Widget>[
              SizedBox(height: 10),
              titlePage(),
              SizedBox(height: 10),
              tabsName(),
              tabsExpanded()
            ],
          ),
        ),
      ),
    );
  }



  void _handleTabSelection() async{
    if (_tabController.indexIsChanging)  {
      await pr.show();
      await _buildGetAssignDailyPlan(date.add(Duration(days: _tabController.index)));
      await pr.hide();
    }
  }

  Widget titlePage() {
    return SizedBox(
      width: double.infinity,
      child: Text(
        '  ยืนยันความพร้อมไรเดอร์',
        style: TextStyle(
            color: Colors.black,
            fontSize: 23,
            fontWeight: FontWeight.bold,
            fontFamily: 'KanitRegular'),
        textAlign: TextAlign.left,
      ),
    );
  }

  Widget tabsName() {
    return Card(
      child: Padding(
        padding:
            const EdgeInsets.only(left: 12, right: 12, top: 10, bottom: 10),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(40.0),
          child: Container(
            color: Colors.grey[300],
            child: new ButtonsTabBar(
              controller: _tabController,
              backgroundColor: Colors.grey.shade700,
              radius: 50,
              unselectedBackgroundColor: Colors.grey[300],
              unselectedLabelStyle: TextStyle(color: Colors.black),
              labelStyle:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              tabs: [
                // date.add(new Duration(days: i))
                for (int i = 0; i < 7; i++)
                  Tab(
                    text: "${formatDate(
                      date.add(new Duration(days: i)),
                      [d, ' ', M],
                    )}",
                  ), // ignore: sdk_version_ui_as_code
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget tabsExpanded() {
    return Expanded(
      child: TabBarView(
        controller: _tabController,
        physics: NeverScrollableScrollPhysics(),
        children: <Widget>[
          for (int i = 0; i < 7; i++)
            Card(
              margin: EdgeInsets.only(left: 5, right: 5, bottom: 10, top: 10),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              child: Padding(
                padding:
                    EdgeInsets.only(left: 12, right: 12, top: 22, bottom: 40),
                child: Container(
                  padding: EdgeInsets.only(top: 10, left: 5, right: 5),
                  child: Column(
                    children: <Widget>[
                      if (listAssignDailyPlan.data.isNotEmpty && !listAssignDailyPlan.isLeave)
                        for (int j = 0; j < listAssignDailyPlan.data.length; j++)
                          timelineBox(
                              listAssignDailyPlan.data[j].tStart,
                              listAssignDailyPlan.data[j].tFinish,
                              listAssignDailyPlan.data[j].diffTime),
                      if (listAssignDailyPlan.data.isEmpty || listAssignDailyPlan.isLeave)
                        Text(listAssignDailyPlan.isLeave ? "คุณได้ทำการลาแล้ว":"คุณยังไม่ได้ยืนยันความพร้อม",
                            style: TextStyle(color: Colors.black)),
                      if(!listAssignDailyPlan.isLeave)
                        confirmReadyBtn()
                    ],
                  ),
                ),
              ),
            )
        ],
      ),
    );
  }

  Widget timelineBox(String start, String stop, String duration) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(start, style: TextStyle(color: Colors.black)),
          SizedBox(width: 10),
          Container(
            constraints: BoxConstraints(minWidth: 200, maxWidth: 300),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.blue,
                ),
              ],
            ),
            padding: EdgeInsets.only(left: 5),
            child:
                Text("${duration} Hr", style: TextStyle(color: Colors.black)),
          ),
          SizedBox(width: 10),
          Text(stop, style: TextStyle(color: Colors.black)),
        ],
      ),
    );
  }

  Widget confirmReadyBtn() {
    return Expanded(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
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
                  "กดยืนยันความพร้อม",
                  style: TextStyle(fontSize: 22, fontFamily: 'KanitRegular'),
                ),
                onPressed: () async {
                  var check = await chooseDate();
                  if (check != null) {
                    selectDate = check;
                    showDialogSelectStore();
                  }
                })),
      ),
    );
  }

  Future<DateTime> chooseDate() {
    return showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().add(Duration(days: -1)),
      lastDate: DateTime.now().add(Duration(days: 6)),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.light(),
          child: child,
        );
      },
    );
  }

  Future showDialogSelectStore() async {
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        int selectedRadio = 0;
        return AlertDialog(
          backgroundColor: Colors.white,
          title: new Text(
            "เลือกการเข้างาน",
            style: new TextStyle(
                fontSize: 17.0,
                color: Colors.black87,
                fontFamily: 'KanitRegular'),
          ),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  storeDropdown(setState),
                  SizedBox(height: 10),
                  shifttimeDropdown(setState)
                ],
              );
            },
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('ยกเลิก'),
              onPressed: () {
                setState(() {
                  clearAllWidget();
                  Navigator.of(context).pop(); // Dismiss alert dialog
                });
              },
            ),
            FlatButton(
              child: Text('ตกลง'),
              onPressed: () async {
                await pr.show();
                await _buildConfirmReady();
                if(confirm){
                  Navigator.of(context).pop();
                  clearAllWidget();
                  await _buildGetAssignDailyPlan(date.add(Duration(days: _tabController.index)));
                  await pr.hide();
                  showDialogMsg("ดำเนินการเสร็จสิ้น");
                }
              },
            ),
          ],
        );
      },
    );
  }

  Widget storeDropdown(StateSetter setState) {
    return Center(
      child: new Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Colors.white,
        ),
        child: DropDownFormField(
          color: Colors.grey.shade200,
          hintText: 'กรุณาเลือกร้าน',
          value: store,
          onSaved: (value) {
            setState(() {
              store = value;
            });
          },
          onChanged: (value) async {
            clearAllWidget();
            await _buildGetShifttime(value, setState);
            setState(() {
              store = value;
            });
          },
          dataSource: globals.listStores,
          textField: "S_SM_LOCATION_CODE",
          valueField: "S_SM_LOCATION_CODE",
        ),
      ),
    );
  }

  Widget shifttimeDropdown(StateSetter setState) {
    return Center(
      child: new Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Colors.white,
        ),
        child: DropDownFormField(
          color: Colors.grey.shade200,
          hintText: 'กรุณาเลือกกะงาน',
          value: shifttime,
          onSaved: (value) {
            setState(() {
              shifttime = value;
            });
          },
          onChanged: (value) {
            setState(() {
              shifttime = value;
            });
          },
          dataSource: listShifttime.map((item) => item.toJson()).toList(),
          textField: "name",
          valueField: "value",
        ),
      ),
    );
  }

  void clearAllWidget() {
    setState(() {
      if (store != null) store = null;
      if (shifttime != null) shifttime = null;
      if (listShifttime.isNotEmpty) listShifttime.clear();
    });
  }

  void showDialogMsg(String message) {
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
}
