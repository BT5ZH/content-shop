import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../scoped_model/sc_main.dart';

class LogoutListTile extends StatelessWidget{
  @override
  Widget build(BuildContext context) {

    return ScopedModelDescendant(builder: (BuildContext context, Widget widget, SCMainModel model){
      return ListTile(
        leading: Icon(Icons.exit_to_app),
        title: Text('退出'),
        onTap: (){
          model.logout();
          // Navigator.of(context).pushReplacementNamed('/');
        },
      );
    },);
  }
}