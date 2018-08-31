import 'package:flutter/material.dart';
import 'CreateTemplatePage.dart';
import 'package:test4liu/dbHelper.dart';
import 'dart:async';
import 'package:test4liu/entity/Template.dart';

class TemplatePage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return new TemplatePageState();
  }
}

class TemplatePageState extends State<TemplatePage> {
  var listData = List<Template>();
  var curPage = 1;
  var listTotalSize = 0;
  ScrollController _controller = new ScrollController();

  TemplatePageState() {
    _controller.addListener(() {
      var maxScroll = _controller.position.maxScrollExtent;
      var pixels = _controller.position.pixels;
      if (maxScroll == pixels && listData.length < listTotalSize) {
        // scroll to bottom, get next page data
        print("load more ... ");
        curPage++;
        getTemplateList(true);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getTemplateList(true);
  }

  Widget createBody() {
    if (listData == null|| listData.isEmpty) {
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

  Future<Null> _pullToRefresh() async {
    curPage = 1;
    getTemplateList(false);
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: createBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(new MaterialPageRoute(builder: (context) {
            return CreateTemplatePage();
          }));
        },
        child: new Icon(Icons.add),
      ),
    );
  }

  void getTemplateList(bool loadMore) {
    DatabaseHelper.internal().getTemplates().then((values) {
      print(values);
      for (var value in values) {
        listData.add(Template(value["template"]));
      }
    });
  }

  renderRow(int i) {
    if (i.isOdd) {
      return new Divider(
        height: 1.0,
      );
    } else {
      i = i ~/ 2;
      return new Text(listData[i].template);
    }
  }
}
