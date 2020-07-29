import 'dart:io';

import 'package:Instary/widgets/duplicate_dialog.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:uuid/uuid.dart';
import 'models/instary.dart';

class CreatePage extends StatefulWidget {
  State<StatefulWidget> createState() {
    return _CreatePageState();
  }
}

// array of photo path, star
class _CreatePageState extends State<CreatePage> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  final _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final contentController = TextEditingController();
  DateTime dateTime = DateTime.now();
  String date = DateFormat.yMMMd().format(DateTime.now());
  double happinessLv = 50.0;
  double tirednessLv = 50.0;
  double stressfulnessLv = 50.0;
  File _pickedImage;

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
              _imageCard(),
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
                        // create unique id
                        var uuid = Uuid();
                        String id = uuid.v1();
                        List<String> imagePaths = _createImagePaths();
                        final newInstary = Instary(
                            id,
                            dateTime,
                            titleController.text,
                            contentController.text,
                            happinessLv,
                            tirednessLv,
                            stressfulnessLv,
                            imagePaths);
                        addInstary(newInstary);
                      }
                    },
                    icon: Icon(Icons.add),
                    label: Text('Submit'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void addInstary(Instary instary) {
    final instaryBox = Hive.box('instary');
    instaryBox.put(instary.id, instary);
    Navigator.pop(context);
  }

  List<String> _createImagePaths() {
    List<String> imagePaths = new List();
    if (_pickedImage == null) {
      // create 1 item in list for empty image
      imagePaths.add(null);
      return imagePaths;
    } else {
      RegExp regex = new RegExp(r'([^\/]+$)');
      String fileName = regex.stringMatch(_pickedImage.path);
      imagePaths.add("/storage/emulated/0/Instary/pictures/$fileName");
      _saveImage(fileName);
      return imagePaths;
    }
  }

  Future<void> _saveImage(String fileName) async {
    await _pickedImage.copy("/storage/emulated/0/Instary/pictures/$fileName");
  }

  Widget _imageCard() {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Text('You image of the day: ',
                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: 20)),
            ),
            GestureDetector(
              child: Center(
                child: _pickedImage == null
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment
                            .center, // Center Row contents horizontally,
                        crossAxisAlignment: CrossAxisAlignment
                            .center, // Center Row contents vertically,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(right: 2.0),
                            child: Icon(Icons.add_photo_alternate,
                                color: Colors.grey),
                          ),
                          Text("Add Image",
                              style: TextStyle(color: Colors.grey)),
                        ],
                      )
                    : Column(
                        children: <Widget>[
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: Image(
                              image: FileImage(_pickedImage),
                            ),
                          ),
                          FlatButton.icon(
                            icon: Icon(
                              Icons.delete_outline,
                              color: Colors.red[800],
                            ),
                            label: Text(
                              "Remove Image",
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: Colors.red[800]),
                            ),
                            onPressed: () {
                              setState(() => _pickedImage = null);
                            },
                          ),
                        ],
                      ),
              ),
              onTap: () => _pickImage(),
            ),
          ],
        ),
      ),
    );
  }

  void _pickImage() async {
    final imageSource = await showDialog<ImageSource>(
        context: context,
        builder: (context) => SimpleDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),
              ),
              title: Text("Select an image source"),
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () => Navigator.pop(context, ImageSource.camera),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 20.0, 30.0, 20.0),
                        child: Column(
                          children: <Widget>[
                            Icon(
                              Icons.camera_alt,
                              color: Colors.grey,
                            ),
                            Text("Camera",
                                style: TextStyle(color: Colors.grey)),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 40.0,
                      color: Colors.grey,
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context, ImageSource.gallery),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(30.0, 20.0, 0, 20.0),
                        child: Column(
                          children: <Widget>[
                            Icon(
                              Icons.photo,
                              color: Colors.grey,
                            ),
                            Text("Gallery",
                                style: TextStyle(color: Colors.grey)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ));

    if (imageSource != null) {
      final file = await ImagePicker.pickImage(source: imageSource);
      if (file != null) {
        // check if file already exist in Instary folder, if so notify user to pick again
        RegExp regex = new RegExp(r'([^\/]+$)');
        String fileName = regex.stringMatch(file.path);
        String filePath = "/storage/emulated/0/Instary/pictures/$fileName";
        bool fileExist = await File(filePath).exists();
        if (fileExist) {
          var dialog = new DuplicateDialog();
          dialog.showDuplicateFileDialog(context);
        } else {
          setState(() => _pickedImage = file);
        }
      }
    }
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
