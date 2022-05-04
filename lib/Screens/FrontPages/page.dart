import 'package:Mkoani/blocs/app/app.dart';
import 'package:Mkoani/components/logo.dart';
import 'package:flutter/material.dart';
import 'package:Mkoani/models/models.dart';
import 'package:provider/provider.dart';

class TutorialPage extends StatefulWidget {
  final Widget content;
  const TutorialPage({Key? key, required this.content}) : super(key: key);

  @override
  State<TutorialPage> createState() => _TutorialPageState();
}

class _TutorialPageState extends State<TutorialPage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Logo(),
          const SizedBox(
            height: 20,
          ),
          Text(
            'Online Booking. Save Time and Money!',
            softWrap: true,
            style: Theme.of(context).textTheme.headline3,
          ),
          const SizedBox(
            height: 20,
          ),
          const Spacer(),
          SizedBox(
            height: 300,
            child: Card(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 25),
                child: widget.content,
              ),
            ),
          ),
          const Spacer(),
          Align(
            alignment: Alignment.bottomRight,
            child: TextButton(
                onPressed: () {
                  AppBloc bloc = context.read<AppBloc>();
                  bloc.add(OnBoardingCompleteEvent(bloc.app));
                },
                child: Text(
                  'skip',
                  style: TextStyle(fontSize: 18, color: Colors.blueGrey[900]),
                )),
          )
        ],
      ),
    );
  }
}

Text customText({required TextStyle style, required String content}) {
  return Text(
    content,
    softWrap: true,
    style: style,
    textAlign: TextAlign.center,
  );
}

TextStyle style = const TextStyle(
    fontSize: 14, color: Colors.black, fontWeight: FontWeight.w400);
TextStyle heading = const TextStyle(
    fontSize: 18, fontWeight: FontWeight.w700, color: Colors.black);
