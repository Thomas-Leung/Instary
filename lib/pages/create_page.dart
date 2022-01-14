import 'dart:io';

import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:hive/hive.dart';
import 'package:instary/models/feelings_level.dart';
import 'package:instary/widgets/feelings_card.dart';
import 'package:instary/widgets/media_card.dart';
import 'package:intl/intl.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:mime/mime.dart';
import 'package:uuid/uuid.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

import '../models/instary.dart';

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
  // _parentFormKey fixed textField generate many warnings: https://github.com/flutter/flutter/issues/9471#issuecomment-864352277
  final _parentFormKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final contentController = TextEditingController();
  DateTime dateTime = DateTime.now();
  String date = DateFormat.yMMMd().format(DateTime.now());
  FeelingsLevel _level = FeelingsLevel.init();
  late final String appDocumentDirPath;
  List<File> _selectedMedia = [];

  @override
  void initState() {
    super.initState();
    setAppDocumentDirPath();
  }

  Future<void> setAppDocumentDirPath() async {
    await path_provider
        .getApplicationDocumentsDirectory()
        .then((value) => appDocumentDirPath = value.path);
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
        // resizeToAvoidBottomPadding: false,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Column(
              children: <Widget>[_backBtn(), _title(), _instaryForm()],
            ),
          ),
        ),
      ),
    );
  }

  Widget _backBtn() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: SizedBox(
        width: double.infinity,
        child: Align(
          alignment: Alignment.centerLeft,
          child: TextButton.icon(
            icon: Icon(Icons.arrow_back_ios),
            label: Text("back"),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
      ),
    );
  }

  Widget _title() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
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
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.vertical,
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0),
        key: _parentFormKey,
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                width: double.maxFinite,
                child: TextButton(
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                  ),
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
                          color: Theme.of(context).colorScheme.secondary),
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
                  // ! means it will never be null, it will throw an error if it is null
                  if (value!.isEmpty) {
                    return 'Please enter title';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: "Title",
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.secondary,
                        width: 1.5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.secondary,
                        width: 1.5),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
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
                        color: Theme.of(context).colorScheme.secondary,
                        width: 1.5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.secondary,
                        width: 1.5),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
              ),
              Container(
                height: 20.0,
              ),
              MediaCard(
                  existingMediaPaths: _selectedMedia,
                  onSelectedMediaChanged: (List<File> selectedMedia) {
                    _selectedMedia = selectedMedia;
                  }),
              Container(
                height: 20.0,
              ),
              FeelingsCard(
                existingLevel: _level,
                onLevelChanged: (FeelingsLevel newLevel) {
                  _level = newLevel;
                },
              ),
              Container(
                height: 20.0,
              ),
              SizedBox(
                width: double.infinity,
                height: 42,
                child: ElevatedButton.icon(
                  onPressed: () {
                    FocusScope.of(context).requestFocus(new FocusNode());
                    // Validate returns true if the form is valid, or false
                    // otherwise.
                    if (_formKey.currentState!.validate()) {
                      // create unique id
                      var uuid = Uuid();
                      String id = uuid.v1();
                      List<String> mediaPaths = _createMediaPaths();
                      final newInstary = Instary(
                          id,
                          dateTime,
                          titleController.text,
                          contentController.text,
                          _level.happinessLv,
                          _level.tirednessLv,
                          _level.stressfulnessLv,
                          mediaPaths);
                      addInstary(newInstary);
                    }
                  },
                  icon: Icon(Icons.add),
                  label: Text('Submit'),
                ),
              ),
              Container(
                height: 20.0,
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

  List<String> _createMediaPaths() {
    // _selectedMedia contains media file from cache
    // mediaPaths will contain paths of saved location
    List<String> mediaPaths = [];
    String imageSaveLocation =
        appDocumentDirPath + GlobalConfiguration().getValue("androidImagePath");
    String videoSaveLocation =
        appDocumentDirPath + GlobalConfiguration().getValue("androidVideoPath");

    if (_selectedMedia.isEmpty) {
      return mediaPaths;
    } else {
      // ([^\/]+)$ gets the file name with extension, e.g. path/filename.jpg -> filename.jpg
      RegExp regex = new RegExp(r'([^\/]+$)');
      _selectedMedia.forEach((file) {
        String? fileName = regex.stringMatch(file.path);
        String? mimeType = lookupMimeType(file.path);
        if (fileName != null && mimeType != null) {
          late String savePath;
          if (mimeType.contains("image")) {
            savePath = imageSaveLocation + fileName;
          } else if (mimeType.contains("video")) {
            savePath = videoSaveLocation + fileName;
          } else {
            throw UnsupportedError("File Type is not supported");
          }
          mediaPaths.add(savePath);
          _saveMedia(file, savePath);
        }
      });
      return mediaPaths;
    }
  }

  Future<void> _saveMedia(File file, String savePath) async {
    await file.copy(savePath);
  }
}
