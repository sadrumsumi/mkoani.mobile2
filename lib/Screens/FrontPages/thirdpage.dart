import 'package:Mkoani/Screens/FrontPages/page.dart';
import 'package:flutter/material.dart';

Widget thirdPage() {
  Widget content = Column(children: [
    Expanded(
      child: const Icon(
        Icons.confirmation_number,
        size: 80,
      ),
    ),
    customText(
      content: 'Done',
      style: heading,
    ),
    customText(
      content: 'SMS or Email print if desired',
      style: style,
    ),
  ]);
  return TutorialPage(content: content);
}
