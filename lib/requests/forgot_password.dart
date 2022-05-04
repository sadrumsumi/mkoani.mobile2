import 'package:Mkoani/requests/main.dart';

Requests requests = Requests();

Future<String> forgot_password({required String email}) async {
  Map<String, dynamic> data =
      await requests.post(url: 'forget_password', body: {'email': email});
  print(data);
  return data['message'];
}
