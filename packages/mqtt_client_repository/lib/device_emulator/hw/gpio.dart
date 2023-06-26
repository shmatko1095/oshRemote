class GPIO<T> {
  late T _val;
  final String name;

  GPIO({required this.name, T? initial}) {
    if (initial == null) {
      if (T is int) {
        _val = 0 as T;
      } else if (T is bool) {
        _val = false as T;
      }
    }
  }

  void set(T val) {
    _val = val;
    // print("$name, val: $val");
  }

  T get() => _val;
}
