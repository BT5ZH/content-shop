import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import './created_content_card.dart';
import '../../scoped_model/sc_main.dart';

import '../../models/content.dart';
class CreatedContentWidget extends StatelessWidget {
  // final List<Content> contentList;
  // final Function deleteContent;
  // CreatedContentWidget(this.contentList, {this.deleteContent}); 

  Widget _buildVideoList(List<Content> contents) {
    Widget videoCards;
    if (contents.length > 0) {
      videoCards = ListView.builder(
        itemBuilder: (BuildContext context, int index) =>CreatedContentCardWidget(contents[index],),// index
        // _buildVideoItem,
        itemCount: contents.length,
      );
    } else {
      videoCards = Center(
        child: Text('展示一下我们的实力吧'),
      );
    }
    return videoCards;
  }

  @override
  Widget build(BuildContext context) {

    return ScopedModelDescendant<SCMainModel>(builder:(BuildContext context, Widget widget, SCMainModel model){
      return _buildVideoList(model.displayedContents);
    });
  }
}
