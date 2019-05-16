import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../models/content.dart';
import '../../scoped_model/sc_main.dart';
import '../tags/price_tag.dart';
import '../tags/address_tag.dart';
import '../ui/title_default.dart';

class CreatedContentCardWidget extends StatelessWidget {
  final Content content;
  // final int contentIndex;
  CreatedContentCardWidget(
    this.content,
  ); //this.contentIndex

  Widget _buildTitlePriceRow() {
    return Container(
      padding: EdgeInsets.only(top: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Flexible(
            child: TitleDefault(content.title),
          ),
          Flexible(
            child: SizedBox(
              width: 8.0,
            ),
          ),
          Flexible(
            child: PriceTag(content.price.toString()),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return ScopedModelDescendant<SCMainModel>(
      builder: (BuildContext context, Widget widget, SCMainModel model) {
        return ButtonBar(
          alignment: MainAxisAlignment.center,
          children: <Widget>[
            IconButton(
                // child: Text('Details'),
                icon: Icon(Icons.info),
                iconSize: 24.0,
                color: Theme.of(context).primaryColor,
                onPressed: () {
                  model.selectContent(content.id); //过滤时候index变化出错
                  Navigator.pushNamed<bool>(
                          context, '/admincontent/' + content.id)
                      .then((_) {
                    model.selectContent(null);
                  });
                } //contentIndex.toString()
                //   .then((bool value) {
                // if (value) {
                //   deleteVideo(index);
                // }
                // }),
                ),
            IconButton(
              icon: Icon(
                  content.isFavorite ? Icons.favorite : Icons.favorite_border),
              iconSize: 24.0,
              color: Colors.red,
              onPressed: () {
                model.selectContent(content.id);
                model.toggleContentFavoriteStatus();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(0.0),
      child: Column(
        children: <Widget>[
          Hero(
            tag: content.id,
            child: FadeInImage(
              image: NetworkImage(content.image),
              height: 200,
              fit: BoxFit.cover,
              placeholder: AssetImage('assets/images/placeholder1.png'),
            ),
          ),
          _buildTitlePriceRow(),
          // AddressTag('西长安街620号陕西示范大学'),
          AddressTag(content.location.address),
          Text(content.userEmail),
          _buildActionButtons(context),
        ],
      ),
    );
  }
}
