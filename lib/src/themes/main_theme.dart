import 'package:flutter/material.dart';

class MainTheme{
  const MainTheme();
  static const btnConfirm = const Color(0xB8C8E5);
  static const btnCancel = const Color(0xB8C8E5);

  static const beginColor = const Color(0xB8C8E5);
  static const endColor = const Color(0xB8C8E5);
  static const Color White400 = Color(0xFFD3D3D3);
  static const Color nearlyWhite = Color(0xFFFAFAFA);
  static const Color white = Color(0xFFFFFFFF);
  static const Color background = Color(0xFFF2F3F8);
  static const Color nearlyDarkBlue = Color(0xFF2633C5);

  static const Color nearlyBlue = Color(0xFF00B6F0);
  static const Color nearlyBlack = Color(0xFF213333);
  static const Color grey = Color(0xFF3A5160);
  static const Color dark_grey = Color(0xFF313A44);

  static const Color darkText = Color(0xFF253840);
  static const Color darkerText = Color(0xFF17262A);
  static const Color lightText = Color(0xFF4A6572);
  static const Color deactivatedText = Color(0xFF767676);
  static const Color dismissibleBackground = Color(0xFF364A54);

  static const HomebeginColor = const Color(0xFF0887e8);
  static const HomeendColor = const Color(0xFF69b8f5);

  static const HomestartTripColor = const Color(0xFFa9a6a6);
  static const HomeendTripColor = const Color(0xFFececec);

  static const ColorNone = const Color(0xFF99000000);

  static const ColorBgAlert = const Color(0xFFd1eaf5);


  static const txtcolor = const Color(0xFFbabeb0);
  static const bgcamera = const Color(0xFF6dcff6);




//  Color(0xFFfbab66);
//  Color(0xFFf7418c);
  static const gradient = const LinearGradient(
    colors: const [beginColor, endColor],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    stops: [0.0, 1.0],
  );
}

