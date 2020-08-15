import 'package:firebase_database/firebase_database.dart';

class Stamp{
  String key;
  String uid;
  String date1;
  String date2;
  bool fix;
  bool approve;
  String remark;

  Stamp(this.uid,this.date1,this.date2,this.fix,this.approve,this.remark);

  Stamp.fromSnapShot(DataSnapshot snapshot):
        key = snapshot.key,
        uid = snapshot.value["uid"],
        date1 = snapshot.value["date1"],
        date2 = snapshot.value["date2"],
        fix = snapshot.value["fix"],
        approve = snapshot.value["approve"],
        remark = snapshot.value["remark"];


  toJson() {
    return {
      "uid": uid,
      "date1": date1,
      "date2": date2,
      "fix": fix,
      "approve": approve,
      "remark": remark,
    };
  }
}
