import 'package:healthblog/screens/searchScreen.dart';

import 'providers/blog.dart';
import 'screens/HomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart ';
import 'screens/blogDetails.dart';
import 'screens/createBlog.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => Blogs(),
      child: MaterialApp(
        title: 'Health Blog',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            primarySwatch: Colors.purple,
            accentColor: Colors.black54,
            appBarTheme: AppBarTheme(
                color: Colors.pink,
                textTheme: TextTheme(headline1: TextStyle(color: Colors.white)),
                iconTheme: IconThemeData(color: Colors.black),
                actionsIconTheme: IconThemeData(color: Colors.black)),
            primaryTextTheme: TextTheme(
                headline1: TextStyle(color: Colors.white, fontSize: 10))),
        home: HomeScreen(),
        routes: {
          CreateBlog.routeName: (context) => CreateBlog(),
          HomeScreen.routeName: (context) => HomeScreen(),
          BlogDetail.routeName: (context) => BlogDetail(),
          SearchScreen.routeName: (context) => SearchScreen(),
        },
      ),
    );
  }
}
