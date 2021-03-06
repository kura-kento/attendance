import 'package:attendance_app/screens/home.dart';
import 'package:attendance_app/screens/login_page.dart';
import 'package:attendance_app/utils/shared_prefs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale("en"),
          const Locale("ja"),
        ],
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
  //  return LoginPage();
    //ログイン中ならscan画面に
    //SharedPrefs.getUserMap()["employeeId"] != null
    if(false){
      return HomePage();
    }else{
      return LoginPage();
    }
  }
}
//InputPage(inputMode: InputMode.login,)

//arsartarukana@gmail.com

//会社番号とそのパスワードを設定できるようにする。
//月の合計時間（残業時間＋労働時間全体）
//タブレット用のアカウント（QRコード用のアカウント区分で分ける）
//申請画面の時間が日を跨いだら時間がおかしくなる。