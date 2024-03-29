import 'dart:io';

import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:hive/hive.dart';
import 'package:instary/models/feelings_level.dart';
import 'package:instary/widgets/feelings_card.dart';
import 'package:instary/widgets/media_card.dart';
import 'package:instary/widgets/sleep_card.dart';
import 'package:instary/widgets/tags_card.dart';
import 'package:intl/intl.dart';
import 'package:mime/mime.dart';
import 'view_page.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as picker;

import '../models/instary.dart';

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
  // _parentFormKey fixed textField generate many warnings: https://github.com/flutter/flutter/issues/9471#issuecomment-864352277
  final _parentFormKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final contentController = TextEditingController();
  // late means it is null for now but it will never be null after initialized
  late DateTime dateTime;
  late String date;
  late FeelingsLevel _level;
  late final String appDocumentDirPath;
  List<File> _selectedMedia = [];
  DateTime? _bedTime;
  DateTime? _wakeUpTime;
  Object redrawSleepCard = Object();
  List<String> dbTags = [];
  List<String> _selectedTags = [];

  @override
  void initState() {
    dateTime = widget.instary.dateTime;
    date = DateFormat.yMMMd().format(dateTime);
    titleController.text = widget.instary.title;
    contentController.text = widget.instary.content;
    _level = FeelingsLevel(widget.instary.happinessLv,
        widget.instary.tirednessLv, widget.instary.stressfulnessLv);
    for (String filePath in widget.instary.mediaPaths) {
      _selectedMedia.add(File(filePath));
    }
    _bedTime = widget.instary.bedTime;
    _wakeUpTime = widget.instary.wakeUpTime;
    _selectedTags = widget.instary.tags;
    setAppDocumentDirPath();
    getExistingTagsFromDb();
    super.initState();
  }

  Future<void> setAppDocumentDirPath() async {
    await path_provider
        .getApplicationDocumentsDirectory()
        .then((value) => appDocumentDirPath = value.path);
  }

  Future<void> getExistingTagsFromDb() async {
    final tagBox = Hive.box('tag');
    setState(() {
      dbTags = tagBox.keys.cast<String>().toList();
    });
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
        // resizeToAvoidBottomInset: false, maybe use this line
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
            label: Text("Cancel"),
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
            TextButton(
              child: Text("Cancel", style: TextStyle(color: Colors.grey[600])),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Delete", style: TextStyle(color: Colors.red[800])),
              onPressed: () {
                final instaryBox = Hive.box('instary');
                // use deletePaths instead of _selectedPaths since user can modify
                // _selectedPaths before deleting the project
                List<String> deletePaths =
                    widget.instary.mediaPaths as List<String>;
                if (deletePaths.isNotEmpty) {
                  deletePaths.forEach((path) => _deleteMedia(path));
                }
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
                    picker.DatePicker.showDatePicker(context,
                        showTitleActions: true,
                        onChanged: (date) {}, onConfirm: (date) {
                      setState(() {
                        this.date = DateFormat.yMMMd().format(date);
                        dateTime = date;
                        // new date so reset bedTime and wakeUpTime
                        _bedTime = null;
                        _wakeUpTime = null;
                        redrawSleepCard = Object();
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
              TagsCard(
                  autocompleteTags: dbTags,
                  existingTags: _selectedTags,
                  onTagsChanged: (List<String> selectedTags) {
                    _selectedTags = selectedTags;
                  }),
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
              SleepCard(
                key: ValueKey<Object>(redrawSleepCard),
                existingDateTime: dateTime,
                existingBedTime: _bedTime,
                existingWakeUpTime: _wakeUpTime,
                onSleepTimeChanged: (DateTime? bedTime, DateTime? wakeUpTime) {
                  _bedTime = bedTime;
                  _wakeUpTime = wakeUpTime;
                },
              ),
              Container(
                height: 20.0,
              ),
              SizedBox(
                width: double.infinity,
                height: 42,
                child: ElevatedButton.icon(
                  label: Text('Save'),
                  icon: Icon(Icons.save),
                  onPressed: () {
                    FocusScope.of(context).requestFocus(new FocusNode());
                    // Validate returns true if the form is valid, or false
                    // otherwise.
                    List<String> mediaPaths = _updateMediaPaths();
                    if (_formKey.currentState!.validate()) {
                      final newInstary = Instary(
                          this.widget.instary.id,
                          dateTime,
                          titleController.text,
                          contentController.text,
                          _level.happinessLv,
                          _level.tirednessLv,
                          _level.stressfulnessLv,
                          mediaPaths,
                          _bedTime,
                          _wakeUpTime,
                          _selectedTags);
                      updateTagDb();
                      updateInstary(newInstary);
                    }
                  },
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

  void updateTagDb() {
    final tagBox = Hive.box('tag');
    _selectedTags.forEach((tag) {
      if (!dbTags.contains(tag)) {
        tagBox.put(tag, "");
      }
    });
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

  // loop _selectedMedia, if file in _selectedMedia is:
  // 1. In Image or Video folder then no need to delete image,
  //    just add to newMediaPaths directly
  // 2. If not, then save them to the correct location and add to newMediaPaths
  List<String> _updateMediaPaths() {
    List<String> newMediaPaths = [];
    String imageSaveLocation =
        appDocumentDirPath + GlobalConfiguration().getValue("androidImagePath");
    String videoSaveLocation =
        appDocumentDirPath + GlobalConfiguration().getValue("androidVideoPath");

    // Remove saved media that are removed by the user in existing media paths
    for (String savedPath in widget.instary.mediaPaths) {
      // get all paths from _sekectedMedia and check if they contains savedPath
      if (!_selectedMedia.map((file) => file.path).contains(savedPath)) {
        _deleteMedia(savedPath);
      }
    }

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
        newMediaPaths.add(savePath);
        _saveMedia(file, savePath);
      }
    });
    return newMediaPaths;
  }

  Future<void> _saveMedia(File file, String savePath) async {
    // copying the same file will create a 0kb file, so need to check if file already exists
    if (!File(savePath).existsSync()) {
      await file.copy(savePath);
    }
  }

  void _deleteMedia(String deletePath) {
    final deleteFile = File(deletePath);
    deleteFile.delete();
  }
}
