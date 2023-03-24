class Password {
  final String value;
  final int length;

  const Password({required this.value, this.length = 8});
  const Password.pure() : value = '', length = 8;

  bool isValid() => value.length >= length;
}
