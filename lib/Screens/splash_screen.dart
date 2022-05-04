import 'package:Mkoani/blocs/bloc.dart';
import 'package:Mkoani/mkoani_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/models.dart';

class SplashScreen extends StatefulWidget {
  static MaterialPage page() {
    return const MaterialPage(
        name: MyPages.splash,
        key: ValueKey(MyPages.splash),
        child: SplashScreen());
  }

  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: Colors.black87,
            body: Stack(
              children: [
                Positioned(
                  left: MediaQuery.of(context).size.width / 12,
                  top: MediaQuery.of(context).size.height / 2,
                  child: Image.asset('images/logo.png'),
                ),
                BlocBuilder<LoadingBloc, LoadingState>(
                  builder: (context, state) {
                    if (state is Load) {
                      return Align(
                        alignment: Alignment.bottomCenter,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              CircularProgressIndicator(),
                              Text('Loading...')
                            ]),
                      );
                    }
                    return Align(
                      child: Row(),
                      alignment: Alignment.bottomCenter,
                    );
                  },
                )
              ],
            )));
  }
}
