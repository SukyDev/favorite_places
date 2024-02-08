import 'package:favorite_places/models/place.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PlaceDetailsScreen extends StatelessWidget {
  const PlaceDetailsScreen({super.key, required this.place});

  final Place place;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          place.title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Theme.of(context).colorScheme.onBackground,
              ),
        ),
      ),
      body: Stack(children: [
        Image.file(
          place.image,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
      ]),
    );
  }
}
