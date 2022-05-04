import 'package:Mkoani/Screens/screens.dart';
import 'package:Mkoani/blocs/app/app.dart';
import 'package:Mkoani/components/loading.dart';
import 'package:Mkoani/components/no_network.dart';
import 'package:Mkoani/home.dart';
import 'package:Mkoani/models/models.dart';
import 'package:Mkoani/models/pages.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

class AppBloc extends Bloc<AppEvents, AppState> {
  List<MaterialPage> pages;
  App app = App(route: ChosenRoute());
  AppBloc(this.pages) : super(Initialising(app: App(route: ChosenRoute()))) {
    on<OnInitialisng>(_initialise);
    on<OnBoardingEvent>(_onBoarding);
    on<OnBoardingCompleteEvent>(_completeOnboarding);

    on<OnAddFreshPage>(_pushNew);
    on<OnAddPage>(_push);
    on<OnRemovePage>(_pop);
    on<OnLoading>(_load);
    on<OnLoadingComplete>(_completeLoading);
    on<OnReplacePage>(_replacePage);
  }

  void _replacePage(OnReplacePage event, Emitter<AppState> emit) {
    replace(replaceWith: event.page);
    app.currentPage = event.page.name;
    emit(Replaced(app: app, page: event.page));
  }

  void _load(OnLoading event, Emitter<AppState> emit) {
    push(LoadUpScreen.page());
    emit(Loading(app));
  }

  void _completeLoading(OnLoadingComplete event, Emitter<AppState> emit) {
    MaterialPage? page = event.page;
    bool fresh = event.fresh;
    bool pop = event.pop;
    if (page == null) {
      popIf(LoadUpScreen.page());
    } else {
      if (fresh) {
        popIf(LoadUpScreen.page());
        pushNew(page);
        app.currentPage = page.name;
      } else if (pop) {
        popIf(LoadUpScreen.page());
        this.pop();
      } else {
        popIf(LoadUpScreen.page());
        push(page);
        app.currentPage = page.name;
      }
    }
    emit(LoadingComplete(app, page: event.page, fresh: event.fresh));
  }

  void _initialise(OnInitialisng event, Emitter<AppState> emit) {
    push(SplashScreen.page());
    emit(Initialising(app: app));
  }

  void _pushNew(OnAddFreshPage events, Emitter<AppState> emit) {
    pushNew(events.page);
    app.currentPage = events.page.name;
    emit(PushNew(events.page));
  }

  void _push(OnAddPage events, Emitter<AppState> emit) {
    push(events.page);
    app.currentPage = events.page.name;
    emit(Push(events.page));
  }

  void _pop(OnRemovePage events, Emitter<AppState> emit) {
    pop();
    app.currentPage = pages.last.name;
    emit(PopState());
  }

  void _onBoarding(OnBoardingEvent event, Emitter<AppState> emit) {
    pushNew(Tutorial.page());
    emit(OnBoarding(app));
  }

  void _completeOnboarding(
      OnBoardingCompleteEvent event, Emitter<AppState> emit) {
    pushNew(Home.page());
    app.onBoardingComplete = true;
    emit(PushNew(Home.page()));
  }

  void pop() {
    if (pages.length > 1) {
      pages.removeLast();
    }
  }

  void popIf(MaterialPage page) {
    try {
      pages.firstWhere((element) => element.name == page.name);
      pop();
    } on StateError {
      return;
    }
  }

  void clear() {
    pages.clear();
  }

  void push(MaterialPage page) {
    try {
      pages.firstWhere((element) => element.name == page.name);
    } on StateError {
      pages.add(page);
    }
  }

  void pushNew(MaterialPage page) {
    clear();
    push(page);
  }

  void goTo() {}

  // replace the topmost page in the stack with another page
  void replace({required MaterialPage replaceWith}) {
    pages.removeLast();
    pages.add(replaceWith);
  }
}
