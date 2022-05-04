import 'package:Mkoani/models/models.dart';

abstract class SeatEvents {
  final BusModel? bus;
  const SeatEvents({this.bus});
}

class OnAddSeat extends SeatEvents {
  final SeatModel selectedSeat;
  const OnAddSeat({required this.selectedSeat});
}

class OnRemoveSeat extends SeatEvents {
  final SeatModel seat;
  const OnRemoveSeat({required this.seat});
}

class OnInitialise extends SeatEvents {
  const OnInitialise();
}

class OnReady extends SeatEvents {
  const OnReady({required BusModel bus}) : super(bus: bus);
}
