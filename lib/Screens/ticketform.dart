import 'package:Mkoani/Screens/screens.dart';
import 'package:Mkoani/blocs/bloc.dart';
import 'package:Mkoani/components/components.dart';
import 'package:Mkoani/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TicketForm extends StatefulWidget {
  static MaterialPage page() {
    return const MaterialPage(
        name: MyPages.ticketform,
        key: ValueKey(MyPages.ticketform),
        child: TicketForm());
  }

  const TicketForm({Key? key}) : super(key: key);

  @override
  _TicketFormState createState() => _TicketFormState();
}

class _TicketFormState extends State<TicketForm> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    AppBloc appStateManager = BlocProvider.of<AppBloc>(context, listen: false);
    SeatBloc seatBloc = context.read<SeatBloc>();
    // retrieve seats info from seat manager
    final List seats = seatBloc.state.selectedSeats;
    // retrieve the selected bus data and route info
    ChosenRoute route = appStateManager.app.route;
    BusModel bus = seatBloc.state.bus!;
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Confirm Passenger Details'),
        actions: [
          PopUpMenu(
              appStateManager: appStateManager, auth: context.read<Auth>())
        ],
      ),
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Flexible(
              fit: FlexFit.loose,
              child: ListView.builder(
                itemCount: seats.length,
                itemBuilder: (context, index) {
                  return TicketFormCard(seat: seats[index], number: index);
                },
              ),
            ),
            DetailsCard(bus: bus, route: route, seats: seats),
            ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    finalise(seatBloc.state.selectedSeats);
                    print(appStateManager.app.payees);
                    await showDialog(
                        context: context,
                        builder: (context) {
                          return const AlertDialog(
                            backgroundColor: Colors.white,
                            content: SizedBox(
                                width: 380, height: 313, child: SendTo()),
                          );
                        });
                  }
                },
                child: const Text('Confirm'))
          ],
        ),
      ),
    ));
  }

  void finalise(List<SeatModel> seats) {
    // build a string of selected seats
    // of this format 'AA_BB, CC_DD, ...'
    String selectedSeats = '';
    int noOfseats = seats.length;

    for (int i = 0; i < noOfseats; i++) {
      if (i < noOfseats - 1) {
        selectedSeats = selectedSeats + seats[i].position.toString() + ',';
      } else {
        selectedSeats = selectedSeats + seats[i].position.toString();
      }
    }
    context.read<AppBloc>().app.addPayee({
      'seats_selected': '${seats.length}',
      'cells_selected': selectedSeats,
    });
  }
}

class DetailsCard extends StatelessWidget {
  const DetailsCard({
    Key? key,
    required this.bus,
    required this.route,
    required this.seats,
  }) : super(key: key);

  final BusModel bus;
  final ChosenRoute route;
  final List seats;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF39748E),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                children: [
                  Expanded(child: const Text('From')),
                  Expanded(child: Text(bus.boardpoint)),
                  Expanded(child: const Text('To')),
                  Expanded(child: Text(bus.droppoint))
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                children: [
                  Expanded(child: const Text('Depart date')),
                  Expanded(child: Text(route.date!)),
                  Expanded(child: const Text('Time')),
                  Expanded(child: Text('${bus.boardtime}-${bus.arrivaltime}'))
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                children: [
                  Expanded(child: const Text('Bus no')),
                  Expanded(child: Text(bus.plateno.toUpperCase())),
                  Expanded(child: const Text('Total fare')),
                  Expanded(child: Text('${bus.busfare * seats.length}'))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class TicketFormCard extends StatefulWidget {
  final SeatModel seat;
  final int number;
  const TicketFormCard({Key? key, required this.seat, required this.number})
      : super(key: key);

  @override
  _TicketFormCardState createState() => _TicketFormCardState();
}

class _TicketFormCardState extends State<TicketFormCard> {
  @override
  Widget build(BuildContext context) {
    AppBloc bloc = context.read<AppBloc>();
    return Card(
      color: const Color(0xFF39748E),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: TextFormField(
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.name,
                onSaved: (newValue) {
                  bloc.app
                      .addPayee({'passenger_name_${widget.number}': newValue!});
                },
                validator: (str) {
                  if (str == null || str.isEmpty) {
                    return 'Please you must fill this';
                  }
                  return null;
                },
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
                controller: TextEditingController(),
                decoration: const InputDecoration(
                    labelText: 'Full name',
                    border: UnderlineInputBorder(),
                    enabledBorder: UnderlineInputBorder(),
                    focusedBorder: UnderlineInputBorder(),
                    disabledBorder: UnderlineInputBorder(),
                    errorBorder: UnderlineInputBorder(),
                    labelStyle: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.done,
                    onSaved: (value) {
                      bloc.app.addPayee({
                        'passenger_phone_${widget.number}': value!,
                        'passenger_seat_${widget.number}': '${widget.seat.id}'
                      });
                    },
                    validator: (str) {
                      if (str == null || str.isEmpty) {
                        return 'Please you must fill this';
                      }
                      return null;
                    },
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                    controller: TextEditingController(),
                    decoration: const InputDecoration(
                        labelText: 'Phone number',
                        border: UnderlineInputBorder(),
                        enabledBorder: UnderlineInputBorder(),
                        focusedBorder: UnderlineInputBorder(),
                        disabledBorder: UnderlineInputBorder(),
                        errorBorder: UnderlineInputBorder(),
                        labelStyle: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Container(
                      padding: const EdgeInsets.only(top: 10),
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Seat no: ${widget.seat.id}'),
                      ),
                      decoration:
                          BoxDecoration(border: Border(bottom: BorderSide()))),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
