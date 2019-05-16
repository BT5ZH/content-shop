import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';


import '../widgets/objects/operation_tag.dart';
import '../widgets/objects/block_two.dart';


class HomePage extends StatefulWidget {
  final List<Map<String,dynamic>> _bookInfomation;
  final List<Map<String,dynamic>> _bookIntroduction;
  // final int pageIndex;
  HomePage(this._bookInfomation,this._bookIntroduction);
  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {

  List<Widget> imageList = List();
  // List<Widget> productBlock = List<Widget>();
  List<Map<String,dynamic>> productBlock = List<Map<String,dynamic>>();
  List<Map<String,dynamic>> productIntroduction = List<Map<String,dynamic>>();


  @override
  void initState() {

    productBlock=widget._bookInfomation;
    productIntroduction=widget._bookIntroduction;
    imageList
      ..add(Image.asset(
        'assets/images/home_band.jpg',
        fit: BoxFit.fill,
      ))
      ..add(Image.asset(
        'assets/images/home_band2.jpg',
        fit: BoxFit.fill,
      ))
      ..add(Image.asset(
        'assets/images/home_band3.jpg',
        fit: BoxFit.fill,
      ))
      ..add(Image.asset(
        'assets/images/home_band.jpg',
        fit: BoxFit.fill,
      ))
      ..add(Image.asset(
        'assets/images/home_band2.jpg',
        fit: BoxFit.fill,
      ));

     
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              child: Swiper(
                itemBuilder: _swiperBuilder,
                itemCount: 5,
                pagination: new SwiperPagination(
                    builder: DotSwiperPaginationBuilder(
                        color: Colors.black54, activeColor: Colors.white)),
                // control: new SwiperControl(
                //     iconPrevious: Icons.arrow_back_ios,
                //     iconNext: Icons.arrow_forward_ios,
                //     color: Colors.blueGrey),
                scrollDirection: Axis.horizontal,
                autoplay: true,
                onTap: (index) => print('$index'),
              ),
              width: MediaQuery.of(context).size.width,
              height: 200.0,
            ),

            Row(
              children: <Widget>[
                Container(
                    child: new Material(
                  borderRadius: BorderRadius.circular(20.0),
                  shadowColor: Colors.blue.shade100,
                  elevation: 5.0,
                  child: new MaterialButton(
                    child: Image.asset('assets/images/home_page_huodong.png'),
                    onPressed: () {},
                  ),
                ),),
                Container(
                    child: new Material(
                  borderRadius: BorderRadius.circular(20.0),
                  shadowColor: Colors.blue.shade100,
                  elevation: 5.0,
                  child: new MaterialButton(
                    onPressed: () {},
                    child: Image.asset('assets/images/home_page_paihang.png'),
                  ),
                )),
              ],
              mainAxisAlignment: MainAxisAlignment.center,
            ),

            
            Container(
              margin: EdgeInsets.all(10.0),
              child: Column(
                children: <Widget>[
                  
                  OperationTag('精彩推荐'),
                  BlockTwoWidget(productBlock,),
                  
                ],
              ),
            ),
            
          ],
        ),),
      ),
    );
  }

  Widget _swiperBuilder(BuildContext context, int index) {
    return (imageList[index]);
  }
  
}
