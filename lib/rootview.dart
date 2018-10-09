import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:joinmun/schedule/schedule.dart';
import 'package:joinmun/event/event.dart';
//import 'package:joinmun/event/eventdetails.dart';
import 'package:joinmun/merch/merch.dart';
import 'package:joinmun/drawer.dart';
import 'package:joinmun/page_container.dart';
import 'package:joinmun/home/home.dart';
import 'package:joinmun/emergency/emergency.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:joinmun/explore/explore.dart';
import 'package:joinmun/feedback/launcher.dart';
import 'package:joinmun/documents/documents.dart';
import 'package:joinmun/chairs/chairs.dart';

class RootView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _RootViewState();
  }
}

class _RootViewState extends State<RootView> with TickerProviderStateMixin {
  Future<Null> _launched;
  final String _feedbackURL = 'http://ugm.id/joinmunfeedback';
  String _title = "";
  int _currentIndex = 0;
  List<PageContainer> _pages;

  @override
  void dispose() {
    if (_pages != null) {
      for (PageContainer container in _pages) {
        container.controller.dispose();
      }
    }
    super.dispose();
  }

  List<PageContainer> _createPages() {
    return <PageContainer>[
      new PageContainer(
        title: "HOME",
        icon: new Icon(Icons.home),
        hasTab: true,
        isExternal: false,
        body: () => new HomePage(),
        tickerProvider: this,
      ),
      new PageContainer(
        title: "JOINTIMES",
        icon: new Icon(Icons.import_contacts),
        hasTab: false,
        isExternal: false,
        body: () => new ScheduleView(),
        tickerProvider: this,
      ),
      new PageContainer(
        title: "SCHEDULE",
        icon: new Icon(Icons.schedule),
        hasTab: true,
        isExternal: false,
        body: () => new ScheduleView(),
        tickerProvider: this,
      ),
      new PageContainer(
        title: "EVENTS",
        icon: new Icon(Icons.event),
        hasTab: false,
        isExternal: false,
        body: () => new EventView(),
        tickerProvider: this,
      ),
       new PageContainer(
        title: "CHAIRS",
        icon: new Icon(Icons.event),
        hasTab: false,
        isExternal: false,
        body: () => new ChairPage(),
        tickerProvider: this,
      ),
      new PageContainer(
        title: "PLACES TO VISIT",
        icon: new Icon(Icons.explore),
        hasTab: true,
        isExternal: false,
        body: () => new ExplorePage(),
        tickerProvider: this,
      ),
      new PageContainer(
        title: "HANDBOOK",
        icon: new Icon(Icons.book),
        hasTab: false,
        isExternal: false,
        body: () => new DocumentsPage(),
        tickerProvider: this,
      ),
      new PageContainer(
        title: "MERCH",
        icon: new Icon(Icons.local_mall),
        hasTab: false,
        isExternal: false,
        body: () => new MerchPage(),
        tickerProvider: this,
      ),
      new PageContainer(
        title: "CONTACTS",
        icon: new Icon(Icons.contact_phone),
        hasTab: false,
        isExternal: false,
        body: () => new ContactsPage(),
        tickerProvider: this,
      ),
      new PageContainer(
        title: "FEEDBACK",
        icon: new Icon(Icons.feedback),
        hasTab: true,
        body: () => MyApp(),
        isExternal: true,
        tickerProvider: this,
      ),
    ];
  }

  Future<Null> _launchInWebViewOrVC(String url) async {
    if (await canLaunch(url)) {
      await launch(url, forceSafariVC: true, forceWebView: true);
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget _buildTransitionsStack() {
    final List<FadeTransition> transitions = <FadeTransition>[];

    for (PageContainer container in _pages) {
      transitions.add(container.transition());
    }

    transitions.sort((FadeTransition a, FadeTransition b) {
      final Animation<double> aAnimation = a.opacity;
      final Animation<double> bAnimation = b.opacity;
      final double aValue = aAnimation.value;
      final double bValue = bAnimation.value;
      return aValue.compareTo(bValue);
    });

    return new Stack(children: transitions);
  }

  @override
  Widget build(BuildContext context) {
    _pages = _createPages();

    PageContainer _page = _pages[_currentIndex];
    _page.controller.value = 1.0;
    _title = _page.title.toString();

    return Scaffold(
        appBar: new AppBar(
          title: new Text(_title),
          elevation: _page.hasTab ? 0.0 : 4.0,
        ),
        drawer: new MyDrawer(
          items: _pages,
          currentIndex: _currentIndex,
          onTap: (int index) {
            setState(() {
              _page.controller.reverse();
              _currentIndex = index;
              _page.controller.forward();
              _title = _page.title.toString();
             
            });
          },
        ),
        body: new Center(
          child: _buildTransitionsStack(),
        ));
  }

  /*void openFeedback(BuildContext context) {
    Navigator.push(
      context,
      new MaterialPageRoute<Null>(
        settings: const RouteSettings(name: 'feedback'),
        builder: (BuildContext context) {
          return new Theme(
            data: Theme.of(context),
            child: new RemarksPage(),
          );
        },
      ),
    );
  }*/

}
