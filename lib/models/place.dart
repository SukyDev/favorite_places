import 'package:uuid/uuid.dart';
import 'dart:io';

final uuid = const Uuid();

class Place {
  final String id;
  final String title;
  final File image;

  Place({required this.title, required this.image}) : id = uuid.v4();

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['image'] = image;
    return data;
  }

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(title: json['title'], image: json['image'],);
  }
}