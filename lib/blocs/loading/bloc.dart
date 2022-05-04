import 'package:Mkoani/blocs/bloc.dart';
import 'package:bloc/bloc.dart';

class LoadingBloc extends Bloc<LoadingEvents, LoadingState> {
  LoadingBloc() : super(NotLoading()) {
    on<OnLoad>(_loading);
    on<OnLoadComplete>(_loadingComplete);
  }

  void _loading(OnLoad event, Emitter<LoadingState> emit) {
    emit(Load(effects: event.effects));
  }

  void _loadingComplete(OnLoadComplete event, Emitter<LoadingState> emit) {
    emit(Complete());
  }
}
