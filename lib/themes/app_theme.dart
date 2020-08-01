import 'package:flutter/material.dart';

class AppTheme {
  // constructor
  AppTheme._();

  static final ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: Colors.teal,
    appBarTheme: AppBarTheme(
      color: Colors.teal,
      iconTheme: IconThemeData(
        color: Colors.white,
      ),
    ),
    cardTheme: CardTheme(color: Colors.red),
    iconTheme: IconThemeData(color: Colors.yellow),
    textTheme: TextTheme(bodyText1: TextStyle(color: Colors.white))
  );
  
  static final ThemeData darkTheme = ThemeData(
    scaffoldBackgroundColor: Colors.black,
    appBarTheme: AppBarTheme(
      color: Colors.teal,
      iconTheme: IconThemeData(
        color: Colors.white,
      ),
    ),
  );
}
