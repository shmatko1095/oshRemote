class User {
  String userId;
  String username;
  String name;

  User({
    required this.userId,
    required this.username,
    required this.name,
  });

  User.empty()
      : userId = "",
        username = "",
        name = "";

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is User &&
          userId == other.userId &&
          username == other.username &&
          name == other.name;

  @override
  int get hashCode => userId.hashCode ^ username.hashCode ^ name.hashCode;
}
