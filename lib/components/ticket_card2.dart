import 'package:Mkoani/models/models.dart';
import 'package:flutter/material.dart';

class MyTicketCard extends StatelessWidget {
  final Ticket ticket;
  const MyTicketCard({Key? key, required this.ticket}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8.0,
      color: const Color(0xff39748E),
      shadowColor: Colors.grey[800],
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                underlinedText(ticket.fullname!),
                underlinedText('Seat no: ${ticket.seatNo}')
              ],
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                underlinedText(ticket.phone!),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.red),
                          shape:
                              MaterialStateProperty.all(const CircleBorder())),
                      onPressed: () {
                        showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) {
                              return AlertDialog(
                                backgroundColor: Colors.white,
                                title: const Text('Warning !'),
                                titleTextStyle: Theme.of(context)
                                    .textTheme
                                    .headline3!
                                    .copyWith(color: Colors.black),
                                contentTextStyle: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .copyWith(color: Colors.black),
                                content: Text(
                                    'Are you sure want to cancel this ticket(s) ?'),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('Cancel')),
                                  TextButton(
                                      onPressed: () {}, child: const Text('Ok'))
                                ],
                              );
                            });
                      },
                      child: const Icon(Icons.close),
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Container underlinedText(String value) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey))),
      child: Text(
        value,
        style: const TextStyle(fontSize: 14),
      ),
    );
  }
}
