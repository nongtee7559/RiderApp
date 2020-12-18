import 'package:flutter/material.dart';
import 'package:myapp/src/models/client_response.dart';
import 'package:myapp/src/pages/launcher.dart';
import 'package:myapp/src/services/network_service.dart';
import 'package:myapp/src/themes/main_theme.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

ProgressDialog pr;

class ChooseClient extends StatefulWidget {
  static const routeName = '/ChooseClient';

  @override
  State<StatefulWidget> createState() {
    return _ChooseClientState();
  }
}

class _ChooseClientState extends State<ChooseClient> {
  TextEditingController controller = new TextEditingController();
  NetworkService networkService;
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
        child: new Theme(
          data: Theme.of(context).copyWith(
            canvasColor: MainTheme.HomeendTripColor,
          ),
          child: Container(
            color: MainTheme.ColorBgAlert,
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Card(
                      margin: EdgeInsets.only(
                          left: 0, right: 0, top: 70, bottom: 18),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 50, right: 50, top: 25, bottom: 25),
                        child: Column(
                          children: <Widget>[
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  new Text(
                                    "เลือกประเภทลูกค้า",
                                    style: new TextStyle(
                                        fontSize: 22,
                                        color: Colors.black87,
                                        fontFamily: 'KanitRegular'),
                                  ),
                                ]),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                new Container(
                  color: MainTheme.ColorBgAlert,
                  child: new Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: new Card(
                      child: new ListTile(
                        leading: new Icon(Icons.search),
                        title: new TextField(
                          controller: controller,
                          decoration: new InputDecoration(
                              hintText: 'ค้นหา...',
                              border: InputBorder.none,
                              hintStyle: new TextStyle(
                                  fontSize: 20, color: Colors.black87)),
                          onChanged: onSearchTextChanged,
                        ),
                        trailing: new IconButton(
                          icon: new Icon(Icons.cancel),
                          onPressed: () {
                            controller.clear();
                            onSearchTextChanged('');
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                new Expanded(
                  child: _searchResult.length != 0 || controller.text.isNotEmpty
                      ? new ListView.builder(
                          itemCount: _searchResult.length,
                          itemBuilder: (context, i) {
                            return Card(
                              margin: EdgeInsets.only(
                                  left: 10, right: 10, bottom: 10),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0)),
                              child: Column(
                                children: <Widget>[
                                  new FlatButton(
                                    onPressed: () async {
                                      SharedPreferences prefs =
                                          await SharedPreferences.getInstance();
                                      await prefs.setString('Client',
                                          (_searchResult[i].sClientCompCode));
                                      await prefs.setString('ClientName',
                                          (_searchResult[i].sNameTh));
                                      Navigator.pushAndRemoveUntil(
                                          context,
                                          PageRouteBuilder(pageBuilder:
                                              (BuildContext context,
                                                  Animation animation,
                                                  Animation
                                                      secondaryAnimation) {
                                            return Launcher();
                                          }, transitionsBuilder:
                                              (BuildContext context,
                                                  Animation<double> animation,
                                                  Animation<double>
                                                      secondaryAnimation,
                                                  Widget child) {
                                            return new SlideTransition(
                                              position: new Tween<Offset>(
                                                begin: const Offset(1.0, 0.0),
                                                end: Offset.zero,
                                              ).animate(animation),
                                              child: child,
                                            );
                                          }),
                                          (Route route) => false);
                                    },
                                    child: _buildHeaderCard(_searchResult[i]),
                                  ),
                                ],
                              ),
                            );
                          },
                        )
                      : new Container(
                          height: MediaQuery.of(context).size.height * 0.70,
                          margin:
                              EdgeInsets.only(left: 10, right: 10, bottom: 10),
                          child: _buildContent(),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  FutureBuilder<List<ClientData>> _buildContent() {
    return FutureBuilder<List<ClientData>>(
      future: networkService.GetDataClient(),
      builder:
          (BuildContext context, AsyncSnapshot<List<ClientData>> snapshot) {
        pr.hide();
        if (snapshot.hasData) {
          if (snapshot.data != null) {
            _userDetails = snapshot.data;
            return _buildListView(snapshot.data);
          }
          return Text("error");
        }
        return Center();
      },
    );
  }

  onSearchTextChanged(String text) async {
    _searchResult.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }
    _userDetails.forEach((userDetail) {
      if (userDetail.sNameTh.contains(text) ||
          userDetail.sNameEn.contains(text)) _searchResult.add(userDetail);
    });
    setState(() {});
  }
}

List<ClientData> _searchResult = [];
List<ClientData> _userDetails = [];

Widget _buildListView(List<ClientData> data) {
  return ListView.builder(
    padding: EdgeInsets.only(top: 10, bottom: 10),
    itemBuilder: (BuildContext context, int position) {
      final item = data[position];
      return Card(
        margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        child: Column(
          children: <Widget>[
            new FlatButton(
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.setString(
                    'Client', (data[position].sClientCompCode));
                await prefs.setString('ClientName', (data[position].sNameTh));
                Navigator.pushAndRemoveUntil(
                    context,
                    PageRouteBuilder(pageBuilder: (BuildContext context,
                        Animation animation, Animation secondaryAnimation) {
                      return Launcher();
                    }, transitionsBuilder: (BuildContext context,
                        Animation<double> animation,
                        Animation<double> secondaryAnimation,
                        Widget child) {
                      return new SlideTransition(
                        position: new Tween<Offset>(
                          begin: const Offset(1.0, 0.0),
                          end: Offset.zero,
                        ).animate(animation),
                        child: child,
                      );
                    }),
                    (Route route) => false);
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

_buildHeaderCard(ClientData item) {
  return SingleChildScrollView(
      child: Column(
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
              Column(children: <Widget>[
                Image.network(
                  item.sLogoSrc != null
                      ? item.sLogoSrc
                      : "http://27.254.189.185:90/ClientNull.png",
//                  'assets/images/logo_home.png',
                  height: 70,
                  width: 70,
                ),
              ]),
              SizedBox(width: 10),
              Container(
                  height: 90,
                  width: 10,
                  child: VerticalDivider(color: Colors.black54)),
              SizedBox(width: 16),
              Column(children: <Widget>[
                Text(
                  item.sNameTh,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontFamily: 'KanitRegular'),
                ),
              ]),
            ],
          ),
        ],
      ),
    ],
  ));
}
