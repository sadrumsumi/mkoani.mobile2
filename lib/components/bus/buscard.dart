import 'package:Mkoani/Screens/screens.dart';
import 'package:Mkoani/blocs/bloc.dart';
import 'package:Mkoani/requests/get_seats.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/models.dart';

class BusCard extends StatelessWidget {
  final BusModel bus;
  const BusCard({Key? key, required this.bus}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        AppBloc bloc = context.read<AppBloc>();
        SeatBloc seatBloc = context.read<SeatBloc>();
        bloc.add(OnLoading(bloc.app));
        BusModel value = await getSeats(bus.id);

        seatBloc.add(OnReady(bus: value));
        bloc.add(OnLoadingComplete(bloc.app, page: Seats.page()));
      },
      child: Card(
          elevation: 8.0,
          color: const Color(0xff39748E),
          shadowColor: Colors.grey[800],
          child: Container(
            height: MediaQuery.of(context).size.height / 7,
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.directions_bus,
                  size: 70,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      bus.name,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      bus.grade,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const Spacer(),
                    Text(bus.plateno,
                        style: Theme.of(context).textTheme.bodyText2),
                    const Spacer(),
                  ],
                ),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${bus.boardtime} - ${bus.arrivaltime}',
                        style: const TextStyle(fontSize: 16)),
                    const Spacer(),
                    Text('Tshs ${bus.busfare}/=',
                        style: Theme.of(context).textTheme.bodyText2),
                    const Spacer(),
                  ],
                ),
              ],
            ),
          )),
    );
  }
}
