import 'package:flutter/material.dart';

class StateTag extends StatelessWidget {
  final int flag;
  final int bookIndex;
  final String bookInfo;
  // final String words;
  StateTag(this.flag,this.bookIndex,this.bookInfo);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
                  children: <Widget>[
                    Text(
                      _buildText(flag,bookIndex),
                      style: new TextStyle(
                        color: Colors.black,
                        fontSize: 18.0,
                      ),
                    ),
                    // Container()
                    Row(children: <Widget>[
                      _buildIcon(flag),
                        
                      Text(
                      '$bookInfo',
                      style: new TextStyle(
                        color: Colors.grey,
                        fontSize: 12.0,
                      ),
                    ),
                    ],)
                    
                  ],
                );
  }
  Widget _buildIcon(int flag){
    Widget flagIcon;
    if(flag==0){
      flagIcon=Icon(Icons.refresh,size:14,color: Colors.grey,);
    }else if(flag==1){
      flagIcon=Icon(Icons.remove_red_eye,size:14,color: Colors.grey,);
    }else if(flag==2){
      flagIcon=Icon(Icons.favorite_border,size:14,color: Colors.grey,);
    }
    return flagIcon;
  }

  String _buildText(int flag, int bookIndex){
    String stringText;
    if(flag==0){
      stringText=bookIndex.toString()+"话";
    }else if(flag==1){
      stringText=bookIndex.toString()+"万";
    }else if(flag==2){
      stringText=bookIndex.toString()+"千";
    }
    return stringText;
  }
}