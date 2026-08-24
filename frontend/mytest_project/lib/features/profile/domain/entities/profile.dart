class Profile {
  final int id;
  final String name;
  final String email;
  final String subscription;
  final bool mt4Connected;
  final bool mt5Connected;

  const Profile({
    required this.id,
    required this.name,
    required this.email,
    required this.subscription,
    required this.mt4Connected,
    required this.mt5Connected,
  });
}