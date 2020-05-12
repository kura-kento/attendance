import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  TextEditingController companyController = TextEditingController();
  TextEditingController employeeController = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: Column(children: loginFormList()),
      )
    );

  }
  List<Widget>loginFormList(){
    List<String> titles = ['会社番号','社員番号','パスワード'];

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
        TextField(
          controller: mapList[i]["controller"],
          style: textStyle,
          decoration: InputDecoration(
              labelText: mapList[i]["title"],
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0)
              )
          ),
        ),
      );
    }
    return _cache;
  }
}