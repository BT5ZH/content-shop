import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:map_view/map_view.dart';
import 'package:flutter/services.dart';

// import './scoped_model/sc_contents.dart';
import './scoped_model/sc_main.dart';
import './pages/home_page.dart';
import './pages/admin/admin_page.dart';
import './pages/admin/admin_content_page.dart';
import './pages/bookshelf_page.dart';
import './pages/profile_page.dart';
import './pages/book_introduction_page.dart';
import './pages/admin/content_create_detail_page.dart';
import './pages/auth.dart';
import './models/content.dart';
import './widgets/pocket/custom_route.dart';
import './global/global_config.dart';

void main() {
  debugPaintSizeEnabled = false;
  MapView.setApiKey(apiKey);
  runApp(HomeWidget());
}

class HomeWidget extends StatefulWidget {
  final SCMainModel model = SCMainModel();
  @override
  _HomeWidgetState createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  final _platformChannel=MethodChannel('content-shop.com/battery');
  List<Widget> pages = List<Widget>();
  List<Map<String, dynamic>> _bookInfo = [];
  List<Map<String, dynamic>> _bookState = [];
  List<Map<String, dynamic>> _recOneRow = [];
  SCMainModel scmodel;
  bool _isAuthenticated = false;

  Future<Null> _getBatteryLevel() async{
    String batteryLevel;
    try{
      final int result=await _platformChannel.invokeMethod('getBatteryLevel');
      batteryLevel='电池电量剩余$result %';
    }catch(error){
      batteryLevel='获取电量信息失败';
    }
    print(batteryLevel);
  }

  @override
  void initState() {
    scmodel = widget.model;
    scmodel.autoAuthenticate();
    scmodel.userSubject.listen((bool isAuthenticated) {
      setState(() {
        _isAuthenticated = isAuthenticated;
      });
    });
    _getBatteryLevel();
    _bookInfo
      ..add({
        "id": "001",
        "image": "assets/images/home_pro_1.jpg",
        "title": "最爱你的那十年",
        "label": "情感",
        "introduction": "情感情感情感情感情感情感情感"
      })
      ..add({
        "id": "002",
        "image": "assets/images/home_pro_2.jpg",
        "title": "浴血商后",
        "label": "古风",
        "introduction": "情感情感情感情感情感情感情感"
      })
      ..add({
        "id": "003",
        "image": "assets/images/home_pro_3.jpg",
        "title": "隔墙有男神",
        "label": "豪门",
        "introduction": "情感情感情感情感情感情感情感"
      })
      ..add({
        "id": "004",
        "image": "assets/images/home_pro_4.jpg",
        "title": "金牌助理",
        "label": "纯爱",
        "introduction": "情感情感情感情感情感情感情感"
      })
      ..add({
        "id": "005",
        "image": "assets/images/home_pro_5.jpg",
        "title": "火影忍者",
        "label": "热血",
        "introduction": "情感情感情感情感情感情感情感"
      })
      ..add({
        "id": "006",
        "image": "assets/images/home_pro_6.jpg",
        "title": "灌篮高手",
        "label": "体育",
        "introduction": "情感情感情感情感情感情感情感"
      });
    _bookState
      ..add({
        "id": "001",
        "state": "continue",
        "current": "23",
        "pageview": "12345",
        "favorite": "34"
      })
      ..add({
        "id": "002",
        "state": "continue",
        "current": "23",
        "pageview": "12345",
        "favorite": "34"
      })
      ..add({
        "id": "003",
        "state": "continue",
        "current": "23",
        "pageview": "12345",
        "favorite": "34"
      })
      ..add({
        "id": "004",
        "state": "continue",
        "current": "23",
        "pageview": "12345",
        "favorite": "34"
      })
      ..add({
        "id": "005",
        "state": "continue",
        "current": "23",
        "pageview": "12345",
        "favorite": "34"
      })
      ..add({
        "id": "006",
        "state": "continue",
        "current": "23",
        "pageview": "12345",
        "favorite": "34"
      });
    _recOneRow
      ..add({
        "id": "004",
        "image": "assets/images/home_pro_4.jpg",
        "title": "金牌助理",
        "label": "纯爱",
        "introduction": "情感情感情感情感情感情感情感"
      })
      ..add({
        "id": "005",
        "image": "assets/images/home_pro_5.jpg",
        "title": "火影忍者",
        "label": "热血",
        "introduction": "情感情感情感情感情感情感情感"
      })
      ..add({
        "id": "006",
        "image": "assets/images/home_pro_6.jpg",
        "title": "灌篮高手",
        "label": "体育",
        "introduction": "情感情感情感情感情感情感情感"
      });
    // pages.add(AdminPage(scmodel));
    pages.add(AdminContentPage(scmodel));
    pages.add(HomePage(_bookInfo, _bookState));

    pages.add(BookshelfPage());
    pages.add(ProfilePage());
    super.initState();
  }

