import 'package:flutter/material.dart';

class ViewPage extends StatelessWidget {
  final instaryTitle;
  final instaryPhoto;

  ViewPage({this.instaryTitle, this.instaryPhoto});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.elliptical(60.0, 60.0)),
            ),
            expandedHeight: MediaQuery.of(context).size.height / 2.5,
            floating: false,
            pinned: false,
            flexibleSpace: FlexibleSpaceBar(
              background: ClipRRect(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.elliptical(60.0, 60.0)),
                child: Image.asset(
                  'assets/images/img1.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SliverFillRemaining(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Flexible(
                          child: Text(
                            instaryTitle,
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 30.0,
                                color: Colors.black),
                          ),
                        ),
                        EditWidget()
                      ],
                    ),
                    Text(
                      "Dec 30, 2019",
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18.0,
                          color: Colors.grey[500]),
                    ),
                    Container(
                      height: 20.0,
                    ),
                    Text(
                      "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
                      style: TextStyle(fontSize: 15.0),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class EditWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.edit),
      onPressed: () {
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text('Coming Soon'),
          duration: Duration(seconds: 3),
        ));
      },
      color: Colors.grey[500],
    );
  }
}
