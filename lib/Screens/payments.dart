import 'package:Mkoani/blocs/app/app.dart';
import 'package:Mkoani/blocs/bloc.dart';
import 'package:Mkoani/components/components.dart';
import 'package:Mkoani/exceptions/unauthorised.dart';
import 'package:Mkoani/home.dart';

import 'package:Mkoani/models/models.dart' as models;

import 'package:Mkoani/requests/get_payments.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyTickets extends StatefulWidget {
  const MyTickets({Key? key}) : super(key: key);
  static MaterialPage page() {
    return const MaterialPage(
        name: models.MyPages.trips,
        key: ValueKey(models.MyPages.trips),
        child: MyTickets());
  }

  @override
  _MyTicketsState createState() => _MyTicketsState();
}

class _MyTicketsState extends State<MyTickets> {
  late Future<List<models.Payment>> _payments;
  @override
  void initState() {
    AppBloc bloc = context.read<AppBloc>();
    models.User? user = bloc.app.user;
    _payments = getPayments(user!.cookie!).catchError((e) {
      bloc.app.user = null;
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
    // providers
    AppBloc appStateManager = BlocProvider.of<AppBloc>(context, listen: false);
    final Auth auth = BlocProvider.of<Auth>(context, listen: false);
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            appStateManager.add(
                OnAddFreshPage(page: Home.page(), app: appStateManager.app));
          },
          child: const Icon(Icons.location_on_outlined),
        ),
        appBar:
            AppBar(title: const Text('Payments'), centerTitle: true, actions: [
          PopUpMenu(
            appStateManager: appStateManager,
            auth: auth,
          )
        ]),
        backgroundColor: Colors.white,
        body: FutureBuilder<List<models.Payment>>(
            future: _payments,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text('${snapshot.error}'),
                );
              }
              if (snapshot.hasData) {
                List<models.Payment> payments = snapshot.data!;
                return Padding(
                    padding: const EdgeInsets.only(left: 1, right: 1),
                    child: ListView.separated(
                        itemBuilder: (context, index) {
                          return PaymentCard(payment: payments[index]);
                        },
                        separatorBuilder: (context, index) {
                          return const SizedBox();
                        },
                        itemCount: payments.length));
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            }),
      ),
    );
  }
}
