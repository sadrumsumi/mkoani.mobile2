import 'package:Mkoani/Screens/screens.dart';
import 'package:Mkoani/blocs/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../components/components.dart';
import '../models/models.dart';

class Seats extends StatelessWidget {
  const Seats({Key? key}) : super(key: key);

  static MaterialPage page() {
    return const MaterialPage(
        name: MyPages.seats, key: ValueKey(MyPages.seats), child: Seats());
  }

  @override
  Widget build(BuildContext context) {
    AppBloc bloc = context.read<AppBloc>();
    return SafeArea(
        child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: Text(
                bloc.app.route.from! + ' to ' + bloc.app.route.to!,
                style: Theme.of(context).textTheme.headline3,
              ),
              centerTitle: true,
              elevation: 0,
              bottom: PreferredSize(
                  child: Text(
                    DateFormat('MMMM d, y').format(DateTime.parse(
                        bloc.app.route.date!.split('-').reversed.join())),
                    style: const TextStyle(fontSize: 16),
                  ),
                  preferredSize: const Size(40, 40)),
            ),
            body: Container(
              margin: const EdgeInsets.all(1),
              decoration: BoxDecoration(
                  color: Color(0xFF39748E),
                  borderRadius: BorderRadius.circular(5)),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Select Seat(s)',
                    style: Theme.of(context).textTheme.headline3,
                  ),
                ),
                const Keys(),
                const Flexible(
                  fit: FlexFit.loose,
                  child: SingleChildScrollView(
                      padding: EdgeInsets.all(8), child: BusSeats()),
                ),
                const BottomCard(),
              ]),
            )));
  }
}

class BottomCard extends StatelessWidget {
  const BottomCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SeatBloc, SeatState>(builder: (context, state) {
      int seats = state.bus?.selectedseats.length ?? 0;
      int totalSeats = state.bus?.totalSeats ?? 0;
      int selectedSeats = state.selectedSeats.length;
      print(state.selectedSeats.length);
      return Card(
          elevation: 9.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                  child: Text(
                '${selectedSeats} of ${totalSeats - (selectedSeats + seats)} seats',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.red,
                ),
              )),
              MaterialButton(
                disabledColor: Colors.grey,
                onPressed: state.selectedSeats.isEmpty
                    ? null
                    : () async {
                        AppBloc bloc = context.read<AppBloc>();
                        bloc.add(
                            OnAddPage(page: TicketForm.page(), app: bloc.app));
                      },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(2)),
                color: Colors.amber,
                child: Text(state.selectedSeats.isEmpty
                    ? 'Confirm'
                    : 'Confirm(Tshs.${state.selectedSeats.length * state.bus!.busfare})'),
              ),
              const SizedBox(
                width: 50,
              )
            ],
          ));
    });
  }
}

class Keys extends StatelessWidget {
  const Keys({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Wrap(
          spacing: 5.9,
          children: const [
            Icon(Icons.circle, color: Color(0xFFC4C4C4)),
            Text('Available'),
          ],
        ),
        Wrap(
          spacing: 5.9,
          children: const [
            Icon(Icons.circle, color: Colors.green),
            Text('Selected'),
          ],
        ),
        Wrap(
          spacing: 5.9,
          children: const [
            Icon(Icons.circle, color: Colors.red),
            Text('Unavailable'),
          ],
        ),
      ],
    );
  }
}
