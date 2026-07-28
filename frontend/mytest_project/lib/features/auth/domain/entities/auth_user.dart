class AuthUser {
  final String id;
  final String name;
  final String email;
  final String token;

  const AuthUser({
    required this.id,
    required this.name,
    required this.email,
    required this.token,
  });

  factory AuthUser.fromJson(
    Map<String, dynamic> json, {
    required String token,
  }) {
    return AuthUser(
      id: json['id'].toString(),
      name: json['name'] as String,
      email: json['email'] as String,
      token: token,
    );
  }
}