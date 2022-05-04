import 'package:Mkoani/exceptions/network_exceptions.dart';
import 'package:Mkoani/models/models.dart';
import 'package:Mkoani/requests/requests.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../exceptions/unauthorised.dart';

Future<List<Payment>> getPayments(String cookie) async {
  http.Response response = await http.get(
    Uri.parse('${Requests.domain}mypayments'),
    // Uri.parse('http://192.168.1.212:5555/api/v1/mypayments'),
    headers: {
      "cookie": "mkoani=$cookie",
      "mkoani": r"VQ2%T$,Bm*^!Xd!pRaqq]7dwR=8;L2Kpv/[D?Y%29zyf>*X,",
    },
  );

  List<Payment> payments = [];

  // process response
  Map<String, dynamic> data = json.decode(response.body);
  print(data);
  if (response.statusCode == 200) {
    if (data['status']) {
      for (var i in data['message']) {
        payments.add(Payment.fromJson(i));
      }
      return payments;
    } else {
      throw NetworkException(data['message']);
    }
  } else if (response.statusCode == 401) {
    throw UnAuthorised('${data['message']}');
  } else {
    throw const NetworkException('Oops something went wrong');
  }
}


/*Requests requests = Requests();

Future<List<Payment>> getPayments(String cookie) async {
  String url = 'mypayments';
  List<Payment> payments = [];
  Map<String, dynamic> data = await requests.get(url, cookie);

  for (var i in data['message']) {
    payments.add(Payment.fromJson(i));
  }
  return payments;
}*/
