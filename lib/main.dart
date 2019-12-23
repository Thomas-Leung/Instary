import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import './viewPage.dart';

void main() {
  runApp(MaterialApp(home: HomePage(), debugShowCheckedModeBanner: false));
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

  // evaluates whether there is text currently in our search bar, and if so,
  // appropriately sets our _searchText to whatever that input is so we can filter our list accordingly
  _HomePageState() {
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
      body: SafeArea(
        child: Column(
          children: <Widget>[_searchBar(context), _title()],
        ),
      ),
    );
  }

  Widget _searchBar(BuildContext context) {
    return Theme(
      child: Padding(
        padding: EdgeInsets.all(25.0),
        child: TextField(
          onTap: _searchPressed,
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
      padding: EdgeInsets.fromLTRB(25.0, 0, 25.0, 25.0),
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
    return ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: names == null ? 0 : filteredNames.length,
      itemBuilder: (BuildContext context, int index) {
        return new ListTile(
          title: Text(filteredNames[index]['name']),
          onTap: () => print(filteredNames[index]['name']),
        );
      },
    );
  }
}
