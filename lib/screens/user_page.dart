import 'package:attendance_app/models/user.dart';
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

  List<User> entries = new List();

  @override
  initState() {
    super.initState();
    _mainReference.onChildAdded.listen(_onUserAdded);
  }

  _onUserAdded(Event e) {
      entries.add(User.fromSnapShot(e.snapshot));
      setState((){});
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: new Text("Firebase Chat")
      ),
      body: Container(
          child: new Column(
            children: <Widget>[
              Expanded(
                child:
                ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemBuilder: (BuildContext context, int index) {
                    return _buildRow(index);
                  },
                  itemCount: entries.length,
                ),
              ),
              Divider(height: 4.0,),
              Container(
                  decoration: BoxDecoration(color: Theme.of(context).cardColor),
                  child: _buildInputArea()
              )
            ],
          )
      ),
    );
  }

  // 投稿されたメッセージの1行を表示するWidgetを生成
  Widget _buildRow(int index) {
    if(entries[index].companyId == "0001"){
      return Card(
          child: ListTile(
              title: Column(
                children: [
                  Text(entries[index].companyId),
                  Text(entries[index].employeeId),
                  Text(entries[index].password)
                ],
              )
          )
      );
    }else{
      return Container();
    }

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
            _mainReference.push().set(User("0002", "1000","aaaa").toJson());
            _textEditController.clear();
            // キーボードを閉じる
            FocusScope.of(context).requestFocus(FocusNode());
          },
        )
      ],
    );
  }
}
