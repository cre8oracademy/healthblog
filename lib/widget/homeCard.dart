import '../providers/selected.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/blog.dart';
import 'BlogItem.dart';

class HomeCard extends StatefulWidget {
  @override
  _HomeCardState createState() => _HomeCardState();
}

class _HomeCardState extends State<HomeCard> {
  @override
  Widget build(BuildContext context) {
    final blogsData = Provider.of<Blogs>(context);
    final _controller = TextEditingController();
    final blogs = blogsData.blogsList;

    if (blogs.length == 0) {
      return Center(
        child: Text('No Blog Exists Create One'),
      );
    }
    var selected = [];
    bool _isloading = false;
    return ChangeNotifierProvider(
      create: (_) => SelectedItems(),
      child: ListView.builder(
        padding: EdgeInsets.all(10.0),
        itemCount: blogs.length + 1,
        scrollDirection: Axis.vertical,
        addSemanticIndexes: true,
        itemBuilder: (context, index) => index == 0
            ? Consumer<SelectedItems>(
                builder: (__, item, _) => Container(
                      child: item.selectedBlogs.length != 0
                          ? ButtonBar(
                              alignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Selected: ' +
                                      item.selectedBlogs.length.toString(),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                FlatButton(
                                    color: Colors.grey[400],
                                    child: Text(
                                      'Cancel',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    onPressed: () => {
                                          Provider.of<SelectedItems>(context,
                                                  listen: false)
                                              .empty()
                                        }),
                                FlatButton(
                                    color: Colors.grey[400],
                                    child: Text(
                                      'Delete All',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                    onPressed: () async {
                                      final bool res = await showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              content: Text(
                                                  "Are you sure you want to delete Selected"),
                                              actions: <Widget>[
                                                FlatButton(
                                                  child: Text(
                                                    "Cancel",
                                                    style: TextStyle(
                                                        color: Colors.black),
                                                  ),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                                FlatButton(
                                                  child: _isloading
                                                      ? CircularProgressIndicator
                                                          .adaptive(
                                                          semanticsLabel:
                                                              "Deleting",
                                                        )
                                                      : Text(
                                                          "Delete",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.red),
                                                        ),
                                                  onPressed: () async {
                                                    try {
                                                      Provider.of<Blogs>(
                                                              context,
                                                              listen: false)
                                                          .deleteMultiple(item
                                                              .selectedBlogs)
                                                          .then((_) => {
                                                                print(
                                                                    'Deleted From Db'),
                                                                Provider.of<SelectedItems>(
                                                                        context,
                                                                        listen:
                                                                            false)
                                                                    .empty(),
                                                              });
                                                      Navigator.of(context)
                                                          .pop();
                                                    } catch (e) {
                                                      SnackBar(
                                                        backgroundColor:
                                                            Colors.red,
                                                        content: Text("Error"),
                                                      );
                                                      print(
                                                          'Error while deleting');
                                                    }
                                                  },
                                                ),
                                              ],
                                            );
                                          });
                                    })
                              ],
                            )
                          : Container(
                              height: 0,
                              width: 0,
                            ),
                    ))
            : BlogItem(
                blogs[index - 1].id,
                blogs[index - 1].title,
                blogs[index - 1].body,
                blogs[index - 1].date.toString(),
                blogs[index - 1].image,
              ),
      ),
    );
  }
}
