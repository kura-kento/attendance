import 'package:firebase_database/firebase_database.dart';

class Attendance{
  String key;
  String date;
  int division;

  Attendance(this.date,this.division);

  Attendance.fromSnapShot(DataSnapshot snapshot):
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
