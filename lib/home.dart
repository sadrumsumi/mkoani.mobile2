import 'package:flutter/material.dart';
import 'package:Mkoani/models/models.dart';
import 'components/components.dart';

class Home extends StatefulWidget {
  static MaterialPage page() {
    return const MaterialPage(
        name: MyPages.routes, key: ValueKey(MyPages.routes), child: Home());
  }

  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Container(
        padding: const EdgeInsets.all(1),
        height: MediaQuery.of(context).size.height,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Logo(),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Online Booking. Save Time and Money',
                      softWrap: true,
                      style: TextStyle(fontSize: 18),
                      //style: theme.textTheme.bodyText1,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Spacer(),
              RoutesForm(),
              Spacer()
            ],
          ),
        ),
      )),
    );
  }
}
