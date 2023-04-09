class User {
  String userId;
  String email;
  String name;

  User({
    required this.userId,
    required this.email,
    required this.name,
  });

  User.empty()
      : userId = "",
        email = "",
        name = "";

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is User &&
          userId == other.userId &&
          email == other.email &&
          name == other.name;

  @override
  int get hashCode => userId.hashCode ^ email.hashCode ^ name.hashCode;
}
