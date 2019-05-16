import 'package:flutter/material.dart';

class BookshelfPage extends StatefulWidget{
  // final int pageIndex;
  // BookselfPage(this.pageIndex);
  @override
  State<StatefulWidget> createState() {

    return _BookshelfPageState();
  }
}

class _BookshelfPageState extends State<BookshelfPage>{
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
          title: Center(
        child: Text('书架'),
      )),
      body: Center(
        child: Text('书架'),
      ),
    
    );
  }
  
}