import 'package:Mkoani/blocs/app/app.dart';
import 'package:Mkoani/components/components.dart';
import 'package:Mkoani/models/models.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DateField extends StatefulWidget {
  const DateField({Key? key}) : super(key: key);

  @override
  _DateFieldState createState() => _DateFieldState();
}

class _DateFieldState extends State<DateField> {
  late String _value;
  @override
  Widget build(BuildContext context) {
    App app = context.read<AppBloc>().app;
    return TextFormField(
        style: const TextStyle(color: Colors.black),
        validator: (text) {
          if (text == null || text.isEmpty) {
            return 'Field cannot be empty';
          }
          return null;
        },
        controller: TextEditingController(text: _value),
        onTap: () async {
          final currentDate = DateTime.now();
          final selectedDate = await showDatePicker(
              context: context,
              initialDate: currentDate,
              firstDate: currentDate,
              lastDate: DateTime(currentDate.year + 1));
          if (selectedDate != null) {
            _value = parseDate(selectedDate);
            setState(() {
              app.route.addDate(_value);
            });
          }
        },
        readOnly: true,
        showCursor: true,
        decoration: InputDecoration(
          suffixIcon: const Icon(
            Icons.calendar_today_sharp,
            color: Colors.grey,
          ),
          label: Text(
            'Depart Date',
            softWrap: true,
            style: TextStyle(color: Colors.grey[600]),
          ),
        ));
  }

  @override
  void initState() {
    ChosenRoute route = context.read<AppBloc>().app.route;

    _value = route.date ?? '';

    super.initState();
  }
}
