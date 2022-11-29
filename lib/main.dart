import 'package:crud_sqlite/model/user_model.dart';
import 'package:crud_sqlite/view/create_user.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CreateUserScreen(user: User(), title: 'CREATE USER'),
    );
  }
}
