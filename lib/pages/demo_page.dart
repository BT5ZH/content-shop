import 'package:flutter/material.dart';

class DemoPage extends StatefulWidget{
  // final int pageIndex;
  // ProfilePage(this.pageIndex);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _DemoPageState();
  }
}

class _DemoPageState extends State<DemoPage>{
final List<ListItem> listData = [];

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
     for (int i = 0; i < 20; i++) {
      listData.add(new ListItem("我是测试标题$i", Icons.cake));
    }
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              expandedHeight: 200.0,
              floating: false,
              pinned: false,
              flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  title: Text("我是一个帅气的标题",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                      )),
                  background: Image.asset('assets/images/episode_1.jpg',
                    fit: BoxFit.fill,
                  )),
            ),
          ];
        },
         body: Center(
          child: new ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              return new ListItemWidget(listData[index]);
            },
            itemCount: listData.length,
          ),
        ),
      ),
    );

  }
  
}

class ListItem {
  final String title;
  final IconData iconData;

  ListItem(this.title, this.iconData);
}

class ListItemWidget extends StatelessWidget {
  final ListItem listItem;

  ListItemWidget(this.listItem);

  @override
  Widget build(BuildContext context) {
    return new InkWell(
      child: new ListTile(
        leading: new Icon(listItem.iconData),
        title: new Text(listItem.title),
      ),
      onTap: () {},
    );
  }
}