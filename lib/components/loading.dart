import 'package:Mkoani/models/models.dart';
import 'package:flutter/material.dart';

class LoadUpScreen extends StatelessWidget {
  const LoadUpScreen({Key? key}) : super(key: key);

  static MaterialLoadingPopUp page() {
    return const MaterialLoadingPopUp(
        name: MyPages.loading,
        key: ValueKey(MyPages.loading),
        child: LoadUpScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: SizedBox(
          width: 300,
          height: 200,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              CircularProgressIndicator(),
              Text(
                'Loading please wait..',
                style: TextStyle(color: Colors.black),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class MaterialLoadingPopUp extends MaterialPage {
  const MaterialLoadingPopUp(
      {required Widget child,
      String? restorationId,
      Object? arguments,
      LocalKey? key,
      String? name,
      bool maintainState = true,
      bool fullscreenDialog = false})
      : super(
            child: child,
            name: name,
            maintainState: maintainState,
            fullscreenDialog: fullscreenDialog,
            restorationId: restorationId,
            arguments: arguments,
            key: key);

  @override
  Route createRoute(BuildContext context) {
    return PageRouteBuilder(
        settings: this,
        pageBuilder: (context, _, __) {
          return const LoadUpScreen();
        },
        opaque: false);
  }
}

class LoadingRoute<T> extends PageRoute<T>
    with MaterialRouteTransitionMixin<T> {
  LoadingRoute({required MaterialPage<T> page}) : super(settings: page);

  MaterialPage<T> get _page => settings as MaterialPage<T>;
  @override
  Widget buildContent(BuildContext context) {
    return _page.child;
  }

  @override
  bool get opaque => false;

  @override
  bool get maintainState => _page.maintainState;

  @override
  bool get fullscreenDialog => super.fullscreenDialog;
}

void showLoading(BuildContext context) {
  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              CircularProgressIndicator(),
              Text(
                'Loading please wait..',
                style: TextStyle(color: Colors.black),
              )
            ],
          ),
        );
      });
}
