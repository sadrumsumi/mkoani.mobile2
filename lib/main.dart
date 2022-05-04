import 'package:Mkoani/blocs/bloc.dart';
import 'package:Mkoani/mkoani_theme.dart';

import 'package:Mkoani/navigation/approuter.dart' as route;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MkoaniApp());
}

class MkoaniApp extends StatefulWidget {
  const MkoaniApp({Key? key}) : super(key: key);

  @override
  State<MkoaniApp> createState() => _MkoaniAppState();
}

class _MkoaniAppState extends State<MkoaniApp> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => AppBloc([])),
          BlocProvider(create: (_) => LoadingBloc()),
          BlocProvider(create: (_) => Auth()),
          BlocProvider(create: (_) => NetworkBloc()),
          BlocProvider(create: (_) => SeatBloc())
        ],
        child: GestureDetector(
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'mkoani',
              theme: MkoaniTheme.dark(),
              home: Router(
                  backButtonDispatcher: RootBackButtonDispatcher(),
                  routerDelegate: route.RouterManager())),
        ));
  }
}
