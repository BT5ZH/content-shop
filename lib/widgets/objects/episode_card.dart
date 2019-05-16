import 'package:flutter/material.dart';

class EpisodeCard extends StatelessWidget {
  final Map<String, dynamic> episodeInfo;
  // final int episodeIndex;
  // final int episodeIndex;
  // final String episodeName;
  // final DateTime postTime;
  // final int faviroteCount;
  // EpisodeCard(this.episodeIndex,this.episodeName,this.postTime,this.faviroteCount);
  EpisodeCard(this.episodeInfo);
  
  @override
  Widget build(BuildContext context) {

    int episodeIndex=int.parse(episodeInfo["episode_index"]);
    String episodeImage=episodeInfo["episode_image"];
     String episodeName=episodeInfo["episode_name"];
   String postTime=episodeInfo["episode_post_time"];
   int faviroteCount=int.parse(episodeInfo["epsisode_favirote_count"]);
    return Card(child: Row(children: <Widget>[
      Image.asset(episodeImage,width: 125.0,height: 75.0,),
      Container(child: Column(children: <Widget>[
        Text('第'+'$episodeIndex'+'话：'+'$episodeName'),
        Text('$postTime'+'$faviroteCount')
      ],),)
    ],),);
  }
}