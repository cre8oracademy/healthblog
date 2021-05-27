import 'dart:io';

import 'createBlog.dart';
import 'searchScreen.dart';

import '../providers/blog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'HomeScreen.dart';
import 'package:share/share.dart';
import '../widget/popup.dart';

class BlogDetail extends StatelessWidget {
  static const routeName = 'details';
  bool imageisnull = true;
  @override
  Widget build(BuildContext context) {
    final blogid = ModalRoute.of(context).settings.arguments as String;
    final blogsData = Provider.of<Blogs>(context).findByID(int.parse(blogid));
    if (blogsData.image == null || blogsData.image == '') {
      imageisnull = false;
    }
    var body = blogsData.body;
    var tags = blogsData.title.split(' ');
    String hashtags = "#" + tags[0];
    String appbar = tags[0];
    if (tags.length > 1) {
      hashtags = '#' + tags[0] + ' ' + tags[1];
      appbar = tags[0] + ' ' + tags[1];
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          appbar,
        ),
        actions: [
          IconButton(
              icon: Icon(
                Icons.share,
                color: Colors.white,
              ),
              onPressed: () => {
                    if (blogsData.image != null && blogsData.image != '')
                      {
                        Share.shareFiles([blogsData.image],
                            text: blogsData.title)
                      }
                    else
                      {Share.share(blogsData.title)}
                  })
        ],
        elevation: 3,
        centerTitle: true,
      ),
      body: ListView(
        children: <Widget>[
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 15, 20, 0),
                  child: Text(
                    blogsData.title,
                    style:
                        TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 10, 20, 0),
                  child: Text(
                    hashtags,
                    style: TextStyle(
                        color: Colors.deepOrange,
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Stack(
                    children: <Widget>[
                      imageisnull
                          ? Container(
                              height: MediaQuery.of(context).size.height * 0.33,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: FileImage(File(blogsData.image)),
                                      fit: BoxFit.cover)),
                            )
                          : Container(
                              height: MediaQuery.of(context).size.height * 0.33,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage('assets/default.jpg'),
                                      fit: BoxFit.cover)),
                            ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(20.0, 0, 20, 0),
            child: Row(
              children: <Widget>[
                Text(
                  blogsData.date,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 15.0,
                  ),
                ),
                Spacer(),
                IconButton(
                  icon: Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                  onPressed: () => {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) => buildPopupDialog(
                            context,
                            blogsData.id.toString(),
                            "The Post Will Be Permanently deleted")),
                  },
                ),
                IconButton(
                  icon: Icon(
                    Icons.edit,
                  ),
                  color: Colors.blue,
                  onPressed: () {
                    Navigator.of(context).pushNamed(CreateBlog.routeName,
                        arguments: blogsData.id.toString());
                  },
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  child: Text(
                    '''   $body
                  ''',
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.grey,
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
