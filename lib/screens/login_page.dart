import 'package:attendance_app/models/user.dart';
import 'package:attendance_app/screens/input_page.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

enum InputForm{
  login,
  admin_create,
  employee_create
}


class LoginPage extends StatefulWidget {

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

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
      appBar: AppBar(),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: Column(
          children: [
            Column(children: loginFormList()),
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
                        return InputPage();
                      },
                    ),
                  );
                  setState(() {});
                },
            ),
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
  loginJudge(){
    var b;
    print( b = entries.where((user) => user.companyId == companyController.text &&
                                       user.employeeId == employeeController.text &&
                                       user.password == password.text));
    if(b.length != 0){
      print("ログインに成功しました。");
    }else{
      print("失敗しました。");
    }
  }
}