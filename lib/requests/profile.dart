import '../models/models.dart';
import 'requests.dart';

Requests request = Requests();

Future<Profile> getProfile({required String cookie}) async {
  Map<String, dynamic> response = await request.get('profile', cookie);
  Map<String, dynamic> data = response['message'];
  return Profile.fromJson(data);
}

Future<String> updateProfile(
    {required String cookie,
    required String firstName,
    required String lastName,
    required String email,
    required String phone}) async {
  Map<String, dynamic> response = await request.post(
      url: "update_profile",
      cookie: cookie,
      body: {
        "firstname": firstName,
        "lastname": lastName,
        "phone": phone,
        "email": email
      });

  return response['message'];
}
