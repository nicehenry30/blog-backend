import '../../domain/entities/profile.dart';

class ProfileModel extends Profile {
  const ProfileModel({
    required super.id,
    required super.name,
    required super.email,
    required super.phone,
    required super.country,
    required super.avatar,
    required super.subscription,
    required super.mt4Connected,
    required super.mt5Connected,
  });

  factory ProfileModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return ProfileModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      country: json['country'],
      avatar: json['avatar'],
      subscription: json['subscription'],
      mt4Connected: json['mt4_connected'],
      mt5Connected: json['mt5_connected'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'country': country,
      'avatar': avatar,
      'subscription': subscription,
      'mt4_connected': mt4Connected,
      'mt5_connected': mt5Connected,
    };
  }
}