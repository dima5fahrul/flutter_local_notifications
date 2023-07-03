import 'package:flutter/material.dart';

import '../flutter_local_notifications/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // NotificationService().initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      title: 'Flutter Demo',
      home: const HomeScreen(),
    );
  }
}
