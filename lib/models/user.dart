class User {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String role; // 担当などの情報

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.role,
  });

  String get fullName => '$firstName $lastName';
}

// ユーザーID からユーザーのフルネームを取得するヘルパー
// ※必要に応じて mockUsers リストと照合してください
String getUserName(String userId, List<User> users) {
  return users.firstWhere(
    (user) => user.id == userId,
    orElse: () => User(id: userId, firstName: userId, lastName: '', email: '', role: ''),
  ).fullName;
} 