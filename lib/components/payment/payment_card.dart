import 'package:Mkoani/Screens/screens.dart';
import 'package:Mkoani/blocs/app/app.dart';
import 'package:Mkoani/models/models.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PaymentCard extends StatelessWidget {
  final Payment payment;
  const PaymentCard({Key? key, required this.payment}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          AppBloc bloc = context.read<AppBloc>();
          bloc.app.addpayment(payment);
          bloc.add(OnAddPage(page: Tickets.page(payment), app: bloc.app));
        },
        child: Card(
            elevation: 8.0,
            color: const Color(0xff39748E),
            shadowColor: Colors.grey[800],
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.payment_outlined,
                    size: 70,
                  ),
                  RichText(
                      text: TextSpan(text: 'Status: ', children: [
                    TextSpan(
                        text: payment.paymentStatus!,
                        style: TextStyle(
                            fontSize: 16,
                            color: getColor(payment.paymentStatus!)))
                  ])),
                  const Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Amount: Tshs ${payment.amount}/=',
                          style: const TextStyle(fontSize: 16)),
                      const SizedBox(
                        height: 18,
                      ),
                      Text(
                          DateFormat('MMMM d, y')
                              .format(DateTime.parse(payment.createdAt!)),
                          style: Theme.of(context).textTheme.bodyText2)
                    ],
                  ),
                ],
              ),
            )));
  }

  Color getColor(String status) {
    switch (status) {
      case 'paid':
        return Colors.green;
      case 'fail':
      case 'pending':
        return Colors.red;
      default:
        return Colors.green;
    }
  }
}
