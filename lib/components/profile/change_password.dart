import 'package:Mkoani/blocs/app/app.dart';
import 'package:Mkoani/models/models.dart';
import 'package:Mkoani/requests/change_password.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChangePassword extends StatefulWidget {
  static MaterialPage page() {
    return const MaterialPage(
        name: MyPages.changePassword,
        key: ValueKey(MyPages.changePassword),
        child: ChangePassword());
  }

  const ChangePassword({Key? key}) : super(key: key);
  @override
  State<ChangePassword> createState() => _SigninState();
}

class _SigninState extends State<ChangePassword> {
  final _formkey = GlobalKey<FormState>();

  final TextEditingController oldpasswordcontroller = TextEditingController();
  final TextEditingController newpasswordcontroller = TextEditingController();
  final TextEditingController confirmcontroller = TextEditingController();

  @override
  void dispose() {
    oldpasswordcontroller.dispose();
    newpasswordcontroller.dispose();
    confirmcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AppBloc appStateManager = BlocProvider.of<AppBloc>(context, listen: false);
    TextStyle theme =
        Theme.of(context).textTheme.bodyText2!.copyWith(color: Colors.black);
    return SizedBox(
      width: 350,
      height: 350,
      child: Form(
          key: _formkey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Change Password?',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                style: theme,
                controller: oldpasswordcontroller,
                validator: (text) {
                  if (text == null || text.isEmpty) {
                    return 'Field cannot be blank';
                  }
                  return null;
                },
                decoration: InputDecoration(
                    hintStyle: theme,
                    border: const OutlineInputBorder(),
                    hintText: 'Old Password'),
              ),
              const SizedBox(
                height: 8,
              ),
              TextFormField(
                style: theme,
                controller: newpasswordcontroller,
                validator: (text) {
                  if (text == null || text.isEmpty) {
                    return 'Field cannot be blank';
                  }
                  return null;
                },
                decoration: InputDecoration(
                    hintStyle: theme,
                    border: const OutlineInputBorder(),
                    hintText: 'New Password'),
              ),
              const SizedBox(
                height: 8,
              ),
              TextFormField(
                style: theme,
                controller: confirmcontroller,
                validator: (text) {
                  if (text == null || text.isEmpty) {
                    return 'Field cannot be blank';
                  }
                  return null;
                },
                decoration: InputDecoration(
                    hintStyle: theme,
                    border: const OutlineInputBorder(),
                    hintText: 'Confirm Password'),
              ),
              const SizedBox(
                height: 8,
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_formkey.currentState!.validate()) {
                    appStateManager.add(OnLoading(appStateManager.app));
                    var value = await changePassword(
                        cookie: appStateManager.app.user!.cookie!,
                        body: {
                          'current_password': oldpasswordcontroller.text,
                          'new_password': newpasswordcontroller.text,
                          'confirm_password': confirmcontroller.text
                        });
                    if (value.containsKey('cookie')) {
                      // update the user
                      appStateManager.app.user = User(cookie: value['cookie']);

                      // Show message
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(value['message'])));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(value['message'])));
                    }
                    appStateManager.add(OnLoadingComplete(appStateManager.app));
                    Navigator.of(context).pop();
                  }
                },
                child: const Text('Submit'),
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.amber),
                    padding: MaterialStateProperty.all(
                        const EdgeInsets.symmetric(vertical: 18))),
              ),
            ],
          )),
    );
  }
}
