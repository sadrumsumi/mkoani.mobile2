import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  const Logo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Container(
        // margin: const EdgeInsets.only(top: 19.33, left: 6.5),
        // padding: const EdgeInsets.all(6),
        width: 200,
        child: const Image(
          image: AssetImage('images/logo.png'),
          fit: BoxFit.fill,
          colorBlendMode: BlendMode.lighten,
          width: 250,
          height: 49.66,
        ),
      ),
      /*Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Mkoani',
            style: Theme.of(context).textTheme.bodyText1,
          ),
          Text(
            'Online Bus Ticket Booking',
            style: Theme.of(context).textTheme.bodyText1,
          )
        ],
      )*/
    ]);
  }
}
