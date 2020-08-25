import 'package:attendance_app/utils/shared_prefs.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EditPage extends StatefulWidget {
  EditPage({Key key, this.documentId,this.documentMap}) : super(key: key);
  final String documentId;
  final Map documentMap;
  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {

  TextEditingController date1Controller = TextEditingController();
  TextEditingController date2Controller = TextEditingController();
  TextEditingController memoController = TextEditingController();

  @override
  void initState() {
    date1Controller = TextEditingController(text:widget.documentMap["date1"].toDate().toString());
    date2Controller = TextEditingController(text:widget.documentMap["date2"] == null ? "" : widget.documentMap["date2"].toDate().toString());

    super.initState();
  }
  void updateData(String collection, String documentID, Map data) {
    data["date1"] = DateTime.parse(date1Controller.text);
    data["date2"] = DateTime.parse(date2Controller.text);
    data["fix"] = true;
    data["approve"] = false;
    Firestore.instance.collection(collection).document(documentID).updateData(data);
  }


  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      ),
      body:Column(
        children:[
          Text(widget.documentMap["date1"].toDate().toString()),
          Text(widget.documentMap["date2"] == null ? "" : widget.documentMap["date2"].toDate().toString()),
          TextField(
            controller: date1Controller,
          ),
          TextField(
            controller: date2Controller,
          ),
          FlatButton(
            child: Text("保存"),
            onPressed: (){
              updateData(SharedPrefs.getUserMap()["uid"],widget.documentId,widget.documentMap);
              Navigator.pop(context);
            },
          )
        ]
      )
    );
  }
}

////更新
//  void updateData(String collection, String documentID, Map data) {
//    Firestore.instance.collection(collection).document(documentID).updateData(data);
//  }


