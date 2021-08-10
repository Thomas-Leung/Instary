import 'package:flutter/material.dart';
import 'package:instary/themes/app_state_notifier.dart';
import 'package:provider/provider.dart';

class AppTheme {
  // constructor
  AppTheme._();

  static final ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: Color.fromRGBO(250, 250, 250, 1),
    appBarTheme: AppBarTheme(
      elevation: 0,
      color: Color.fromRGBO(250, 250, 250, 1),
      iconTheme: IconThemeData(
        color: Colors.black,
      ),
      textTheme: TextTheme(
        headline6: TextStyle(
            fontSize: 20.0, color: Colors.black, fontWeight: FontWeight.bold),
      ),
    ),
    colorScheme: ThemeData().colorScheme.copyWith(
          // secondary is accentColor replacement
          // ADD BUTTON IN MAIN PAGE
          secondary: Colors.indigo[700],
          // BARCHART
          secondaryVariant: Colors.indigo[400],
        ),
    cardTheme: CardTheme(color: Color.fromRGBO(250, 250, 250, 1)),
    iconTheme: IconThemeData(color: Colors.grey[500]),
    hintColor: Colors.black87,
    inputDecorationTheme: new InputDecorationTheme(
      labelStyle: new TextStyle(color: Colors.black87),
    ),
    textTheme: TextTheme(
      // CREATEPAGE/ EDITPAGE TITLE
      headline1: TextStyle(
          fontWeight: FontWeight.normal, fontSize: 40, color: Colors.black),
      // HOMEPAGE TITLE
      headline2: TextStyle(
          fontWeight: FontWeight.bold, fontSize: 32.0, color: Colors.black),
      // HOMEPAGE INSTARY TITLE
      headline3: TextStyle(
          fontWeight: FontWeight.w600, fontSize: 32.0, color: Colors.white),
      // VIEWPAGE TITLE
      headline4: TextStyle(
          fontWeight: FontWeight.w700, fontSize: 30.0, color: Colors.black),
      // VIEW PAGE CARD TITLE
      headline5: TextStyle(
          color: Colors.blueGrey[700],
          fontSize: 20,
          fontWeight: FontWeight.bold),
      // VIEWPAGE DATE, HOMEPAGE NO INSTARY TEXT
      headline6: TextStyle(
          fontWeight: FontWeight.w600, fontSize: 18.0, color: Colors.grey[500]),
      // DATE ON MAIN PAGE
      subtitle2: TextStyle(
          fontWeight: FontWeight.w600, fontSize: 16.0, color: Colors.grey[400]),
      // VIEWPAGE CONTENT
      bodyText2: TextStyle(fontSize: 15.0),
      // BARCHART TEXT
      caption: TextStyle(
          color: const Color(0xff7589a2),
          fontWeight: FontWeight.bold,
          fontSize: 14),
    ),
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
    scaffoldBackgroundColor: Color.fromRGBO(48, 48, 48, 1),
    appBarTheme: AppBarTheme(
      color: Color.fromRGBO(48, 48, 48, 1),
      iconTheme: IconThemeData(
        color: Colors.white70,
      ),
      textTheme: TextTheme(
        headline6: TextStyle(
            fontSize: 20.0, color: Colors.white, fontWeight: FontWeight.bold),
      ),
    ),
    colorScheme: ThemeData().colorScheme.copyWith(
          // secondary is accentColor replacement
          secondary: Colors.deepPurple[300],
          secondaryVariant: Colors.deepPurple[300],
        ),
    cardTheme: CardTheme(color: Color.fromRGBO(48, 48, 48, 1)),
    iconTheme: IconThemeData(color: Colors.grey),
    hintColor: Colors.white70,
    inputDecorationTheme: new InputDecorationTheme(
      labelStyle: new TextStyle(color: Colors.white70),
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
}

/// Create additional custom text theme on top of the provided attributes
class CustomTextStyle {
  static TextStyle cardCreateTitle(BuildContext context) {
    // listen to AppStateNotifier for darkMode change event
    var theme = Provider.of<AppStateNotifier>(context, listen: true);
    if (!theme.isDarkModeOn) {
      return Theme.of(context)
          .textTheme
          .headline6
          .copyWith(fontWeight: FontWeight.w400, color: Colors.black);
    } else {
      return Theme.of(context)
          .textTheme
          .headline6
          .copyWith(fontWeight: FontWeight.w400, color: Colors.white);
    }
  }
}
