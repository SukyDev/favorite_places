part of 'add_place_bloc.dart';

class AddPlaceEvent extends Equatable{
  @override
  List<Object?> get props => [];
}

class AddPlaceAddingStarted extends AddPlaceEvent {
  AddPlaceAddingStarted({required this.isStarted});
  final bool isStarted;

  @override
  List<Object?> get props => [isStarted];
}

class AddPlaceAddingFinished extends AddPlaceEvent {
  AddPlaceAddingFinished({required this.isFinished, required this.place});
  final bool isFinished;
  final Place place;

  @override
  List<Object?> get props => [isFinished, place];
}