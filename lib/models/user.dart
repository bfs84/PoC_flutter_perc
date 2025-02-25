class User {
  final int userId;
  final String firstName;
  final String lastName;
  final String email;
  final String role; // 担当などの情報
  final DateTime createdAt;
  final DateTime updatedAt;

  User({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.role,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['user_id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      email: json['email'],
      role: json['role'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() => {
        'user_id': userId,
        'first_name': firstName,
        'last_name': lastName,
        'email': email,
        'role': role,
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt.toIso8601String(),
      };

  String get fullName => '$firstName $lastName';
}

// ユーザーID からユーザーのフルネームを取得するヘルパー
// ※必要に応じて mockUsers リストと照合してください
String getUserName(String userId, List<User> users) {
  return users.firstWhere(
    (user) => user.userId.toString() == userId,
    orElse: () => User(
      userId: 0,
      firstName: userId,
      lastName: '',
      email: '',
      role: '',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
  ).fullName;
} 