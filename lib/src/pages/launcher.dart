import 'dart:io';

import 'package:flutter/material.dart';
import 'package:myapp/src/pages/approveReady.dart';
import 'package:myapp/src/pages/jobalert.dart';
import 'package:myapp/src/pages/leaveAlert_pages.dart';
import 'package:myapp/src/pages/leaveFill.dart';
import 'package:myapp/src/pages/perform_page.dart';
import 'package:myapp/src/pages/profile_edit_page.dart';
import 'package:myapp/src/pages/profile_preview_page.dart';
import 'package:myapp/src/pages/startstop.dart';
import 'package:myapp/src/pages/statusready_page.dart';
import 'package:myapp/src/pages/not_confirm_bill_rider_page.dart';
import 'Leave_Approve_page.dart';
import 'package:myapp/src/pages/rider_approve_ready.dart';
import 'approveOrder.dart';
import 'home.dart';
import 'profile.dart';
import 'package:myapp/src/utils/globals.dart' as globals;

GlobalKey navBarGlobalKey = GlobalKey(debugLabel: 'bottomAppBar');

class Launcher extends StatefulWidget {
  static const routeName = '/';

  @override
  State<StatefulWidget> createState() {
    return _LauncherState();
  }
}

class _LauncherState extends State<Launcher> {
  int _selectedIndex = 0;
  PageController _pageController;
  int _selectedIndex1 = 0;
  List<BottomNavigationBarItem> _menuBar = <BottomNavigationBarItem>[
    BottomNavigationBarItem(
      icon: Icon(Icons.home),
      title: Text(
        'หน้าหลัก',
        style: TextStyle(fontFamily: 'KanitRegular', color: Colors.white),
      ),
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.business_center),
      title: Text(
        'ทำงาน',
        style: TextStyle(fontFamily: 'KanitRegular', color: Colors.white),
      ),
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.account_circle),
      title: Text(
        'บัญชี',
        style: TextStyle(fontFamily: 'KanitRegular', color: Colors.white),
      ),
    ),
  ];

  void _onItemTapped(int index) {
    _selectedIndex1 = index;
    setState(() {
      _selectedIndex = index;

      if (_selectedIndex <= 2) {
        _pageController.animateToPage(index,
            duration: Duration(milliseconds: 250), curve: Curves.easeOut);
      } else {
        _pageController.jumpToPage(index);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }
  @override
  void setState(fn) {
    if(mounted) {
      super.setState(fn);
    }
  }
  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_selectedIndex1 <= 2) {
      return SafeArea(
        child: Scaffold(
          appBar: ProfileHeader(MediaQuery.of(context).size.height / 5),
          body: SizedBox.expand(
            child: PageView(
              physics: NeverScrollableScrollPhysics(),
              controller: _pageController,
              onPageChanged: (index) {
                setState(() => _selectedIndex = index);
              },
              children: <Widget>[
                Home(),
                Perform(),
                Profile(),
              ],
            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
            key: navBarGlobalKey,
            items: _menuBar,
            currentIndex: _selectedIndex,
            selectedItemColor: Theme.of(context).primaryColor,
            unselectedItemColor: Colors.white,
            onTap: _onItemTapped,
          ),
        ),
      );
    } else {
      return SafeArea(
        child: Scaffold(
          appBar: ProfileHeader(MediaQuery.of(context).size.height / 5),
          body: SizedBox.expand(
            child: PageView(
              controller: _pageController,
              physics: NeverScrollableScrollPhysics(),
              onPageChanged: (index) {
              },
              children: <Widget>[
                Home(), //0
                Perform(), //1
                Profile(), //2
                Jobalert(), //3
                Startstop(), //4
                ApproveOrder(), //5 Don't use this line
                LeaveFill(), //6
                LeaveAlert(), //7
                LeaveApprove(), //8
                ProfilePreview(), //9
                ProfileEdit(), //10
                StatusReadys(), //11
                ApproveReady(), //12
                NotConfirmBillPage(), //13
                ApproveOrder(), //14
                ApproveReady(), //15
              ],
            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
            key: navBarGlobalKey,
            items: _menuBar,
            selectedItemColor: Theme.of(context).primaryColor,
            unselectedItemColor: Colors.white,
            onTap: _onItemTapped,
          ),
        ),
      );
    }
  }
}

class ProfileHeader extends StatelessWidget implements PreferredSizeWidget{
  @override
  final double height;
  ProfileHeader(
      this.height,
      { Key key,
      }):super(key: key);
  @override
  Widget build(BuildContext context) {
    return Stack(alignment: Alignment.centerLeft, children: <Widget>[
      FittedBox(
        child: Image.asset(
          globals.Path_Imageheader,
          fit: BoxFit.fill,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height / 5,
        ),
      ),

      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: CircleAvatar(
              backgroundColor: Colors.black87,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: globals.user_Path == null
                    ? Image.asset(globals.Path_ImageProfile,
                    width: 70, height: 70, fit: BoxFit.fill)
                    : Image.file(File(globals.user_Path),
                    width: 70, height: 70, fit: BoxFit.fill),
              ),
              radius: 40,
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: Text(
                  'ยินดีต้อนรับ',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'KanitRegular'),
                ),
              ),
              Container(
                  child: Text(
                    globals.Fname + ' ' + globals.Lname,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'KanitRegular'),
                  )),
              Container(
                  child: Text(
                    'รหัสพนักงาน ' + globals.s_EMP_NO,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'KanitRegular'),
                  ))
            ],
          )
        ],
      )
    ]);
  }

  Size get preferredSize {
    return new Size.fromHeight(height);
  }
}

