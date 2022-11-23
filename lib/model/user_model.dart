import 'package:crud_sqlite/connection/user_database.dart';
import 'package:crud_sqlite/constant/database_field.dart';

class User {
  int? uid;
  String? name;
  int? age;
  User({this.uid, this.age, this.name});
  Map<String, dynamic> toJson() {
    return {fuId: uid, fuName: name, fuAge: age};
  }
  // User.fromJson(Map<String, dynamic> res) {
  //   uid = res[fuId];
  //   name = res[fuName];
  //   age = res[fuAge];
  // }

  User.fromJson(Map<String, dynamic> res)
      : uid = res[fuId],
        name = res[fuName],
        age = res[fuAge];
}
