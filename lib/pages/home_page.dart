import 'dart:io';

import 'package:instary/pages/view_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:mime/mime.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class HomePage extends StatefulWidget {
  final PageController mainPageController;

  HomePage({required this.mainPageController});
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // controls the text label we use as a search bar
  final TextEditingController _filter = TextEditingController();
  String _searchText = "";
  List instaries = []; // Instaries we get from Hive NoSQL
  List filteredInstaries = []; // Instaries filtered by search text
  Icon _searchIcon = Icon(Icons.search);
  Icon _settingsIcon = Icon(Icons.settings);

  // evaluates whether there is text currently in our search bar, and if so,
  // appropriately sets our _searchText to whatever that input is so we can filter our list accordingly
  _HomePageState() {
    // text controller listener
    _filter.addListener(() {
      if (_filter.text.isEmpty) {
        setState(() {
          _searchText = "";
          filteredInstaries = instaries;
        });
      } else {
        setState(() {
          _searchText = _filter.text;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    setup();
  }

  Future<void> setup() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    final imageDir = new Directory(
        appDocDir.path + GlobalConfiguration().getValue("androidImagePath"));
    imageDir.exists().then((isDir) async {
      PermissionStatus storageStatus = await Permission.storage.status;
      if (!storageStatus.isGranted) {
        print("No Storage Permission yet");
        storageStatus = await Permission.storage.request();
        if (storageStatus.isPermanentlyDenied) {
          // tell user to go to settings to allow permission
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) => AlertDialog(
              title: Text("Storage Permission"),
              content: Text(
                  'This app needs storage access save and display images.'),
              actions: <Widget>[
                TextButton(
                  child: Text("Open Settings"),
                  onPressed: () {
                    openAppSettings();
                  },
                )
              ],
            ),
          );
        } else if (storageStatus.isDenied) {
          SystemChannels.platform.invokeMethod('SystemNavigator.pop');
        }
      }
      if (!isDir && storageStatus.isGranted) {
        new Directory(appDocDir.path +
                GlobalConfiguration().getValue("androidImagePath"))
            .create(recursive: true)
            // The created directory is returned as a Future.
            .then((Directory directory) {
          print(directory.path);
        });
        new Directory(appDocDir.path +
                GlobalConfiguration().getValue("androidVideoPath"))
            .create(recursive: true);
      }
    });
    this._getInstary();
  }

  @override
  void dispose() async {
    super.dispose();
    // need to await to make sure search listener is disposed as well
    // if not we might get memory leak
    await Hive.close(); // close all boxes when leave page
  }

  Future<void> _getInstary() async {
    List tempList = [];
    if (!Hive.isBoxOpen('instary')) {
      await Hive.openBox('instary');
    }
    final instaryBox = Hive.box('instary');
    // to initialize instaries when start
    for (int i = 0; i < instaryBox.length; i++) {
      final instary = instaryBox.getAt(i);
      tempList.add(instary);
    }
    setState(() {
      instaries = tempList.toList();
      instaries.sort((a, b) {
        var adate = a.dateTime;
        var bdate = b.dateTime;
        return bdate.compareTo(adate);
      }); // latest at top
      filteredInstaries = instaries;
    });
    // to update instaries when changes
    instaryBox.watch().listen((event) {
      List updateList = [];
      for (int i = 0; i < instaryBox.length; i++) {
        final instary = instaryBox.getAt(i);
        updateList.add(instary);
      }
      setState(() {
        instaries = updateList.toList();
        instaries.sort((a, b) {
          var adate = a.dateTime;
          var bdate = b.dateTime;
          return bdate.compareTo(adate);
        }); // latest at top
        filteredInstaries = instaries;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // hide soft input keyboard when click outside textfield (searchbar)
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: new Scaffold(
        // fix overflow when keyboard pops up
        // resizeToAvoidBottomPadding: false,
        body: SafeArea(
          child: Column(
            children: <Widget>[_title(), _buildList(), _searchBar(context)],
          ),
        ),
        // bottom navigation
        floatingActionButton: FloatingActionButton(
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
          elevation: 4.0,
          onPressed: () => Navigator.pushNamed(context, '/createPage'),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomAppBar(
          shape: CircularNotchedRectangle(),
          notchMargin: 10.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(
                  icon: Icon(Icons.show_chart_rounded),
                  onPressed: () {
                    if (widget.mainPageController.hasClients) {
                      widget.mainPageController.animateToPage(
                        0,
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeInOut,
                      );
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _searchBar(BuildContext context) {
    return Theme(
      child: Padding(
        padding: EdgeInsets.fromLTRB(25.0, 0, 25.0, 15.0),
        child: TextField(
          onTap: _searchPressed,
          controller: _filter,
          decoration: InputDecoration(
            filled: true,
            fillColor: Theme.of(context).bannerTheme.backgroundColor,
            hintText: "Search",
            prefixIcon: _searchIcon,
            contentPadding:
                new EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: Theme.of(context).bannerTheme.backgroundColor!),
              borderRadius: BorderRadius.circular(28),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: Theme.of(context).bannerTheme.backgroundColor!),
              borderRadius: BorderRadius.circular(28),
            ),
          ),
        ),
      ),
      data: Theme.of(context).copyWith(primaryColor: Colors.grey[600]),
    );
  }

  void _searchPressed() {
    setState(() {
      if (this._searchIcon.icon == Icons.search) {
        this._searchIcon = new Icon(Icons.close);
      } else {
        this._searchIcon = new Icon(Icons.search);
        FocusScope.of(context).requestFocus(FocusNode());
        filteredInstaries = instaries;
        _filter.clear();
      }
    });
  }

  Widget _title() {
    return Padding(
      padding: EdgeInsets.fromLTRB(25.0, 25.0, 25.0, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            "Instary",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32.0),
          ),
          IconButton(
            padding: EdgeInsets.zero,
            constraints: BoxConstraints(),
            icon: _settingsIcon,
            onPressed: () => Navigator.pushNamed(context, '/settingsPage'),
          )
        ],
      ),
    );
  }

  Widget _buildList() {
    if (_searchText != "") {
      List tempList = [];
      for (int i = 0; i < filteredInstaries.length; i++) {
        if (filteredInstaries[i]
            .title
            .toLowerCase()
            .contains(_searchText.toLowerCase())) {
          tempList.add(filteredInstaries[i]);
        }
      }
      filteredInstaries = tempList;
    }
    if (instaries.length == 0 || filteredInstaries.length == 0) {
      return Expanded(
        child: Center(
          child: Text(
            "No instary :(",
            style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18.0,
                color: Colors.grey[400]),
          ),
        ),
      );
    }
    return Expanded(
      child: PageView.builder(
        physics: BouncingScrollPhysics(),
        controller: PageController(viewportFraction: 0.85),
        itemCount: instaries.isEmpty ? 0 : filteredInstaries.length,
        itemBuilder: (BuildContext context, int index) {
          // get mediaFile
          File? imageFile;
          if ((filteredInstaries[index].mediaPaths as List).isNotEmpty) {
            // only assign if it is an image
            for (final filePath in filteredInstaries[index].mediaPaths) {
              if (lookupMimeType(filePath)!.contains("image") &&
                  File(filePath).existsSync()) {
                imageFile = new File(filePath);
                break;
              }
            }
          }
          return Padding(
            padding: EdgeInsets.all(16.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ViewPage(
                        instary: filteredInstaries[index],
                      ),
                    ),
                  );
                },
                child: Stack(fit: StackFit.expand, children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      image: DecorationImage(
                        image: imageFile != null
                            ? FileImage(imageFile)
                            : AssetImage('assets/images/img_not_found.png')
                                as ImageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: [0.0, 0.6, 1.0],
                        colors: [
                          Colors.transparent,
                          Colors.transparent,
                          Colors.black87,
                        ],
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 32.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            filteredInstaries[index].title,
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 32.0,
                                color: Colors.white),
                          ),
                          Text(
                            DateFormat.yMMMd()
                                .format(filteredInstaries[index].dateTime),
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16.0,
                                color: Colors.grey[400]),
                          ),
                        ],
                      ),
                    ),
                  )
                ]),
              ),
            ),
          );
        },
      ),
    );
  }
}
