import 'package:attendance_app/main.dart';
import 'package:attendance_app/models/user.dart';
import 'package:attendance_app/utils/shared_prefs.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

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
  TextEditingController password = TextEditingController();

  final _mainReference = FirebaseDatabase.instance.reference().child("Users");
  List<User> entries = List();

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
          child: Column(
            children: [
              Column(children: loginFormList()),
              btnMode(),
            ],
          ),
        )
    );

  }
  List<Widget>loginFormList(){
    List<String> titles = ['会社番号','社員番号','パスワード'];
    List<TextEditingController> controllers = [companyController,employeeController,password];

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
          padding: EdgeInsets.all(8.0),
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
  loginJudge()async{
    var b;
    b = entries.where((user) => user.companyId == companyController.text &&
                                user.employeeId == employeeController.text &&
                                user.password == password.text).toList();
    if(b.length != 0){
      print(b[0].key);
      //hashcodeに変更
      SharedPrefs.setLogin(b[0].key);
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) {
            return MyApp();
          },
        ),
      );
      setState(() {});
    }else{
      print("失敗しました。");
    }
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
              await loginJudge();
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
      print(_cache.key);
      SharedPrefs.setLogin(_cache.key);
    }
  }
}
