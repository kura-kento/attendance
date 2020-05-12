import 'package:firebase_database/firebase_database.dart';

class User{
  String key;
  String companyId;
  String employeeId;
  String password;

  User(this.companyId,this.employeeId,this.password);

  User.fromSnapShot(DataSnapshot snapshot):
  key = snapshot.key,
  companyId = snapshot.value["companyId"],
  employeeId = snapshot.value["employeeId"],
  password = snapshot.value["password"];

  toJson() {
    return {
      "companyId": companyId,
      "employeeId": employeeId,
      "password": password,
    };
  }
}
