import 'package:firebase_database/firebase_database.dart';

class Stamp{
  String key;
  String uid;
  String date;
  int division;

  Stamp(this.uid,this.date,this.division);

  Stamp.fromSnapShot(DataSnapshot snapshot):
        key = snapshot.key,
        uid = snapshot.value["uid"],
        date = snapshot.value["date"],
        division = snapshot.value["division"];

  toJson() {
    return {
      "uid": uid,
      "date": date,
      "division": division,
    };
  }
}
