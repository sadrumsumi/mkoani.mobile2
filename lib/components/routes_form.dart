import 'package:Mkoani/Screens/screens.dart';
import 'package:Mkoani/blocs/app/app.dart';
import 'package:Mkoani/exceptions/network_exceptions.dart';
import 'package:Mkoani/requests/gettrips.dart';

import '/components/components.dart';
import 'package:Mkoani/models/models.dart';

import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class RoutesForm extends StatefulWidget {
  const RoutesForm({Key? key}) : super(key: key);

  @override
  State<RoutesForm> createState() => _RoutesFormState();
}

class _RoutesFormState extends State<RoutesForm> {
  final _formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
            key: _formkey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Book Bus Tickets',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      height: 1.17,
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w700),
                ),
                const RouteFormFiled(
                  name: 'From',
                ),
                const SizedBox(
                  height: 8,
                ),
                const RouteFormFiled(name: 'To'),
                const SizedBox(
                  height: 8,
                ),
                const DateField(),
                const SizedBox(
                  height: 8,
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (_formkey.currentState!.validate()) {
                      AppBloc bloc = context.read<AppBloc>();
                      App app = bloc.app;

                      // perform validation first
                      String from = app.route.from!;
                      String to = app.route.to!;
                      String date = app.route.date!;
                      if (from == to) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: Text(
                                'Oops!You seem to have given the same routes')));
                      } else {
                        try {
                          bloc.add(OnLoading(app));
                          var value =
                              await getTrips(from: from, to: to, date: date);

                          if (value.isNotEmpty) {
                            app.route.addBuses(value);
                            bloc.add(OnLoadingComplete(app,
                                page: BusDetails.page()));
                          } else {
                            bloc.add(OnLoadingComplete(app));
                            showSnackbar(context,
                                'Sorry, there are no buses for this route today');
                          }
                        } on NetworkException catch (e) {
                          bloc.add(OnLoadingComplete(app));

                          showSnackbar(context, e.toString());
                        } on Exception {
                          showSnackbar(context,
                              "some minor hiccups occured please try again later");
                        }
                      }
                    }
                  },
                  child: Text(
                    'Search Route',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ButtonStyle(
                      padding: MaterialStateProperty.all(
                          const EdgeInsets.symmetric(vertical: 20)),
                      backgroundColor:
                          MaterialStateProperty.all(const Color(0xffe6b412))),
                )
              ],
            )),
      ),
    );
  }
}

class RouteFormFiled extends StatefulWidget {
  const RouteFormFiled({Key? key, required this.name}) : super(key: key);

  final String name;
  @override
  State<RouteFormFiled> createState() => _RouteFormFiledState();
}

class _RouteFormFiledState extends State<RouteFormFiled> {
  late String text;
  @override
  Widget build(BuildContext context) {
    App app = context.read<AppBloc>().app;
    TextStyle style = const TextStyle(color: Colors.black);
    return TextFormField(
        style: style,
        validator: (text) {
          if (text == null || text.isEmpty) {
            return 'Field cannot be empty';
          }
          return null;
        },
        readOnly: true,
        showCursor: true,
        controller: TextEditingController(text: text),
        onTap: () async {
          var result = await showSearch(
              context: context, delegate: CustomSearch(hinttext: 'From'));
          if (result is String) {
            setState(() {
              text = result;
              widget.name.toLowerCase() == 'from'
                  ? app.route.addFrom(text)
                  : app.route.addTo(text);
            });
          }
        },
        decoration: InputDecoration(
          suffixIcon: const Icon(Icons.location_on, color: Colors.grey),
          border: Theme.of(context).inputDecorationTheme.border,
          label: Text(
            widget.name,
            softWrap: true,
          ),
        ));
  }

  @override
  void initState() {
    String name = widget.name;
    ChosenRoute route = context.read<AppBloc>().app.route;
    if (name.toLowerCase() == 'from') {
      text = route.from ?? '';
    } else {
      text = route.to ?? '';
    }
    super.initState();
  }
}

class CustomSearch extends SearchDelegate {
  String hinttext;

  CustomSearch({required this.hinttext});

  @override
  String? get searchFieldLabel => hinttext;
  @override
  List<Widget>? buildActions(BuildContext context) {}

  @override
  Widget buildSuggestions(BuildContext context) {
    return process(context);
  }

  ListView process(BuildContext context) {
    List<RouteModel> cities = context.read<AppBloc>().app.cities!;
    cities = cities
        .where((element) =>
            element.name.toLowerCase().startsWith(query.toLowerCase()))
        .toList();
    return ListView.builder(
        shrinkWrap: true,
        itemCount: cities.length,
        itemBuilder: (context, index) {
          RouteModel route = cities.elementAt(index);
          return GestureDetector(
            onTap: () {
              query = cities[index].name;
              close(context, query);
            },
            child: ListTile(
              title: Text(route.name),
            ),
          );
        });
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          close(context, null);
        },
        icon: const Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    return process(context);
  }
}
