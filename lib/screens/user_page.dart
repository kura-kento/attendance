import 'package:attendance_app/models/user.dart';
import 'package:attendance_app/utils/shared_prefs.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class UserPage extends StatefulWidget {
  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {

  final _stampRef = FirebaseDatabase.instance.reference().child("Stamp");
  final _textEditController = TextEditingController();
  //.add(Duration(days: 1));
  List lists = List();

  Map<String, dynamic> data = {
    "title": "テスト",
    "createdAt": DateTime.now(),
  };
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("${SharedPrefs.getUserMap()['name']}"),
      ),
      body:Column(
        children: [
         FutureBuilder(
              future: _stampRef.orderByChild("uid").equalTo(SharedPrefs.getUserMap()['uid']).once(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if(snapshot.data != null){
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
                            child: Container(
                              height:50,
                              child: Row(
                                children: [
                                  Expanded(
                                    flex:4,
                                    child: Container(

                                      width:50,
                                      child:Text(DateFormat('M/dd').format(DateTime.parse(lists[index]["date1"])),textAlign: TextAlign.center)
                                    ),
                                  ),
                                  Expanded(
                                    flex: 15,
                                    child: Text("出勤: " +lists[index]["date1"]),
                                  ),
                                  Expanded(
                                    flex: 15,
                                    child: Text("退勤: " +lists[index]["date2"]),
                                  ),
                                  Expanded(
                                    flex: 4,
                                    child: Container(
                                        width:50,
                                        child:Text("aa",textAlign: TextAlign.center,)
                                    ),
                                  ),
                                ],

                              ),
                            ),
                          );
                        });
                  }else{
                    return Container(
                      child: Text("データが無い"),
                    );
                  }
                }
                return CircularProgressIndicator();
              },
          ),
          StreamBuilder(
            stream: Firestore.instance.collection("test").snapshots(),
            builder: (context,snapshot){
              if(!snapshot.hasData) return Text("loading");
              return ListView(
                children: [
                  snapshot.data.documents.map(
                        (doc) {
                      return Text(doc.data["title"]);
                    },
                  ).toList(),
                ],
              );
            },
          )
        //  Column(children: fiveDays()),

        ],
      ),
      floatingActionButton: FloatingActionButton(
              onPressed: (){
                setData("test",data);
              },
      ),
    );
  }

//documentの登録
  void setData(String collection, Map data) {
    Firestore.instance.collection(collection).document().setData(data);
    print("テスト");
  }
//更新
  void updateData(String collection, String documentID, Map data) {
    Firestore.instance.collection(collection).document(documentID).updateData(data);
  }
//削除
  void deleteData(String collection, String documentId) {
    Firestore.instance.collection(collection).document(documentId).delete();
  }
  Future<Map<String, dynamic>> getData(String collection, String documentId) async {
    DocumentSnapshot docSnapshot =
    await Firestore.instance.collection(collection).document(documentId).get();

    return docSnapshot.data;
  }
}
