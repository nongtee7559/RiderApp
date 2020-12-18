import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myapp/src/models/DeliveryOrderDetails_Response.dart';
import 'package:myapp/src/models/MasterDropdownList.dart';
import 'package:myapp/src/models/bodyNotConfirmOrder.dart';
import 'package:myapp/src/pages/jobalert.dart';
import 'package:myapp/src/pages/launcher.dart';
import 'package:myapp/src/services/network_service.dart';
import 'package:myapp/src/themes/login_theme.dart';
import 'package:myapp/src/themes/main_theme.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:myapp/src/widgets/dropdown_formfield.dart';
import 'package:myapp/src/utils/globals.dart' as globals;

ProgressDialog pr;
NetworkService networkService;
SlidableController slidableController;

class NotConfirmBillPage extends StatefulWidget {
  static const routeName = '/notConfirmBill';

  @override
  _NotConfirmBillPageState createState() => _NotConfirmBillPageState();
}

class _NotConfirmBillPageState extends State<NotConfirmBillPage> {
  //declare variable
  bool isConfirm = false;
  bool _isVisible = false;
  int deliveryType;
  int _selectedDeliveryType;
  final BodyNotConfirmOrder model = new BodyNotConfirmOrder();

  String deleteReason;
  String editReason;
  String mainReason;
  String selectedValue;
  String _orderID;
  String _dateOrder;
  String editTitle = "แก้ไขออเดอร์";
  String deleteTitle = "ลบออเดอร์";
  String store;

  List<DeliveryOrderDetail> detailOrders = new List<DeliveryOrderDetail>();
  List detailReasons = new List();
  List mainReasons = new List();
  List listDeliveryType = new List();

  TextEditingController amountOrder = new TextEditingController();
  TextEditingController orderNo = new TextEditingController();

  final List<DropdownMenuItem> items = [];
  final formKey = new GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    receipt.clear();
    model.listDods = new List<ListDod>();
    networkService = NetworkService();
    slidableController = SlidableController();
    _buildGetOrderDetail();
    _buildGetMainReasons();
    _buildGetDetailReasons();
    _buildGetDeliveryType();

