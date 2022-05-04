import 'package:Mkoani/blocs/bloc.dart';
import 'package:Mkoani/components/components.dart' as c;
import 'package:Mkoani/home.dart';
import 'package:Mkoani/models/models.dart';
import 'package:flutter/material.dart';

class PopUpMenu extends StatelessWidget {
  const PopUpMenu({Key? key, required this.appStateManager, required this.auth})
      : super(key: key);

  final AppBloc appStateManager;
  final Auth auth;

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () async {
          int? value = await showMenu(
              context: context,
              position: RelativeRect.fromLTRB(100, 0, 0, 0),
              items: [
                if (appStateManager.app.currentPage != null &&
                    appStateManager.app.currentPage != MyPages.profile)
                  PopupMenuItem(child: Text('Profile'), value: 0),
                PopupMenuItem(value: 1, child: Text('logout'))
              ]);
          if (value == 0) {
            // navigate to profile page
            print(10009);
            appStateManager.add(
                OnAddPage(page: c.Profile.page(), app: appStateManager.app));
          } else if (value == 1) {
            appStateManager.app.logout();
            appStateManager.add(
                OnAddFreshPage(page: Home.page(), app: appStateManager.app));
            auth.add(OnLogout());
            c.showSnackbar(context, 'You are logged out');
          }
        },
        icon: const Icon(Icons.more_vert));
  }
}
