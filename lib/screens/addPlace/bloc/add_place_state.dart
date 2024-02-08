part of 'add_place_bloc.dart';

class AddPlaceState extends Equatable {
  const AddPlaceState(
      {required this.isPlaceAdded, required this.isPlaceAdding});

  final bool isPlaceAdded;
  final bool isPlaceAdding;

  @override
  List<Object?> get props => [isPlaceAdded, isPlaceAdding];

  AddPlaceState copyWith(bool? isPlaceAdded, bool? isPlaceAdding) {
    return AddPlaceState(
        isPlaceAdded: isPlaceAdded ?? this.isPlaceAdded,
        isPlaceAdding: isPlaceAdding ?? this.isPlaceAdding);
  }
}
