import 'package:Mkoani/Screens/screens.dart';

import 'package:Mkoani/blocs/bloc.dart';

import 'package:Mkoani/components/no_network.dart';
import 'package:Mkoani/models/models.dart';
import 'package:Mkoani/requests/getroutes.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class RouterManager extends RouterDelegate
    with PopNavigatorRouterDelegateMixin, ChangeNotifier {
  @override
  final GlobalKey<NavigatorState> navigatorKey;

  RouterManager({Key? key}) : navigatorKey = GlobalKey<NavigatorState>();

  @override
  Future<void> setNewRoutePath(configuration) async {}

  @override
  Widget build(BuildContext context) {
    AppBloc bloc = context.watch<AppBloc>();
    NetworkBloc net = context.watch<NetworkBloc>();
    print(net.state);
    print(bloc.state);
    print(bloc.pages);
    if (bloc.state is Initialising) {
      bloc.push(SplashScreen.page());
      initialise(bloc, context.read<Auth>(), net, context.read<LoadingBloc>());
    }
    if (net.state is NetworkAvailable) {
      bloc.popIf(NoNetwork.page());
    }
    if (net.state is NetworkNotAvailable) {
      bloc.push(NoNetwork.page());
    }
    return Navigator(
      onPopPage: (route, results) {
        if (!route.didPop(results)) {
          return false;
        }
        if (route.settings.name == MyPages.seats) {
          context.read<SeatBloc>().add(const OnInitialise());
        }
        bloc.add(OnRemovePage(app: bloc.app));
        return true;
      },
      key: navigatorKey,
      pages: List.from(bloc.pages),
    );
  }

  Future<void> initialise(
      AppBloc appBloc, Auth auth, NetworkBloc net, LoadingBloc load) async {
    if (appBloc.state is Initialising && net.state is NetworkAvailable) {
      load.add(OnLoad(effects: null));
      App app = appBloc.app;
      print(9000);
      List<RouteModel> cities = await getRoutes();
      print(7800);
      app.cities = cities;

      const storage = FlutterSecureStorage();
      String? cookie = await storage.read(key: "cookie");
      if (cookie != null && cookie.isNotEmpty) {
        User user = User(cookie: cookie);
        app.user = user;
        print(app.user!.cookie!);
        app.initialised = true;
        app.onBoardingComplete = true;
        auth.add(OnLogin());
        appBloc.add(OnAddFreshPage(app: app, page: MyTickets.page()));
      } else {
        app.initialised = true;
        appBloc.add(OnBoardingEvent(app));
      }
      load.add(OnLoadComplete());
    }
  }
}
