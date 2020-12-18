import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:myapp/src/themes/main_theme.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:myapp/src/utils/globals.dart' as globals;
import 'package:myapp/src/services/Strings.dart';

ProgressDialog pr;

class StatusReadys extends StatefulWidget {
  static const routeName = '/perform';

  @override
  State<StatefulWidget> createState() {
    return _StatusReadyState();
  }
}

class _StatusReadyState extends State<StatusReadys> {
  double progress = 0;
  InAppWebViewController webView;
  String url = "";
  var Client;
  @override
  void initState() {
    _buildProfile();
    super.initState();
  }
  @override
  void setState(fn) {
    if(mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    pr = new ProgressDialog(context);
    pr.style(message: 'Please wait...');
    return Scaffold(
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(gradient: MainTheme.gradient),
        child: Container(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: MediaQuery.of(context).size.height - 250,
                child: Column(children: <Widget>[
                  Container(
                      padding: EdgeInsets.all(0.0),
                      child: progress < 1.0
                          ? LinearProgressIndicator(value: progress)
                          : Container()),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.all(0.0),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.white)),
                      child: InAppWebView(
                        initialUrl:
                            "${Strings.ParameterUrl}supplier/reportriderleavemobile/" +
                                Client.toString() +
                                "?E=" +
                                globals.i_EMP_ID.toString() +
                                "&T=" +
                                globals.onlyToken.toString(),
                        initialHeaders: {},
                        initialOptions: InAppWebViewGroupOptions(
                            crossPlatform: InAppWebViewOptions(
                          debuggingEnabled: true,
                        )),
                        onWebViewCreated: (InAppWebViewController controller) {
                          webView = controller;
                        },
                        onLoadStart:
                            (InAppWebViewController controller, String url) {
                          setState(() {
                            this.url = url;
                          });
                        },
                        onLoadStop: (InAppWebViewController controller,
                            String url) async {
                          setState(() {
                            this.url = url;
                          });
                        },
                        onProgressChanged:
                            (InAppWebViewController controller, int progress) {
                          setState(() {
                            this.progress = progress / 100;
                          });
                        },
                      ),
                    ),
                  ),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _buildProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      Client = prefs.getString('Client');
    });
  }
}
