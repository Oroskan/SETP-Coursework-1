import 'package:flutter/material.dart';
import 'settings_menu.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});
  

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Account Settings',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: AccountSettings(),  // Replace the default home with your AccountSettings page
    );
  }
}
