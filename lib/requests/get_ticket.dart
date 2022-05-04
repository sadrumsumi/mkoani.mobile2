import 'package:Mkoani/exceptions/network_exceptions.dart';
import 'package:Mkoani/models/models.dart';
import 'package:Mkoani/requests/requests.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../exceptions/unauthorised.dart';

/*Future<Ticket> getTicket(
    {required String cookie, required int paymentId}) async {
  http.Response response = await http.get(
    Uri.parse('http://192.168.1.212:5555/api/v1/mytickets/$paymentId'),
    headers: {
      "cookie": "mkoani=$cookie",
      "mkoani": r"VQ2%T$,Bm*^!Xd!pRaqq]7dwR=8;L2Kpv/[D?Y%29zyf>*X,",
    },
  );

  // process response
  Map<String, dynamic> data = json.decode(response.body);
  print(data);
  if (response.statusCode == 200) {
    if (data['status']) {
      return Ticket.fromJson(data['message'][0]);
    } else {
      throw NetworkException(data['message']);
    }
  } else if (response.statusCode == 401) {
    throw UnAuthorised('${data['message']}');
  } else {
    throw const NetworkException('Oops something went wrong');
  }
}*/

Requests request = Requests<Ticket>();

Future<List<Ticket>> getTicket(
    {required String cookie, required String paymentId}) async {
  String url = 'mytickets/$paymentId';

  List<Ticket> tickets = [];

  Map<String, dynamic> data = await request.get(url, cookie);

  for (var i in data['message']['data']['tickets']) {
    tickets.add(Ticket.fromJson(i, data['message']['data']['reference']));
  }
  return tickets;
}
