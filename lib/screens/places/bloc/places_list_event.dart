part of 'places_list_bloc.dart';

class PlacesListEvent extends Equatable{
  const PlacesListEvent();

  @override
  List<Object?> get props => [];

}

final class PlacesListPlaceAdded extends PlacesListEvent {
  const PlacesListPlaceAdded({required this.place});
  final Place? place;

  @override
  List<Object?> get props => [place];
}

final class PlacesListPlaceRemoved extends PlacesListEvent {
  const PlacesListPlaceRemoved({required this.place});
  final Place? place;

  @override
  List<Object?> get props => [place];
}
