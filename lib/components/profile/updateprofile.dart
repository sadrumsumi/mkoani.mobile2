import 'package:Mkoani/blocs/bloc.dart';
import 'package:Mkoani/exceptions/network_exceptions.dart';
import 'package:Mkoani/models/models.dart' as m;
import 'package:Mkoani/requests/profile.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../components.dart';

class UpdateProfile extends StatefulWidget {
  static MaterialPage page() {
    return const MaterialPage(
        name: m.MyPages.editprofile,
        key: ValueKey(m.MyPages.editprofile),
        child: UpdateProfile());
  }

  const UpdateProfile({Key? key}) : super(key: key);
  @override
  State<UpdateProfile> createState() => _SigninState();
}

class _SigninState extends State<UpdateProfile> {
  final _formkey = GlobalKey<FormState>();
  bool _initialise = false;
  late TextEditingController emailcontroller;
  late TextEditingController phonecontroller;
  late TextEditingController firstnamecontroller;
  late TextEditingController lastnamecontroller;
  late final Future<m.Profile> profile;

  @override
  void initState() {
    AppBloc appStateManager = BlocProvider.of<AppBloc>(context, listen: false);
    profile = getProfile(cookie: appStateManager.app.user!.cookie!);
    super.initState();
  }

  @override
  void dispose() {
    phonecontroller.dispose();
    emailcontroller.dispose();
    firstnamecontroller.dispose();
    lastnamecontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AppBloc appStateManager =
        context.select((AppBloc appStatemanager) => appStatemanager);
    final Auth auth = BlocProvider.of<Auth>(context, listen: false);
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          elevation: 0.0,
          title: const Text('Profile'),
          centerTitle: true,
          bottom: PreferredSize(
            preferredSize: const Size(double.infinity, 10),
            child: SizedBox(
              child: Container(
                decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.white)),
                ),
              ),
            ),
          ),
          actions: [
            PopUpMenu(
              appStateManager: appStateManager,
              auth: auth,
            )
          ],
        ),
        body: FutureBuilder<m.Profile>(
            future: profile,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text('${snapshot.data}'),
                  );
                } else {
                  TextStyle theme = Theme.of(context)
                      .textTheme
                      .bodyText1!
                      .copyWith(color: Colors.black);
                  m.Profile p = snapshot.data!;
                  if (!_initialise) {
                    emailcontroller = TextEditingController(text: p.email);
                    firstnamecontroller =
                        TextEditingController(text: p.firstName);
                    lastnamecontroller =
                        TextEditingController(text: p.lastName);
                    phonecontroller = TextEditingController(text: p.phone);
                    _initialise = true;
                  }

                  return Center(
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height / 4 * 2 + 50,
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Form(
                              key: _formkey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  const Text(
                                    'Update profile',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  TextFormField(
                                    style: theme,
                                    controller: firstnamecontroller,
                                    validator: (text) {
                                      if (text == null || text.isEmpty) {
                                        return 'Field cannot be blank';
                                      }
                                      return null;
                                    },
                                    decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        hintText: 'First name'),
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  TextFormField(
                                    style: theme,
                                    controller: lastnamecontroller,
                                    validator: (text) {
                                      if (text == null || text.isEmpty) {
                                        return 'Field cannot be blank';
                                      }
                                      return null;
                                    },
                                    decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        hintText: 'Last name'),
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  TextFormField(
                                    style: theme,
                                    controller: phonecontroller,
                                    validator: (text) {
                                      if (text == null || text.isEmpty) {
                                        return 'Field cannot be blank';
                                      }
                                      return null;
                                    },
                                    decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        hintText: 'Phone'),
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  TextFormField(
                                    style: theme,
                                    keyboardType: TextInputType.emailAddress,
                                    controller: emailcontroller,
                                    validator: (text) {
                                      if (text == null || text.isEmpty) {
                                        return 'Field cannot be blank';
                                      }
                                      return null;
                                    },
                                    decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        hintText: 'Email'),
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  ElevatedButton(
                                    onPressed: () async {
                                      appStateManager
                                          .add(OnLoading(appStateManager.app));
                                      try {
                                        String reply = await updateProfile(
                                            cookie: appStateManager
                                                .app.user!.cookie!,
                                            firstName: firstnamecontroller.text,
                                            lastName: lastnamecontroller.text,
                                            email: emailcontroller.text,
                                            phone: phonecontroller.text);
                                        showSnackbar(context, reply);
                                        appStateManager.add(OnLoadingComplete(
                                            appStateManager.app,
                                            page: UpdateProfile.page(),
                                            pop: true));
                                      } on NetworkException catch (e) {
                                        showSnackbar(context, e.msg!);
                                      }
                                    },
                                    child: const Text('Update'),
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                Colors.amber),
                                        padding: MaterialStateProperty.all(
                                            const EdgeInsets.symmetric(
                                                vertical: 18))),
                                  ),
                                ],
                              )),
                        ),
                      ),
                    ),
                  );
                }
              } else {
                return const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(Colors.amber),
                  ),
                );
              }
            }),
      ),
    );
  }
}
