import 'package:Mkoani/blocs/app/app.dart';
import 'package:Mkoani/blocs/bloc.dart';
import 'package:Mkoani/exceptions/network_exceptions.dart';
import 'package:Mkoani/requests/gettrips.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/models.dart';
import '../components/components.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BusDetails extends StatefulWidget {
  static MaterialPage page() {
    return const MaterialPage(
        name: MyPages.buses, key: ValueKey(MyPages.buses), child: BusDetails());
  }

  const BusDetails({Key? key}) : super(key: key);

  @override
  State<BusDetails> createState() => _BusDetailsState();
}

class _BusDetailsState extends State<BusDetails> {
  late List<BusModel> buses;
  @override
  Widget build(BuildContext context) {
    AppBloc bloc = context.read<AppBloc>();
    final Auth auth = BlocProvider.of<Auth>(context, listen: false);
    print(bloc.pages);
    App app = bloc.app;
    return Scaffold(
        floatingActionButton: Wrap(
          spacing: 2.45,
          direction: Axis.vertical,
          children: [
            FloatingActionButton(
              onPressed: () {},
              child: const Icon(Icons.filter_list_outlined),
            ),
            FloatingActionButton(
              onPressed: () {
                context.read<AppBloc>().add(OnRemovePage(app: app));
              },
              child: const Icon(Icons.location_on),
            )
          ],
        ),
        appBar: AppBar(
          title: Text(
            '${app.route.from!.toUpperCase()} to'
            ' ${app.route.to!.toUpperCase()}',
            softWrap: true,
          ),
          actions: [
            IconButton(
                onPressed: () async {
                  final currentDate = DateTime.now();
                  DateTime? selectedDate = await showDatePicker(
                      context: context,
                      initialDate: currentDate,
                      firstDate: currentDate,
                      lastDate: DateTime(currentDate.year + 1));
                  if (selectedDate != null) {
                    try {
                      bloc.add(OnLoading(app));

                      List<BusModel> buses = await getTrips(
                          from: app.route.from!,
                          to: app.route.to!,
                          date: parseDate(selectedDate));

                      bloc.add(OnLoadingComplete(app));
                      setState(() {
                        this.buses = buses;
                      });
                    } on NetworkException catch (e) {
                      showSnackbar(context, e.toString());
                    }
                  }
                },
                icon: const Icon(Icons.calendar_today)),
            PopUpMenu(
              appStateManager: bloc,
              auth: auth,
            )
          ],
          bottom: PreferredSize(
              child: Text(
                DateFormat('MMMM d, y').format(
                    DateTime.parse(app.route.date!.split('-').reversed.join())),
                style: const TextStyle(fontSize: 16),
              ),
              preferredSize: const Size(40, 40)),
        ),
        body: Container(
            color: Colors.grey[400],
            child: ListView.builder(
                itemCount: buses.length,
                itemBuilder: (context, i) {
                  return BusCard(bus: buses[i]);
                })));
  }

  @override
  void initState() {
    buses = context.read<AppBloc>().app.route.buses;
    super.initState();
  }
}
