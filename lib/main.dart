import 'package:city_app/screens/auth_list.dart';
import 'package:city_app/screens/dropdown_screen.dart';
import 'package:flutter/material.dart';

import 'apis/api_service.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Super Astrologer City App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        scaffoldBackgroundColor: Colors.white,
        useMaterial3: true,
      ),
      home: const AuthList(),
    );
  }
}
