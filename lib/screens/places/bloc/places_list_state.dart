part of 'places_list_bloc.dart';

class PlacesListState extends Equatable {
  PlacesListState({required this.places});
  Places places;

  @override
  List<Object> get props => [places];

  PlacesListState copyWith(Places places) {
    return PlacesListState(
      places: places,
    );
  }

  PlacesListState? fromJson(Map<String, dynamic> json) {
    print("Iz json-a state ${json['places']}");
    try {
      final places = Places.fromJson(json);
      return PlacesListState(
        places: json['places'],
      );
    } catch(error) {
      print("Error fetching data");
      print(error.toString());
    }
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = <String, dynamic>{};
      data['places'] = json.encode(places);
      return data;
  }
}