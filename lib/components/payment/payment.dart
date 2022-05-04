import 'package:Mkoani/Screens/payments.dart';
import 'package:Mkoani/blocs/app/app.dart';
import 'package:Mkoani/components/alert.dart';
import 'package:Mkoani/models/models.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import '../../requests/requests.dart';

class Payment extends StatefulWidget {
  static MaterialPage page() {
    return const MaterialPage(
        name: MyPages.payment,
        key: ValueKey(MyPages.payment),
        child: Payment());
  }

  const Payment({Key? key}) : super(key: key);

  @override
  State<Payment> createState() => _MyStatefulWidgetState();
}

/// This is the private State class that goes with Payment.
class _MyStatefulWidgetState extends State<Payment> {
  String _menuChoice = 'airtel';
  late io.Socket socket;

  @override
  void initState() {
    // the reference number
    String reference =
        context.read<AppBloc>().app.currentPayment!.reference ?? 'error';

    socket = io.io(Requests.websocketlocal,
        io.OptionBuilder().setTransports(['websocket']).build());
    socket.onConnect((_) {
      socket.emit('one', 'hello from me');
    });
    socket.onConnectError((data) {
      print('##');
      print(data);
    });
    socket.emit('room', {'room': reference});
    socket.on('feedback', (data) {
      Map<String, dynamic> response = data;
      print(data.runtimeType);
      print('^^');
      /* if (response['status']) {
        // navigate to trips
        Provider.of<AppStateManager>(context, listen: false).toPayment();
        Provider.of<AppStateManager>(context, listen: false).toTrips(true);
        //dispose();
      }*/
    });
    super.initState();
  }

  @override
  void dispose() {
    socket.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // get the payment options
    AppBloc bloc = context.read<AppBloc>();
    String reference = bloc.app.currentPayment!.reference ?? 'error';
    List<PaymentOption>? options = bloc.app.currentPayment!.options;
    print(reference);

    return SafeArea(
        child: Scaffold(
            backgroundColor: const Color(0xFF39748E),
            appBar: AppBar(
              centerTitle: true,
              backgroundColor: const Color(0xFF39748E),
              elevation: 0,
              bottom: PreferredSize(
                child: Container(
                  decoration: const BoxDecoration(
                      border: Border(bottom: BorderSide(color: Colors.white))),
                ),
                preferredSize: const Size(double.infinity, 0),
              ),
              title: const Text(
                'Payment',
              ),
            ),
            body: Column(
              children: [
                TextButton(
                  onPressed: () async {
                    String? name = await showPop(context: context);
                    if (name != null) {
                      setState(() {
                        _menuChoice = name;
                      });
                    }
                  },
                  child: const Text(
                    'Choose your payment methods',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: PaymentMenu(
                        choice: _menuChoice,
                        options: options,
                        reference: reference,
                      ),
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                      border: Border(top: BorderSide(color: Colors.white))),
                  child: TextButton(
                    onPressed: () {
                      bloc.add(OnAddFreshPage(
                          page: MyTickets.page(), app: bloc.app));
                    },
                    child: const Text(
                      'Skip',
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                          color: Color(0xFFC4C4C4)),
                    ),
                  ),
                )
              ],
            )));
  }
}

class PaymentMenu extends StatefulWidget {
  final String choice;
  final List<PaymentOption>? options;
  final String? reference;
  const PaymentMenu(
      {Key? key, required this.choice, required this.options, this.reference})
      : super(key: key);

  @override
  _PaymentMenuState createState() => _PaymentMenuState();
}

class _PaymentMenuState extends State<PaymentMenu> {
  @override
  Widget build(BuildContext context) {
    TextStyle theme =
        Theme.of(context).textTheme.bodyText1!.copyWith(color: Colors.black);
    return SizedBox(
      height: MediaQuery.of(context).size.height / 2,
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                    border: Border(
                        bottom: BorderSide(width: 1.0, color: Colors.black26))),
                child: Row(
                  children: [
                    Text(
                      widget.choice,
                      style: theme,
                    ),
                    const Spacer(),
                    Text('Pay Number:', style: theme),
                    const SizedBox(
                      width: 8,
                    ),
                    Text(widget.reference ?? '', style: theme)
                  ],
                ),
              ),
            ),
            ...buildMenuSteps(data: widget.options, choice: widget.choice)
          ],
        ),
      ),
    );
  }

  List<Widget> buildMenuSteps(
      {List<PaymentOption>? data, required String choice}) {
    if (data == null) {
      return [];
    }
    TextStyle theme =
        Theme.of(context).textTheme.bodyText1!.copyWith(color: Colors.black);
    List<Widget> children = [];
    for (PaymentOption option in data) {
      if (option.name == choice) {
        int count = 1;
        for (var step in option.steps) {
          children.add(Expanded(
              child: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(
              '$count.' + step,
              style: theme,
            ),
          )));
          count++;
        }
      }
    }
    return children;
  }
}
