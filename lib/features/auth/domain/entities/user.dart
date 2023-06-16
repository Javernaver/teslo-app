// ignore_for_file: public_member_api_docs, sort_constructors_first
class User {
  final String id;
  final String email;
  final String fullName;
  final String token;
  final List<String> roles;

  User({
    required this.id,
    required this.email,
    required this.fullName,
    required this.token,
    required this.roles,
  });

  bool get isAdmin => roles.contains('admin');

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      fullName: json['fullName'],
      token: json['token'],
      roles: [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'fullName': fullName,
      'token': token,
      'roles': roles,
    };
  }
}
