import 'package:Mkoani/Screens/FrontPages/page.dart';
import 'package:flutter/material.dart';

Widget firstpage() {
  return TutorialPage(
      content: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
    customText(style: heading, content: 'How to book'),
    customText(
        style: style, content: 'steps on how to book bus tickets with Mkoani.'),
    Expanded(
      child: const Icon(
        Icons.map_outlined,
        size: 80,
      ),
    ),
    customText(style: heading, content: 'Select Route'),
    customText(
        style: style,
        content: 'choose where you want to depart from and '
            'your destination point.Select a bus of your '
            'choice and then seats you want to book'),
  ]));
}
