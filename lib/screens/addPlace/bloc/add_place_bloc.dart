import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:favorite_places/models/place.dart';
part 'add_place_event.dart';
part 'add_place_state.dart';

class AddPlaceBloc extends Bloc<AddPlaceEvent, AddPlaceState> {
  AddPlaceBloc() : super(const AddPlaceState(isPlaceAdded: false, isPlaceAdding: false,),) {
    on<AddPlaceAddingStarted>((event, emit) {
      emit(state.copyWith(!event.isStarted, event.isStarted));
    });

    on<AddPlaceAddingFinished>((event, emit) {
      emit(state.copyWith(event.isFinished, !event.isFinished));
    });
  }
}