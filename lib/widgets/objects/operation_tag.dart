import 'package:flutter/material.dart';

class OperationTag extends StatelessWidget {
  final String operation;

  OperationTag(this.operation);
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(left: 5.0,top: 10.0,right: 5.0,bottom: 1.0),
        // padding: EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.5),
        // decoration: BoxDecoration(
        //     color: Theme.of(context).accentColor,
        //     borderRadius: BorderRadius.circular(6.0)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
          margin: EdgeInsets.all(0.0),
          child: Text(
            operation,
            style: new TextStyle(
              color: Colors.blue,
              fontSize: 24.0,
              // fontStyle: FontStyle.italic,
              letterSpacing: 2.0,
              // decoration: TextDecoration.underline
            ),
          ),
        ),
        // SizedBox(
        //   width: 8.0,
        // ),
        Container(
          // alignment: Alignment(1.0,0.0),
          child: Row(
            children: <Widget>[
              Text('换一换'),
              Container(
                child: new Icon(Icons.refresh),
              ),
              Text('|'),
              Text('更多'),
              Container(
                child: new Icon(Icons.arrow_right),
              ),
            ],
          ),
        )
      ],
    ));
  }
}
