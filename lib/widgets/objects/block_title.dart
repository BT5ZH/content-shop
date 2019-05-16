import 'package:flutter/material.dart';

class BlockTitleWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      margin: EdgeInsets.only(top: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('这些作品也值得看一看哦'),
          Image.asset(
            'assets/images/cat_icon.jpg',
            width: 25.0,
            height: 30.0,
          ),
        ],
      ),
    );
  }
}
