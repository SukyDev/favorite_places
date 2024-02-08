import 'package:favorite_places/models/places.dart';
import 'package:favorite_places/models/place.dart';
import 'package:favorite_places/providers/user_places.dart';
import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:favorite_places/screens/places/bloc/places_list_bloc.dart';
import 'package:favorite_places/screens/addPlace/view/add_place.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlacesListScreen extends ConsumerWidget {
  const PlacesListScreen({super.key});

  // Places places = Places([]);

  void _addPlace(BuildContext context) async {
    // final result = await Navigator.of(context).push<Place>(
    //   MaterialPageRoute(
    //     builder: (context) => const AddPlaceScreen(),
    //   ),
    // );

    // setState(() {
    //   places.placesArray.add(result!);
    //   print(places.placesArray);
    // });
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => const AddPlaceScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final places = ref.watch(userPlacesProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Your Places',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Theme.of(context).colorScheme.onBackground,
              ),
        ),
        actions: [
          IconButton(
              onPressed: () {
                _addPlace(context);
              },
              icon: const Icon(Icons.add))
        ],
      ),
      body: BlocProvider(
        create: (context) => PlacesListBloc(),
        child: BlocBuilder<PlacesListBloc, PlacesListState>(
          builder: (context, state) {
            print(state.places);
            if (places.isNotEmpty) {
              return ListView.builder(
                itemCount: places.length,
                itemBuilder: (ctx, index) => ListTile(
                  title: Text(
                    places[index].title,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(color: Theme.of(context).colorScheme.onBackground),
                    textAlign: TextAlign.left,
                  ),
                ),
              );
            } else {
              return Center(
                child: Text(
                  "NO PLACES ADDED",
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(color: Theme.of(context).colorScheme.onBackground),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
