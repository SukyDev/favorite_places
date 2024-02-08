import 'package:bloc/bloc.dart';

class SimpleBlocObserver extends BlocObserver {
@override
  void onChange(BlocBase bloc, Change change) {
    // TODO: implement onChange
    super.onChange(bloc, change);
    print("Preview change for bloc: ${bloc.runtimeType} $change");
  }

  @override
  void onEvent(Bloc bloc, Object? event) {
    // TODO: implement onEvent
    super.onEvent(bloc, event);
    print("Preview event change for bloc: ${bloc.runtimeType} $event");
  }
}