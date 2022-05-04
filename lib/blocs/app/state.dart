import 'package:Mkoani/blocs/app/app.dart';
import 'package:Mkoani/models/models.dart';
import 'package:flutter/material.dart';

abstract class AppState {
  App? app;

  App? get model => app!;
  App? set(App model) => app = model;
  AppState(this.app);
}

class NavigationState extends AppState {
  @override
  App? get model => null;

  @override
  App? set(App? model) => null;

  @override
  NavigationState() : super(null);
}

class Loading extends AppState {
  Loading(App app) : super(app);
}

class LoadingComplete extends AppState {
  final MaterialPage? page;
  bool fresh;
  LoadingComplete(App app, {this.page, this.fresh = false}) : super(app);
}

class Initialising extends AppState {
  Initialising({required App app}) : super(app);
}

class Initialised extends AppState {
  Initialised(App app) : super(app);
}

class OnBoarding extends AppState {
  OnBoarding(App app) : super(app);
}

class OnBoardingComplete extends AppState {
  OnBoardingComplete(App app) : super(app);
}

class PopState extends NavigationState {
  PopState();
}

class Push extends NavigationState {
  final MaterialPage page;
  Push(this.page);
}

class PushNew extends NavigationState {
  final MaterialPage page;
  PushNew(this.page);
}

class Clear extends NavigationState {
  Clear();
}

class Goto extends NavigationState {
  final MaterialPage page;
  Goto(this.page);
}

class Replaced extends AppState {
  final MaterialPage page;
  Replaced({required App app, required this.page}) : super(app);
}
