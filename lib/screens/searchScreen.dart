import 'package:healthblog/widget/card-small.dart';

import '../widget/bottombar.dart';

import '../providers/blog.dart';
import '../screens/HomeScreen.dart';
import '../screens/createBlog.dart';
import '../widget/card-horizontal.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  static const routeName = 'search';

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _controller = TextEditingController();
  String _searchText;
  var blogs = [];
  var blogsDown = [];

  @override
  @override
  void initState() {
    _controller.addListener(
      () {
        setState(() {
          _searchText = _controller.text;
        });
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    bool _isloading = false;
    final blogsData = Provider.of<Blogs>(context);
    List blogs = blogsData.searchedBlogs;
    _searchBar() {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 10),
        child: TextFormField(
          onChanged: (value) {
            Provider.of<Blogs>(context, listen: false)
                .changeSearchString(value);
          },
          maxLength: 50,
          controller: _controller,
          autocorrect: true,
          decoration: InputDecoration(
              fillColor: Colors.black12,
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.purple, width: 2.0),
                  borderRadius: BorderRadius.all(Radius.circular(25))),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Colors.black,
                      width: 2.0,
                      style: BorderStyle.solid),
                  borderRadius: BorderRadius.all(Radius.circular(25))),
              filled: true,
              alignLabelWithHint: true,
              labelText: "Search Blogs",
              hintText: "Search String",
              contentPadding: EdgeInsets.all(20)),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text(
          'Search',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0.0,
      ),
      body: ListView.builder(
        itemCount: blogs.length + 1,
        itemBuilder: (BuildContext context, int index) {
          final item = index - 1;
          return index == 0
              ? _searchBar()
              : Dismissible(
                  background: slideRightBackground(),
                  secondaryBackground: slideLeftBackground(),
                  confirmDismiss: (direction) async {
                    if (direction == DismissDirection.endToStart) {
                      final bool res = await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              content: Text("Are you sure you want to delete "),
                              actions: <Widget>[
                                FlatButton(
                                  child: Text(
                                    "Cancel",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                FlatButton(
                                  child: _isloading
                                      ? CircularProgressIndicator.adaptive(
                                          semanticsLabel: "Deleting",
                                        )
                                      : Text(
                                          "Delete",
                                          style: TextStyle(color: Colors.red),
                                        ),
                                  onPressed: () async {
                                    try {
                                      _isloading = true;
                                      await Provider.of<Blogs>(context,
                                              listen: false)
                                          .deleteBlog(blogs[item].id.toString())
                                          .then((value) =>
                                              {Navigator.of(context).pop()});
                                    } catch (e) {
                                      SnackBar(
                                        backgroundColor: Colors.red,
                                        content: Text("Error"),
                                      );
                                      print('Error while deleting');
                                    }
                                  },
                                ),
                              ],
                            );
                          });
                      return res;
                    } else {
                      Navigator.of(context).pushNamed(CreateBlog.routeName,
                          arguments: blogs[item].id.toString());
                    }
                  },
                  key: Key(item.toString()),
                  child: CardSmall(
                    id: blogs[index - 1].id,
                    img: blogs[index - 1].image,
                    title: blogs[index - 1].title,
                    cta: blogs[index - 1].body,
                    date: blogs[index - 1].date,
                  ),
                );
        },
      ),
    );
  }
}

Widget slideRightBackground() {
  return Container(
    color: Colors.green,
    child: Align(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            width: 20,
          ),
          Icon(
            Icons.edit,
            color: Colors.white,
          ),
          Text(
            " Edit",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.left,
          ),
        ],
      ),
      alignment: Alignment.centerLeft,
    ),
  );
}

Widget slideLeftBackground() {
  return Container(
    color: Colors.red,
    child: Align(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Icon(
            Icons.delete,
            color: Colors.white,
          ),
          Text(
            " Delete",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.right,
          ),
          SizedBox(
            width: 20,
          ),
        ],
      ),
      alignment: Alignment.centerRight,
    ),
  );
}
