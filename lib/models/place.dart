import 'package:uuid/uuid.dart';
import 'dart:io';

final uuid = const Uuid();

class Place {
  final String id;
  final String title;
  final File image;
  final PlaceLocation location;

  Place({required this.title, required this.image, required this.location, String? id})
      : id = id ?? uuid.v4();

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['image'] = image;
    data['location'] = location.toJson();
    return data;
  }

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
        title: json['title'], image: json['image'], location: json['location']);
  }
}

class PlaceLocation {
  const PlaceLocation(
      {required this.latitude, required this.longitude, required this.address});

  final double latitude;
  final double longitude;
  final String address;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['address'] = address;
    return data;
  }

  factory PlaceLocation.fromJson(Map<String, dynamic> json) {
    return PlaceLocation(
        latitude: json['latitude'],
        longitude: json['longitude'],
        address: json['address']);
  }
}
