import 'package:Mkoani/blocs/auth/bloc.dart';
import 'package:Mkoani/blocs/bloc.dart';
import 'package:Mkoani/components/components.dart' as c;

import 'package:Mkoani/exceptions/network_exceptions.dart';
import 'package:Mkoani/home.dart';
import 'package:Mkoani/models/models.dart';
import 'package:Mkoani/requests/forgot_password.dart';
import 'package:Mkoani/requests/sigin.dart';
import 'package:Mkoani/requests/send_payments.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';

class Signin extends StatefulWidget {
  static MaterialPage page() {
    return const MaterialPage(
        name: MyPages.login, key: ValueKey(MyPages.login), child: Signin());
  }

  const Signin({Key? key, this.pageController}) : super(key: key);
  final PageController? pageController;

  @override
  State<Signin> createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  final _formkey = GlobalKey<FormState>();

  final TextEditingController textcontroller = TextEditingController();

  final TextEditingController passwordcontroller = TextEditingController();
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  @override
  void dispose() {
    passwordcontroller.dispose();
    textcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle cardTextColor = const TextStyle(color: Colors.black);
    Auth bloc = context.read<Auth>();
    AppBloc appStateManager = context.read<AppBloc>();
    print(appStateManager.app.onBoardingComplete);
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const c.Logo(),
              const SizedBox(
                height: 10,
              ),
              Text(
                'Online Booking. Save Time and Money',
                softWrap: true,
                style: Theme.of(context).textTheme.headline3,
              ),
              Flexible(fit: FlexFit.tight, child: Row()),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Form(
                      key: _formkey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'Login',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black,
                                  fontSize: 18),
                            ),
                          ),
                          TextFormField(
                            style: cardTextColor,
                            controller: textcontroller,
                            validator: (text) {
                              if (text == null || text.isEmpty) {
                                return 'Field cannot be blank';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                                border: const OutlineInputBorder(),
                                hintStyle: cardTextColor,
                                hintText: 'Email or phone number'),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          TextFormField(
                            style: cardTextColor,
                            controller: passwordcontroller,
                            validator: (text) {
                              if (text == null || text.isEmpty) {
                                return 'Field cannot be blank';
                              }
                              return null;
                            },
                            obscureText: true,
                            decoration: InputDecoration(
                                hintStyle: cardTextColor,
                                border: const OutlineInputBorder(),
                                hintText: 'password'),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              InkWell(
                                onTap: () {
                                  showDialog(
                                      barrierDismissible: false,
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          backgroundColor: Colors.white,
                                          title: Text(
                                            'Forgot Password?',
                                            textAlign: TextAlign.center,
                                          ),
                                          titleTextStyle: Theme.of(context)
                                              .textTheme
                                              .headline3!
                                              .copyWith(color: Colors.black),
                                          content: SizedBox(
                                            height: 150,
                                            child: ForgotPassword(),
                                          ),
                                        );
                                      });
                                },
                                child: const Padding(
                                  child: Text(
                                    'Forgot Password?',
                                    style: TextStyle(color: Colors.blue),
                                  ),
                                  padding: EdgeInsets.all(7),
                                ),
                              )
                            ],
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              if (_formkey.currentState!.validate()) {
                                // login the user only if he isnot logged in
                                appStateManager
                                    .add(OnLoading(appStateManager.app));
                                try {
                                  var reply = await login(
                                      username: textcontroller.text,
                                      password: passwordcontroller.text);

                                  appStateManager.app.user = reply;

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
                                backgroundColor: MaterialStateProperty.all(
                                    Colors.orangeAccent),
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
                                widget.pageController!.nextPage(
                                    duration: const Duration(seconds: 1),
                                    curve: Curves.easeIn);
                              } else {
                                appStateManager.add(OnReplacePage(
                                    page: c.Register.page(),
                                    app: appStateManager.app));
                              }
                            },
                            child: const Text('Don`t have an account?'),
                          ),
                        ],
                      )),
                ),
              ),
              Flexible(fit: FlexFit.tight, child: Row()),
              if (bloc.state is Anonymous &&
                  appStateManager.state is OnBoarding)
                Align(
                  alignment: Alignment.bottomRight,
                  child: TextButton(
                      onPressed: () {
                        appStateManager
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

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({
    Key? key,
  }) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final TextEditingController email = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextFormField(
          textInputAction: TextInputAction.done,
          keyboardType: TextInputType.emailAddress,
          style: TextStyle(color: Colors.black),
          controller: email,
          decoration: InputDecoration(
              labelStyle: Theme.of(context)
                  .textTheme
                  .bodyText2!
                  .copyWith(color: Colors.black),
              labelText: 'Enter your email address'),
        ),
        const Spacer(),
        BlocBuilder<LoadingBloc, LoadingState>(builder: (context, state) {
          print(state);
          return ElevatedButton(
              onPressed: () async {
                if (email.text.isNotEmpty) {
                  try {
                    context.read<LoadingBloc>().add(OnLoad());
                    String response = await forgot_password(email: email.text);
                    context.read<LoadingBloc>().add(OnLoadComplete());
                    Navigator.of(context).pop();
                    c.showSnackbar(context, response);
                  } on NetworkException catch (e) {
                    context.read<LoadingBloc>().add(OnLoadComplete());
                    Navigator.of(context).pop();
                    c.showSnackbar(context, e.toString());
                  }
                }
              },
              child: state is Load
                  ? CircularProgressIndicator(
                      strokeWidth: 2.0,
                      color: Colors.white60,
                    )
                  : Text('Reset Password'));
        })
      ],
    );
  }

  @override
  void dispose() {
    email.dispose();
    super.dispose();
  }
}

Future<void> pay(BuildContext context) async {
  AppBloc appStateManager = context.read<AppBloc>();
  SeatBloc bloc = context.read<SeatBloc>();
  if (appStateManager.app.payees.isEmpty) {
    if (!appStateManager.app.onBoardingComplete) {
      appStateManager.add(OnLoadingComplete(appStateManager.app,
          page: Home.page(), fresh: true));
    } else {
      appStateManager.add(OnLoadingComplete(
        appStateManager.app,
        page: Signin.page(),
        pop: true,
      ));
    }
  } else if (appStateManager.app.payees.isNotEmpty) {
    try {
      Map<String, dynamic> value = await sendPayment(
          cookie: appStateManager.app.user!.cookie!,
          body: appStateManager.app.payees);

      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Payment details sent')));
      appStateManager.app.addPayment(value);
      appStateManager.app.payees.clear();
      bloc.add(const OnInitialise());
      appStateManager.add(OnLoadingComplete(appStateManager.app,
          fresh: true, page: c.Payment.page()));
    } on NetworkException catch (e) {
      appStateManager.add(OnLoadingComplete(appStateManager.app));
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
    }
  }
}
