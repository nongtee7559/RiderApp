import 'dart:math';

import 'package:flutter/material.dart';

class Constant {
  // shared preferences
  static const String IS_LOGIN_PREF = "is_login";
  static const String USERNAME_PREF = "username";

  //routes
  static const String HOME_ROUTE = "/home";
  static const String RIDER_APPROVE_READY_ROUTE = "/RiderApproveReady";

  static const String LOGIN_ROUTE = "/login";
  static const String JOBALERT_ROUTE = "/jobalert";
  static const String APPROVEORDER_ROUTE = "/approveOrder";


  static const String DETAIL_ROUTE = "/youtube detail";
  static const String FAVORITE_ROUTE = "/favorite";
  static const String MAP_ROUTE = "/map";
  static const String TIMELINE_ROUTE = "/timeline";
//  static const String MAIN_ROUTE = "/main";
  static const String MAIN_LAUNCHER = "/launcher";
  static const String MYAPP_ROUTE = "My";



  //strings
  static const String APP_NAME = "CM APP";

  //fonts
  static const String QUICK_SAND_FONT = "Quicksand";
  static const String KANIT_FONT = "Kanit";

  //images
  static const String IMAGE_DIR = "assets/images";
  static const String HEADER_1_IMAGE = "$IMAGE_DIR/header_1.png";
  static const String HEADER_2_IMAGE = "$IMAGE_DIR/header_2.png";
  static const String HEADER_3_IMAGE = "$IMAGE_DIR/header_3.png";
  static const String CMDEV_LOGO_IMAGE = "$IMAGE_DIR/cmdev_logo.png";
  static const String PIN_MARKER = "$IMAGE_DIR/pin_marker.png";
  static const String PIN_CURRENT = "$IMAGE_DIR/pin_current.png";

  //color
  static const Color PRIMARY_COLOR = Colors.blue;
  static const Color BLUE_COLOR = Colors.blueAccent;
  static const Color GRAY_COLOR = Color(0xFF666666);
  static const Color BG_COLOR = Color(0xFFF4F6F8);
  static const Color BG_WHITE_COLOR = Color(0xFFFFFFFF);
  static const Color BG_LOAD_COLOR = Color(0xFFe1e5e7);
  static const Color BG_CARD_HOME = Color(0xFF0D47A1);


  static const IconData account_circle = IconData(0xe853, fontFamily: 'MaterialIcons');
  //random color
  static final Random _random = Random();

  // Returns a random color.
  static Color next() {
    return Color(0xFF000000 + _random.nextInt(0x00FFFFFF));
  }
}