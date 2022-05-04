import 'dart:async';

import 'package:Mkoani/blocs/bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkBloc extends Bloc<NetworkEvents, Network> {
  final Connectivity _connectivity = Connectivity();
  late final StreamSubscription controller;
  NetworkBloc() : super(Unknown()) {
    on<OnNetworkAvailable>(_online);
    on<OnNetworkNotAvailable>(_offline);
    controller = _connectivity.onConnectivityChanged
        .asBroadcastStream()
        .listen(updateConnection);
  }

  void _online(NetworkEvents event, Emitter<Network> emit) {
    emit(NetworkAvailable());
  }

  void _offline(NetworkEvents event, Emitter<Network> emit) {
    emit(NetworkNotAvailable());
  }

  void updateConnection(ConnectivityResult result) {
    if (result == ConnectivityResult.none) {
      add(OnNetworkNotAvailable());
    } else {
      add(OnNetworkAvailable());
    }
  }

  @override
  Future<void> close() {
    controller.cancel();
    return super.close();
  }
}
