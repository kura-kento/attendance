import 'package:attendance_app/utils/shared_prefs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';

class ApplyPage extends StatefulWidget {
  @override
  _ApplyPageState createState() => _ApplyPageState();
}

class _ApplyPageState extends State<ApplyPage> {

  TextEditingController dateController = TextEditingController();
  TextEditingController time1Controller = TextEditingController();
  TextEditingController time2Controller = TextEditingController();
  TextEditingController memoController = TextEditingController();

  List<String>_items = ["休暇申請","残業申請"];
  String itemName = "休暇申請";

  DateTime _time1Text = DateTime(2020,2,1,0,0);
  DateTime _time2Text = DateTime(2020,2,1,0,0);
  int _breakTime = SharedPrefs.getUserMap()["breakTime"];

  bool _lights = true;
  Widget _pickerItem(String str){
    return Text(
        str,
        style : TextStyle(fontSize: 32)
    );
  }

  String _labelText = "なし";

  void _onSelectedItemChanged(int index){
    itemName = _items[index];
    setState(() {});
  }

  @override
  void initState() {
    memoController = TextEditingController(text: _breakTime.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
      ),
      body: Container(
      child:Column(
        children: [
          FlatButton(
            child: Text(itemName+">"),
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
          ),

          Row(
            children: [
              Container(
                width: 80,
                child: Center(
                  child: Text("日付",
                    style: TextStyle(fontSize: 18)),
                ),
              ),
              IconButton(
                icon: Icon(Icons.date_range),
                onPressed: () => _selectDate(context),
              ),
              Text(_labelText,
                  style: TextStyle(fontSize: 18)),
            ],
          ),

          timeWidget("出勤時間",0),
          timeWidget("退勤時間",1),
          Row(
            children: [
              Container(
                width: 80,
                child: Center(
                  child: Text("休憩時間",
                      style: TextStyle(fontSize: 18)),
                ),
              ),
              Container(
                width: 80,
                child: TextField(
                  controller: memoController,
                ),
              ),
              Container(
                width: 80,
                child: Center(
                  child: Text("分",
                      style: TextStyle(fontSize: 18)),
                ),
              ),
            ],
          ),
          MergeSemantics(
            child: ListTile(
              title: Text('有給'),
              trailing: CupertinoSwitch(
                value: _lights,
                onChanged: (bool value) { setState(() { _lights = value; }); },
              ),
              onTap: () { setState(() { _lights = !_lights; }); },
            ),
          ),
          FlatButton(
            child: Text("保存"),
            onPressed: (){
             // Navigator.pop(context);
            },
          )
        ],
      )
      ),
    );
  }
  Future<void> _selectDate(BuildContext context) async {
    final DateTime selected = await showDatePicker(
      locale: const Locale("ja"),
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(DateTime.now().year - 1),
      lastDate: DateTime(DateTime.now().year + 1),
    );
    if (selected != null) {
      _labelText = DateFormat("yyyy年M月dd日").format(selected);
      setState(() {});
    }
  }

  Widget timeWidget(String title, index){
   return Row(
        children: [
          Container(
            width:80,
            child: Text(title,
                style: TextStyle(fontSize: 18)),
          ),
          InkWell(
            child:Text(DateFormat("HH:mm").format(index==0? _time1Text:_time2Text),
                style: TextStyle(fontSize: 18)
            ),
            onTap: (){
              showCupertinoModalPopup(
                context: context,
                builder: (BuildContext context) {
                  return StatefulBuilder(
                      builder: (context, setState1) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Container(
                              decoration: BoxDecoration(
                                color: Color(0xffffffff),
                                border: Border(
                                  bottom: BorderSide(
                                    color: Color(0xff999999),
                                    width: 0.0,
                                  ),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Container(),
                                  CupertinoButton(
                                    child: Text('決定', style: TextStyle(color: Colors.cyan),),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0,
                                      vertical: 5.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              color: Color(0xffffffff),
                              height: MediaQuery.of(context).size.height / 3,
                              child:
                              SizedBox(
                                  height: 200,
                                  child: CupertinoDatePicker(
                                    mode: CupertinoDatePickerMode.time,
                                    initialDateTime: (index == 0? _time1Text : _time2Text),
                                    use24hFormat: true,
                                    onDateTimeChanged: (DateTime newDateTime) {
                                      index == 0 ? _time1Text = newDateTime : _time2Text = newDateTime;
                                      setState(() {});
                                    },
                                  )
                              ),

                            ),
                          ],
                        );
                      }
                  );
                },
              );
            },
          ),
        ],
    );
  }
}


