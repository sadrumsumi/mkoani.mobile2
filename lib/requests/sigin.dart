import 'dart:convert';
import 'package:Mkoani/exceptions/network_exceptions.dart';
import 'package:Mkoani/exceptions/unauthorised.dart';
import 'package:http/http.dart' as http;
import '../models/models.dart';
import 'requests.dart';

Future<User> login({required username, required password}) async {
  http.Response response = await http.post(
      Uri.parse('${Requests.domain}signin'),
      //Uri.parse('http://192.168.1.212:5555/api/v1/signin'),
      headers: <String, String>{
        "mkoani": r"VQ2%T$,Bm*^!Xd!pRaqq]7dwR=8;L2Kpv/[D?Y%29zyf>*X,",
        'Content-Type': 'application/json; charset=UTF-8',
      },
      encoding: Encoding.getByName('utf8'),
      body: jsonEncode(
          <String, String>{"username": username, "password": password}));

  Map data = jsonDecode(response.body);
  if (response.statusCode == 200) {
    if (data['status']) {
      String cookie = response.headers['set-cookie'].toString().split('=')[1];
      return User(role: data['message']['roles'][0], cookie: cookie);
    } else {
      throw NetworkException('${data['message']}');
    }
  } else if (response.statusCode == 401) {
    throw UnAuthorised('${data['message']}');
  } else {
    throw const NetworkException('Oops something went wrong');
  }
}
