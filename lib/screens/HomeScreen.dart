import 'dart:ui';

import 'package:page_transition/page_transition.dart';

import '../widget/bottombar.dart';

import '../providers/blog.dart';
import '../screens/searchScreen.dart';
import 'package:provider/provider.dart';
import 'createBlog.dart';
import '../widget/homeCard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = 'home';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  void initState() {
    Provider.of<Blogs>(context, listen: false).init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        elevation: 16,
        semanticLabel: "Health Blogs",
        child: Column(
          children: [
            Center(
              child: Column(
                children: [
                  Image.asset(
                    'assets/home.png',
                  ),
                  Text(
                    'Helth Blogs',
                    style: TextStyle(fontSize: 18),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 50,
            ),
            FlatButton(
              color: Colors.pink,
              minWidth: 5000,
              onPressed: () => {
                _scaffoldKey.currentState.openEndDrawer(),
                Navigator.push(
                    context,
                    PageTransition(
                        type: PageTransitionType.fade, child: HomeScreen()))
              },
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Text('Home'),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            FlatButton(
              minWidth: 5000,
              color: Colors.grey[300],
              onPressed: () => {
                _scaffoldKey.currentState.openEndDrawer(),
                Navigator.push(
                        context,
                        PageTransition(
                            type: PageTransitionType.rightToLeftWithFade,
                            child: CreateBlog()))
                    .then((value) => {}),
              },
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Text('Create'),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            FlatButton(
              minWidth: 5000,
              color: Colors.grey[300],
              onPressed: () => {
                _scaffoldKey.currentState.openEndDrawer(),
                Navigator.push(
                    context,
                    PageTransition(
                        type: PageTransitionType.rightToLeftWithFade,
                        child: SearchScreen()))
              },
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Text('Search'),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            IconButton(
                color: Colors.pink,
                icon: Icon(
                  Icons.cancel,
                  size: 35,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                })
          ],
        ),
      ),
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.menu,
            color: Colors.pink,
          ),
          onPressed: () => _scaffoldKey.currentState.openDrawer(),
        ),
        backgroundColor: Colors.transparent,
        title: IconButton(
          iconSize: 100,
          icon: Image.asset(
            'assets/home.png',
          ),
          onPressed: () {},
        ),
        elevation: 0,
        toolbarHeight: 60,
        centerTitle: true,
      ),
      body: Container(
        color: Colors.grey[300],
        child: FutureBuilder(
            future: Provider.of<Blogs>(context).addValue(),
            builder: (context, dataSnapshot) {
              if (dataSnapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return HomeCard();
              }
            }),
      ),
    );
  }
}
