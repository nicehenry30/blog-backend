import '../../domain/entities/profile.dart';

class ProfileModel extends Profile {
  const ProfileModel({
    required super.id,
    required super.name,
    required super.email,
    required super.subscription,
    required super.mt4Connected,
    required super.mt5Connected,
  });

  factory ProfileModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return ProfileModel(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      subscription: json['subscription'] as String? ?? 'Free',
      mt4Connected: json['mt4_connected'] as bool? ?? false,
      mt5Connected: json['mt5_connected'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'subscription': subscription,
      'mt4_connected': mt4Connected,
      'mt5_connected': mt5Connected,
    };
  }
}