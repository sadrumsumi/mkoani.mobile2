import 'package:Mkoani/Screens/FrontPages/firstpage.dart';
import 'package:Mkoani/Screens/FrontPages/secondpage.dart';
import 'package:Mkoani/Screens/FrontPages/thirdpage.dart';

import 'package:Mkoani/components/components.dart';
import 'package:Mkoani/models/models.dart';
import 'package:flutter/material.dart';
import 'package:page_view_indicators/circle_page_indicator.dart';

class Tutorial extends StatefulWidget {
  static MaterialPage page() {
    return const MaterialPage(
        key: ValueKey(MyPages.onBoarding),
        name: MyPages.onBoarding,
        child: Tutorial());
  }

  const Tutorial({Key? key}) : super(key: key);

  @override
  _TutorialState createState() => _TutorialState();
}

class _TutorialState extends State<Tutorial> {
  final PageController _controller = PageController();
  ValueNotifier<int> _notifier = ValueNotifier<int>(0);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Stack(children: [
            PageView(
                controller: _controller,
                children: [
                  firstpage(),
                  secondPage(),
                  thirdPage(),
                  Signin(
                    pageController: _controller,
                  ),
                  Register(
                    pageController: _controller,
                  )
                ],
                onPageChanged: (value) {
                  _notifier.value = value;
                }),
            Positioned(
                bottom: MediaQuery.of(context).size.height / 30,
                left: MediaQuery.of(context).size.width / 3,
                child: CirclePageIndicator(
                    size: 20,
                    selectedSize: 20,
                    dotColor: Color(0xFFC4C4C4),
                    selectedDotColor: Color(0xFFFFFF00),
                    currentPageNotifier: _notifier,
                    itemCount: 5))
          ]),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
