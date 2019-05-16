import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../../scoped_model/sc_main.dart';
import './content_create_page.dart';


class ContentListPage extends StatefulWidget {
  final SCMainModel model;
  ContentListPage(this.model);
  @override
  State<StatefulWidget> createState() {

    return _ContentListPage();
  }
}
class _ContentListPage extends State<ContentListPage>{

  @override
  initState(){
    if(widget.model.cloudFlag=="FB"){
      widget.model.fetchContents(onlyForUser:true,clearExisting: true);
    }else if(widget.model.cloudFlag=="AWS"){
      widget.model.fetchContentsAWS(onlyForUser:true,clearExisting: true);
    }
    super.initState();
  }

  Widget _buildEditButton(
      BuildContext context, int index, SCMainModel model) {
    return IconButton(
      icon: Icon(Icons.edit),
      onPressed: () {
        model.selectContent(model.allContents[index].id);
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) {
              return ContentCreatePage( );
            },
          ),
        ).then((onValue){
          model.selectContent(null);
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<SCMainModel>(
      builder: (BuildContext context, Widget widget, SCMainModel model) {
        return ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            return Dismissible(
              key: Key(model.allContents[index].title),
              onDismissed: (DismissDirection direction) {
                if (direction == DismissDirection.endToStart) {
                  model.selectContent(model.allContents[index].id);
                  if(model.cloudFlag == "FB"){
                    model.deleteContent();
                  }else if(model.cloudFlag == "AWS"){
                    model.deleteContentAWS();
                  }
                } else if (direction == DismissDirection.startToEnd) {
                } else {}
              },
              background: Container(
                color: Colors.red,
              ),
              child: Column(
                children: <Widget>[
                  ListTile(
                      leading: CircleAvatar(
                        backgroundImage:

                            NetworkImage(model.allContents[index].image),
                      ),
                      title: Text(model.allContents[index].title),
                      subtitle:
                          Text('\$${model.allContents[index].price.toString()}'),
                      trailing: _buildEditButton(context, index, model)),
                  Divider(),
                ],
              ),
            );
          },
          itemCount: model.allContents.length,
        );
      },
    );
  }
}
