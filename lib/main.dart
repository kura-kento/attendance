import 'package:attendance_app/screens/input_page.dart';
import 'package:attendance_app/screens/login_page.dart';
import 'package:attendance_app/screens/qr_scan.dart';
import 'package:attendance_app/utils/shared_prefs.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,

        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: FutureBuilder(
        builder: (BuildContext context ,AsyncSnapshot snapshot) {
          if(snapshot.hasData){
            return snapshot.data;
          }else{
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        },
        future: setting(),
      )
    );
  }
  Future<Widget> setting()async{
    await SharedPrefs.setInstance();
    return LoginPage();
    //ログイン中ならscan画面に
//    if(SharedPrefs.getUserMap()["employeeId"]){
//      return QrScan();
//    }else{
//      return LoginPage();
//    }
  }
}
//InputPage(inputMode: InputMode.login,)

