import 'package:Mkoani/blocs/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/models.dart';

class Seat extends StatefulWidget {
  final SeatModel seatModel;

  const Seat({Key? key, required this.seatModel}) : super(key: key);

  @override
  State<Seat> createState() => _SeatState();
}

class _SeatState extends State<Seat> {
  late bool _selected;

  @override
  void initState() {
    _selected = widget.seatModel.selected;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(4),
        child: ElevatedButton(
          onPressed: widget.seatModel.status == 'full'
              ? null
              : () {
                  if (_selected) {
                    context
                        .read<SeatBloc>()
                        .add(OnRemoveSeat(seat: widget.seatModel));
                  } else {
                    context
                        .read<SeatBloc>()
                        .add(OnAddSeat(selectedSeat: widget.seatModel));
                  }
                  setState(() {
                    _selected = !_selected;
                  });
                },
          child: Text(
            '${widget.seatModel.id}',
            style: Theme.of(context).textTheme.bodyText2,
          ),
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(_selected
                  ? Colors.green[800]
                  : widget.seatModel.status == 'full'
                      ? Colors.redAccent
                      : const Color(0xFFC4C4C4))),
        ));
  }

  bool isSelected(SeatState state) {
    List<SeatModel> seats = state.selectedSeats;
    for (int index = 0; index < seats.length; index++) {
      if (seats[index].id == widget.seatModel.id) {
        return true;
      }
    }
    return false;
  }
}
