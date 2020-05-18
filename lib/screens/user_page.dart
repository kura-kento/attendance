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

  final _stampRef = FirebaseDatabase.instance.reference().child("Stamp");
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
            future: _stampRef.orderByChild("uid").equalTo("2wobWLNHvhQRgphaMcCIwqnCYaL2").once(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                lists.clear();
                Map<dynamic, dynamic> values = snapshot.data.value;
                values.forEach((key, values) {
                  lists.add(values);
                });
                return ListView.builder(
                    shrinkWrap: true,
                    itemCount: lists.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text("${SharedPrefs.getUser()[3]}: "+ lists[index]["uid"]),
                            Text("パスワード: " +lists[index]["date"]),
                            Text((lists[index]["division"] == 0) ? "出勤":"退勤")
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
           // _stampRef.push().set(User("0001", "1000","aaaa","vvvv",1).toJson());
            _textEditController.clear();
            // キーボードを閉じる
            FocusScope.of(context).requestFocus(FocusNode());
          },
        )
      ],
    );
  }
}
