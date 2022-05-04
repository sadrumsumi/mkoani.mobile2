import 'package:Mkoani/blocs/bloc.dart';
import 'package:bloc/bloc.dart';

class Auth extends Bloc<AuthEvents, AuthState> {
  Auth() : super(Anonymous()) {
    on<OnRegister>(_register);
    on<OnLogin>(_login);
    on<OnLogout>(_logout);
  }

  void _register(AuthEvents event, Emitter<AuthState> emit) {
    emit(Authenticated());
  }

  void _login(AuthEvents event, Emitter<AuthState> emit) {
    emit(Authenticated());
  }

  void _logout(AuthEvents event, Emitter<AuthState> emit) {
    emit(Anonymous());
  }
}
