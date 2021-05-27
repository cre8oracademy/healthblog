import 'dart:io';

import '../screens/blogDetails.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import '../constants/Theme.dart';

class CardHorizontal extends StatelessWidget {
  CardHorizontal(
      {this.title = "Placeholder Title",
      this.cta = "sdadasdasd",
      this.img,
      this.id,
      this.body,
      this.date});

  final String cta;
  final String img;
  final int id;
  final String title;
  final String body;
  final String date;

  @override
  Widget build(BuildContext context) {
    bool isnull = true;
    if (img == null || img == '') {
      isnull = false;
    }
    return Container(
        height: 140,
        child: GestureDetector(
          onTap: () => {
            print(id),
            Navigator.of(context)
                .pushNamed(BlogDetail.routeName, arguments: id.toString())
          },
          child: Card(
            elevation: 0.6,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(6.0))),
            child: Row(
              children: [
                Flexible(
                  flex: 1,
                  child: isnull
                      ? Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(6.0),
                                  bottomLeft: Radius.circular(6.0)),
                              image: DecorationImage(
                                image: FileImage(File(img)),
                                fit: BoxFit.cover,
                              )))
                      : Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(6.0),
                                  bottomLeft: Radius.circular(6.0)),
                              image: DecorationImage(
                                image: AssetImage('assets/default.jpg'),
                                fit: BoxFit.cover,
                              ))),
                ),
                Flexible(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(title,
                              maxLines: 2,
                              style: TextStyle(
                                  color: ArgonColors.header, fontSize: 16)),
                          Text(cta,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 4,
                              style: TextStyle(
                                  color: ArgonColors.primary,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600)),
                          Container(
                            color: Colors.grey[200],
                            child: Center(
                              child: Text(
                                date,
                                maxLines: 1,
                              ),
                            ),
                          )
                        ],
                      ),
                    )),
              ],
            ),
          ),
        ));
  }
}
