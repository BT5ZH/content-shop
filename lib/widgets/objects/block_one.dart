import 'package:flutter/material.dart';
import './block_card.dart';

class BlockOneWidget extends StatelessWidget {
  // final Map<String, dynamic> products_hot;
  // final int _index;
  // BlockWidget(this._index, this.products_hot);
  final List<Map<String,dynamic>> productBlock;
  // List<String> list= ["one", "two", "three", "four"];
  BlockOneWidget(this.productBlock);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(0.0),
      child: _getBlockWidgets(productBlock)
      
    );
  }

  Widget _getBlockWidgets(List<Map<String,dynamic>> xlist)
  {
    List<Widget> list = new List<Widget>();

    for(int i = 0; i < xlist.length; i++){

      if(i<3){
        list.add( BlockCardWidget(xlist[i]));
      }
        
    }
    return new Column(
      
      children: <Widget>[
      new Row(children: list),
      // new Row(children: list2),
    ],);

  }
  
}
