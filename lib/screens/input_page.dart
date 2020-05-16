import 'package:attendance_app/main.dart';
import 'package:attendance_app/models/user.dart';
import 'package:attendance_app/screens/qr_scan.dart';
import 'package:attendance_app/utils/shared_prefs.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

enum InputMode{
  login,
  admin_create,
  employee_create
}


class InputPage extends StatefulWidget {

  InputPage({Key key, this.inputMode}) : super(key: key);

  final InputMode inputMode;

  @override
  _InputPageState createState() => _InputPageState();
}

class _InputPageState extends State<InputPage> {

  TextEditingController companyController = TextEditingController();
  TextEditingController employeeController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController password = TextEditingController();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  FirebaseUser user;

  final _mainReference = FirebaseDatabase.instance.reference().child("Users");
  List<User> entries = List();

  final storage = new FlutterSecureStorage();

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
          title: Text(widget.inputMode == InputMode.login ? "ログイン": "それ以外"),
        ),
        body: GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(height: 50,),
                Column(children: loginFormList()),
                btnMode(),
              ],
            ),
          ),
        ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
            register();
        },
      ),
    );

  }
  Future<void> register()async{
    final FirebaseUser user = (await _firebaseAuth.createUserWithEmailAndPassword(
    email: 'an email',
    password: 'a password',
    ))
    .user;
  }

  List<Widget>loginFormList(){
    List<String> titles = ['会社番号','メールアドレス','パスワード'];
    List<TextEditingController> controllers = [companyController,emailController,password];

    List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    for(int i=0;i < titles.length ;i++){
      mapList.add({
        "title" : titles[i],
        "controller" : TextEditingController()
      });
    }
    TextStyle textStyle = Theme.of(context).textTheme.title;

    List<Widget> _cache = <Widget>[];
    for(int i = 0;i<titles.length;i++){
      _cache.add(
        Padding(
          padding: EdgeInsets.only(top: 10.0, right: 40.0, bottom: 10.0, left: 40.0),
          child: TextField(
            controller: controllers[i],
            style: textStyle,
            decoration: InputDecoration(
                labelText: titles[i],
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0)
                )
            ),
          ),
        ),
      );
    }
    return _cache;
  }
//  signIn()async{
//    var userSearch;
//    userSearch = entries.where((user) => user.companyId == companyController.text &&
//                                user.employeeId == employeeController.text &&
//                                user.password == password.text).toList();
//    if(userSearch.length != 0){
////      _basicsFlash(duration: Duration(seconds: 2),text: "ログインに成功しました。");
//      SharedPrefs.setLogin(userSearch[0].key);
//      await Navigator.of(context).push(
//        MaterialPageRoute(
//          builder: (context) {
//            return QrScan();
//          },
//        ),
//      );
//      setState(() {});
//    }else{
//      print("失敗しました。");
//      _basicsFlash(duration: Duration(seconds: 2),text: "ログインに失敗しました。");
//    }
//  }
  Future<AuthResult> signIn(String email, String password) async {
    final AuthResult result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    print("User id is ${result.user.uid}");
    return result;
  }

  Widget btnMode(){

    if(widget.inputMode == InputMode.login){
      return Column(
        children: [
          InkWell(
            child:Container(
                height: 50,
                child: Center(child:Text("ログイン"))),
            onTap: ()async{
              await signIn(emailController.text,password.text);
              setState(() {});
            },
          ),
          InkWell(
            child:Container(
                height: 50,
                child: Center(child:Text("管理者用"))),
            onTap: () async{
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return InputPage(inputMode: InputMode.admin_create);
                  },
                ),
              );
              setState(() {});
            },
          ),
        ],
      );
    }else if(widget.inputMode == InputMode.admin_create){
      return InkWell(
        child:Container(
            height: 50,
            child: Center(child:Text("新規登録"))),
        onTap: ()async{
          await save();
          setState(() {});
        },
      );
    }else{
      return InkWell(
        child:Container(
            height: 50,
            child: Center(child:Text("社員追加"))),
        onTap: ()async{
          await save();
          setState(() {});
        },
      );
    }

  }
  save(){
    var _cache;
    _cache = _mainReference.push().set(User(companyController.text, employeeController.text,password.text).toJson());
  //  _textEditController.clear();
    FocusScope.of(context).requestFocus(FocusNode());
    if(widget.inputMode == InputMode.admin_create){
      //ログイン状態いじ
      SharedPrefs.setLogin(_cache.key);
    }
  }

  void _basicsFlash({
    Duration duration,
    String text,
    flashStyle = FlashStyle.floating,
  }) {
    showFlash(
      context: context,
      duration: duration,
      builder: (context, controller) {
        return Flash(
          controller: controller,
          style: flashStyle,
          boxShadows: kElevationToShadow[4],
          horizontalDismissDirection: HorizontalDismissDirection.horizontal,
          child: FlashBar(
            message: Text(text),
          ),
        );
      },
    );
  }
}
