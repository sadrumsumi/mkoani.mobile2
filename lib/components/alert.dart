import 'package:Mkoani/blocs/app/app.dart';
import 'package:Mkoani/components/components.dart';

import 'package:flutter/material.dart';

void showAlert(
    {required BuildContext context,
    required Exception e,
    required AppBloc appStateManager}) {
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

                      appStateManager.add(OnAddPage(
                          page: Signin.page(), app: appStateManager.app));
                    },
                    child: const Text('login'))
              ],
            ),
          ),
        );
      });
}

Future<String?> showPop({
  required BuildContext context,
}) async {
  return showDialog<String?>(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          content: SizedBox(
            width: 100,
            height: 150,
            child: Padding(
              padding: const EdgeInsets.all(9),
              child: Wrap(
                  spacing: 2.0,
                  children: buildMenuButton(context: context, names: [
                    'vodacom',
                    'airtel',
                    'ttcl',
                    'zantel',
                    'tigo',
                    'halotel'
                  ])),
            ),
          ),
        );
      });
}

List<Widget> buildMenuButton(
    {required BuildContext context,
    required List<String> names,
    double width = 70,
    double height = 70}) {
  List<Widget> children = [];
  for (String name in names) {
    children.add(GestureDetector(
      onTap: () {
        Navigator.of(context).pop(name);
      },
      child: Padding(
        padding: const EdgeInsets.all(0),
        child: Image.asset(
          'images/operators/$name.png',
          fit: BoxFit.cover,
          width: width,
          height: height,
        ),
      ),
    ));
  }
  return children;
}
