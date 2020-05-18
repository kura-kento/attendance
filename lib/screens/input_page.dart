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
  admin,
  employee
}


class InputPage extends StatefulWidget {

  InputPage({Key key, this.inputMode,this.uid}) : super(key: key);

  final InputMode inputMode;
  final String uid;

  @override
  _InputPageState createState() => _InputPageState();
}

class _InputPageState extends State<InputPage> {

  TextEditingController companyController = TextEditingController();
  TextEditingController employeeController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController adminController = TextEditingController();

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
          title: Text(widget.inputMode == InputMode.employee ? "ログイン": "それ以外"),
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
    List<String> titles = ['会社番号','社員番号',"名前","管理者区分"];
    List<TextEditingController> controllers = [companyController,employeeController,nameController,adminController];

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
            keyboardType: (i == 3)? TextInputType.number : TextInputType.text ,
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

  Widget btnMode(){

    if(widget.inputMode == InputMode.employee){
      return Column(
        children: [
          InkWell(
            child:Container(
                height: 50,
                child: Center(child:Text("登録"))),
            onTap: () async{
              await save();
              Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                   return QrScan();
                    }
                  )
              );
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
                    return InputPage(inputMode: InputMode.admin);
                  },
                ),
              );
              setState(() {});
            },
          ),
        ],
      );
    }else if(widget.inputMode == InputMode.admin){
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
    _mainReference.push().set(User(companyController.text, employeeController.text,nameController.text,widget.uid,int.parse(adminController.text)).toJson());
    FocusScope.of(context).requestFocus(FocusNode());
    SharedPrefs.setUser([companyController.text, employeeController.text,nameController.text,widget.uid,adminController.text]);
      //ログイン状態いじ
    SharedPrefs.setLogin(widget.uid);
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
