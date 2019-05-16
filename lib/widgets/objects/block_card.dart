import 'package:flutter/material.dart';


class BlockCardWidget extends StatelessWidget {
  final Map<String, dynamic> products;
  // final int _index;
  BlockCardWidget(this.products);
  @override
  Widget build(BuildContext context) {
    // String bookId=products['id'];
    return Card(
      margin: EdgeInsets.only(left: 5.0, top: 0.0, right: 5.0, bottom: 1.0),
      child: InkWell(
        onTap: () {
          print(products['image']);
          print(products['id']);
          Navigator.pushReplacementNamed(context, '/bookDetail/'+'${products['id']}');
        },
        child: Column(
          children: <Widget>[
            Container(
              width: 100.0,
              height: 150.0,
              child: Image.asset(products['image']),
            ),
            Text(products['title']),
            Text(products['label']),
          ],
        ),
      ),
    );
  }
}
