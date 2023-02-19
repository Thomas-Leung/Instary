import 'package:flutter/material.dart';

showCustomSnackbar(context, message) {
  return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    duration: Duration(seconds: 6),
    margin: EdgeInsets.all(15),
    backgroundColor: Theme.of(context).sliderTheme.thumbColor,
    closeIconColor: Colors.white,
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(15)),
    ),
    content: Text(
      message,
      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    ),
    action: SnackBarAction(
      textColor: Colors.white,
      label: 'Close',
      onPressed: () {},
    ),
  ));
}
