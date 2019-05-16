import 'package:flutter/material.dart';
import '../widgets/objects/episode_card.dart';

class BookDetailListPage extends StatelessWidget {
  final int bookPageCount;
  final List<Map<String, dynamic>> episodeList;
  BookDetailListPage(this.bookPageCount,this.episodeList);

//   @override
//   State<StatefulWidget> createState() {

//     return _BookDetailListPageState();
//   }
// }

// class _BookDetailListPageState extends State<BookDetailListPage>{

  // Widget _buildEpisodeItems(BuildContext context, int index){
  //   return EpisodeCard(episodeList[index],index);
  // }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 8.0),
              child: Text('全部章节 (' + '$bookPageCount)'),
            ),
            Container(
              child: Row(children: <Widget>[
                SizedBox(
                  width: 45,
                  child: FlatButton(
                    padding: EdgeInsets.all(0.0),
                    child: Text('正序'),
                    onPressed: () {},
                  ),
                ),
                Text('|'),
                SizedBox(
                  width: 45,
                  child: FlatButton(
                    padding: EdgeInsets.all(0.0),
                    child: Text('倒序'),
                    onPressed: () {},
                  ),
                ),
              ]),
            ),
          ],
        ),
        Column(
          children: episodeList
            .map(
              (element)=>EpisodeCard(element)
            ).toList()
        ),
        // ListView.builder(
        //   itemBuilder: _buildEpisodeItems,
        //   itemCount: episodeList.length,
        // )
          // ListView(
          //   children: <Widget>[

          //   ],
          // ),
        // )
      ],
    );
  }
}
