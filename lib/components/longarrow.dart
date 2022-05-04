import 'package:flutter/material.dart';

class LongArrow extends StatelessWidget {
  const LongArrow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
              child: Container(
            height: 2.0,
            color: Colors.amber,
          )),
          const Icon(Icons.keyboard_arrow_right)
        ]);
  }
}
