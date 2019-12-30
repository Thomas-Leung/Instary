import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import './createPage.dart';
import './viewPage.dart';

void main() {
  runApp(MaterialApp(
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.grey[900],
        accentColor: Color(0xff425296),
      ),
      home: HomePage(),
      routes: {'/createPage': (context) => CreatePage()},
      debugShowCheckedModeBanner: false));
}

class HomePage extends StatefulWidget {
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // controls the text label we use as a search bar
  final TextEditingController _filter = TextEditingController();
  final dio = Dio(); // for http requests
  String _searchText = "";
  List names = List(); // names we get from API
  List filteredNames = List(); // names filtered by search text
  Icon _searchIcon = Icon(Icons.search);
  Icon _darkModeIcon = Icon(Icons.brightness_5);

  // evaluates whether there is text currently in our search bar, and if so,
  // appropriately sets our _searchText to whatever that input is so we can filter our list accordingly
  _HomePageState() {
    // text controller listener
    _filter.addListener(() {
      if (_filter.text.isEmpty) {
        setState(() {
          _searchText = "";
          filteredNames = names;
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
    this._getNames();
    super.initState();
  }

  void _getNames() async {
    final response = await dio.get('https://swapi.co/api/people');
    List tempList = new List();
    for (int i = 0; i < response.data['results'].length; i++) {
      tempList.add(response.data['results'][i]);
    }

    setState(() {
      names = tempList;
      filteredNames = names;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      // fix overflow when keyboard pops up
      resizeToAvoidBottomPadding: false,
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
              icon: _darkModeIcon,
              onPressed: () {
                setState(() {
                  if (this._darkModeIcon.icon == Icons.brightness_5) {
                    this._darkModeIcon = new Icon(Icons.brightness_4);
                  } else {
                    this._darkModeIcon = new Icon(Icons.brightness_5);
                  }
                });
              },
            )
          ],
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
        filteredNames = names;
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
      List tempList = new List();
      for (int i = 0; i < filteredNames.length; i++) {
        if (filteredNames[i]['name']
            .toLowerCase()
            .contains(_searchText.toLowerCase())) {
          tempList.add(filteredNames[i]);
        }
      }
      filteredNames = tempList;
    }
    return Expanded(
      child: PageView.builder(
        controller: PageController(viewportFraction: 0.85),
        itemCount: names == null ? 0 : filteredNames.length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: EdgeInsets.all(16.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ViewPage(
                        instaryTitle: filteredNames[index]['name'],
                        instaryPhoto: "assets/images/cat.png",
                      ),
                    ),
                  );
                },
                child: Stack(fit: StackFit.expand, children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      image: const DecorationImage(
                        image: AssetImage('assets/images/img2.jpg'),
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
                      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 32.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            filteredNames[index]['name'],
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 32.0,
                                color: Colors.white),
                          ),
                          Text(
                            "Dec 30, 2019",
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
