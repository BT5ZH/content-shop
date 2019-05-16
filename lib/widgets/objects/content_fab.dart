import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../../scoped_model/sc_main.dart';
import '../../models/content.dart';

class ContentFab extends StatefulWidget {
  final Content content;
  ContentFab(this.content);
  @override
  State<StatefulWidget> createState() {
    return _ContentFabState();
  }
}

class _ContentFabState extends State<ContentFab> with TickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant(
      builder: (BuildContext context, Widget widget, SCMainModel model) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              height: 70.0,
              width: 56.0,
              alignment: FractionalOffset.topCenter,
              child: ScaleTransition(
                scale: CurvedAnimation(
                    parent: _controller,
                    curve: Interval(0.0, 1.0, curve: Curves.easeOut)),
                child: FloatingActionButton(
                  backgroundColor: Theme.of(context).cardColor,
                  heroTag: 'contact',
                  mini: true,
                  onPressed: () {},
                  child: Icon(
                    Icons.mail,
                    color: Theme.of(context).accentColor,
                  ),
                ),
              ),
            ),
            Container(
              height: 70.0,
              width: 56.0,
              alignment: FractionalOffset.topCenter,
              child: ScaleTransition(
                scale: CurvedAnimation(
                    parent: _controller,
                    curve: Interval(0.0, 1.0, curve: Curves.easeOut)),
                child: FloatingActionButton(
                  backgroundColor: Theme.of(context).cardColor,
                  heroTag: 'favorite',
                  mini: true,
                  onPressed: () {
                    model.toggleContentFavoriteStatus();
                  },
                  child: Icon(
                      model.selectedContent.isFavorite
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: Colors.red),
                ),
              ),
            ),
            Container(
              height: 70.0,
              width: 56.0,
              child: FloatingActionButton(
                  // backgroundColor: Theme.of(context).cardColor,
                  heroTag: 'options',
                  // mini:true,
                  onPressed: () {
                    if (_controller.isDismissed) {
                      _controller.forward();
                    } else {
                      _controller.reverse();
                    }
                  },
                  child: AnimatedBuilder(
                    animation: _controller,
                    builder: (BuildContext context, Widget widget) {
                      print(_controller.value);
                      return Transform(
                        alignment: FractionalOffset.center,
                        transform: Matrix4.rotationZ(
                            _controller.value * 0.5 * math.pi),
                        child: Icon(_controller.isDismissed?
                          Icons.more_vert:Icons.close
                        ),
                      );
                    },
                  ),),
            ),
          ],
        );
      },
    );
  }
}
