import 'package:flutter/material.dart';

class MyThemeData {
  static final darkTheme = ThemeData(
    // fontFamily: 'OnePlus-Regular',
    scaffoldBackgroundColor: Colors.black,
    primaryColor: Colors.white,
    secondaryHeaderColor: const Color(0xff393E46),
    visualDensity: VisualDensity.adaptivePlatformDensity,
    appBarTheme: const AppBarTheme(
        iconTheme: IconThemeData(color: Color(0xffFFFFFF)),
        backgroundColor: Color(0xff37474F)),
    bottomSheetTheme:
        const BottomSheetThemeData(backgroundColor: Color(0xff37474F)),
    bottomNavigationBarTheme:
        const BottomNavigationBarThemeData(backgroundColor: Color(0xff37474F)),
    iconTheme: const IconThemeData(color: Color(0xffFFFFFF)),
    unselectedWidgetColor: Colors.white,
  );

  static final lightTheme = ThemeData(
    // fontFamily: 'OnePlus-Regular',
    scaffoldBackgroundColor: const Color(0xffFFFFFF),
    primaryColor: Colors.black,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    secondaryHeaderColor: const Color(0xffFFFFFF),
    appBarTheme: const AppBarTheme(
        iconTheme: IconThemeData(color: Color(0xff222222)),
        backgroundColor: Color(0xffDEE4E7)),
    bottomSheetTheme:
        const BottomSheetThemeData(backgroundColor: Color(0xffDEE4E7)),
    bottomNavigationBarTheme:
        const BottomNavigationBarThemeData(backgroundColor: Color(0xffDEE4E7)),
    iconTheme: const IconThemeData(color: Color(0xff222222)),
    // floatingActionButtonTheme: const FloatingActionButtonThemeData(
    //   backgroundColor: Colors.red,
    // ),
  );
}
