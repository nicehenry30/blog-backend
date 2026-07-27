import 'package:mytest_project/features/auth/domain/entities/auth_user.dart';

class AuthUserModel extends AuthUser {
  const AuthUserModel({
    required super.id,
    required super.name,
    required super.email,
    required super.token,
  });

  factory AuthUserModel.fromJson(Map<String, dynamic> json) {
    return AuthUserModel(
      id: json['user']['id'].toString(),
      name: json['user']['name'].toString(),
      email: json['user']['email'].toString(),
      token: json['token'].toString(),
    );
  }
}
