import 'package:Mkoani/models/app.dart';
import 'package:flutter/material.dart';

abstract class AppEvents {
  App app;
  AppEvents(this.app);
}

class OnLoading extends AppEvents {
  OnLoading(App app) : super(app);
}

class OnLoadingComplete extends AppEvents {
  final MaterialPage? page;
  bool fresh;
  bool pop;
  OnLoadingComplete(App app, {this.page, this.fresh = false, this.pop = false})
      : super(app);
}

class OnBoardingEvent extends AppEvents {
  OnBoardingEvent(App app) : super(app);
}

class OnBoardingCompleteEvent extends AppEvents {
  OnBoardingCompleteEvent(App app) : super(app);
}

class OnInitialisng extends AppEvents {
  OnInitialisng(App app) : super(app);
}

class OnInitialised extends AppEvents {
  OnInitialised(App app) : super(app);
}

class OnRemovePage extends AppEvents {
  OnRemovePage({required App app}) : super(app);
}

class OnAddPage extends AppEvents {
  final MaterialPage page;
  OnAddPage({required this.page, required App app}) : super(app);
}

class OnAddFreshPage extends AppEvents {
  final MaterialPage page;
  OnAddFreshPage({required this.page, required App app}) : super(app);
}

class OnClearPages extends AppEvents {
  OnClearPages({required App app}) : super(app);
}

class OnGoToPage extends AppEvents {
  final MaterialPage page;
  OnGoToPage({required this.page, required App app}) : super(app);
}

class OnReplacePage extends AppEvents {
  MaterialPage page;
  OnReplacePage({required this.page, required App app}) : super(app);
}
