import 'dart:math';

import 'package:crud_sqlite/connection/user_database.dart';
import 'package:crud_sqlite/model/user_model.dart';
import 'package:crud_sqlite/view/read_data_screen.dart';
import 'package:flutter/material.dart';

class CreateUserScreen extends StatefulWidget {
  CreateUserScreen({super.key, required this.user, required this.title});
  User user;
  String title;

  @override
  State<CreateUserScreen> createState() => _CreateUserScreenState();
}

class _CreateUserScreenState extends State<CreateUserScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();

  getUserUpdate() {
    setState(() {
      nameController.text = widget.user.name!;
      ageController.text = widget.user.age.toString();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.user.uid);
    if (widget.user.uid != null) {
      getUserUpdate();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ReadDataScreen(),
                    ));
              },
              icon: Icon(Icons.menu))
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: nameController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), hintText: 'Entter name'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: ageController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), hintText: 'Enter age'),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await widget.user.uid == null
              ? ConnectionDB()
                  .insertUser(
                    User(
                        uid: DateTime.now().millisecond,
                        name: nameController.text,
                        age: int.parse(ageController.text)),
                  )
                  .then((value) => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ReadDataScreen(),
                      )))
              : ConnectionDB()
                  .updateUser(User(
                      name: nameController.text,
                      age: int.parse(ageController.text),
                      uid: widget.user.uid))
                  .then((value) => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ReadDataScreen(),
                      )));
        },
        tooltip: 'Increment',
        child: Icon(widget.user.uid == null ? Icons.add : Icons.done),
      ),
    );
  }
}
