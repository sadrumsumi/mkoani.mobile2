import 'package:Mkoani/models/models.dart';

abstract class SeatState {
  BusModel? bus;
  List<SeatModel> selectedSeats;
  SeatState({this.bus, required this.selectedSeats});
}

class Selected extends SeatState {
  SeatModel seat;

  Selected(
      {required BusModel bus,
      required this.seat,
      required List<SeatModel> selectedSeats})
      : super(bus: bus, selectedSeats: selectedSeats) {
    addSelectedSeat(seat);
  }

  void addSelectedSeat(SeatModel seat) {
    seat.selected = true;
    selectedSeats.add(seat);
  }
}

class Deselected extends SeatState {
  SeatModel seat;
  Deselected(
      {required BusModel bus,
      required this.seat,
      required List<SeatModel> selectedSeats})
      : super(bus: bus, selectedSeats: selectedSeats) {
    removeSelectedSeat(seat);
  }

  void removeSelectedSeat(SeatModel seat) {
    seat.selected = false;
    for (SeatModel i in selectedSeats) {
      if (seat.id == i.id) {
        selectedSeats.removeWhere((model) => seat.id == model.id);
        break;
      }
    }
  }
}

class Initial extends SeatState {
  Initial() : super(bus: null, selectedSeats: []) {
    selectedSeats.clear();
  }
}

class Ready extends SeatState {
  Ready({required BusModel bus, required List<SeatModel> selectedSeats})
      : super(bus: bus, selectedSeats: selectedSeats);
}
