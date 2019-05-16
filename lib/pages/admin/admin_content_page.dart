import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../../scoped_model/sc_main.dart';
import '../../widgets/objects/created_content.dart';
import '../../widgets/ui/logout_list_tile.dart';


class AdminContentPage extends StatefulWidget {
  final SCMainModel model;
  AdminContentPage(this.model);
  @override
  State<StatefulWidget> createState() {

    return _AdminContentPage();
  }
}

class _AdminContentPage extends State<AdminContentPage>{

  @override
  initState(){
    if(widget.model.cloudFlag=="FB"){
      widget.model.fetchContents();
    }else if(widget.model.cloudFlag=="AWS"){
      widget.model.fetchContentsAWS();
    }
    
    super.initState();
  }

  Widget _buildSideDrawer(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
           AppBar(
              title: Text('选择视频'),
              automaticallyImplyLeading: false,
            ),
          
          ListTile(
            leading: Icon(Icons.edit),
            title: Text('管理视频'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/admin');
            },
          ),
          Divider(),
          LogoutListTile(),
        ],
      ),
    );
  }


  Widget _buildContentsList(){
    return ScopedModelDescendant(builder:(BuildContext context, Widget child, SCMainModel model){
      Widget content = Center(child: Text('秀自己 '),);
      //displayedContents的使用好像是错的

      if(model.allContents.length>0 && !model.isLoading){
        content = CreatedContentWidget();
      }else if(model.isLoading){
        content = Center(child:CircularProgressIndicator());
      }
      if(model.cloudFlag=="FB"){
        return RefreshIndicator(onRefresh: model.fetchContents,child: content,) ;
      }else if(model.cloudFlag=="AWS"){
        return RefreshIndicator(onRefresh: model.fetchContentsAWS,child: content,) ;
      }

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildSideDrawer(context),
      appBar: AppBar(
      title: Text('创建预览'),
      actions: <Widget>[
        ScopedModelDescendant<SCMainModel>(
          builder: (BuildContext context, Widget widget, SCMainModel model) {
            return IconButton(
              icon: Icon(model.displayFavirotesOnly
                  ? Icons.favorite
                  : Icons.favorite_border),
              color: Colors.white,
              onPressed: () {

                model.toggleDisplayMode();
              },
            );
          },
        ),
      ],
    ),
      body:
          _buildContentsList(),
    );
  }
}
