import 'package:Mkoani/blocs/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import '../../models/models.dart';
import 'seat.dart';

class BusSeats extends StatefulWidget {
  // final List<int> layout;
  const BusSeats({Key? key}) : super(key: key);

  @override
  State<BusSeats> createState() => _BusSeatsState();
}

class _BusSeatsState extends State<BusSeats> {
  int _seatId = 1;
  int _columnnumber = 1;
  int _rownumber = 1;
  List<String>? _seats = [];

  @override
  Widget build(BuildContext context) {
    SeatBloc bloc = BlocProvider.of<SeatBloc>(context, listen: false);

    // get selectedseats from other users
    _seats = bloc.state.bus!.selectedseats;
    // did this user select seats before
    List<SeatModel> selectedSeats = bloc.state.selectedSeats;
    print(selectedSeats.map((e) => e.id).toList());
    return Padding(
      padding: const EdgeInsets.only(left: 12, right: 12, top: 20, bottom: 20),
      child: Column(
        //mainAxisAlignment: MainAxisAlignment.center,
        children: buildRows(bloc.state.bus!.layouts!, selectedSeats),
      ),
    );
  }

  Widget buildRow(String layout, List selectedSeats) {
    /** builds a row of seats using the layout attribute  */
    List<Widget> row = [];
    for (int i = 0; i < layout.length; i++) {
      if (layout[i] == 'f') {
        String position = '${_rownumber}_$_columnnumber';
        row.add(Expanded(
            child: Seat(
          seatModel: SeatModel(
              id: _seatId,
              status: _seats!.contains(position) ? 'full' : 'empty',
              position: position,
              selected: isSeatSelected(_seatId, selectedSeats)),
        )));
        _seatId++;
      } else if (layout[i] == '_') {
        row.add(const Expanded(
            child: SizedBox(
          width: 25,
        )));
      }
      _columnnumber++;
    }
    _columnnumber = 1;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: row,
    );
  }

  bool isSeatSelected(int seatId, List selectedSeats) {
    for (var seat in selectedSeats) {
      if (seat.id == seatId) {
        return true;
      }
    }
    return false;
  }

  List<Widget> buildRows(List layouts, List selectedSeats) {
    List<Widget> rows = [];
    for (var i in layouts) {
      rows.add(buildRow(i, selectedSeats));
      _rownumber++;
    }
    /* reset seatId after building rows*/
    context.read<SeatBloc>().state.bus?.totalSeats = _seatId - 1;
    _seatId = 1;

    // print(seats);
    return rows;
  }
}
