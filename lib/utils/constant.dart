import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Constants {
  static const kPurpleColor = Color(0xFFB97DFE);
  static const kRedColor = Color(0xFFFE4067);
  static const kGreenColor = Color(0xFFADE9E3);
}


const kCyan = Color.fromARGB(255, 1, 203, 248);


double? height(BuildContext context) {
  double? size = MediaQuery.of(context).size.height;
  return size;
}

double? width(BuildContext context) {
  double? size = MediaQuery.of(context).size.width;
  return size;
}

double? fontSize(BuildContext context) {
  double? size = MediaQuery.of(context).textScaleFactor;
  return size;
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}

iconSize(BuildContext context) => width(context)! * 0.06;

TextStyle subinfo(BuildContext context) {
  return TextStyle(
    fontSize: width(context)! * 0.03,
    color: const Color(0xFF29292F).withOpacity(0.7),
    fontWeight: FontWeight.w500,
  );
}

TextStyle dtStyle(BuildContext context) {
  return TextStyle(
    fontSize: width(context)! * 0.03,
    fontWeight: FontWeight.w500,
    overflow: TextOverflow.ellipsis,
  );
}

TextStyle mainInfo(BuildContext context) {
  return TextStyle(
    fontSize: width(context)! * 0.04,
    overflow: TextOverflow.ellipsis,
    fontWeight: FontWeight.bold,
    color: const Color(0xFF29292F),
  );
}

appBarTextStyle(BuildContext context) => TextStyle(
      fontSize: width(context)! * 0.04,
      fontWeight: FontWeight.bold,
      letterSpacing: 0.7,
      color: Colors.white,
      overflow: TextOverflow.ellipsis,
    );

mainBarTextStyle(BuildContext context) => TextStyle(
      fontSize: width(context)! * 0.05,
      color: const Color(0xFFA83242),
      fontWeight: FontWeight.bold,
      overflow: TextOverflow.ellipsis,
    );

bodyInfoTextStyle(BuildContext context) =>
    Theme.of(context).textTheme.subtitle2!.copyWith(
          color: Colors.grey,
        );

TextStyle kDataStyle = TextStyle(
  color: Colors.grey[600],
  fontSize: 12,
);

const kButtonText = TextStyle(
  fontSize: 12,
  fontWeight: FontWeight.bold,
);

const kTitleText = TextStyle(
  color: kCyan,
  fontSize: 12,
  overflow: TextOverflow.ellipsis,
  fontWeight: FontWeight.bold,
);

themeTextStyle({context, double? fsize, FontWeight? fweight}) => TextStyle(
      color: Theme.of(context).primaryColor,
      fontSize: fsize,
      overflow: TextOverflow.ellipsis,
      fontWeight: fweight,
    );

kLoginHeadText(BuildContext context) {
  return TextStyle(
    fontSize: width(context)! * 0.07,
    color: kCyan,
    fontWeight: FontWeight.bold,
  );
}

toastView(
        {String? message,
        Color? clr = Colors.white,
        Color? bclr = Colors.grey}) =>
    Fluttertoast.showToast(
      msg: message!,
      fontSize: 14,
      timeInSecForIosWeb: 1,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: bclr,
      textColor: clr,
    );
