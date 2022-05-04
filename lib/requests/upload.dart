import 'dart:convert';

import 'package:Mkoani/exceptions/network_exceptions.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'requests.dart';
import 'dart:io';

Future<String> upload({required XFile file, required String cookie}) async {
  var request = http.MultipartRequest(
      'POST', Uri.parse(Requests.domain + 'upload_profile_image'));
  request.headers['cookie'] = "mkoani=$cookie";
  request.headers['mkoani'] =
      r"VQ2%T$,Bm*^!Xd!pRaqq]7dwR=8;L2Kpv/[D?Y%29zyf>*X,";
  request.files.add(await http.MultipartFile.fromPath(
      'profile_image', file.path,
      contentType: MediaType('image', 'jpg')));

  var response = await request.send();
  if (response.statusCode == 200) {
    Map<String, dynamic> data =
        jsonDecode(await response.stream.bytesToString());
    if (data['status']) {
      return data['message'];
    } else {
      throw NetworkException(data['message']);
    }
  }
  throw const NetworkException(
      'sorry something is wrong please come again later');
}
