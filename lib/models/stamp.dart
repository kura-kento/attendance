import 'package:firebase_database/firebase_database.dart';

class Stamp{
  String key;
  String date;
  int division;

  Stamp(this.date,this.division);

  Stamp.fromSnapShot(DataSnapshot snapshot):
        key = snapshot.key,
        date = snapshot.value["date"],
        division = snapshot.value["division"];

  toJson() {
    return {
      "date": date,
      "division": division,
    };
  }
}
