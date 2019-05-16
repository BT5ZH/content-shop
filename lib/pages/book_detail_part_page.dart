import 'package:flutter/material.dart';
import '../widgets/objects/state_tag.dart';
import '../widgets/objects/block_title.dart';
import '../widgets/objects/block_one.dart';

class BookDetailPartPage extends StatefulWidget {
  final Map<String, dynamic> bookIntro;
  final List<Map<String, dynamic>> productRec1;
  // final Map<String,dynamic> bookInfo;
  BookDetailPartPage(this.bookIntro,this.productRec1);

  @override
  State<StatefulWidget> createState() {
    return _BookDetailPartPageState();
  }
}

class _BookDetailPartPageState extends State<BookDetailPartPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 10.0),
            alignment: Alignment.centerLeft,
            child: Text('jkfsdajfka',style: new TextStyle(color: Colors.black,fontSize: 16),),
          ),
          new Divider(
            color: Colors.red,
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                
                StateTag(0,int.parse(widget.bookIntro['current']),'更新至'),
                StateTag(1,int.parse(widget.bookIntro['pageview']),'浏览量'),
                StateTag(2,int.parse(widget.bookIntro['favorite']),'点赞数'),
                
              ],
            ),
          ),
          BlockTitleWidget(),
          BlockOneWidget(widget.productRec1),
        ],
      ),
    );
  }
}
