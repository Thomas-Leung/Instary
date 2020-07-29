import 'package:flutter/material.dart';

// Dialog is used when deplicate file is detected in app.
class DuplicateDialog {
  // returns a Future that completes when the dialog is dismissed
  Future<void> showDuplicateFileDialog(BuildContext context) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("The image is already in Instary."),
          content: Text("Please pick another image that is not repeated."),
          actions: <Widget>[
            FlatButton(
                child: Text("OK"), onPressed: () => Navigator.of(context).pop())
          ],
          elevation: 0.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(8.0),
            ),
          ),
        );
      },
    );
  }
}
