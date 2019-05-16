import 'package:flutter/material.dart';

import '../../scoped_model/sc_main.dart';
import './content_create_page.dart';
import './content_list_page.dart';
import '../../widgets/ui/logout_list_tile.dart';

class AdminPage extends StatelessWidget {
  final SCMainModel scMainModel;
  AdminPage(this.scMainModel);
  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text('选择'),
            automaticallyImplyLeading: false,
          ),
          ListTile(
            leading: Icon(Icons.shop),
            title: Text('所有视频'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/');// /contents
            },
          ),
          Divider(),
          LogoutListTile(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    
      
      return DefaultTabController(
        length: 2,
        child: Scaffold(
            drawer: _buildDrawer(context),
            appBar: AppBar(
          title: Text('管理'),
          bottom: TabBar(
            tabs: <Widget>[
              Tab(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[Icon(Icons.create), Text('创建内容')],
            ),
              ),
              Tab(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[Icon(Icons.list), Text('我的内容')],
            ),
              ),
            ],
          ),
        ),
            body: TabBarView(
              children: <Widget>[ContentCreatePage(), ContentListPage(scMainModel)],
            )),
      );
    
  }
}
