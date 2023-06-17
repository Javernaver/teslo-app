import 'package:teslo_shop/features/auth/domain/entities/user.dart';

class UserMapper {
  static User userJsonToEntity(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      fullName: json['fullName'],
      email: json['email'],
      roles: List<String>.from(['roles'].map((role) => role)),
      token: json['token'],
    );
  }
}
