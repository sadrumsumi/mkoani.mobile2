import 'package:Mkoani/Screens/FrontPages/page.dart';
import 'package:flutter/material.dart';

Widget secondPage() {
  Widget content = Column(children: [
    Expanded(
      child: const Icon(
        Icons.book,
        size: 80,
      ),
    ),
    customText(
      content: 'Booking info & Payment',
      style: heading,
    ),
    customText(
      content: 'Confirm your credentials per your'
          'Identifications card and proceed for payment',
      style: style,
    ),
  ]);
  return TutorialPage(content: content);
}
