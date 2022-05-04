class User {
  final String? email;
  final String? phone;
  final String? cookie;
  final String? role;

  const User({this.email, this.phone, this.cookie, this.role});

  void updateCookie(String cookie) {
    cookie = cookie;
  }
}

class Profile {
  int id;
  String firstName;
  String lastName;
  String email;
  String phone;
  List roles;
  String createdAt;
  String profilePic;

  Profile(
      {required this.id,
      required this.createdAt,
      required this.email,
      required this.firstName,
      required this.lastName,
      required this.phone,
      required this.profilePic,
      required this.roles});

  Profile.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        createdAt = json['createdAt'],
        firstName = json['firstname'],
        lastName = json['lastname'],
        email = json['email'],
        phone = json['phone'],
        profilePic = json['profile'],
        roles = json['roles'];

  toJson() {
    Map<String, dynamic> json = {};
    json['id'] = id;
    json['roles'] = roles;
    json['created_at'] = createdAt;
    json['firstname'] = firstName;
    json['lastname'] = lastName;
    json['email'] = email;
    json['phone'] = phone;
  }
}
