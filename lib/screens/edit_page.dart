import 'package:flutter/material.dart';

class EditPage extends StatefulWidget {
  EditPage({Key key, this.documentId,this.documentMap}) : super(key: key);
  final String documentId;
  final Map documentMap;
  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  @override
  void initState() {
    super.initState();
  }


  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.documentMap["date1"].toDate().toString()),
      ),
    );
  }
}

////更新
//  void updateData(String collection, String documentID, Map data) {
//    Firestore.instance.collection(collection).document(documentID).updateData(data);
//  }


