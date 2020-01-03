import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:instary/viewPage.dart';
import 'package:intl/intl.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

import 'models/instary.dart';

class EditPage extends StatefulWidget {
  final instary;
  EditPage({this.instary});

  State<StatefulWidget> createState() {
    return _EditPageState();
  }
}

// array of photo path, star
class _EditPageState extends State<EditPage> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  final _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final contentController = TextEditingController();
  DateTime dateTime;
  String date;
  double happinessLv;
  double tirednessLv;
  double stressfulnessLv;

  @override
  void initState() {
    dateTime = widget.instary.dateTime;
    date = DateFormat.yMMMd().format(dateTime);
    titleController.text = widget.instary.title;
    contentController.text = widget.instary.content;
    happinessLv = widget.instary.happinessLv;
    tirednessLv = widget.instary.tirednessLv;
    stressfulnessLv = widget.instary.stressfulnessLv;
    super.initState();
  }

  @override
  void dispose() {
    // clean up the controllers when the widget is disposed
    titleController.dispose();
    contentController.dispose();
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
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[_backBtn(), _title(), _instaryForm()],
            ),
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
          label: Text("Cancel"),
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text("Edit Instary",
              style: TextStyle(fontStyle: FontStyle.normal, fontSize: 40)),
          IconButton(
            icon: Icon(Icons.delete, size: 30.0),
            color: Colors.red[800],
            onPressed: () {
              _showDeleteDialog();
            },
          )
        ],
      ),
    );
  }

  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          title: Text("Delete Instary"),
          content: Text("Are you sure you want to delete this Instary?"),
          actions: <Widget>[
            FlatButton(
              child: Text("Cancel", style: TextStyle(color: Colors.grey[600])),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text("Delete", style: TextStyle(color: Colors.red[800])),
              onPressed: () {
                final instaryBox = Hive.box('instary');
                instaryBox.delete(this.widget.instary.id);
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
            )
          ],
        );
      },
    );
  }

  Widget _instaryForm() {
    return Expanded(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
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
                      setState(() {
                        this.date = DateFormat.yMMMd().format(date);
                        dateTime = date;
                      });
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
                controller: titleController,
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
                controller: contentController,
                maxLines: 6,
                decoration: InputDecoration(
                  hintText: "What have you experienced today?",
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
              _feelingCard(),
              Container(
                height: 20.0,
              ),
              Center(
                child: ButtonTheme(
                  minWidth: 250.0,
                  height: 42.0,
                  buttonColor: Colors.indigo[700],
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0)),
                  textTheme: ButtonTextTheme.primary,
                  child: RaisedButton.icon(
                    onPressed: () {
                      FocusScope.of(context).requestFocus(new FocusNode());
                      // Validate returns true if the form is valid, or false
                      // otherwise.
                      if (_formKey.currentState.validate()) {
                        final newInstary = Instary(
                            this.widget.instary.id,
                            dateTime,
                            titleController.text,
                            contentController.text,
                            happinessLv,
                            tirednessLv,
                            stressfulnessLv);
                        updateInstary(newInstary);
                      }
                    },
                    icon: Icon(Icons.save),
                    label: Text('Save'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void updateInstary(Instary instary) {
    final instaryBox = Hive.box('instary');
    instaryBox.put(instary.id, instary);
    // hacky way for now, pop back to main page and update ViewPage
    Navigator.of(context).popUntil((route) => route.isFirst);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ViewPage(instary: instary),
      ),
    );
  }

  Widget _feelingCard() {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Align(
              alignment: Alignment.centerLeft,
              child: Text('Rate your feelings',
                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: 20)),
            ),
            Container(
              child: Text("Happiness"),
              padding: EdgeInsets.only(top: 16.0),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: <Widget>[
                  Icon(Icons.sentiment_dissatisfied),
                  Expanded(
                    child: SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        activeTrackColor: Colors.indigo[700],
                        inactiveTrackColor: Colors.grey,
                        trackHeight: 4.0,
                        thumbColor: Colors.indigo,
                        thumbShape:
                            RoundSliderThumbShape(enabledThumbRadius: 8.0),
                        overlayColor: Colors.purple.withAlpha(60),
                        overlayShape:
                            RoundSliderOverlayShape(overlayRadius: 16.0),
                      ),
                      child: Slider(
                        value: happinessLv,
                        min: 0,
                        max: 100,
                        divisions: 100,
                        onChanged: (value) {
                          setState(() {
                            happinessLv = value;
                          });
                        },
                      ),
                    ),
                  ),
                  Icon(Icons.sentiment_satisfied)
                ],
              ),
            ),
            Container(
              child: Text("Tiredness"),
              padding: EdgeInsets.only(top: 16.0),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: <Widget>[
                  Icon(Icons.battery_charging_full),
                  Expanded(
                    child: SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        activeTrackColor: Colors.indigo[700],
                        inactiveTrackColor: Colors.grey,
                        trackHeight: 4.0,
                        thumbColor: Colors.indigo,
                        thumbShape:
                            RoundSliderThumbShape(enabledThumbRadius: 8.0),
                        overlayColor: Colors.purple.withAlpha(60),
                        overlayShape:
                            RoundSliderOverlayShape(overlayRadius: 16.0),
                      ),
                      child: Slider(
                        value: tirednessLv,
                        min: 0,
                        max: 100,
                        divisions: 100,
                        onChanged: (value) {
                          setState(() {
                            tirednessLv = value;
                          });
                        },
                      ),
                    ),
                  ),
                  Icon(Icons.airline_seat_flat)
                ],
              ),
            ),
            Container(
              child: Text("Stressfulness"),
              padding: EdgeInsets.only(top: 16.0),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: <Widget>[
                  Icon(Icons.sentiment_very_satisfied),
                  Expanded(
                    child: SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        activeTrackColor: Colors.indigo[700],
                        inactiveTrackColor: Colors.grey,
                        trackHeight: 4.0,
                        thumbColor: Colors.indigo,
                        thumbShape:
                            RoundSliderThumbShape(enabledThumbRadius: 8.0),
                        overlayColor: Colors.purple.withAlpha(60),
                        overlayShape:
                            RoundSliderOverlayShape(overlayRadius: 16.0),
                      ),
                      child: Slider(
                        value: stressfulnessLv,
                        min: 0,
                        max: 100,
                        divisions: 100,
                        onChanged: (value) {
                          setState(() {
                            stressfulnessLv = value;
                          });
                        },
                      ),
                    ),
                  ),
                  Icon(Icons.sentiment_very_dissatisfied)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
