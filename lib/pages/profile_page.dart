import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  // final int pageIndex;
  // ProfilePage(this.pageIndex);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ProfilePageState();
  }
}

class _ProfilePageState extends State<ProfilePage> {
  List<Map<String, dynamic>> temp = [];
  List<Widget> temp2 = [Text('测试'), Text('测试2')];
  List<String> temp3 = ['测试2', '测试4'];

  @override
  void initState() {
    // TODO: implement initState
    temp
      ..add({
        'T-Icon': 'Icons.keyboard_arrow_right',
        'title': '自动购买管理',
        'subtitle': '畅读订阅漫画'
      })
      ..add({
        'T-Icon': 'Icons.keyboard_arrow_right',
        'title': '我的订阅记录',
        'subtitle': '订阅的漫画都在这里哦'
      })
      ..add({
        'T-Icon': 'Icons.keyboard_arrow_right',
        'title': '我的消息',
        'subtitle': '没什么好解释的'
      })
      ..add({
        'T-Icon': 'Icons.keyboard_arrow_right',
        'title': '兑换码',
        'subtitle': '没什么好解释的'
      })
      ..add({
        'T-Icon': 'Icons.keyboard_arrow_right',
        'title': '应用中心',
        'subtitle': '没什么好解释的'
      });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
// var dividedWidgetList = ListTile.divideTiles(
//         context: context,
//         tiles: _getListData(),
//         color: Colors.black).toList();

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          color: Colors.grey,
          child: Column(
            children: <Widget>[
              Container(
                color: Color.fromARGB(255, 255, 204, 204),
                child: ClipPath(
                  clipper: _BandImage(),
                  child: new Container(
                    width: MediaQuery.of(context).size.width,
                    // height: MediaQuery.of(context).size.height,
                    height: 180.0,
                    child: Image.asset(
                      'assets/images/episode_1.jpg',
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
              Container(
                color: Color.fromARGB(255, 255, 204, 204),
                child: Row(
                  children: <Widget>[
                    new Expanded(
                      child: new Container(
                        child: FlatButton(
                          padding: EdgeInsets.all(0.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              new Icon(
                                Icons.home,
                                size: 26.0,
                              ),
                              Text('阅读币')
                            ],
                          ),
                          onPressed: () {},
                        ),
                      ),
                      flex: 4,
                    ),
                    new Expanded(
                      child: new Container(
                          alignment: Alignment.center, child: Text('|')),
                      flex: 2,
                    ),
                    new Expanded(
                      child: new Container(
                        child: FlatButton(
                          padding: EdgeInsets.all(0.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              new Icon(
                                Icons.home,
                                size: 26.0,
                              ),
                              Text('交换币')
                            ],
                          ),
                          onPressed: () {},
                        ),
                      ),
                      flex: 4,
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  top: 10.0,
                ),
                padding: EdgeInsets.only(
                  top: 0.0,
                ),
                color: Colors.white,
                height: 50,
                child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      // crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text('充值阅读币'),
                        Text('畅读订阅漫画'),
                        Icon(Icons.keyboard_arrow_right),
                      ],
                    
                ),
              ),

              Container(
                margin: EdgeInsets.only(
                  top: 10.0,
                ),
                padding: EdgeInsets.only(
                  top: 0.0,
                ),
                color: Colors.white,
                height: 200,
                child: ListView.separated(
                  itemCount: 5,
                  itemBuilder: (BuildContext context, int index) {
                    return new Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          // Icon(temp[index]['title']),
                          Text('${temp[index]['title']}'),
                          Text('${temp[index]['subtitle']}'),
                          Icon(Icons.keyboard_arrow_right),
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return new Divider(
                      height: 1.0,
                      color: Colors.blue,
                    );
                  },
                ),
              ),

              Container(
                margin: EdgeInsets.only(
                  top: 10.0,
                ),
                padding: EdgeInsets.only(
                  top: 0.0,
                ),
                color: Colors.white,
                height: 50,
                child:  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text('客服热线'),
                        Text('为您服务'),
                        Icon(Icons.keyboard_arrow_right),
                      ],
                   
                 
                ),
              ),
              // new Container(
              //       height: 200,
              //   child: new ListView(
              //     children: list,
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  // _getListData() {
  //   List<Widget> widgets = [];
  //   for (int i = 0; i < 100; i++) {
  //     widgets.add(new Padding(
  //         padding: new EdgeInsets.all(10.0), child: new Text('Row $i')));
  //   }
  //   return widgets;
  // }
}

class _BandImage extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height);
//     path.quadraticBezierTo(
//         size.width / 2, size.height - 50, size.width, size.height);
//     path.lineTo(size.width, 0);
    path.lineTo(0.0, size.height);
    var firstControlPoint = Offset(size.width / 4, size.height - 30);
    var firstPoint = Offset(size.width / 2, size.height - 30);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstPoint.dx, firstPoint.dy);

    var secondControlPoint =
        Offset(size.width - (size.width / 4), size.height - 30);
    var secondPoint = Offset(size.width, size.height);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondPoint.dx, secondPoint.dy);

    path.lineTo(size.width, 0.0);
    path.fillType = PathFillType.evenOdd;

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
    return false;
  }
}
