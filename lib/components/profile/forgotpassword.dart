import 'package:Mkoani/models/models.dart';

import 'package:flutter/material.dart';

class ForgotPassword extends StatefulWidget {
  static MaterialPage page() {
    return const MaterialPage(
        name: MyPages.forgotPassword,
        key: ValueKey(MyPages.forgotPassword),
        child: ForgotPassword());
  }

  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _formkey = GlobalKey<FormState>();
  final TextEditingController emailcontroller = TextEditingController();

  @override
  void dispose() {
    emailcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
              child: Container(
            decoration: BoxDecoration(
                color: Colors.black.withOpacity(.8),
                image: const DecorationImage(
                    image: AssetImage('images/logo.png'))),
          )),
          Expanded(
            flex: 2,
            child: SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 15),
                child: Form(
                    key: _formkey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          'Forgot Password',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          controller: emailcontroller,
                          validator: (text) {
                            if (text == null || text.isEmpty) {
                              return 'Field cannot be blank';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(), hintText: 'Email'),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        ElevatedButton(
                          onPressed: () {},
                          child: const Text('Submit'),
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.amber),
                              padding: MaterialStateProperty.all(
                                  const EdgeInsets.symmetric(vertical: 18))),
                        ),
                      ],
                    )),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
