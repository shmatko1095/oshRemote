class User {
  String userId;
  String username;

  User({
    required this.userId,
    required this.username,
  });

  User.empty()
      : userId = "",
        username = "";
}
