import 'package:firebase_database/firebase_database.dart';

class User{
  String key;
  String companyId;
  String employeeId;
  String name;
  String uid;
  int division;

//承認（bool）と区分（int）も追加

  User(this.companyId,this.employeeId,this.name,this.uid,this.division);

  User.fromSnapShot(DataSnapshot snapshot):
  key = snapshot.key,
  companyId = snapshot.value["companyId"],
  employeeId = snapshot.value["employeeId"],
  name = snapshot.value["name"],
  uid = snapshot.value["uid"],
  division = int.parse(snapshot.value["division"]);

  toJson() {
    return {
      "companyId": companyId,
      "employeeId": employeeId,
      "name": name,
      "uid": uid,
      "division": division.toString(),
    };
  }
}
