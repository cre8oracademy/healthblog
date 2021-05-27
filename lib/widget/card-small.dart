import 'dart:io';

import 'package:flutter/material.dart';
import 'package:healthblog/screens/blogDetails.dart';
import '../constants/Theme.dart';

class CardSmall extends StatelessWidget {
  CardSmall(
      {this.title = "Placeholder Title",
      this.cta = "",
      this.img = "https://via.placeholder.com/200",
      this.tap = defaultFunc,
      this.id,
      this.date});

  final String cta;
  final int id;
  final String img;
  final Function tap;
  final String date;
  final String title;

  static void defaultFunc() {
    print("the function works!");
  }

  @override
  Widget build(BuildContext context) {
    bool isnull = true;
    return Container(
      height: 235,
      child: GestureDetector(
        onTap: () => {
          print(id),
          Navigator.of(context)
              .pushNamed(BlogDetail.routeName, arguments: id.toString())
        },
        child: Card(
            elevation: 0.4,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8.0))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                    flex: 2,
                    child: isnull
                        ? Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(6.0),
                                    topRight: Radius.circular(6.0)),
                                image: DecorationImage(
                                  image: FileImage(File(img)),
                                  fit: BoxFit.cover,
                                )))
                        : Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(6.0),
                                    topRight: Radius.circular(6.0)),
                                image: DecorationImage(
                                  image: AssetImage('assets/default.jpg'),
                                  fit: BoxFit.cover,
                                )))),
                Flexible(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 8.0, bottom: 8.0, left: 8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(title,
                              style: TextStyle(
                                  color: ArgonColors.header, fontSize: 13)),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(cta,
                                maxLines: 2,
                                style: TextStyle(
                                    color: ArgonColors.primary,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600)),
                          )
                        ],
                      ),
                    ))
              ],
            )),
      ),
    );
  }
}
