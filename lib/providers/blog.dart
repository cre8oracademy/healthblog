import 'dart:collection';

import '../db/sqlite.dart';
import '../models/blog.dart';
import '../db/sqlite.dart';
import 'package:flutter/cupertino.dart';

class Blogs with ChangeNotifier {
  DataStore _dataStore = new DataStore();
  // ignore: unused_field

  List<BlogModel> _blogs = [];
  String _searchString = "";
  UnmodifiableListView<BlogModel> get searchedBlogs => _searchString.isEmpty
      ? UnmodifiableListView(_blogs.reversed)
      : UnmodifiableListView(_blogs
          .where((blog) => blog.title.toLowerCase().contains(_searchString)));
  void changeSearchString(String searchString) {
    _searchString = searchString.toLowerCase();
    notifyListeners();
  }

  List<BlogModel> get blogsList {
    return [..._blogs.reversed];
  }

  List<BlogModel> get blogsListSearched {
    return [..._blogs.reversed];
  }

  Future<void> deleteMultiple(List<int> ids) async {
    for (var blog in ids) {
      bool delete = await _dataStore.deleteItem(blog.toString());
      if (delete) {
        _blogs
            .removeWhere((element) => element.id == int.parse(blog.toString()));
      }
      notifyListeners();
    }
  }

  Future<void> init() async {
    await _dataStore.initialiizeDatabase();
  }

  Future<void> addValue() async {
    _blogs = await _dataStore.getBlogs();
  }

  Future<void> deleteBlog(String id) async {
    bool delete = await _dataStore.deleteItem(id);
    if (delete) {
      _blogs.removeWhere((element) => element.id == int.parse(id));
    }
    notifyListeners();
  }

  Future<void> addBlog(BlogModel blogModel) async {
    final newBlog = BlogModel(
        id: null,
        title: blogModel.title,
        body: blogModel.body,
        image: blogModel.image,
        date: blogModel.date);
    _dataStore
        .insertBlog(newBlog)
        .then((response) => {newBlog.id = response, _blogs.add(newBlog)});
    notifyListeners();
    return Future.value();
  }

  BlogModel findByID(int productId) {
    return _blogs.firstWhere((element) => element.id == productId);
  }

  Future<void> updateBlog(int id, BlogModel newModel) async {
    print("update Handle");

    final indexodblog = _blogs.indexWhere((element) => element.id == id);
    if (indexodblog >= 0) {
      _dataStore.update(newModel, id);
      _blogs[indexodblog] = newModel;
      notifyListeners();
    } else {
      print('Error');
    }
  }
}
