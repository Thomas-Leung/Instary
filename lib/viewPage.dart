import 'package:flutter/material.dart';

class ViewPage extends StatelessWidget {
  final instaryTitle;
  final instaryPhoto;

  ViewPage({this.instaryTitle, this.instaryPhoto});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
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
              child: Image.asset(instaryPhoto),
            )
          ],
        ),
      ),
    );
  }
}
