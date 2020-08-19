import 'dart:convert';

import 'package:attendance_app/main.dart';
import 'package:attendance_app/screens/user_page.dart';
import 'package:attendance_app/utils/shared_prefs.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:qr_flutter/qr_flutter.dart';


class QrScan extends StatefulWidget {

  @override
  _QrScanState createState() => _QrScanState();
}

class _QrScanState extends State<QrScan> {
  int division;
  ScanResult scanResult;
  var instance;
  QuerySnapshot querySnapshot;
  bool buttonBool = false;

  void initState() {
     instance = Firestore.instance.collection(SharedPrefs.getUserMap()["uid"]).orderBy('date1', descending: true).snapshots();
     getData();
    super.initState();
  }

  Future<void> getData() async {
    querySnapshot = await Firestore.instance.collection(SharedPrefs.getUserMap()["uid"]).orderBy('date1', descending: true).getDocuments();
    buttonBool = querySnapshot.documents[0]["date2"] == null ? false : true;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        title: Text(SharedPrefs.getUserMap()['name']),
       // leading: Container(),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  height: 150,
                  width:150,
                  child: FlatButton(
                    color: buttonBool ? Colors.red[400] :Colors.red[100],
                    child: Text('出勤', style: TextStyle(color: Colors.white),),
                    onPressed: (){
                      //押した時にgetData()の処理が終わっていないためエラーが出る。
                      getData();
                       querySnapshot.documents.length == 0 || querySnapshot.documents[0].data["date2"] != null ? stamp(SharedPrefs.getUserMap()['companyId']) : print("退勤処理ができてません。");
                    //  SharedPrefs.getUserMap()['division'] != 0 ? scan() : stamp(SharedPrefs.getUserMap()['companyId']);
                      buttonBool=false;
                      setState(() {});
                    },
                  ),
                ),
                Container(
                  height:150,
                  width:150,
                  child: FlatButton(
                    color: buttonBool ? Colors.blue[100] :Colors.blue[400],
                    child: Text('退勤', style: TextStyle(color: Colors.white),),
                    onPressed: (){
                      getData();
                      querySnapshot.documents.length == 0 || querySnapshot.documents[0].data["date2"] != null ? print("date2が入っている。"):updateData(SharedPrefs.getUserMap()["uid"],querySnapshot.documents[0].documentID,querySnapshot.documents[0].data);
                      buttonBool=true;
                      setState(() {});
                      },
                  ),
                ),
              ],
            ),
           // (scanResult != null) ? Text(scanResult.rawContent ?? "データがnull"):Text("スキャン出来ていない"),

            Divider(color: Colors.grey,height:0),

            (SharedPrefs.getUserMap()['division'] == 0) ? QrImage(data: SharedPrefs.getUserMap()['companyId'], version: QrVersions.auto, size: 200.0,) : Container(),
            Divider(color: Colors.grey,height:0),
            logout(),
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
    if(SharedPrefs.getUserMap()['companyId'] == companyId){
      Map<String, dynamic> data = {
        "date1": DateTime.now(),
        "date2": null,
        "fix": false,//修正
        "approve": false,//承認
        "memo": "",
        "createdAt": DateTime.now()
      };
      setData(SharedPrefs.getUserMap()['uid'],data);
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
       SharedPrefs.setUserMap(json.encode({}));
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
//documentの登録
void setData(String collection, Map data) {
  Firestore.instance.collection(collection).document().setData(data);
}

//更新
void updateData(String collection, String documentID, Map data) {
  data["date2"] = DateTime.now();
  Firestore.instance.collection(collection).document(documentID).updateData(data);
}



//DateFormat("yyyy-MM-dd HH:mm").format(DateTime.now())