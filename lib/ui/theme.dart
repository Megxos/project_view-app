import 'package:flutter/material.dart';
import 'package:project_view/ui/colors.dart';

ThemeData primaryTheme = new ThemeData(
  scaffoldBackgroundColor: Colors.white,
  accentColor: Colors.pinkAccent,
  fontFamily: "Gilroy",
  appBarTheme: AppBarTheme(
      elevation: 0,
      centerTitle: true,
      color: primaryColor,
      iconTheme: IconThemeData(color: Colors.white),
      textTheme: TextTheme(
        headline6: TextStyle(
          color: primaryColor,
          fontSize: 25,
        ),
      )),
  textTheme: TextTheme(
      headline6: TextStyle(fontSize: 20),
      bodyText2: TextStyle(
        fontSize: 20,
        color: darkTextColor,
      ),
      bodyText1: TextStyle(
        fontSize: 20,
      ),
      subtitle1: TextStyle(fontSize: 20),
      caption: TextStyle(fontSize: 12),
      overline: TextStyle(fontSize: 18),
      button: TextStyle(
        fontSize: 20,
      )),
  tabBarTheme: TabBarTheme(
      labelStyle: TextStyle(fontWeight: FontWeight.bold),
      labelColor: Colors.grey[700],
      unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal)),
  dialogTheme: DialogTheme(
      elevation: 0,
      titleTextStyle: TextStyle(
        color: Colors.grey[900],
        fontSize: 25,
      )),
  snackBarTheme: SnackBarThemeData(
      backgroundColor: primaryColor,
      actionTextColor: plainWhite,
      contentTextStyle: TextStyle(color: plainWhite, fontSize: 18)),
  inputDecorationTheme: InputDecorationTheme(
      contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
      filled: true,
      fillColor: offWhite,
      enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 0, color: Color(0xe3e9e9e0))),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide: BorderSide(color: secondaryColor, width: 2))),
  canvasColor: Colors.white,
);

ThemeData darkTheme = new ThemeData(
  accentColor: primaryTheme.accentColor,
  appBarTheme: primaryTheme.appBarTheme,
  scaffoldBackgroundColor: Colors.grey[900],
  textTheme: primaryTheme.textTheme.copyWith(
    headline6: primaryTheme.textTheme.headline6.copyWith(color: plainWhite),
    bodyText2: primaryTheme.textTheme.bodyText2.copyWith(color: plainWhite),
    bodyText1: primaryTheme.textTheme.bodyText1.copyWith(color: plainWhite),
    subtitle1: primaryTheme.textTheme.subtitle1.copyWith(color: plainWhite),
    subtitle2: primaryTheme.textTheme.subtitle2.copyWith(color: plainWhite),
    caption: primaryTheme.textTheme.caption.copyWith(color: plainWhite),
  ),
  canvasColor: darkTextColor,
  dialogTheme: primaryTheme.dialogTheme.copyWith(
      titleTextStyle: TextStyle().copyWith(color: plainWhite),
      backgroundColor: darkTextColor),
  inputDecorationTheme:
      primaryTheme.inputDecorationTheme.copyWith(fillColor: Colors.grey[700]),
);

Color darkText = Colors.black;
