import 'dart:async';

import 'package:joinmun/page_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

const String imgHeader = 'assets/img_drawer_header.png';

class MyDrawer extends StatelessWidget {
  MyDrawer({
    @required this.items,
    this.onTap,
    this.currentIndex: 0,
  }) : super() {
    assert(items != null);
    assert(0 <= currentIndex && currentIndex < items.length);
  }

  final List<PageContainer> items;

  final int currentIndex;

  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    final List<Widget> lists = <Widget>[];
    for (int i = 0; i < items.length; i++) {
      PageContainer container = items[i];
      lists.add(
        ListTileTheme(
          textColor: Colors.white,
          selectedColor: theme.accentColor,
          child: new ListTile(
              //leading: container.icon,
              title: Center(
                child: new Text(
                  container.title,
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w500,
                    letterSpacing: 1.0,
                    fontSize: 16.0,
                  ),
                ),
              ),
              selected: currentIndex == i,
              onTap: () {
                Navigator.of(context).pop(); // Hide drawer
                if (onTap != null) onTap(i);
              }),
        ),
      );
    }

    return new Drawer(
      child: Container(
        color: theme.primaryColor,
        child: new Column(
          children: <Widget>[
            new Container(
              height: 100.0,
            ),
            new Expanded(
              child: new ListView(
                children: <Widget>[
                  new Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: lists,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
