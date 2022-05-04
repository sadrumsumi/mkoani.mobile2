import 'package:flutter/material.dart';

class EmptyTrip extends StatelessWidget {
  const EmptyTrip({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          /*
          */
          children: [
            const Expanded(
                flex: 2,
                child: SizedBox(
                  height: 10,
                )),
            const Text(
              'It looks you don"t have any upcoming trips with us yet',
              textAlign: TextAlign.center,
              softWrap: true,
            ),
            const SizedBox(
              height: 32,
            ),
            ElevatedButton(
              onPressed: () {},
              child: Text('GO TO SEARCH'),
              style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all(const Size(280, 40))),
            )
          ],
        ));
  }
}
