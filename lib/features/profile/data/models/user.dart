class User {
  final String email;
  final String name;

  const User({required this.email, required this.name});

  factory User.fromJson(Map<String, dynamic> json) =>
      User(email: json['email'] as String, name: json['name'] as String);
}
