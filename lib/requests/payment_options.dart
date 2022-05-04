import 'dart:convert';

import 'package:Mkoani/exceptions/network_exceptions.dart';
import 'package:Mkoani/exceptions/unauthorised.dart';
import 'package:Mkoani/models/models.dart';
import 'package:http/http.dart';
import 'requests.dart';

/*Future<List<PaymentOption>> getPaymentOptions(String cookie) async {
  Map<String, dynamic> data = await request.get('payment-method');
  print(data);
  return [];
}*/

Future<List<PaymentOption>> getPaymentOptions(String cookie) async {
  Response data =
      await get(Uri.parse('${Requests.domain}payment-method'), headers: {
    "cookie": "mkoani=$cookie",
    "mkoani": r"VQ2%T$,Bm*^!Xd!pRaqq]7dwR=8;L2Kpv/[D?Y%29zyf>*X,",
    "Content-Type": "application/x-www-form-urlencoded",
  });
  Map<String, dynamic> resp = jsonDecode(data.body);
  if (data.statusCode == 200) {
    if (resp['status']) {
      List<PaymentOption> options = [];
      for (Map i in resp['message']) {
        options.add(PaymentOption.fromjson(i));
      }
      return options;
    } else {
      throw NetworkException();
    }
  } else if (data.statusCode == 400) {
    throw UnAuthorised();
  } else {
    throw NetworkException();
  }
}
