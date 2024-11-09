import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserTheme extends GetxController {
  final RxBool userThemeState = true.obs;

  final Rx<Color> tfc = Colors.white.obs;

  final Color ts = const Color.fromARGB(85, 255, 255, 255);

  Rx<Color> buttonColor = const Color.fromARGB(255, 0, 101, 179).obs;
  // Color.fromARGB(255, 237, 52, 52).obs is red
  //Color.fromARGB(255, 0, 101, 179).obs is blue

  ThemeData currentTheme = ThemeData(
    // the theme overide is only for highlighting
    cupertinoOverrideTheme: const CupertinoThemeData(
      primaryColor: Colors.blue,
    ),
    canvasColor: Colors.grey,
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
    appBarTheme: AppBarTheme(
      elevation: 0,
      titleTextStyle:
          const TextStyle(color: Colors.white, fontFamily: 'NotoSans'),
      backgroundColor: Colors.grey[850],
      iconTheme: const IconThemeData(color: Colors.white),
    ),
    drawerTheme: DrawerThemeData(
        backgroundColor: Colors.grey[850], shadowColor: Colors.grey[850]),
  ).copyWith(
      scaffoldBackgroundColor: Colors.grey[850],
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        selectedLabelStyle: TextStyle(
            fontFamily: 'NotoSans', fontWeight: FontWeight.bold, fontSize: 18),
        unselectedLabelStyle: TextStyle(fontFamily: 'NotoSans', fontSize: 16),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white,
      ),
      textSelectionTheme: const TextSelectionThemeData(
          selectionColor: Colors.blue,
          selectionHandleColor: Colors.blue,
          cursorColor: Colors.blue));
  Color? bars = Colors.grey[850];
  Brightness statbright = Brightness.dark;
}
