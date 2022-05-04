import 'package:Mkoani/exceptions/network_exceptions.dart';
import 'package:Mkoani/models/models.dart';
import 'package:Mkoani/requests/requests.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../exceptions/unauthorised.dart';

Future<Map<String, dynamic>> sendPayment(
    {required Map body, required String cookie}) async {
  var response = await http.post(Uri.parse('${Requests.domain}payment'),
      headers: {
        "cookie": "mkoani=$cookie",
        "mkoani": r"VQ2%T$,Bm*^!Xd!pRaqq]7dwR=8;L2Kpv/[D?Y%29zyf>*X,",
        "Content-Type": "application/x-www-form-urlencoded",
      },
      encoding: Encoding.getByName('utf8'),
      body: body);
  // process response
  // parse the response
  Map data = json.decode(response.body);
  print(data);
  if (response.statusCode == 200) {
    if (data['status']) {
      List<PaymentOption> options = [];
      for (Map i in data['message']['methods']) {
        options.add(PaymentOption.fromjson(i));
      }
      return {
        'paymentOptions': options,
        'reference': data['message']['reference'] ?? ''
      };
    } else {
      throw NetworkException(data['message']);
    }
  } else if (response.statusCode == 400) {
    throw UnAuthorised('${data['message']}');
  } else {
    throw const NetworkException('Oops something went wrong');
  }
}

/*Requests requests = Requests();

Future<String> sendPayment({required Map body, required String cookie}) async {
  Map<String, dynamic> data =
      await requests.post(url: 'payment', body: body, cookie: cookie);
  return data['message'];
}*/
