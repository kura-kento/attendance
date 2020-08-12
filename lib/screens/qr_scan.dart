import 'package:attendance_app/main.dart';
import 'package:attendance_app/models/stamp.dart';
import 'package:attendance_app/screens/user_page.dart';
import 'package:attendance_app/utils/shared_prefs.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';


class QrScan extends StatefulWidget {

  @override
  _QrScanState createState() => _QrScanState();
}

class _QrScanState extends State<QrScan> {
  int division;
  ScanResult scanResult;

  final _stampRef = FirebaseDatabase.instance.reference().child("Stamp");

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        title: Text("スキャン"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FlatButton(
                  color: Colors.redAccent,
                  child: Text('出勤', style: TextStyle(color: Colors.white),),
                  onPressed: (){
                    division=0;
                    SharedPrefs.getUser()[4] != "0" ? scan():_stampRef.push().set(Stamp(SharedPrefs.getUser()[3],DateFormat("yyyy-MM-dd HH:mm").format(DateTime.now()),division).toJson());
                  },
                ),
                FlatButton(
                  color: Colors.blueAccent,
                  child: Text('退勤', style: TextStyle(color: Colors.white),),
                  onPressed: (){
                    division=1;
                    SharedPrefs.getUser()[4] != "0" ? scan():_stampRef.push().set(Stamp(SharedPrefs.getUser()[3],DateFormat("yyyy-MM-dd HH:mm").format(DateTime.now()),division).toJson());;
                  },
                ),
              ],
            ),
            (scanResult != null) ? Text(scanResult.rawContent ?? "データがnull"):Text("スキャン出来ていない"),
            Divider(color: Colors.grey,height:0),
            logout(),
            Divider(color: Colors.grey,height:0),

            (SharedPrefs.getUser()[4]=="0") ? QrImage(data: SharedPrefs.getUser()[0], version: QrVersions.auto, size: 200.0,) : Container(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async{
          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return UserPage();
              },
            ),
          );
          setState(() {});
        },
      ),
    );
  }

  Future scan() async {
    try {
      var options = ScanOptions(
        strings: {
          "cancel" : "キャンセル",
          "flash_on" : "ライトオン",
          "flash_off" : "ライトオフ"
        }
      );
      var result = await BarcodeScanner.scan(options: options);
      scanResult = result;
      stamp(result.rawContent);
    } on PlatformException catch (e) {
      var result = ScanResult(
        type: ResultType.Error,
        format: BarcodeFormat.unknown,
      );
      if (e.code == BarcodeScanner.cameraAccessDenied) {
        result.rawContent = 'カメラへのアクセスが許可されていません!';

      } else {
        result.rawContent = 'エラー: $e';
      }
    }
    setState(() {});
  }

  void stamp(companyId){
    if(SharedPrefs.getUser()[0] == companyId){
      _stampRef.push().set(Stamp(SharedPrefs.getUser()[3],DateFormat("yyyy-MM-dd HH:mm").format(DateTime.now()),division).toJson());
      print("stampテーブルに保存");
    }else{
      print("stampテーブルに保存が失敗");
    }
  }

 Widget logout(){
   return InkWell(
     child: Container(
         height: 50,
         child: Center(child: Text("ログアウト"))),
     onTap: () async {
       SharedPrefs.setUser([]);
       _handleSignOut().catchError((e) => print(e));
       await Navigator.of(context).push(
         MaterialPageRoute(
           builder: (context) {
             return MyApp();
           },
         ),
       );
       setState(() {});
     },
   );
  }
  Future<void> _handleSignOut() async {
    await FirebaseAuth.instance.signOut();
    try {
      await GoogleSignIn().signOut();
    } catch (e) {
      print(e);
    }
  }
}
//DateFormat("yyyy-MM-dd HH:mm").format(DateTime.now())