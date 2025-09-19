// lib/models/user.dart
class User {
  final int id;
  final String firstName;
  final String lastName;
  final String username;
  final String email;
  final String phone;
  final String description;
  final DateTime dateOfBirth;
  final String gender;
  final String avatar;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.email,
    required this.phone,
    required this.description,
    required this.dateOfBirth,
    required this.gender,
    required this.avatar,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      description: json['description'] ?? '',
      dateOfBirth: DateTime.parse(json['dob'] ?? '2000-01-01'),
      gender: json['gender'] ?? '',
      avatar: json['avatar_url'] ?? '',
    );
  }
}