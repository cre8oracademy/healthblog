import 'package:flutter/material.dart';
import '../screens/HomeScreen.dart';
import '../screens/createBlog.dart';
import '../screens/searchScreen.dart';

bottombar(int index, context) {
  var color = Colors.black;
  var color2 = Colors.white;
  var bg = Colors.pink;
  var color3 = Colors.black;
  hit() {
    if (index == 0) {
    } else {
      Navigator.of(context).pushNamed(HomeScreen.routeName);
    }
  }

  hit2() {
    if (index == 1) {
    } else {
      Navigator.of(context).pushNamed(CreateBlog.routeName);
    }
  }

  hit3() {
    if (index == 2) {
    } else {
      Navigator.of(context).pushNamed(SearchScreen.routeName);
    }
  }

  switch (index) {
    case 0:
      color = Colors.purple;
      break;
    case 1:
      color2 = Colors.white;

      bg = Colors.purple;
      break;
    case 2:
      color3 = Colors.purple;
      break;
  }
  return BottomAppBar(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        FlatButton(
          onPressed: () {
            hit();
          },
          child: Icon(
            Icons.home,
            color: color,
          ),
        ),
        FloatingActionButton(
          backgroundColor: bg,
          onPressed: () {
            hit2();
          },
          child: Icon(
            Icons.add,
            color: color2,
            size: 40,
          ),
        ),
        FlatButton(
          onPressed: () {
            hit3();
          },
          child: Icon(
            Icons.search,
            color: color3,
          ),
        ),
      ],
    ),
  );
}
