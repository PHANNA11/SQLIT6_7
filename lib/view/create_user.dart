import 'dart:io';
import 'dart:math';
import 'package:image_picker/image_picker.dart';
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
  File? fileImage;
  getUserUpdate() {
    setState(() {
      nameController.text = widget.user.name!;
      ageController.text = widget.user.age.toString();
      fileImage = File(widget.user.image.toString());
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
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      actionsAlignment: MainAxisAlignment.center,
                      title: const Text('Choose one option'),
                      actions: [
                        MaterialButton(
                          color: Colors.blueAccent,
                          onPressed: () {
                            openCamera();
                            Navigator.pop(context);
                          },
                          child: const Text("Camra"),
                        ),
                        MaterialButton(
                          color: Colors.redAccent,
                          onPressed: () {
                            getImageFromGallary();
                            Navigator.pop(context);
                          },
                          child: const Text("Gallary"),
                        ),
                      ],
                    );
                  },
                );
              },
              icon: Icon(Icons.camera_alt)),
          const SizedBox(
            width: 30,
          ),
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
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 250,
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.brown,
                    image: fileImage == null
                        ? const DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(
                                'https://imgs.search.brave.com/IgqAzs6VdBbPwoIJ8zOgUb3GlAO4sDn2spOOkm2yTXw/rs:fit:800:600:1/g:ce/aHR0cHM6Ly9jZG4u/ZHJpYmJibGUuY29t/L3VzZXJzLzYzNDMz/Ni9zY3JlZW5zaG90/cy8yMjQ2ODgzL19f/X19fLnBuZw'))
                        : DecorationImage(
                            fit: BoxFit.cover,
                            image: FileImage(File(fileImage!.path)))),
              ),
            ),
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
                        age: int.parse(ageController.text),
                        image: fileImage!.path.toString()),
                  )
                  .then((value) => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ReadDataScreen(),
                      )))
              : ConnectionDB()
                  .updateUser(
                    User(
                        name: nameController.text,
                        age: int.parse(ageController.text),
                        uid: widget.user.uid,
                        image: fileImage!.path.toString()),
                  )
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

  Future getImageFromGallary() async {
    final file = await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      fileImage = File(file!.path);
    });
  }

  Future openCamera() async {
    final file = await ImagePicker().pickImage(source: ImageSource.camera);
    setState(() {
      fileImage = File(file!.path);
    });
  }
}
