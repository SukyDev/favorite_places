import 'package:equatable/equatable.dart';
import 'package:favorite_places/models/places.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'dart:convert';
import 'package:favorite_places/models/place.dart';
part 'places_list_event.dart';
part 'places_list_state.dart';

class PlacesListBloc extends Bloc<PlacesListEvent, PlacesListState> with HydratedMixin {
  PlacesListBloc() : super(PlacesListState(places: Places(const []))) {
    on<PlacesListPlaceAdded>((event, emit) {
      List<Place>? currentState = state.places.placesArray;
      print('State je ${currentState}');
      currentState?.add(event.place!);
      Places places = Places(currentState);
      emit(state.copyWith(places));
    });

    on<PlacesListPlaceRemoved>((event, emit) {
      var currentState = state.copyWith(state.places);
      currentState.places.placesArray?.removeWhere((element) => element.title == event.place?.title);
      emit(state.copyWith(currentState as Places));
    });
  }



  @override
  PlacesListState? fromJson(Map<String, dynamic> json) {
    print("Nesto printa: ${state.fromJson(json)}");
    return state.fromJson(json);
  }

  @override
  Map<String, dynamic>? toJson(PlacesListState state) {
    return state.toJson();
  }
}