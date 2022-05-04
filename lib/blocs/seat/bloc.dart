import 'package:Mkoani/blocs/bloc.dart';

import 'package:Mkoani/models/models.dart';
import 'package:bloc/bloc.dart';

class SeatBloc extends Bloc<SeatEvents, SeatState> {
  BusModel? _bus;
  List<SeatModel> _selectedSeats = [];
  SeatBloc() : super(Initial()) {
    on<OnRemoveSeat>(_removeSeat);
    on<OnAddSeat>(_addSeat);
    on<OnInitialise>(_setup);
    on<OnReady>(_initialise);
  }

  void _setup(OnInitialise event, Emitter<SeatState> emit) {
    emit(Initial());
  }

  void _initialise(OnReady event, Emitter<SeatState> emit) {
    _bus = event.bus;
    _selectedSeats = [];
    emit(Ready(bus: event.bus!, selectedSeats: _selectedSeats));
  }

  void _addSeat(OnAddSeat event, Emitter<SeatState> emit) {
    emit(Selected(
        bus: _bus!, seat: event.selectedSeat, selectedSeats: _selectedSeats));
  }

  void _removeSeat(OnRemoveSeat event, Emitter<SeatState> emit) {
    emit(Deselected(
        bus: _bus!, seat: event.seat, selectedSeats: _selectedSeats));
  }
}
