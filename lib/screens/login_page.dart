import 'package:attendance_app/models/user.dart';
import 'package:attendance_app/screens/qr_scan.dart';
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

  void transitionNextPage(FirebaseUser user) {
    if (user == null) return;
    Navigator.push(context, MaterialPageRoute(builder: (context) =>
        NextPage()
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ログイン画面"),
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

  signIn(uid)async{
    var userSearch;
    userSearch = entries.where((user) => user.uid == uid.uid).toList();

      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) {
              if(userSearch.length != 0){
        //      _basicsFlash(duration: Duration(seconds: 2),text: "ログインに成功しました。");
        //      SharedPrefs.setLogin(userSearch[0].key);
                return QrScan();
              }else {
                print("失敗しました。");
                return InputPage(inputMode: InputMode.employee, uid: uid.uid);
              }
          },
        ),
      );
      setState(() {});
    //  _basicsFlash(duration: Duration(seconds: 2),text: "ログインに失敗しました。");
    }

}

class NextPage extends StatefulWidget {

  @override
  _NextPageState createState() => _NextPageState();
}

class _NextPageState extends State<NextPage> {


  Future<void> _handleSignOut() async {
    await FirebaseAuth.instance.signOut();
    try {
      await GoogleSignIn().signOut();
    } catch (e) {
      print(e);
    }
    SharedPrefs.setUser([]);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ユーザー情報表示"),
      ),
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.network(SharedPrefs.getUser()[2]),
              Text(SharedPrefs.getUser()[0],
                style: TextStyle(
                  fontSize: 24,
                ),
              ),
              Text(SharedPrefs.getUser()[1],
                style: TextStyle(
                  fontSize: 24,
                ),
              ),
              RaisedButton(
                child: Text('ログアウト'),
                onPressed: () {
                  _handleSignOut().catchError((e) => print(e));
                },
              ),
            ]),
      ),
    );
  }
}