import 'package:uuid/uuid.dart';

final uuid = const Uuid();

class Place {
  final String id;
  final String title;

  Place({required this.title}) : id = uuid.v4();

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    return data;
  }

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(title: json['title'],);
  }
}