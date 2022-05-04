import 'package:Mkoani/blocs/bloc.dart';
import 'package:Mkoani/components/components.dart';
import 'package:Mkoani/exceptions/network_exceptions.dart';
import 'package:Mkoani/exceptions/unauthorised.dart';
import 'package:Mkoani/requests/get_ticket.dart';
import 'package:Mkoani/requests/payment_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/models.dart' as m;

class Tickets extends StatefulWidget {
  final m.Payment payment;
  const Tickets({Key? key, required this.payment}) : super(key: key);

  static MaterialPage page(m.Payment payment) {
    return MaterialPage(
        key: const ValueKey(m.MyPages.mytickets),
        name: m.MyPages.mytickets,
        child: Tickets(payment: payment));
  }

  @override
  State<Tickets> createState() => _TicketsState();
}

class _TicketsState extends State<Tickets> {
  late Future<List<m.Ticket>> _tickets;

  @override
  void initState() {
    AppBloc bloc = context.read<AppBloc>();
    m.User? user = bloc.app.user;
    _tickets = getTicket(cookie: user!.cookie!, paymentId: widget.payment.id!)
        .catchError((e) {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return AlertDialog(
              content: SizedBox(
                width: 100,
                height: 100,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                        'Oops your session seems to have expired, please login'),
                    ElevatedButton(
                        onPressed: () {
                          // navigate to login
                          Navigator.of(context).pop();
                          context.read<AppBloc>().add(
                              OnAddPage(page: Signin.page(), app: bloc.app));
                        },
                        child: const Text('login'))
                  ],
                ),
              ),
            );
          });
    }, test: (e) => e is UnAuthorised);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AppBloc appStateManager = BlocProvider.of<AppBloc>(context, listen: false);
    final Auth auth = BlocProvider.of<Auth>(context, listen: false);
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('Ticket(s) Details'),
          actions: [
            PopUpMenu(
              appStateManager: appStateManager,
              auth: auth,
            )
          ],
        ),
        body: FutureBuilder<List<m.Ticket>>(
          future: _tickets,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<m.Ticket> tickets = snapshot.data!;

              Map<String, dynamic> tripDetails = {};
              tripDetails['from'] = tickets[0].from;
              tripDetails['to'] = tickets[0].to;
              tripDetails['depart_date'] = tickets[0].departureDate;
              tripDetails['time'] = tickets[0].departureTime;
              tripDetails['bus_no'] = tickets[0].plateNo;
              tripDetails['fare'] = tickets[0].busfare;
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Flexible(
                    child: ListView.builder(
                        itemCount: tickets.length,
                        itemBuilder: (context, index) {
                          return MyTicketCard(ticket: tickets[index]);
                        }),
                  ),
                  Card(
                    color: const Color(0xFF39748E),
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        children: [
                          _createRow({
                            'From:': tripDetails['from'],
                            'To:': tripDetails['to']
                          }),
                          _createRow({
                            'Depart time': tripDetails['depart_date'],
                            'Time:': tripDetails['time']
                          }),
                          _createRow({
                            'Bus no:': tripDetails['bus_no'],
                            'Total fare:':
                                'Tshs.' + tripDetails['fare'].toString() + '/='
                          }),
                        ],
                      ),
                    ),
                  ),
                  StatusFooter(
                    status: widget.payment.paymentStatus!,
                    reference: tickets[0].reference,
                  )
                ],
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('${snapshot.error}'),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ));
  }

  Widget _createRow(Map<String, String> row) {
    List<Widget> children = [];
    for (String i in row.keys) {
      children.add(Expanded(child: Text(i)));
      children.add(Expanded(child: Text(row[i]!)));
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(children: children),
    );
  }
}

class StatusFooter extends StatelessWidget {
  final String status;
  final String? reference;
  const StatusFooter({Key? key, required this.status, required this.reference})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color color;
    switch (status) {
      case 'paid':
        color = const Color(0xFF383D41);
        return _createCard(color, status);
      case 'cancelled':
        color = const Color(0xFF721C24);
        return _createCard(color, status);
      case 'pending':
        return Padding(
          padding: const EdgeInsets.all(3.0),
          child:
              BlocBuilder<LoadingBloc, LoadingState>(builder: (context, state) {
            return ElevatedButton(
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(const Color(0xFF0C5460))),
                onPressed: state is Load
                    ? null
                    : () async {
                        LoadingBloc bloc = context.read<LoadingBloc>();
                        AppBloc appBloc = context.read<AppBloc>();
                        bloc.add(OnLoad());
                        try {
                          List<m.PaymentOption> options =
                              await getPaymentOptions(
                                  appBloc.app.user!.cookie!);
                          bloc.add(OnLoadComplete());

                          appBloc.app.currentPayment!.options = options;
                          appBloc.app.currentPayment!.reference = reference;
                          appBloc.add(OnAddPage(
                              page: Payment.page(), app: appBloc.app));
                        } on UnAuthorised {
                          bloc.add(OnLoadComplete());

                          appBloc.add(
                              OnAddPage(page: Signin.page(), app: appBloc.app));
                        } on NetworkException catch (e) {
                          bloc.add(OnLoadComplete());
                          showSnackbar(context, e.toString());
                        } on Exception catch (e) {
                          bloc.add(OnLoadComplete());
                          showSnackbar(context,
                              'Ooop! We are experiencing some minor hiccups please try again later');
                          throw e;
                        }
                      },
                child: state is Load
                    ? FittedBox(
                        child: CircularProgressIndicator(
                        strokeWidth: 2.0,
                      ))
                    : const Text('Pay'));
          }),
        );
      default:
        return Container();
    }
  }

  Widget _createCard(Color color, String status) {
    return Card(
      color: color,
      child: Padding(
        padding: const EdgeInsets.all(9),
        child: Text(status),
      ),
    );
  }
}

enum Status { pending, cancelled, paid }
