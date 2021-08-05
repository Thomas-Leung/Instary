import 'dart:io';

import 'package:instary/pages/view_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

class HomePage extends StatefulWidget {
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
    final imageDir =
        new Directory(GlobalConfiguration().getValue("androidImagePath"));
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
        new Directory(GlobalConfiguration().getValue("androidImagePath"))
            .create(recursive: true)
            // The created directory is returned as a Future.
            .then((Directory directory) {
          print(directory.path);
        });
      }
    });
    this._getInstary();
    super.initState();
  }

  @override
  void dispose() {
    Hive.close(); // close all boxes when leave page
    super.dispose();
  }

  void _getInstary() {
    List tempList = [];
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
            children: <Widget>[_searchBar(context), _title(), _buildList()],
          ),
        ),
        // bottom navigation
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
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
                icon: _settingsIcon,
                onPressed: () => Navigator.pushNamed(context, '/settingsPage'),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _searchBar(BuildContext context) {
    return Theme(
      child: Padding(
        padding: EdgeInsets.fromLTRB(25.0, 25.0, 25.0, 15.0),
        child: TextField(
          onTap: _searchPressed,
          controller: _filter,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.blueGrey[50],
            hintText: "Search",
            prefixIcon: _searchIcon,
            contentPadding:
                new EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blueGrey[50]),
              borderRadius: BorderRadius.circular(28),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blueGrey[50]),
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
      padding: EdgeInsets.fromLTRB(25.0, 0, 25.0, 0),
      child: Row(
        children: <Widget>[
          Text(
            "Instary",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32.0),
          ),
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
        controller: PageController(viewportFraction: 0.85),
        itemCount: instaries == null ? 0 : filteredInstaries.length,
        itemBuilder: (BuildContext context, int index) {
          // get imagePath
          File imagePath;
          if (filteredInstaries[index].imagePaths[0] != null) {
            imagePath = new File(filteredInstaries[index].imagePaths[0]);
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
                        image: imagePath != null
                            ? FileImage(imagePath)
                            : AssetImage('assets/images/img_not_found.png'),
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