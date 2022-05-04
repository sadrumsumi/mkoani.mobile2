import 'package:Mkoani/exceptions/network_exceptions.dart';
import 'package:Mkoani/exceptions/unauthorised.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Requests<T> {
  static const domain = 'http://192.168.1.212:5555/api/v1/';
  // static const domain = "https://www.mkoani.co.tz/api/v1/";
  static const static = "https://www.mkoani.co.tz/";
  static const websocket = "https://www.mkoani.co.tz/personal";
  static const websocketlocal = 'http://192.168.1.212:5555/personal';
  static const apiSecret = {
    "mkoani": r"VQ2%T$,Bm*^!Xd!pRaqq]7dwR=8;L2Kpv/[D?Y%29zyf>*X,",
  };

  Future<Map<String, dynamic>> get(String url, [String cookie = 'null']) async {
    Map<String, String> headers = {
      "Content-Type": "application/x-www-form-urlencoded",
    };

    if (cookie != 'null') {
      headers.addAll({"cookie": "mkoani=$cookie"});
    }
    headers.addAll(apiSecret);

    http.Response response =
        await http.get(Uri.parse(domain + url), headers: headers);

    // print calls for debugging
    print(response.body);

    Map<String, dynamic> data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      if (data['status']) {
        return data;
      } else {
        throw NetworkException(data['message']);
      }
    } else if (response.statusCode == 400) {
      throw UnAuthorised(data['message']);
    } else {
      throw NetworkException(data['message']);
    }
  }

  Future<Map<String, dynamic>> post(
      {required String url, String cookie = 'null', required Map body}) async {
    Map<String, String> headers = {
      "Content-Type": "application/x-www-form-urlencoded",
    };

    if (cookie != 'null') {
      headers.addAll({"cookie": "mkoani=$cookie"});
    }
    headers.addAll(apiSecret);

    http.Response response = await http.post(Uri.parse(domain + url),
        body: body, headers: headers, encoding: Encoding.getByName('utf8'));

    // print calls for debugging
    print(response.body);

    Map<String, dynamic> data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      if (data['status']) {
        return data;
      } else {
        throw NetworkException(data['message']);
      }
    } else if (response.statusCode == 400) {
      print('YYUUUU');
      throw UnAuthorised(data['message']);
    } else {
      throw NetworkException(data['message']);
    }
  }
}
