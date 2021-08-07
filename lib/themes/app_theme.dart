import 'package:flutter/material.dart';

class AppTheme {
  // constructor
  AppTheme._();

  static final ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: Color.fromRGBO(250, 250, 250, 1),
    appBarTheme: AppBarTheme(
      color: Color.fromRGBO(250, 250, 250, 1),
      iconTheme: IconThemeData(
        color: Colors.white,
      ),
    ),
    colorScheme: ThemeData().colorScheme.copyWith(
          // secondary is accentColor replacement
          secondary: Colors.indigo[700],
          secondaryVariant: Colors.indigo[700],
        ),
    cardTheme: CardTheme(color: Color.fromRGBO(250, 250, 250, 1)),
    iconTheme: IconThemeData(color: Colors.grey),
    hintColor: Colors.black87,
    inputDecorationTheme: new InputDecorationTheme(
      labelStyle: new TextStyle(color: Colors.black87),
    ),
    textTheme: TextTheme(bodyText1: TextStyle(color: Colors.white)),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(primary: Colors.black87),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        side: MaterialStateProperty.resolveWith<BorderSide>(
            (states) => BorderSide(color: Colors.indigo[700])),
        backgroundColor: MaterialStateProperty.resolveWith<Color>(
            (states) => Colors.indigo[700]),
        shape: MaterialStateProperty.resolveWith<OutlinedBorder>((_) {
          return RoundedRectangleBorder(borderRadius: BorderRadius.circular(5));
        }),
        textStyle: MaterialStateProperty.resolveWith<TextStyle>(
            (states) => TextStyle(color: Colors.white)),
      ),
    ),
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
