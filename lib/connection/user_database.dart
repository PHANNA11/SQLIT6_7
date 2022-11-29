import 'dart:ffi';
import 'package:crud_sqlite/constant/database_field.dart';
import 'package:crud_sqlite/model/user_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:developer' as dev;

class ConnectionDB {
  Future<Database> initDataBase() async {
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, 'userdatabase.db'),
      onCreate: (database, version) async {
        await database.execute(
          'CREATE TABLE $tblName($fuId INTEGER PRIMARY KEY, $fuName TEXT, $fuAge INTEGER)',
        );
      },
      version: 1,
    );
  }

  Future<void> insertUser(User user) async {
    final db = await initDataBase();
    await db.insert(tblName, user.toJson());
    dev.log('Function Insert');
  }

  Future<void> deleteUser(int userId) async {
    final db = await initDataBase();
    await db.delete(tblName, where: "$fuId=?", whereArgs: [userId]);
  }

  Future<void> updateUser(User user) async {
    final db = await initDataBase();
    await db.update(tblName, user.toJson(),
        where: '$fuId=?', whereArgs: [user.uid]);
  }

  Future<List<User>> getUser() async {
    final db = await initDataBase();
    final List<Map<String, dynamic>> queryResult = await db.query(tblName);
    return queryResult.map((e) => User.fromJson(e)).toList();
    //queryResult.map((e) => todo.fromMap(e)).toList();
  }
}
