import 'package:attendance_app/screens/edit_page.dart';
import 'package:attendance_app/utils/shared_prefs.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class UserPage extends StatefulWidget {
  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {

  //.add(Duration(days: 1));
  List lists = List();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("${SharedPrefs.getUserMap()['name']}"),
          //leading: Container(),
      ),
      body: StreamBuilder(
        //管理者の場合は選択した。uidのデータを見れるようにする。
          stream:  Firestore.instance.collection(SharedPrefs.getUserMap()['uid']).orderBy('date1', descending: true).snapshots(),
          builder:(BuildContext context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData) return Text("loading");
              return ListView(
                shrinkWrap: true,
                children: snapshot.data.documents.map<Widget>(
                      (doc) {
                    return InkWell(
                      onTap: () async{
                          await Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) {
                                return EditPage(documentId: doc.documentID,documentMap:doc.data);
                              },
                            ),
                          );
                          setState(() {});
                      },
                      child: Container(
                        height:40,
                        child: Row(
                          children: [
                            Expanded(
                              flex:4,
                              child: Container(
                                  width:50,
                                  child:Text(DateFormat('M/dd').format(doc.data["date1"].toDate()),textAlign: TextAlign.center)
                              ),
                            ),
                            Expanded(
                              flex: 15,
                              child: Text("出勤: " + DateFormat('M月dd日 HH:mm').format(doc.data["date1"].toDate())),
                            ),
                            Expanded(
                              flex: 15,
                              child: Text("退勤: "+ (doc.data["date2"] == null ? "null":DateFormat('M月dd日 HH:mm').format(doc.data["date2"].toDate()))),
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
                  },
                ).toList(),
              );
            },
      ),
      floatingActionButton: FloatingActionButton(
              onPressed: (){
              },
      ),
    );
  }

////documentの登録
//  void setData(String collection, Map data) {
//    Firestore.instance.collection(collection).document().setData(data);
//  }
////更新
//  void updateData(String collection, String documentID, Map data) {
//    Firestore.instance.collection(collection).document(documentID).updateData(data);
//  }
////削除
//  void deleteData(String collection, String documentId) {
//    Firestore.instance.collection(collection).document(documentId).delete();
//  }
  Future<Map<String, dynamic>> getData(String collection, String documentId) async {
    DocumentSnapshot docSnapshot =
    await Firestore.instance.collection(collection).document(documentId).get();

    return docSnapshot.data;
  }
}