  int _selectedIndex = 0;

  // Widget _buildRootEntry() {
  //   // return ScopedModelDescendant<SCMainModel>(
  //   //   builder: (BuildContext context, Widget widget, SCMainModel model) {
  //   return Scaffold(
  //     body: Center(
  //       child: pages[_selectedIndex],
  //     ),
  //     bottomNavigationBar: BottomNavigationBar(
  //       type: BottomNavigationBarType.fixed,
  //       items: <BottomNavigationBarItem>[
  //         BottomNavigationBarItem(icon: Icon(Icons.home), title: Text('首页')),
  //         BottomNavigationBarItem(
  //             icon: Icon(Icons.business), title: Text('抢看')),
  //         BottomNavigationBarItem(icon: Icon(Icons.school), title: Text('书架')),
  //         BottomNavigationBarItem(icon: Icon(Icons.person), title: Text('我')),
  //       ],
  //       currentIndex: _selectedIndex,
  //       fixedColor: Colors.deepPurple,
  //       onTap: _onItemTapped,
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    print('构造主页面');
    print('_isAuthenticated = $_isAuthenticated');
    return ScopedModel<SCMainModel>(
      model: scmodel,
      child: MaterialApp(
        title: '鹿鹿',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        // home: userId==null?AuthPage():_buildRootEntry(context),
        routes: {
          '/': (BuildContext context) =>
              // scmodel.user == null ? AuthPage() : AdminPage(scmodel),
              !_isAuthenticated ? AuthPage() : AdminContentPage(scmodel), //AdminPage(scmodel),//

          '/admin': (BuildContext context) =>
              !_isAuthenticated ? AuthPage() : AdminPage(scmodel),
          // '/admincontent': (BuildContext context) => AdminContentPage(),
          // '/contents': (BuildContext context) => AdminContentPage(scmodel),
        },
        onGenerateRoute: (RouteSettings settings) {
          if (!_isAuthenticated) {
            return MaterialPageRoute<bool>(
                builder: (BuildContext context) => AuthPage());
          }

          final List<String> pathElements = settings.name.split('/');
          if (pathElements[0] != '') {
            return null;
          }
          if (pathElements[1] == 'bookDetail') {
            print(settings.name);
            print(pathElements[2]);

            final int index = int.parse(pathElements[2]) - 1;
            print(_bookInfo[index]['id']);
            return MaterialPageRoute<bool>(
                builder: (BuildContext context) => !_isAuthenticated
                    ? AuthPage()
                    : BookIntroductionPage(
                        _bookInfo[index]['id'], _bookState[index], _recOneRow));
          } else if (pathElements[1] == 'admincontent') {
            // final int index = int.parse(pathElements[2]);
            final String contentId = (pathElements[2]);
            // scmodel.selectContent(contentId);
            final Content content =
                scmodel.allContents.firstWhere((Content content) {
              return content.id == contentId;
            });

            return CustomRoute<bool>(
              builder: (BuildContext context) => !_isAuthenticated
                  ? AuthPage()
                  : ContentCreateDetailPage(content), //contentId
            );
          }
          return null;
        },
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      // login(_formData['email'], _formData['password']);
    });
  }
}
