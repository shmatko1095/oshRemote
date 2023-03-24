import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:osh_remote/app.dart';

import 'injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const App());
}
