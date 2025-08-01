import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AuthList extends StatefulWidget {
  const AuthList({super.key});

  @override
  State<AuthList> createState() => _AuthListState();
}

class _AuthListState extends State<AuthList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Auth List'),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [

          ],
        ),
      ),
    );
  }
}
