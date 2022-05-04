import 'package:Mkoani/blocs/bloc.dart';
import 'package:Mkoani/components/components.dart';

import 'package:Mkoani/exceptions/network_exceptions.dart';
import 'package:Mkoani/models/models.dart';

import 'package:Mkoani/requests/signup.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

enum UserType { agent, customer }

class Register extends StatefulWidget {
  static MaterialPage page() {
    return const MaterialPage(
        name: MyPages.register,
        key: ValueKey(MyPages.register),
        child: Register());
  }

  const Register({Key? key, this.pageController}) : super(key: key);
  final PageController? pageController;
  @override
  State<Register> createState() => _SigninState();
}

class _SigninState extends State<Register> {
  final _formkey = GlobalKey<FormState>();
  final FlutterSecureStorage storage = const FlutterSecureStorage();
  final TextEditingController emailcontroller = TextEditingController();

  final TextEditingController phonecontroller = TextEditingController();
  final TextEditingController firstnamecontroller = TextEditingController();

  final TextEditingController lastnamecontroller = TextEditingController();

  @override
  void dispose() {
    phonecontroller.dispose();
    emailcontroller.dispose();
    firstnamecontroller.dispose();
    lastnamecontroller.dispose();
    super.dispose();
  }

  UserType _value = UserType.customer;

  @override
  Widget build(BuildContext context) {
    TextStyle cardTextColor = const TextStyle(color: Colors.black);
    AppBloc appStateManager = BlocProvider.of<AppBloc>(context, listen: false);
    Auth auth = context.read<Auth>();

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Logo(),
              const SizedBox(
                height: 18,
              ),
              Text(
                'Online Booking. Save Time and Money',
                softWrap: true,
                style: Theme.of(context).textTheme.headline3,
              ),
              const SizedBox(
                height: 18,
              ),
              const Spacer(),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Form(
                      key: _formkey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'Registrations',
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .headline3!
                                .copyWith(color: Colors.black),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            style: const TextStyle(color: Colors.black),
                            keyboardType: TextInputType.name,
                            controller: firstnamecontroller,
                            validator: (text) {
                              if (text == null || text.isEmpty) {
                                return 'Field cannot be blank';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                hintStyle: TextStyle(color: Colors.black),
                                hintText: 'First name'),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          TextFormField(
                            keyboardType: TextInputType.name,
                            style: const TextStyle(color: Colors.black),
                            controller: lastnamecontroller,
                            validator: (text) {
                              if (text == null || text.isEmpty) {
                                return 'Field cannot be blank';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                hintStyle: TextStyle(color: Colors.black),
                                hintText: 'Last name'),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          TextFormField(
                            keyboardType: TextInputType.phone,
                            style: const TextStyle(color: Colors.black),
                            controller: phonecontroller,
                            validator: (text) {
                              if (text == null || text.isEmpty) {
                                return 'Field cannot be blank';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                hintStyle: TextStyle(color: Colors.black),
                                hintText: 'Phone'),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          TextFormField(
                            style: const TextStyle(color: Colors.black),
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
                                hintStyle: TextStyle(color: Colors.black),
                                hintText: 'Email'),
                          ),
                          Row(
                            children: [
                              Row(
                                children: [
                                  Radio(
                                    value: UserType.customer,
                                    groupValue: _value,
                                    onChanged: (UserType? value) {
                                      if (value != null) {
                                        setState(() {
                                          _value = value;
                                        });
                                      }
                                    },
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Text(
                                    'Customer',
                                    style: cardTextColor,
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  Radio(
                                    value: UserType.agent,
                                    groupValue: _value,
                                    onChanged: (UserType? value) {
                                      if (value != null) {
                                        setState(() {
                                          _value = value;
                                        });
                                      }
                                    },
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Text(
                                    'Agent',
                                    style: cardTextColor,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              if (_formkey.currentState!.validate()) {
                                // register user
                                appStateManager
                                    .add(OnLoading(appStateManager.app));
                                try {
                                  var value = await register(
                                      phone: phonecontroller.text,
                                      role: _value.name,
                                      email: emailcontroller.text,
                                      firstname: firstnamecontroller.text,
                                      lastname: lastnamecontroller.text);

                                  // add the user model to the appmanager
                                  appStateManager.app.user = value;

                                  await storage.write(
                                      key: 'cookie',
                                      value: appStateManager.app.user!.cookie);
                                  // now send the payment info
                                  // only when login succeeds
                                  await pay(context);
                                } on NetworkException catch (e) {
                                  appStateManager.add(
                                      OnLoadingComplete(appStateManager.app));
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('$e')));
                                }
                              }
                            },
                            child: const Text('Submit'),
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.amber),
                                padding: MaterialStateProperty.all(
                                    const EdgeInsets.symmetric(vertical: 18))),
                          ),
                          TextButton(
                            style: TextButton.styleFrom(
                              textStyle: const TextStyle(fontSize: 15),
                            ),
                            onPressed: () {
                              if (!appStateManager.app.onBoardingComplete &&
                                  widget.pageController != null) {
                                widget.pageController!.previousPage(
                                    duration: const Duration(seconds: 1),
                                    curve: Curves.easeIn);
                              } else {
                                context.read<AppBloc>().add(OnReplacePage(
                                    page: Signin.page(),
                                    app: appStateManager.app));
                              }
                            },
                            child: const Text('Already have an account?'),
                          ),
                        ],
                      )),
                ),
              ),
              const Spacer(),
              if (auth.state is Anonymous &&
                  appStateManager.state is OnBoarding)
                Align(
                  alignment: Alignment.bottomRight,
                  child: TextButton(
                      onPressed: () {
                        context
                            .read<AppBloc>()
                            .add(OnBoardingCompleteEvent(appStateManager.app));
                      },
                      child: Text(
                        'skip',
                        style: TextStyle(
                            fontSize: 18, color: Colors.blueGrey[900]),
                      )),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
