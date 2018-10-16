import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'pages/MsgListPage.dart';
import 'pages/GroupsPage.dart';
import 'pages/TemplatePage.dart';
import 'pages/MinePage.dart';
import 'pages/FieldPage.dart';

void main() {
  runApp(new MyTestClient());
}

class MyTestClient extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new MyTestClientState();
}

class MyTestClientState extends State<MyTestClient> {
  int _tabIndex = 0;
  final tabTextStyleNormal = new TextStyle(color: Color(0xff969696));
  final tabTextStyleSelected = new TextStyle(color: Color(0xff969696));

  var tabImages;
  var _body;
  var appBarTitles = ['信息', '分组', '模板', '字段', '我的'];

  Image getTabImage(path) {
    return new Image.asset(path, width: 20.0, height: 20.0);
  }

  void initData() {
    if (tabImages == null) {
      tabImages = [
        [
          getTabImage('images/ic_nav_news_normal.png'),
          getTabImage('images/ic_nav_news_actived.png')
        ],
        [
          getTabImage('images/ic_nav_tweet_normal.png'),
          getTabImage('images/ic_nav_tweet_actived.png')
        ],
        [
          getTabImage('images/ic_nav_discover_normal.png'),
          getTabImage('images/ic_nav_discover_actived.png')
        ],
        [
          getTabImage('images/ic_nav_discover_normal.png'),
          getTabImage('images/ic_nav_discover_actived.png')
        ],
        [
          getTabImage('images/ic_nav_my_normal.png'),
          getTabImage('images/ic_nav_my_pressed.png')
        ]
      ];
    }

    _body = new IndexedStack(
      children: <Widget>[
        new MsgListPage(),
        new GroupsPage(),
        new TemplatePage(),
        new FieldPage(),
        new MinePage()
      ],
      index: _tabIndex,
    );
  }

  TextStyle getTabTextStyle(int curIndex) {
    if (curIndex == _tabIndex) {
      return tabTextStyleSelected;
    }
    return tabTextStyleNormal;
  }

  Text getTabTitle(int curIndex) {
    return new Text(
      appBarTitles[curIndex],
      style: getTabTextStyle(curIndex),
    );
  }

  Image getTabIcon(int curIndex) {
    if (curIndex == _tabIndex) {
      return tabImages[curIndex][1];
    }
    return tabImages[curIndex][0];
  }

  @override
  Widget build(BuildContext context) {
    initData();
    return MaterialApp(
      theme: new ThemeData(primaryColor: Colors.lightBlue),
      home: new Scaffold(
        body: _body,
        bottomNavigationBar: new CupertinoTabBar(
          items: <BottomNavigationBarItem>[
            new BottomNavigationBarItem(
                icon: getTabIcon(0), title: getTabTitle(0)),
            new BottomNavigationBarItem(
                icon: getTabIcon(1), title: getTabTitle(1)),
            new BottomNavigationBarItem(
                icon: getTabIcon(2), title: getTabTitle(2)),
            new BottomNavigationBarItem(
                icon: getTabIcon(3), title: getTabTitle(3)),
            new BottomNavigationBarItem(
                icon: getTabIcon(4), title: getTabTitle(4)),
          ],
          currentIndex: _tabIndex,
          onTap: (index) {
            setState(() {
              _tabIndex = index;
            });
          },
        ),
      ),
    );
  }
}
