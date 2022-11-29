import 'package:crud_sqlite/connection/user_database.dart';
import 'package:crud_sqlite/model/user_model.dart';
import 'package:crud_sqlite/view/create_user.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class ReadDataScreen extends StatefulWidget {
  const ReadDataScreen({
    super.key,
  });

  @override
  State<ReadDataScreen> createState() => _ReadDataScreenState();
}

class _ReadDataScreenState extends State<ReadDataScreen> {
  late ConnectionDB db;
  late Future<List<User>> listuser;
  List<User> users = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    db = ConnectionDB();
    db.getUser().then((value) {
      setState(() {
        users = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('READ')),
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CreateUserScreen(
                            user: users[index], title: 'UPDATE USER'),
                      ));
                },
                onLongPress: () async {
                  await ConnectionDB().deleteUser(users[index].uid!);
                },
                title: Text(users[index].name.toString())),
          );
        },
      ),
    );
  }
}
