import 'package:flutter/material.dart';
import 'CreateTemplatePage.dart';
import 'package:test4liu/entity/Field.dart';
import 'package:test4liu/constants/Constants.dart';
import 'package:test4liu/events/SaveFieldEvent.dart';
import 'package:test4liu/dbHelper.dart';
import 'dart:async';

class FieldPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return FieldPageState();
  }
}

class FieldPageState extends State<FieldPage> with WidgetsBindingObserver {
  var listData = List<Field>();
  var curPage = 1;
  var listTotalSize = 0;
  var dbSize = 0;
  ScrollController _controller = new ScrollController();

  TemplatePageState() {
    _controller.addListener(() {
      var maxScroll = _controller.position.maxScrollExtent;
      var pixels = _controller.position.pixels;
      print("maxScroll:$maxScroll" + "pexels:$pixels");
      if (maxScroll == pixels) {
        // scroll to bottom, get next page data
        print("load more ... ");
        curPage++;
        getTemplateList(true);
      }
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    print("state:$state");
    switch (state) {
      case AppLifecycleState.resumed:
        curPage = 1;
        getTemplateList(false);
        break;
      default:
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    getTemplateList(false);
    Constants.eventBus.on(SaveFieldEvent).listen((event) {
      curPage = 1;
      getTemplateList(false);
    });
  }

  @override
  dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Widget createBody() {
    if (listData == null || listData.isEmpty) {
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
        heroTag: this,
        onPressed: () {
          Navigator.of(context).push(new MaterialPageRoute(builder: (context) {
            return CreateTemplatePage(title: Constants.createField);
          }));
        },
        child: new Icon(Icons.add),
      ),
    );
  }

  void getTemplateList(bool loadMore) {
    if (loadMore) {
      setState(() {});
    } else {
      DatabaseHelper.internal().getFields().then((values) {
        print(values);
        setState(() {
          listData.clear();
          dbSize = 0;
          for (var value in values) {
            listData.add(Field(value["field"]));
            dbSize++;
          }
        });
      });
    }
  }

  renderRow(int i) {
    if (i.isOdd) {
      return new Divider(
        height: 1.0,
      );
    } else {
      i = i ~/ 2;
      return new Text(listData[i].field);
    }
  }
}
