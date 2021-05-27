import 'package:flutter/foundation.dart';

class BlogModel {
  int id;
  String title;
  String body;
  final String date;
  String image;

  BlogModel(
      {this.id,
      @required this.title,
      @required this.body,
      @required this.image,
      @required this.date});
  factory BlogModel.fromMap(Map<String, dynamic> json) => BlogModel(
        id: json["id"],
        title: json["title"],
        body: json["body"],
        date: json["date"],
        image: json["image"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "title": title,
        "body": body,
        "date": date,
        "image": image,
      };
}
