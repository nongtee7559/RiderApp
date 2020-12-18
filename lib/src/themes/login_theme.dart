import 'package:flutter/material.dart';

class LoginTheme{
  const LoginTheme();
  static const btnConfirm = const Color(0xFFFFC400);
  static const beginColor = const Color(0xFF0D47A1);
  static const endColor = const Color(0xFF0D47A1);

  static const btnSubmit = const Color(0xFF92d58c);
  static const btncancel = const Color(0xFFff235d);

  static const btncolor = const Color(0xFFffffff);
     static const cardBg = const Color(0xFF94c1f8);
  static const bg_btnProfile = const Color(0xFFD7F9FF);


  static const LoginbeginColor = const Color(0xFF69b8f5);
  static const LoginendColor = const Color(0xFF0887e8);
//  Color(0xFFfbab66);
//  Color(0xFFf7418c);
  static const gradient = const LinearGradient(
    colors: const [LoginbeginColor, LoginendColor],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    stops: [0.0, 1.0],
  );
}