    super.initState();
  }
  @override
  void setState(fn) {
    if(mounted) {
      super.setState(fn);
    }
  }
  //get Data from API

  Future<void> _buildGetOrderDetail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _orderID = prefs.getString('orderID');
    _dateOrder = prefs.getString('dateOrder');

    NetworkService()
        .postGetdataDataDetail(_orderID)
        .then((value) async {
      var json = jsonDecode(value);

      var errorMessage = json['errorMessage'];
      if (errorMessage['isError'] == false) {
        final responseJson = jsonDecode(value.toString());
        var data = DeliveryOrderDetailResponse.fromJson(responseJson);
        detailOrders = data.deliveryOrderDetails;
        if (data.deliveryOrderDetails.isEmpty) {
          showDialogAcceap('ไม่พบข้อมูลออเดอร์');
        } else {
          AddJsonToListOrderDetail(data.deliveryOrderDetails);
        }
        setState(() {
          return Center(
            child: RefreshProgressIndicator(),
          );
        });
      } else {
        var json = jsonDecode(value);
        var errorMessage = json['errorMessage'];
        print('errorMessage : ${errorMessage['errorText']}');
        showDialogInvid(errorMessage['errorText']);
      }
      return Center(
        child: RefreshProgressIndicator(),
      );
    });
  }

  Future<void> _buildGetDetailReasons() async {
    NetworkService()
        .PostMasterDropdownList(
            "REASON", "RIDER_NOT_CONFRIM_DETAIL")
        .then((value) async {
      var json = jsonDecode(value);
      var errorMessage = json['errorMessage'];
      if (errorMessage['isError'] == false) {
        var responseJson = jsonDecode(value.toString());
        var data = new MasterDropdownList.fromJson(responseJson);
        setState(() {
          detailReasons = data.masterddl;
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

  Future<void> _buildGetMainReasons() async {
    NetworkService()
        .PostMasterDropdownList("REASON", "DELIVERY_ORDER_HEADER")
        .then((value) async {
      var json = jsonDecode(value);
      var errorMessage = json['errorMessage'];
      if (errorMessage['isError'] == false) {
        final responseJson = jsonDecode(value.toString());
        var data = MasterDropdownList.fromJson(responseJson);
        setState(() {
          mainReasons = data.masterddl;
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

  Future<void> _buildGetDeliveryType() async {
    NetworkService()
        .PostMasterDropdownList( "ANR_KEY_CONFIG", "DeliveryType")
        .then((value) async {
      var json = jsonDecode(value);
      var errorMessage = json['errorMessage'];
      if (errorMessage['isError'] == false) {
        final responseJson = jsonDecode(value.toString());
        var data = MasterDropdownList.fromJson(responseJson);
        if (data.masterddl.isEmpty) {
          showDialogAcceap('ไม่พบข้อมูลเหตุผลประเภทรถ');
        }
        setState(() {
          listDeliveryType = data.masterddl;
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

  Future<void> _postUpdateNotConfirmBillRider() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _orderID = prefs.getString('orderID');
    _dateOrder = prefs.getString('dateOrder');
    //set model for update
    model.doh = _orderID;
    model.dOrder = DateTime.parse(_dateOrder);
    model.reasonId = mainReason;
    model.isProcess = true;
    model.UserID = globals.s_User_ID;
    NetworkService()
        .postUpdateNotConfirmBillRider(model)
        .then((value) async {
      var json = jsonDecode(value);
      var errorMessage = json['errorMessage'];
      print("errorMessage $errorMessage");
      if (errorMessage['isError'] == false) {
        await pr.hide();
        setState(() {
          final BottomNavigationBar navigationBar =
              navBarGlobalKey.currentWidget;
          navigationBar.onTap(0);
          return Center(
            child: RefreshProgressIndicator(),
          );
        });
      } else {
        await pr.hide();
        var json = jsonDecode(value);
        var errorMessage = json['errorMessage'];
        print('errorMessage : ${errorMessage['errorText']}');
        showDialogInvid(errorMessage['errorText']);
      }
      return Center(
        child: RefreshProgressIndicator(),
      );
    });
  }

  Future<void> AddJsonToListOrderDetail(List<DeliveryOrderDetail> data) async {
    items.clear();
    setState(() {
      for (var i = 0; i <= data.length; i++) {
        items.add(DropdownMenuItem(
          child: Text(
            data[i].sOrderNo,
            style: new TextStyle(
                fontSize: 17.0,
                color: Colors.black87,
                fontFamily: 'KanitRegular'),
          ),
          value: data[i].sOrderNo,
        ));
      }
    });
  }

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    pr = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false, showLogs: false);
    pr.style(message: 'โปรดรอสักครู่...');
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        resizeToAvoidBottomPadding: false,
        body: Container(
          height: double.infinity,
          decoration: BoxDecoration(gradient: MainTheme.gradient),
          child: new Theme(
            data: Theme.of(context).copyWith(
              canvasColor: Colors.white,
            ),
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  SizedBox(height: 16),
                  amountOrderInput(),
                  mainReasonDropdown(),
                  SizedBox(height: 10),
                  searchOrderDropdown(),
                  addBilBtn(),
                  listOrderDetail(),
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
        ),
      ),
    );
  }

  //////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////

  //method
  Widget mainReasonDropdown() {
    return Center(
      child: Form(
        key: formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(16),
              child: DropDownFormField(
                hintText: 'กรุณาเลือกเหตุผลหลัก',
                value: mainReason,
                onSaved: (value) {
                  setState(() {
                    mainReason = value;
                  });
                },
                onChanged: (value) {
                  setState(() {
                    mainReason = value;
                  });
                },
                dataSource: mainReasons.map((item) => item.toJson()).toList(),
                textField: 'name',
                valueField: 'value',
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget searchOrderDropdown() {
    return Container(
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
      color: Colors.white,
      child: SearchableDropdown.single(
        items: items.toList(),
        icon: Icon(Icons.search),
        style: new TextStyle(
            fontSize: 17.0,
            color: Colors.grey.shade500,
            fontFamily: 'KanitRegular'),
        value: selectedValue,
        hint: Text("#ค้นหาเลขที่ออเดอร์"),
        searchHint: Text("ผลการค้นหา",
            style: TextStyle(
              fontSize: 17.0,
              color: Colors.black,
            )),
        keyboardType: TextInputType.number,
        onChanged: (value) {
          setState(() {
            selectedValue = value;
          });
        },
        dialogBox: true,
        isExpanded: true,
      ),
    );
  }

  Widget editReasonDropdown(StateSetter setState) {
    return Center(
      child: new Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Colors.white,
        ),
        child: DropDownFormField(
          hintText: 'กรุณาเลือกเหตุผล',
          value: editReason,
          onSaved: (value) {
            setState(() {
              editReason = value;
            });
          },
          onChanged: (value) {
            setState(() {
              editReason = value;
              if (editReason == "9") {
                showTypeVehicle(true);
              } else {
                showTypeVehicle(false);
              }
            });
          },
          dataSource: detailReasons.map((item) => item.toJson()).toList(),
          textField: "name",
          valueField: "value",
        ),
      ),
    );
  }

  Widget deleteReasonDropdown(StateSetter setState) {
    return Center(
      child: new Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Colors.white,
        ),
        child: DropDownFormField(
          hintText: 'กรุณาเลือกเหตุผล',
          value: deleteReason,
          onSaved: (value) {
            setState(() {
              deleteReason = value;
            });
          },
          onChanged: (value) {
            setState(() {
              deleteReason = value;
            });
          },
          dataSource: detailReasons.map((item) => item.toJson()).toList(),
          textField: "name",
          valueField: "value",
        ),
      ),
    );
  }

  Widget storeDropdown(StateSetter setState) {
    return Center(
      child: new Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Colors.white,
        ),
        child: Container(
          margin: EdgeInsets.fromLTRB(15, 10, 15, 0),
          child: DropDownFormField(
            hintText: 'รหัสสาขา',
            value: store,
            onSaved: (value) {
              setState(() {
                store = value;
              });
            },
            onChanged: (value) {
              setState(() {
                store = value;
              });
            },
            dataSource: globals.listStores,
            textField: 'S_SM_LOCATION_CODE',
            valueField: 'S_SM_LOCATION_CODE',
          ),
        ),
      ),
    );
  }

  Widget amountOrderInput() {
    return Container(
      color: Colors.white,
      margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
      child: ListTile(
        title: new Text("จำนวนออเดอร์ทั้งหมด ${detailOrders.length} ใบ"),
      ),
    );
  }

  Widget addOrderNoInput() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(12, 0, 8, 0),
      margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
      child: TextField(
        controller: orderNo,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
            hintText: '#เลขที่ออเดอร์',
            hintStyle: new TextStyle(
                fontSize: 17.0,
                color: Colors.grey.shade500,
                fontFamily: 'KanitRegular'),
            enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xffd3e9f6)))),
      ),
    );
  }

  Widget listOrderDetail() {
    return Center(
      child: OrientationBuilder(
        builder: (context, orientation) => _buildList(
            context,
            orientation == Orientation.portrait
                ? Axis.vertical
                : Axis.horizontal),
      ),
    );
  }

  Widget _buildList(BuildContext context, Axis direction) {
    final Axis slidableDirection =
        direction == Axis.horizontal ? Axis.vertical : Axis.horizontal;
    return Container(
      height: 400.0,
      child: new ListView.builder(
        scrollDirection: direction,
        itemBuilder: (context, index) {
          return _getSlidableWithLists(context, index, slidableDirection);
        },
        itemCount: selectedValue == null ? detailOrders.length : 1,
      ),
    );
  }

  Widget _getSlidableWithLists(
      BuildContext context, int index, Axis direction) {
    final DeliveryOrderDetail item = selectedValue == null
        ? detailOrders[index]
        : detailOrders.firstWhere((value) => value.sOrderNo == selectedValue);
    return Container(
      margin: EdgeInsets.fromLTRB(15, 0, 15, 4),
      child: Slidable(
        key: Key("ลำดับที่ ${index + 1} เลขที่ออเดอร์ #${item.sOrderNo}"),
        controller: slidableController,
        direction: direction,
        actionPane: SlidableBehindActionPane(),
        actionExtentRatio: 0.25,
        child: VerticalListItem(item, index + 1),
        actions: <Widget>[
          IconSlideAction(
            caption: 'แก้ไข',
            color: Color(0xfff9fad3),
            icon: Icons.edit,
            onTap: () => showDialogEditBill(editTitle, item.sOrderNo),
          ),
        ],
        secondaryActions: <Widget>[
          IconSlideAction(
            caption: 'ลบออก',
            color: Color(0xffd3d3d3),
            icon: Icons.delete,
            onTap: () =>
                showDialogDeleteBill(deleteTitle, index, item.sOrderNo),
            closeOnTap: false,
          ),
        ],
      ),
    );
  }

  Widget addBilBtn() {
    return Container(
      padding: EdgeInsets.fromLTRB(15, 15, 0, 0),
      child: Row(
        children: [
          FloatingActionButton(
            onPressed: () => showDialogAddBill("เพิ่มออเดอร์"),
            child: Container(
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle, // circular shape
                gradient: LinearGradient(
                  colors: [
                    Color(0xff0e8aea),
                    Color(0xff64b5f4),
                  ],
                ),
              ),
              child: Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(
            width: 5,
          ),
          Text(
            "เพิ่มข้อมูล",
            style: new TextStyle(
                fontSize: 17.0,
                color: Colors.black87,
                fontFamily: 'KanitRegular'),
          ),
        ],
      ),
    );
  }

  Widget addTypeVehicleBtn(StateSetter setState) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      padding: MediaQuery.of(context).viewInsets,
      child: Center(
        child: Column(
          children: <Widget>[
            Text("ประเภทการจัดส่ง"),
            for (int i = 0; i < listDeliveryType.length; i++)
              ListTile(
                title: Text(
                  listDeliveryType[i].name,
                  style: new TextStyle(
                      fontSize: 17.0,
                      color: Colors.black87,
                      fontFamily: 'KanitRegular'),
                ),
                leading: Radio(
                  value: i,
                  groupValue: _selectedDeliveryType,
                  activeColor: Colors.black,
                  onChanged: (int value) {
                    setState(() {
                      _selectedDeliveryType = value;
                      deliveryType = int.parse(listDeliveryType[value].value);
                      print(deliveryType);
                    });
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget editTypeVehicleBtn(StateSetter setState) {
    return Visibility(
      visible: _isVisible,
      child: Container(
        child: new ListTile(
          title: Center(
            child: new Visibility(
              visible: _isVisible,
              child: Column(
                children: <Widget>[
                  Text("ประเภทการจัดส่ง"),
                  for (int i = 0; i < listDeliveryType.length; i++)
                    ListTile(
                      title: Text(
                        listDeliveryType[i].name,
                        style: new TextStyle(
                            fontSize: 17.0,
                            color: Colors.black87,
                            fontFamily: 'KanitRegular'),
                      ),
                      leading: Radio(
                        value: i,
                        groupValue: deliveryType,
                        activeColor: Colors.black,
                        onChanged: (int value) {
                          setState(() {
                            deliveryType = value;
                          });
                        },
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future showDialogAddBill(String message) async {
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: AlertDialog(
            backgroundColor: Color(0xFFd3e9f6),
            title: new Text(
              message,
              style: new TextStyle(
                  fontSize: 17.0,
                  color: Colors.black87,
                  fontFamily: 'KanitRegular'),
            ),
            content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return Column(
                  children: <Widget>[
                    addOrderNoInput(),
                    SizedBox(height: 5),
                    storeDropdown(setState),
                    SizedBox(height: 5),
                    addTypeVehicleBtn(setState),
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
                  });
                  Navigator.of(context).pop(); // Dismiss alert dialog
                },
              ),
              FlatButton(
                child: Text('ตกลง'),
                onPressed: () async {
                  if ((detailOrders.singleWhere(
                          (value) => value.sOrderNo == orderNo.text,
                          orElse: () => null)) !=
                      null) {
                    showDialogAcceap("ออเดอร์นี้มีในระบบแล้ว");
                  } else if (orderNo.text == null ||
                      store == null ||
                      deliveryType == null) {
                    showDialogAcceap("กรุณากรอกข้อมูลออเดอร์ให้ครบถ้วน");
                  } else if (mainReason == null) {
                    showDialogAcceap(
                        "กรุณาเลือกเหตุผลหลักของการไม่ยืนยันออเดอร์");
                  } else {
                    setState(() {
                      var dod = new DeliveryOrderDetail(
                          sOrderNo: orderNo.text, cStatus: 'add');
                      detailOrders.add(dod);
                      AddJsonToListOrderDetail(detailOrders);
                      var ldod = new ListDod(
                          orderId: orderNo.text,
                          deliveryType: deliveryType,
                          locationCode: store,
                          reasonDod: mainReason,
                          statusDod: 'W');
                      model.listDods.add(ldod);
                    });
                    clearAllWidget();
                    Navigator.of(context).pop();
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future showDialogEditBill(String message, String _orderNo) async {
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        int selectedRadio = 0;
        return AlertDialog(
          backgroundColor: Color(0xFFf9fad3),
          title: new Text(
            message,
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
                  editReasonDropdown(setState),
                  SizedBox(height: 5),
                  editTypeVehicleBtn(setState)
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
                setState(() {
                  if (editReason == null) {
                    showDialogAcceap("กรุณาเลือกเหตุผลการแก้ไขออเดอร์");
                  } else {
                    detailOrders
                        .firstWhere((value) => value.sOrderNo == _orderNo)
                        .cStatus = 'edit';
                    var ldod = new ListDod(
                        orderId: _orderNo,
                        reasonDod: editReason,
                        deliveryType: deliveryType,
                        statusDod: 'E');
                    model.listDods.add(ldod);
                    clearAllWidget();
                    Navigator.of(context).pop(); // Dismiss alert dialog
                  }
                });
              },
            ),
          ],
        );
      },
    );
  }

  Future showDialogDeleteBill(
      String message, int index, String _orderNo) async {
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        int selectedRadio = 0;
        return AlertDialog(
          backgroundColor: Color(0xffd3d3d3),
          title: new Text(
            message,
            style: new TextStyle(
                fontSize: 17.0,
                color: Colors.black87,
                fontFamily: 'KanitRegular'),
          ),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [deleteReasonDropdown(setState)],
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
                setState(() {
                  if (deleteReason == null) {
                    showDialogAcceap("กรุณาเลือกเหตุผลการลบออเดอร์");
                  } else {
                    detailOrders.removeAt(index);
                    var ldod = new ListDod(
                        orderId: _orderNo,
                        reasonDod: deleteReason,
                        statusDod: 'N');
                    model.listDods.add(ldod);
                    clearAllWidget();
                    Navigator.of(context).pop(); // Dismiss alert dialog
                  }
                });
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
                // if (message != "กรุณากรอกข้อมูลให้ครบถ้วน") {
                //   final BottomNavigationBar navigationBar =
                //       navBarGlobalKey.currentWidget;
                //   navigationBar.onTap(3);
                // }
              },
            ),
          ],
        );
      },
    );
  }

  void showDialogConfirm(String title, String message) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(title),
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
                Navigator.of(dialogContext).pop();
                if (mainReason == null) {
                  showDialogAcceap('กรุณาเลือกเหตุผลหลักการไม่ยืนยันบิล');
                } else {
                  await pr.show();
                  await _postUpdateNotConfirmBillRider();
                }
              },
            ),
          ],
        );
      },
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
                navigationBar.onTap(14);
              },
            ),
          ],
        );
      },
    );
  }

  void showTypeVehicle(bool enable) {
    setState(() {
      _isVisible = enable;
    });
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
              "บันทึกข้อมูล",
              style: TextStyle(fontSize: 22, fontFamily: 'KanitRegular'),
            ),
            onPressed: () async {
              showDialogConfirm('ยืนยันข้อมูล',
                  'รวมออเดอร์ทั้งหมดของท่านคือ ${detailOrders.length} ใบ');
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
              "ไม่บันทึก",
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
              "ไม่บันทึก",
              style: TextStyle(fontSize: 22, fontFamily: 'KanitRegular'),
            ),
            onPressed: () async {
              show_Dialog('คุณต้องการยกเลิกข้อมูลใช่หรือไม่');
            },
          ),
        ),
      ],
    );
  }

  void clearAllWidget() {
    setState(() {
      if (orderNo.text != null) orderNo.clear();
      if (store != null) store = null;
      if (_selectedDeliveryType != null) _selectedDeliveryType = null;
      if (deliveryType != null) deliveryType = null;
      if (editReason != null) editReason = null;
      if (deleteReason != null) deleteReason = null;
    });
  }
}

class VerticalListItem extends StatelessWidget {
  VerticalListItem(this.item, this.index);

  final DeliveryOrderDetail item;
  int index;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
          Slidable.of(context)?.renderingMode == SlidableRenderingMode.none
              ? Slidable.of(context)?.open()
              : Slidable.of(context)?.close(),
      child: new Container(
        color: item.cStatus == 'edit'
            ? Color(0xfff9fad3)
            : item.cStatus == 'add' ? Color(0xff0e8aea) : Colors.white,
        child: new ListTile(
          title: new Text(
            "ลำดับที่ $index เลขที่ออเดอร์ #${item.sOrderNo}",
            style: new TextStyle(
                fontSize: 17.0,
                color: Colors.black87,
                fontFamily: 'KanitRegular'),
          ),
        ),
      ),
    );
  }
}
