import 'package:flutter/material.dart';

void showSnackbar(BuildContext context, String data) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(data)));
}

Widget makeAppBar(BuildContext context, String title) {
  return AppBar();
}
