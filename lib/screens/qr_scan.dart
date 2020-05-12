import 'package:attendance_app/screens/user_page.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class QrScan extends StatefulWidget {
  QrScan({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _QrScanState createState() => _QrScanState();
}

class _QrScanState extends State<QrScan> {
  ScanResult scanResult;

  @override
  void initState() {
    scan();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
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
            (scanResult != null) ? Text(scanResult.rawContent ?? ""):Text("")
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
      var result = await BarcodeScanner.scan(
          options: options
      );
      setState(() {
        scanResult = result;
      });
    } on PlatformException catch (e) {
      var result = ScanResult(
        type: ResultType.Error,
        format: BarcodeFormat.unknown,
      );
      if (e.code == BarcodeScanner.cameraAccessDenied) {
        setState(() {
          result.rawContent = 'カメラへのアクセスが許可されていません!';
        });
      } else {
        result.rawContent = 'エラー: $e';
      }
      setState(() {
        scanResult = result;
        scanResult.rawContent = "打刻に成功しました！";
      });
    }
  }
}