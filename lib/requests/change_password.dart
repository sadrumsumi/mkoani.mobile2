import 'dart:convert';

import 'package:http/http.dart' as http;
import 'requests.dart';



Future<Map> changePassword({required Map body, required String cookie}) async {

  http.Response response = await http.post(Uri.parse(Requests.domain+'change_password'), body: body, headers:{"cookie": "mkoani=$cookie",
    "mkoani": r"VQ2%T$,Bm*^!Xd!pRaqq]7dwR=8;L2Kpv/[D?Y%29zyf>*X,"} );

  // print response for debugging
  print(response.body);
  Map<String, dynamic> data = jsonDecode(response.body);

  if(data['status']){
    // update cookie
    String cookie = response.headers['set-cookie'].toString().split('=')[1];
    return {'message' : data['message'], 'cookie': cookie};
  }
  else{
    return {'message': data['message']};
  }

}