import 'package:flutter/material.dart';

class AppTheme {
  // constructor
  AppTheme._();

  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    // primaryColor: Colors.grey[900],

    // +(ADD) BUTTONS
    colorScheme: ColorScheme.light(
      secondary: Color(0xff425296),
      // onSurface: DatePicker Text color
    ),

    // SEARCH BAR
    bannerTheme: MaterialBannerThemeData(backgroundColor: Colors.blueGrey[50]),

    appBarTheme: AppBarTheme(
      elevation: 0,
      color: Colors.white54,
      iconTheme: IconThemeData(
        color: Colors.black,
      ),
      // APP BAR TITLE
      titleTextStyle: TextStyle(
          fontSize: 20.0, color: Colors.black, fontWeight: FontWeight.bold),
    ),

    // SWITCH, SLIDER
    sliderTheme: SliderThemeData(
        activeTrackColor: Colors.indigo[700], thumbColor: Colors.indigo),

    // BARCHART
    indicatorColor: Colors.indigo[400],
    // BARCHART TOOLTIP color is inside the barchart code
    // cardTheme: CardTheme(color: Color.fromRGBO(241, 241, 241, 1)),

    // FEELINGS ICONS
    iconTheme: IconThemeData(color: Colors.grey[500]),

    // LABELS in TEXTFIELDS (Title and Content textfields)
    inputDecorationTheme: new InputDecorationTheme(
      labelStyle: new TextStyle(color: Colors.black87),
    ),

    textTheme: TextTheme(
      // VIEWPAGE TITLE
      bodyText2: TextStyle(color: Colors.black),
      // VIEWPAGE CARD TITLE
      subtitle1: TextStyle(color: Colors.blueGrey[700]),
      // BARCHART LABEL
      overline: TextStyle(color: Color(0xff7589a2)),
    ),

    // BACK or CANCEL BUTTON
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(primary: Colors.black87),
    ),

    // SAVE BUTTON
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        minimumSize: MaterialStateProperty.resolveWith<Size>(
            (states) => Size(250.0, 42)),
        side: MaterialStateProperty.resolveWith<BorderSide>(
            // Reference: https://stackoverflow.com/a/67717268
            (states) => BorderSide(color: Colors.indigo[700]!)),
        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
        backgroundColor: MaterialStateProperty.resolveWith<Color>(
            (states) => lightTheme.colorScheme.secondary),
        shape: MaterialStateProperty.resolveWith<OutlinedBorder>((_) {
          return RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0));
        }),
        textStyle: MaterialStateProperty.resolveWith<TextStyle>(
            (states) => TextStyle(color: Colors.white)),
      ),
    ),

    // CIRCULAR PROGRESS INDICATOR
    progressIndicatorTheme:
        ProgressIndicatorThemeData(color: Colors.indigo[300]),
  );

  /// DARK THEME
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,

    // +(ADD and SUBMIT) BUTTON
    colorScheme: ColorScheme.dark(
      secondary: Colors.deepPurple[300]!,
      onPrimary: Colors.white,
    ),
    bannerTheme: MaterialBannerThemeData(backgroundColor: Colors.grey[800]),
    appBarTheme: AppBarTheme(
      elevation: 0,
      color: Colors.black26,
    ),
    sliderTheme: SliderThemeData(
        activeTrackColor: Colors.deepPurple[300],
        thumbColor: Colors.deepPurple[200]),
    indicatorColor: Colors.deepPurple[300],
    iconTheme: IconThemeData(color: Colors.white),
    inputDecorationTheme: new InputDecorationTheme(
      labelStyle: new TextStyle(color: Colors.white),
    ),
    textTheme: TextTheme(
      bodyText2: TextStyle(color: Colors.white),
      subtitle1: TextStyle(color: Colors.blueGrey[50]),
      overline: TextStyle(color: Colors.blueGrey[50]),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(primary: Colors.white),
    ),
    // ButtonStyle > elevatedButtonTheme > ButtonTheme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        minimumSize: MaterialStateProperty.resolveWith<Size>(
            (states) => Size(250.0, 42)),
        side: MaterialStateProperty.resolveWith<BorderSide>(
            (states) => BorderSide(color: Colors.deepPurple[300]!)),
        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
        backgroundColor: MaterialStateProperty.resolveWith<Color>(
            (states) => darkTheme.colorScheme.secondary),
        shape: MaterialStateProperty.resolveWith<OutlinedBorder>((_) {
          return RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0));
        }),
        textStyle: MaterialStateProperty.resolveWith<TextStyle>(
            (states) => TextStyle(color: Colors.white)),
      ),
    ),
    progressIndicatorTheme:
        ProgressIndicatorThemeData(color: Colors.deepPurple[300]),
  );
}
