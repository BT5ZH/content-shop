import 'package:flutter/material.dart';
import './book_detail_part_page.dart';
import './book_detail_list_page.dart';


class BookIntroductionPage extends StatefulWidget {
  final String bookId;
  final Map<String, dynamic> bookIntro;
  final List<Map<String, dynamic>> recOneRow;
  BookIntroductionPage(this.bookId, this.bookIntro, this.recOneRow);
  int tabIndex = 0;
  @override
  State<StatefulWidget> createState() {
    return _BookIntroductionPageState();
  }
}

// Text('书架' + '${widget.bookId}')
class _BookIntroductionPageState extends State<BookIntroductionPage> {
  List<Map<String,dynamic>> episodelist=[];
  @override
  void initState() {
    episodelist
      ..add({"episode_index":"1","episode_image":"assets/images/episode_1.jpg","episode_name":"丰盛的晚餐","episode_post_time":"2019-02-03","epsisode_favirote_count":"1234"})
      ..add({"episode_index":"2","episode_image":"assets/images/episode_1.jpg","episode_name":"丰盛的晚餐","episode_post_time":"2019-02-03","epsisode_favirote_count":"1234"})
      ..add({"episode_index":"3","episode_image":"assets/images/episode_1.jpg","episode_name":"丰盛的晚餐","episode_post_time":"2019-02-03","epsisode_favirote_count":"1234"})
      ..add({"episode_index":"4","episode_image":"assets/images/episode_1.jpg","episode_name":"丰盛的晚餐","episode_post_time":"2019-02-03","epsisode_favirote_count":"1234"});

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    // Widget temp;

    return Scaffold(
      appBar: AppBar(
          title: Center(
        child: Text('漫画章节'),
      )),
      body:
          SingleChildScrollView(
                child:
          Column(
        children: <Widget>[
          // SingleChildScrollView(
          //   child:
          // Column(
          //   children: <Widget>[
          Container(
            child: new Stack(
              alignment: AlignmentDirectional.topStart,
              children: <Widget>[
                new Opacity(
                  opacity: 0.8, //不透明度
                  child: new Container(
                    width: MediaQuery.of(context).size.width,
                    height: 180.0,
                    color: Colors.blue,
                  ),
                ),
                new Align(
                  alignment: Alignment(-0.8, 0.5),
                  child: Container(
                    child: Image.asset(
                      'assets/images/home_pro_1.jpg',
                      fit: BoxFit.fill,
                    ),
                    width: 120.0,
                    height: 180.0,
                  ),
                ),
                new Align(
                  alignment: Alignment(0.6, 0.1),
                  child: Container(
                    width: MediaQuery.of(context).size.width / 2,
                    child: Text(
                      '最爱你的那十年',
                      style: new TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          letterSpacing: 1.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                new Align(
                  alignment: Alignment(0.6, 0.4),
                  child: Container(
                      width: MediaQuery.of(context).size.width / 2,
                      // height: 100.0,
                      // alignment: AlignmentDirectional(-0.8, -0.2),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Text(
                            '类别: ',
                            style: new TextStyle(
                              color: Colors.white,
                              fontSize: 14.0,
                            ),
                          ),
                          Padding(
                            padding: new EdgeInsets.only(left: 8.0, right: 8.0),
                            child: Text(
                              '言情',
                              style: new TextStyle(
                                color: Colors.white,
                                fontSize: 14.0,
                              ),
                            ),
                          ),
                          Text(
                            '都市',
                            style: new TextStyle(
                              color: Colors.white,
                              fontSize: 14.0,
                            ),
                          ),
                        ],
                      )),
                ),
              ],
            ),
            width: MediaQuery.of(context).size.width,
            // height: MediaQuery.of(context).size.height / 2,
            height: 200.0,
          ),

          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                FlatButton(
                  child: Text(
                    '详情',
                  ),
                  onPressed: () {
                    setState(() {
                      widget.tabIndex = 0;
                    });
                  },
                ),
                FlatButton(
                  child: Text('选集'),
                  onPressed: () {
                    setState(() {
                      widget.tabIndex = 1;
                    });
                  },
                )
              ],
            ),
          ),

          // Expanded(
          //   child: 
          //   SingleChildScrollView(
          //       child:
            _buildContainer(widget.tabIndex),
          //   ),
          // ),
        ],
      ),
),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          children: <Widget>[
            new Expanded(
              child: new Container(
                  child: Row(
                children: <Widget>[
                  new Icon(
                    Icons.favorite_border,
                    size: 22.0,
                  ),
                  Text('收藏'),
                ],
              )

                  // color: Colors.red,
                  ),
              flex: 2,
            ),
            new Expanded(
              child: new Container(
                  child: Row(
                children: <Widget>[
                  new Icon(
                    Icons.thumb_up,
                    size: 22.0,
                  ),
                  Text('点赞数')
                ],
              )
                  ),
              flex: 2,
            ),
            new Expanded(
              child: new Container(
                  child: 
                  FlatButton(
                    padding: EdgeInsets.all(0.0),
                    child: Row(
                children: <Widget>[
                  new Icon(
                    Icons.home,
                    size: 26.0,
                  ),
                  Text('返回')
                ],
              ),
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/');
                    },
                  ),
                  
                  ),
              flex: 2,
            ),
            new Expanded(
              child: Container(
                child: new Material(
                  borderRadius: BorderRadius.circular(20.0),
                  color: Colors.red,
                  shadowColor: Colors.blue.shade100,
                  elevation: 5.0,
                  child: new MaterialButton(
                    // color: Colors.red,
                    child: Text('继续阅读'),
                    onPressed: () {},
                  ),
                ),
              ),
              flex: 3,
            ),
          ],
        ),
      ),

      // Center(
      //   child: Text('书架'+'${widget.bookId}'),
      // ),
    );
  }

  Widget _buildContainer(int flagIndex) {
    Widget introductionContainer;
    if (flagIndex == 0) {
      introductionContainer =
          BookDetailPartPage(widget.bookIntro, widget.recOneRow);
      // ListView(
      //     children:<Widget>[
      //       BookDetailPartPage(widget.bookIntro, widget.recOneRow),
      //     ],);
      // : BookDetailPartPage(widget.bookIntro, widget.recOneRow));
    } else {
      introductionContainer = Container(child: BookDetailListPage(23,episodelist));
    }

    return introductionContainer;
  }
}
