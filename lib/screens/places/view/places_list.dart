import 'package:favorite_places/models/places.dart';
import 'package:favorite_places/models/place.dart';
import 'package:favorite_places/providers/user_places.dart';
import 'package:favorite_places/screens/places_detail/view/place_details.dart';
import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:favorite_places/screens/places/bloc/places_list_bloc.dart';
import 'package:favorite_places/screens/addPlace/view/add_place.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlacesListScreen extends ConsumerStatefulWidget {
  const PlacesListScreen({super.key});

  @override
  ConsumerState<PlacesListScreen> createState() {
    return _PlacesListScreenState();
  }

// Places places = Places([]);
}

class _PlacesListScreenState extends ConsumerState<PlacesListScreen> {
  late Future<void> _placesFuture;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _placesFuture = ref.read(userPlacesProvider.notifier).loadPlaces();
  }

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
  Widget build(BuildContext context) {
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
              return FutureBuilder(
                future: _placesFuture,
                builder: (context, snapshot) => snapshot.connectionState ==
                        ConnectionState.waiting
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        itemCount: places.length,
                        itemBuilder: (ctx, index) => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            leading: CircleAvatar(
                              radius: 26,
                              backgroundImage: FileImage(places[index].image),
                            ),
                            title: Text(
                              places[index].title,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onBackground),
                              textAlign: TextAlign.left,
                            ),
                            subtitle: Text(
                              places[index].location.address,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onBackground),
                            ),
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (ctx) =>
                                      PlaceDetailsScreen(place: places[index]),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
              );
            } else {
              return Center(
                child: Text(
                  "NO PLACES ADDED",
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onBackground),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
