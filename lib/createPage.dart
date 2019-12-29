import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class CreatePage extends StatefulWidget {
  State<StatefulWidget> createState() {
    return _CreatePageState();
  }
}

// title*, date*, content*, feelings (happiness level, tiredness level, stressfulness level), array of photo path, star
class _CreatePageState extends State<CreatePage> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  final _formKey = GlobalKey<FormState>();
  final titleConrtoller = TextEditingController();
  final contentConrtoller = TextEditingController();
  DateTime dateTime = DateTime.now();
  String date = DateFormat.yMMMd().format(DateTime.now());

  @override
  void dispose() {
    // clean up the controllers when the widget is disposed
    titleConrtoller.dispose();
    contentConrtoller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // hide soft input keyboard when click outside textfield
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        body: SafeArea(
          child: Builder(
            builder: (BuildContext context) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[_backBtn(), _title(), _instaryForm()],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _backBtn() {
    return SizedBox(
      width: double.infinity,
      child: Align(
        alignment: Alignment.centerLeft,
        child: FlatButton.icon(
          icon: Icon(Icons.arrow_back_ios),
          label: Text("back"),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  Widget _title() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text("Create Instary",
            style: TextStyle(fontStyle: FontStyle.normal, fontSize: 40)),
      ),
    );
  }

  Widget _instaryForm() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              width: double.maxFinite,
              child: FlatButton(
                padding: EdgeInsets.all(0),
                onPressed: () {
                  DatePicker.showDatePicker(context,
                      showTitleActions: true,
                      onChanged: (date) {}, onConfirm: (date) {
                    this.date = DateFormat.yMMMd().format(date);
                    dateTime = date;
                  }, currentTime: dateTime);
                },
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    this.date,
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 25,
                        color: Theme.of(context).accentColor),
                  ),
                ),
              ),
            ),
            Container(
              height: 10.0,
            ),
            TextFormField(
              controller: titleConrtoller,
              // The validator receives the text that the user has entered.
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter title';
                }
                return null;
              },
              decoration: InputDecoration(
                labelText: "Title",
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Theme.of(context).accentColor, width: 1.5),
                ),
                // when focused
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0)),
              ),
            ),
            Container(
              height: 20.0,
            ),
            TextFormField(
              controller: contentConrtoller,
              maxLines: 6,
              decoration: InputDecoration(
                labelText: "Content",
                alignLabelWithHint: true,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Theme.of(context).accentColor, width: 1.5),
                ),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0)),
              ),
            ),
            Container(
              height: 20.0,
            ),
            RaisedButton(
              onPressed: () {
                FocusScope.of(context).requestFocus(new FocusNode());
                // Validate returns true if the form is valid, or false
                // otherwise.
                if (_formKey.currentState.validate()) {
                  print(titleConrtoller.text);
                }
              },
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
