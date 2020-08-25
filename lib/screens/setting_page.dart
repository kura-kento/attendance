import 'package:attendance_app/utils/shared_prefs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {

  TextEditingController deadlineController = TextEditingController();
  final List<String> _items = [
    "1日","2日","3日","4日","5日","6日","7日","8日","9日","10日",
    "11日","12日","13日","14日","15日","16日","17日","18日","19日","20日",
    "21日","22日","23日","24日","25日","26日","27日","28日","末日"
  ];
  Widget _pickerItem(String str){
    return Text(
      str,
      style : TextStyle(fontSize: 32)
    );
  }

  void _onSelectedItemChanged(int index){
    SharedPrefs.setDeadline(_items[index]);
    setState(() {});
  }

  @override
  void initState() {
    deadlineController = TextEditingController(text:SharedPrefs.getDeadline());
    var aa = _items.where((user) => user == "21日");
    print(aa.length);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("設定"),
        leading: Container(),
      ),
        body: Container(
          child:Column(
            children: [
              Text("休憩時間"),
              Row(
                children: [
                  Text("締め日："),
                  FlatButton(
                    child: Text(SharedPrefs.getDeadline()+">"),
                    onPressed: (){
                     showCupertinoModalPopup(
                         context: context,
                         builder:(BuildContext context){
                           return Center(
                             child: Container(
                                     color: Color(0xffffffff),
                                     height: MediaQuery.of(context).size.height / 3,
                                     child: CupertinoPicker(
                                       itemExtent: 40,
                                       children: _items.map(_pickerItem).toList(),
                                       onSelectedItemChanged: _onSelectedItemChanged,
                                     ),
                                 ),
                           );
                         }
                     );
                    },
                  )
                ],
              ),
            ],
          )
        ),
    );
  }
}
