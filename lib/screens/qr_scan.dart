import 'package:attendance_app/main.dart';
import 'package:attendance_app/screens/user_page.dart';
import 'package:attendance_app/utils/shared_prefs.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';


class QrScan extends StatefulWidget {


  @override
  _QrScanState createState() => _QrScanState();
}

class _QrScanState extends State<QrScan> {
  ScanResult scanResult;

  final _attendanceRef = FirebaseDatabase.instance.reference().child("Attendance");

  @override
  void initState() {
    scan();
    super.initState();
  }
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
            FlatButton(
              color: Colors.blueAccent,
              child: Text('QR SCAN', style: TextStyle(color: Colors.white),),
              onPressed: scan,
            ),
            (scanResult != null) ? Text(scanResult.rawContent ?? ""):Text(""),
            logout(),
            QrImage(
              data: "1100",
              version: QrVersions.auto,
              size: 200.0,
            ),
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
       setState(() {});
    }
  }
 Widget logout(){
   return InkWell(
     child: Container(
         height: 50,
         child: Center(child: Text("ログアウト"))),
     onTap: () async {
       SharedPrefs.setLogin("null");
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

}
//DateFormat("yyyy-MM-dd HH:mm").format(DateTime.now())