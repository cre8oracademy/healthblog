import 'dart:io';

import '../providers/blog.dart';
import '../providers/selected.dart';
import '../screens/HomeScreen.dart';
import 'package:provider/provider.dart';

import '../screens/blogDetails.dart';
import '../screens/createBlog.dart';
import 'package:flutter/material.dart';
import '../constants/Theme.dart';
import 'package:share/share.dart';
import 'popup.dart';

class BlogItem extends StatefulWidget {
  final int id;
  final String title;
  final String body;
  final String date;
  final String image;
  const BlogItem(
    this.id,
    this.title,
    this.body,
    this.date,
    this.image,
  );

  @override
  _BlogItemState createState() => _BlogItemState();
}

class _BlogItemState extends State<BlogItem> {
  bool isSelected = false;
  String _chosenValue;

  Widget build(BuildContext context) {
    bool isnull = true;
    if (widget.image == null || widget.image == '') {
      isnull = false;
    }

    var selected = Provider.of<SelectedItems>(context).selectedBlogs;
    setState(() {
      if (selected != null && selected.contains(widget.id)) {
        isSelected = true;
      } else {
        isSelected = false;
      }
    });
    select() {
      print('Selected ' + widget.id.toString());
      if (selected.contains(widget.id)) {
        isSelected = false;
        print('Deselected' + widget.id.toString());
        Provider.of<SelectedItems>(context, listen: false).deselect(widget.id);
      } else {
        isSelected = true;
        Provider.of<SelectedItems>(context, listen: false).select(widget.id);
      }
      ;
      print(isSelected);
    }

    return GestureDetector(
      onLongPress: () => select(),
      onTap: () => {
        if (selected.length == 0)
          {
            Provider.of<SelectedItems>(context, listen: false).empty(),
            Navigator.of(context).pushNamed(BlogDetail.routeName,
                arguments: widget.id.toString())
          }
        else
          {select()}
      },
      child: Container(
        //decoration: BorderDirectional(),
        height: 300,
        width: null,
        child: Stack(children: [
          Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(18.0))),
              color:
                  isSelected ? Colors.purple.withOpacity(0.08) : Colors.white,
              elevation: 5,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    flex: 6,
                    child: isnull
                        ? Container(
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(18.0)),
                                image: DecorationImage(
                                  image: FileImage(File(widget.image)),
                                  fit: BoxFit.cover,
                                )))
                        : Container(
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(18.0)),
                                image: DecorationImage(
                                  image: AssetImage('assets/default.jpg'),
                                  fit: BoxFit.cover,
                                )),
                          ),
                  ),
                  Flexible(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 8.0, bottom: 0, left: 8.0),
                        child: Text(widget.title,
                            maxLines: 3,
                            style: TextStyle(
                                color: ArgonColors.header, fontSize: 18)),
                      )),
                  Flexible(
                    flex: 2,
                    child: ButtonBar(
                      alignment: MainAxisAlignment.spaceBetween,
                      children: [
                        FlatButton(
                          color: Colors.pink,
                          onPressed: () => {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) =>
                                    buildPopupDialog(
                                        context,
                                        widget.id.toString(),
                                        "The Post Will Be Permanently deleted")),
                          },
                          child: Text(
                            'Delete',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        FlatButton(
                          color: Colors.pink,
                          onPressed: () => {
                            Navigator.of(context).pushNamed(
                                CreateBlog.routeName,
                                arguments: widget.id.toString())
                          },
                          child: Text(
                            'Edit',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        FlatButton(
                          color: Colors.pink,
                          onPressed: () => {
                            if (widget.image != null && widget.image != '')
                              {
                                Share.shareFiles([widget.image],
                                    text: widget.title)
                              }
                            else
                              {Share.share(widget.title)}
                          },
                          child: Text(
                            'share',
                          ),
                        )
                      ],
                    ),
                  )
                ],
              )),
          Align(
            alignment: Alignment.center,
            child: Icon(
              Icons.check_circle,
              size: 50,
              color: isSelected ? Colors.purple : Colors.transparent,
            ),
          ),
        ]),
      ),
    );
  }
}
