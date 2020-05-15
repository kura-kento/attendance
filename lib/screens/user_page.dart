import 'package:attendance_app/models/user.dart';
import 'package:attendance_app/utils/shared_prefs.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserPage extends StatefulWidget {
  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {

  final _mainReference = FirebaseDatabase.instance.reference().child("Users");
  final _textEditController = TextEditingController();

  List lists = List();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: new Text("Firebase Chat")
      ),
      body:
          FutureBuilder(
            future: _mainReference.orderByKey().equalTo(SharedPrefs.getLogin()).once(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                lists.clear();
                Map<dynamic, dynamic> values = snapshot.data.value;
                values.forEach((key, values) {
                  lists.add(values);
                });
                return new ListView.builder(
                    shrinkWrap: true,
                    itemCount: lists.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text("社員番号: "+ lists[index]["employeeId"]),
                            Text("パスワード: " +lists[index]["password"]),
                            Text((lists[index]["employeeId"] == User("0001","1000","aaaa").employeeId) ? "yes":"no")
                          ],
                        ),
                      );
                    });
              }
              return CircularProgressIndicator();
            },
          )

    );
  }

  // 投稿メッセージの入力部分のWidgetを生成
  Widget _buildInputArea() {
    return Row(
      children: <Widget>[
        SizedBox(width: 16.0,),
        Expanded(
          child: TextField(
            controller: _textEditController,
          ),
        ),
        CupertinoButton(
          child: Text("Send"),
          onPressed: () {
            _mainReference.push().set(User("0001", "1000","aaaa").toJson());
            _textEditController.clear();
            // キーボードを閉じる
            FocusScope.of(context).requestFocus(FocusNode());
          },
        )
      ],
    );
  }
}
