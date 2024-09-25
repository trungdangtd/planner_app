// ignore_for_file: file_names

class UserModel {
  final int? id;
  final String email;
  final String password;

  UserModel({
    this.id,
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'password': password,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'], // Ensure this key exists in your database
      email: map['email'] ?? '',
      password: map['password'] ?? '',
    );
  }

  @override
  String toString() => 'User(id: $id, email: $email)';
}
