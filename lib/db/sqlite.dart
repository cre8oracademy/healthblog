import 'dart:async';
import '../models/blog.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

final String tableBlog = 'blogs';
final String columnId = 'id';
final String columnTitle = 'title';
final String columnBody = 'body';
final String columnDate = 'date';
final String columnImage = 'image';

class DataStore {
  DataStore();
  var readyCompleter = Completer();
  static const databaseName = 'new.db';
  Future get ready => readyCompleter.future;
  static Database _database;
  Future<Database> get database async {
    if (_database == null) {
      print('init');
      return await initialiizeDatabase();
    } else {
      return _database;
    }
  }

  initialiizeDatabase() async {
    if (_database == null || !_database.isOpen) {
      var dir = await getDatabasesPath();
      var path = dir + "SportsBlog.db";
      Database database = await openDatabase(path,
          version: 1,
          singleInstance: false,
          readOnly: false, onCreate: (db, version) {
        print("initialized");
        db.execute('''
        create table $tableBlog(
          $columnId integer primary key autoincrement,
          $columnTitle text not null,
          $columnBody text not null,
          $columnDate text not null,
          $columnImage text not null)
          ''');
      });
      _database = database;
    }
  }

  Future<int> insertBlog(BlogModel blogModel) async {
    await initialiizeDatabase();
    print('iam in db file');
    final db = await database;
    print(database);
    if (db != null) {
      var res = await _database.insert(tableBlog, blogModel.toMap());
      return res;
    } else {
      await initialiizeDatabase();
    }
    return -1;
  }

  Future<void> update(BlogModel blog, int id) async {
    final db = await database;
    db.update(tableBlog, blog.toMap(), where: 'id = ?', whereArgs: [id]);
  }

  Future<bool> deleteItem(String id) async {
    final db = await database;
    db.delete(tableBlog, where: 'id = ?', whereArgs: [id]);
    return true;
  }

  Future<List<BlogModel>> getBlogs() async {
    await initialiizeDatabase();
    List<BlogModel> _blogs = [];
    final db = await database;
    if (db != null) {
      var res = await db.query(tableBlog);
      res.forEach((element) {
        var resTwo = BlogModel.fromMap(element);
        _blogs.add(resTwo);
      });
      return _blogs;
    } else {
      return _blogs;
    }
  }
}
