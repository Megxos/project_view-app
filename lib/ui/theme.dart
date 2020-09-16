import 'package:flutter/material.dart';
import 'package:project_view/ui/colors.dart';

ThemeData primaryTheme = new ThemeData(
    scaffoldBackgroundColor: Colors.white,
    accentColor: Colors.pinkAccent,
    appBarTheme: AppBarTheme(
        elevation: 0,
        color: Colors.indigo[500],
        iconTheme: IconThemeData(color: Colors.white),
        textTheme: TextTheme(
            headline6: TextStyle(
                color: Colors.indigo[500],
                fontSize: 25,
                fontFamily: 'SFProText',
                fontWeight: FontWeight.bold
            ),
        )
    ),
    textTheme: TextTheme(
        headline6: TextStyle(fontSize: 20),
        bodyText2: TextStyle(fontSize: 20,),
        bodyText1: TextStyle(fontSize: 20),
        subtitle1: TextStyle(fontSize: 20),
        caption: TextStyle(fontSize: 12),
        overline:TextStyle(fontSize: 18),
        button: TextStyle(fontSize: 20)
    ),
    tabBarTheme: TabBarTheme(
        labelStyle: TextStyle(fontWeight: FontWeight.bold),
        labelColor: Colors.grey[700],
        unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal)
    ),
    dialogTheme: DialogTheme(
        elevation: 0,
      titleTextStyle: TextStyle(
        fontFamily: "SFProText",
          color: Colors.grey[900],
          fontSize: 25
      )
    ),
    snackBarTheme: SnackBarThemeData(
        backgroundColor: primaryColor,
        actionTextColor:  plainWhite,
        contentTextStyle: TextStyle(
            color: plainWhite,
            fontSize: 18
        )
    ),
    inputDecorationTheme: InputDecorationTheme(
        contentPadding: EdgeInsets.all(10.0),
        filled: true,
        fillColor: plainWhite,
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: secondaryColor,
                width: 1.5
            )
        ),
        border: OutlineInputBorder(
            borderSide: BorderSide(
                color: secondaryColor,
                width: 2
            )
        )
    ),
    canvasColor: Colors.white,
);

Color darkText = Colors.black;
