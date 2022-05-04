import 'package:Mkoani/models/models.dart';
import 'package:flutter/material.dart';

class NoNetwork extends StatelessWidget {
  static MaterialPage page() {
    return const MaterialPage(
        name: MyPages.noNetwork,
        key: ValueKey(MyPages.noNetwork),
        child: NoNetwork());
  }

  const NoNetwork({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Image.asset('images/network.png'),
        ),
      ),
    );
  }
}
