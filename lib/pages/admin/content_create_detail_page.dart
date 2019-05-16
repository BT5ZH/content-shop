import 'dart:async';

import 'package:flutter/material.dart';
import 'package:map_view/map_view.dart';

import '../../models/content.dart';
import '../../widgets/objects/content_fab.dart';
import '../../widgets/ui/title_default.dart';
import '../../widgets/tags/address_tag.dart';

class ContentCreateDetailPage extends StatelessWidget {
  // final int contentIndex;
  // final String contentId;
  // ContentCreateDetailPage(this.contentId);

  final Content content;
  ContentCreateDetailPage(this.content);

  // _showWarningDialog(BuildContext context) {
  //   showDialog(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return AlertDialog(
  //           title: Text('确定删除'),
  //           content: Text('删除后数据不能被恢复'),
  //           actions: <Widget>[
  //             FlatButton(
  //               child: Text('放弃'),
  //               onPressed: () {
  //                 Navigator.pop(context);
  //               },
  //             ),
  //             FlatButton(
  //               child: Text('继续'),
  //               onPressed: () {
  //                 Navigator.pop(context);
  //                 Navigator.pop(context, true);
  //               },
  //             )
  //           ],
  //         );
  //       });
  // }

  void _showMap() {
    final List<Marker> markers = <Marker>[Marker(
        'id', 'title', content.location.latitude, content.location.longitude)];
    
    final mapview = MapView();
    final cp = CameraPosition(
        Location(content.location.latitude, content.location.longitude), 14.0);
    mapview.show(
        MapOptions(
            initialCameraPosition: cp,
            mapViewType: MapViewType.normal,
            title: '主人打卡地'),
        toolbarActions: [ToolbarAction('关闭', 1)]);
    mapview.onToolbarAction.listen((int id){
      if(id==1){
        mapview.dismiss();
      }
    });
    mapview.onMapReady.listen((_){
      mapview.setMarkers(markers);
    });
  }

  Widget _buildAddressPriceRow(String address, double price) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        // Text('on the detail page'),
        GestureDetector(
          child: AddressTag(address),
          onTap: _showMap,
        ),

        Container(
          child: Text('|', style: TextStyle(color: Colors.grey)),
        ),
        Text(
          '\$' + price.toString(),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        print('button is pressed!');
        Navigator.pop(context, false);
        return Future.value(false);
      },
      child: Scaffold(
        // appBar: AppBar(
        //   title: Text(content.title),
        // ),
        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              expandedHeight: 250.0,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(content.title),
                background: Hero(
                  tag: content.id,
                  child: FadeInImage(
                    image: NetworkImage(content.image),
                    height: 200,
                    fit: BoxFit.cover,
                    placeholder: AssetImage('assets/images/placeholder1.png'),
                  ),
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(10.0),
                    child: TitleDefault(content.title),
                  ),
                  _buildAddressPriceRow(
                      content.location.address, content.price),
                  Container(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      content.description,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),

        //  Column(
        //   crossAxisAlignment: CrossAxisAlignment.center,
        //   children: <Widget>[
        //     // Image.network(_content.image),

        //     Container(
        //       padding: EdgeInsets.all(10.0),
        //       child: TitleDefault(content.title),
        //     ),
        //     Row(
        //       mainAxisAlignment: MainAxisAlignment.center,
        //       children: <Widget>[
        //         // Text('on the detail page'),
        //         AddressTag(content.location.address),
        //         Container(
        //           child: Text('|', style: TextStyle(color: Colors.grey)),
        //         ),
        //         Text(
        //           '\$' + content.price.toString(),
        //         )
        //       ],
        //     ),
        //     Container(
        //       padding: EdgeInsets.all(10.0),
        //       child: Text(
        //         content.description,
        //         textAlign: TextAlign.center,
        //       ),
        //     ),

        //     // RaisedButton(
        //     //   child: Text('返回'),
        //     //   onPressed: () => _showWarningDialog(context),
        //     // )
        //   ],
        // ),
        floatingActionButton: ContentFab(content),
      ),
    );
  }
}
