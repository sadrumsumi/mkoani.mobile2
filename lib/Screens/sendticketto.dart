import 'package:Mkoani/blocs/bloc.dart';
import 'package:Mkoani/components/components.dart' as c;
import 'package:Mkoani/exceptions/network_exceptions.dart';

import 'package:Mkoani/requests/send_payments.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/models.dart';
import '../exceptions/unauthorised.dart';

class SendTo extends StatefulWidget {
  static MaterialPage page() {
    return const MaterialPage(
        name: MyPages.sendTickets,
        key: ValueKey(MyPages.sendTickets),
        child: SendTo());
  }

  const SendTo({Key? key}) : super(key: key);

  @override
  State<SendTo> createState() => _SendToState();
}

class _SendToState extends State<SendTo> {
  final _formkey = GlobalKey<FormState>();
  final TextEditingController emailcontroller = TextEditingController();

  final TextEditingController phonecontroller = TextEditingController();

  final TextEditingController namecontroller = TextEditingController();

  @override
  void dispose() {
    emailcontroller.dispose();
    phonecontroller.dispose();
    namecontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle theme =
        Theme.of(context).textTheme.bodyText1!.copyWith(color: Colors.black);
    return Form(
        key: _formkey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'We will send your ticket(s) details to this email'
              ' and phone number',
              style: theme,
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              style: const TextStyle(color: Colors.black),
              keyboardType: TextInputType.emailAddress,
              controller: emailcontroller,
              validator: (text) {
                if (text == null || text.isEmpty) {
                  return 'Field can not be blank';
                }
                if (!text.contains('@')) {
                  return 'Email is not valid';
                }
                return null;
              },
              decoration: const InputDecoration(
                  labelStyle: TextStyle(color: Colors.black),
                  labelText: 'email',
                  border: OutlineInputBorder()),
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              style: const TextStyle(color: Colors.black),
              keyboardType: TextInputType.phone,
              controller: phonecontroller,
              validator: (text) {
                if (text == null || text.isEmpty) {
                  return 'Phone number can not be null';
                }
                if (!RegExp(r'^[0-9]{10,10}$').hasMatch(phonecontroller.text)) {
                  return 'Phone number is not valid';
                }
                return null;
              },
              decoration: const InputDecoration(
                  labelStyle: TextStyle(color: Colors.black),
                  labelText: 'phone number',
                  border: OutlineInputBorder()),
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              keyboardType: TextInputType.name,
              style: const TextStyle(color: Colors.black),
              controller: namecontroller,
              validator: (text) {
                if (text == null || text.isEmpty) {
                  return 'Field can not be blank';
                }

                return null;
              },
              decoration: const InputDecoration(
                  labelStyle: TextStyle(color: Colors.black),
                  labelText: 'full name',
                  border: OutlineInputBorder()),
            ),
            const SizedBox(
              height: 10,
            ),
            BlocBuilder<LoadingBloc, LoadingState>(builder: (context, state) {
              return ElevatedButton(
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all(
                        const EdgeInsets.symmetric(vertical: 8)),
                  ),
                  onPressed: state is Load
                      ? null
                      : () async {
                          if (_formkey.currentState!.validate()) {
                            AppBloc bloc = context.read<AppBloc>();
                            SeatBloc seatBloc = context.read<SeatBloc>();
                            LoadingBloc loadbloc = context.read<LoadingBloc>();
                            loadbloc.add(OnLoad(effects: 'null'));
                            bloc.app.addPayee({
                              'callback_email': emailcontroller.text,
                              'callback_phone': phonecontroller.text,
                              'callback_name': namecontroller.text,
                              'trip_route_id': seatBloc.state.bus!.tripRouteId!,
                              'trip_id': seatBloc.state.bus!.tripId!,
                              'is_main_route': seatBloc.state.bus!.isMainRoute!
                            });
                            print(bloc.app.payees);

                            // if user is logged in already
                            // send the payment details
                            // unless catch the unauthorised error

                            if (bloc.app.user != null) {
                              try {
                                await sendBookings();
                              } on UnAuthorised catch (e) {
                                loadbloc.add(OnLoadComplete());
                                if (loadbloc.state is Complete) {
                                  Navigator.of(context).pop();
                                  bloc.add(OnAddPage(
                                      app: bloc.app, page: c.Signin.page()));
                                  c.showSnackbar(context, e.toString());
                                }
                              } on NetworkException {
                                loadbloc.add(OnLoadComplete());
                                if (loadbloc.state is Complete) {
                                  Navigator.of(context).pop();
                                  c.showSnackbar(context,
                                      'We are experiencing some minor hiccups');
                                }
                              }
                            } else {
                              if (loadbloc.state is Complete) {
                                Navigator.of(context).pop();
                                bloc.add(OnAddPage(
                                    app: bloc.app, page: c.Signin.page()));
                              }
                            }
                          }
                        },
                  child: state is Load
                      ? CircularProgressIndicator()
                      : const Text('Send'));
            }),
          ],
        ));
  }

  Future<void> sendBookings() async {
    AppBloc bloc = context.read<AppBloc>();
    LoadingBloc loading = context.read<LoadingBloc>();

    var value = await sendPayment(
        cookie: bloc.app.user!.cookie!, body: bloc.app.payees);

    c.showSnackbar(context, 'success');

    print(value);

    bloc.app.addPayment(value);
    loading.add(OnLoadComplete());
    if (loading.state is Complete) {
      bloc.add(OnAddFreshPage(page: c.Payment.page(), app: bloc.app));
    }
  }
}
