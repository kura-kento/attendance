import 'package:attendance_app/screens/qr_scan.dart';
import 'package:attendance_app/screens/setting_page.dart';
import 'package:attendance_app/screens/user_page.dart';
import 'package:attendance_app/utils/shared_prefs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  //以下BottomNavigationBar設定
  int _currentIndex = 0;
  final _pageWidgets = [
    QrScan(),
    UserPage(),
    SettingPage(),
    QrScan(),
  ];

  @override
  void initState(){
    super.initState();
  }



//メインのページ
  @override
  Widget build(BuildContext context) {
    return Scaffold(
          resizeToAvoidBottomInset: false,
          body: Column(
            children: <Widget>[
              Expanded(child:_pageWidgets.elementAt(_currentIndex)),

            ],
          ),
          bottomNavigationBar:BottomNavigationBar(
            items: bottomNavi(),
            iconSize: 30.0,
            selectedFontSize: 15.0,
            unselectedFontSize: 12.0,
            currentIndex: _currentIndex,
            fixedColor: Colors.blueAccent,
            onTap: _onItemTapped,
            type: BottomNavigationBarType.fixed,
          ),
        );
  }
  void _onItemTapped(int index) => setState(() => _currentIndex = index );
}

List<BottomNavigationBarItem> bottomNavi(){
 List<BottomNavigationBarItem> _cache = [BottomNavigationBarItem(icon: Icon(Icons.access_time), title: Text('勤怠')),
                                         BottomNavigationBarItem(icon: Icon(Icons.equalizer), title: Text('データ')),
                                         BottomNavigationBarItem(icon: Icon(Icons.settings), title: Text('設定')),
                                        ];

 if(SharedPrefs.getUserMap()["division"]==0){
   _cache.add(
       BottomNavigationBarItem(icon: Icon(Icons.assignment_turned_in), title: Text('申請'))
   );
 }
 return _cache;
}