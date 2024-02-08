import 'package:favorite_places/providers/user_places.dart';
import 'package:favorite_places/screens/places/bloc/places_list_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:favorite_places/screens/addPlace/bloc/add_place_bloc.dart';
import 'package:favorite_places/models/place.dart';
import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddPlaceScreen extends ConsumerStatefulWidget {
  const AddPlaceScreen({super.key});

  @override
  ConsumerState<AddPlaceScreen> createState() {
    return _AddPlaceScreenState();
  }
}

class _AddPlaceScreenState extends ConsumerState<AddPlaceScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _name;
  bool _isLoading = false;
  bool _isStateSaved = false;

  void _saveCurrentState() {
    _formKey.currentState!.save();
    final enteredText = _name;

    if (enteredText == null || enteredText.isEmpty) {
      return;
    }

    ref.read(userPlacesProvider.notifier).addPlace(enteredText);
  }

  void _returnToMainScreen() async {
    Place place = Place(title: _name!);
    Navigator.of(context).pop();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _isLoading = false;
    _isStateSaved = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add new Place'),
      ),
      body: BlocProvider(
        create: (context) => AddPlaceBloc(),
        child:
            BlocBuilder<AddPlaceBloc, AddPlaceState>(builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Form(
                  key: _formKey,
                  child: TextFormField(
                    decoration: const InputDecoration(
                      label: Text('Title'),
                      fillColor: Colors.white,
                    ),
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                    onSaved: (value) {
                      _name = value!;
                    },
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                SizedBox(
                    width: 130,
                    child: BlocListener<AddPlaceBloc, AddPlaceState>(
                      listener: (context, state) {
                        if (state.isPlaceAdding) {
                          setState(() {
                            _isLoading = true;
                          });
                          print("Place is adding");
                        }
                        if (state.isPlaceAdded) {
                          _isLoading = false;
                          print("Place is added");
                          context.read<AddPlaceBloc>().add(
                                AddPlaceAddingStarted(isStarted: false),
                              );
                        }
                      },
                      child: ElevatedButton(
                        onPressed: _isLoading
                            ? null
                            : () {
                                _saveCurrentState();
                                if (_name != null) {
                                  context.read<AddPlaceBloc>().add(
                                        AddPlaceAddingStarted(isStarted: true),
                                      );
                                  _isStateSaved = true;
                                }
                                if (_isStateSaved) {
                                  Future.delayed(const Duration(seconds: 1),
                                      () {
                                    context.read<AddPlaceBloc>().add(
                                          AddPlaceAddingFinished(
                                            isFinished: true,
                                            place: Place(title: _name!),
                                          ),
                                        );
                                    _returnToMainScreen();
                                  });
                                  // }
                                }
                              },
                        child: Center(
                          child: _isLoading
                              ? const SizedBox(
                                  height: 16,
                                  width: 16,
                                  child: CircularProgressIndicator())
                              : const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.add),
                                    Text('Add Place')
                                  ],
                                ),
                        ),
                      ),
                    ))
              ],
            ),
          );
        }),
      ),
    );
  }
}
