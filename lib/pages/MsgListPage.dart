import 'dart:async';
import 'package:flutter/material.dart';

class MsgListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new MsgListPageState();
}

class MsgListPageState extends State<MsgListPage> {
  var listData;
  var curPage = 1;
  var listTotalSize = 0;
  ScrollController _controller = new ScrollController();
  TextStyle textStyle = new TextStyle(fontSize: 15.0);

  MsgListPageState() {
    _controller.addListener(() {
      var maxScroll = _controller.position.maxScrollExtent;
      var pixels = _controller.position.pixels;
      if (maxScroll == pixels && listData.length < listTotalSize) {
        print("load more ...");
        curPage++;
        getMsgList(true);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getMsgList(false);
  }

  Future<Null> _pullToRefresh() async {
    curPage = 1;
    getMsgList(false);
    return null;
  }

  @override
  Widget build(BuildContext context) {
    if (listData == null) {
      return new Center(
        child: new CircularProgressIndicator(),
      );
    } else {
      Widget listView = new ListView.builder(
        itemCount: listData.length * 2,
        itemBuilder: (context, i) => renderRow(i),
        controller: _controller,
      );
      return new RefreshIndicator(child: listView, onRefresh: _pullToRefresh);
    }
  }

  void getMsgList(bool isLoadMore) {
    List<String> _listData = new List();
    for (int i = 0; i < 10; i++) {
      _listData.add(i.toString());
    }
    setState(() {
      if (!isLoadMore) {
        listData = _listData;
      } else {
        listData.addAll(_listData);
      }
    });
  }

  renderRow(int i) {
    if (i.isOdd) {
      return new Divider(
        height: 1.0,
      );
    } else {
        i = i~/2;
        return new Text(listData[i]);
    }
  }
}
