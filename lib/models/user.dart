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
}
