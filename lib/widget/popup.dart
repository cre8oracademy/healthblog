import '../providers/blog.dart';
import '../screens/HomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

buildPopupDialog(BuildContext context, String id, String message) {
  bool _loading = false;
  return new AlertDialog(
    title: const Text("Are You Sure"),
    content: new Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(message),
      ],
    ),
    actions: <Widget>[
      TextButton(
        onPressed: () async {
          try {
            _loading = true;
            Navigator.of(context).popAndPushNamed(HomeScreen.routeName);
            await Provider.of<Blogs>(context, listen: false).deleteBlog(id);
          } catch (e) {
            print('Error while deleting');
          }
        },
        child: _loading
            ? LinearProgressIndicator()
            : const Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
      ),
    ],
  );
}
