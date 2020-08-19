import 'dart:convert';

import 'package:attendance_app/models/user.dart';
import 'package:attendance_app/screens/home.dart';
import 'package:attendance_app/utils/shared_prefs.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'input_page.dart';

class LoginPage extends StatefulWidget {

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  TextEditingController companyController = TextEditingController();
  TextEditingController employeeController = TextEditingController();

  final _mainReference = FirebaseDatabase.instance.reference().child("Users");
  List<User> entries = List();

  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  initState() {
    super.initState();
    _mainReference.onChildAdded.listen(_onUserAdded);
  }

  _onUserAdded(Event e) {
    entries.add(User.fromSnapShot(e.snapshot));
    setState((){});
  }

  Future<FirebaseUser> _handleSignIn() async {
    GoogleSignInAccount googleCurrentUser = _googleSignIn.currentUser;
    try {
      if (googleCurrentUser == null) googleCurrentUser = await _googleSignIn.signInSilently();
      if (googleCurrentUser == null) googleCurrentUser = await _googleSignIn.signIn();
      if (googleCurrentUser == null) return null;

      GoogleSignInAuthentication googleAuth = await googleCurrentUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final FirebaseUser user = (await _auth.signInWithCredential(credential)).user;
      print("ログイン中： " + user.uid);

//      SharedPrefs.setUser([user.displayName,user.email,user.photoUrl]);
      return user;
    } catch (e) {
      print(e);
      return null;
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ログイン画面"+SharedPrefs.getLogin()),
      ),
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RaisedButton(
                child: Text('ログイン'),
                onPressed: () {
                  _handleSignIn()
                      .then((FirebaseUser user) =>
                      signIn(user)
                  )
                      .catchError((e) => print(e));
                },
              ),
            ]
        ),
      ),
    );
  }

  signIn(userData)async{
    var userSearch;
    userSearch = entries.where((user) => user.uid == userData.uid).toList();

      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) {
              if(userSearch.length != 0){
        //      _basicsFlash(duration: Duration(seconds: 2),text: "ログインに成功しました。");
                //0：会社番号、１：社員番号、2：名前、３：uid番号、４：管理者区分
             // SharedPrefs.setUser([userSearch[0].companyId,userSearch[0].employeeId,userSearch[0].name,userSearch[0].uid,userSearch[0].division.toString()]);

              SharedPrefs.setUserMap(
                json.encode({
                  'companyId': userSearch[0].companyId,
                  'employeeId': userSearch[0].employeeId,
                  'name': userSearch[0].name,
                  'uid': userSearch[0].uid,
                  'division': userSearch[0].division,
                })
              );

            return HomePage();
              }else {
                print("失敗しました。");
                return InputPage(uid: userData.uid);
              }
          },
        ),
      );
      setState(() {});
    //  _basicsFlash(duration: Duration(seconds: 2),text: "ログインに失敗しました。");
    }
}
