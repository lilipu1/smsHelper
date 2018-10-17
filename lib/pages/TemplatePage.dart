import 'package:flutter/material.dart';
import 'package:sky_engine/ui/ui.dart';
import 'CreateTemplatePage.dart';
import 'package:test4liu/dbHelper.dart';
import 'dart:async';
import 'package:test4liu/entity/Template.dart';
import 'package:test4liu/constants/Constants.dart';
import 'package:test4liu/events/SaveTemplateEvent.dart';
import 'package:url_launcher/url_launcher.dart';

class TemplatePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new TemplatePageState();
  }
}

class TemplatePageState extends State<TemplatePage>
    with WidgetsBindingObserver {
  var listData = List<Template>();
  var curPage = 1;
  var listTotalSize = 0;
  var dbSize = 0;
  ScrollController _controller = new ScrollController();
  var clickActions = ["发送", "编辑", "删除"];

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
  void didChangeAppLifecycleState(state) {
    super.didChangeAppLifecycleState(state);
    print("state:$state");
    /* switch (state) {
      case AppLifecycleState.resumed:
        curPage = 1;
        getTemplateList(false);
        break;
      default:
        break;
    }*/
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    getTemplateList(false);
    Constants.eventBus.on<SaveTemplateEvent>().listen((event) {
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
            return CreateTemplatePage(title: Constants.createTemplate);
          }));
        },
        child: new Icon(Icons.add),
      ),
    );
  }

  void getTemplateList(bool loadMore) {
    if (loadMore) {
      print("加载更多");
      setState(() {});
    } else {
      DatabaseHelper.internal().getTemplates().then((values) {
        print("values:$values");
        setState(() {
          listData.clear();
          dbSize = 0;
          for (var value in values) {
            var template = Template(value["template"]);
            template.id = value["id"];
            listData.add(template);
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
      String text = listData[i].template;
      return MaterialButton(
        textTheme: ButtonTextTheme.accent,
        padding: EdgeInsets.symmetric(vertical: 9.0),
        onPressed: () {
          showOptions(i);
        },
        child: Text(
          text,
        ),
      );
    }
  }

  Future<Null> showOptions(int i) async {
    switch (await showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            children: <Widget>[
              SimpleDialogOption(
                onPressed: () {
                  _sendMsg(listData[i].template);
                },
                child: const Text('发送'),
              ),
              SimpleDialogOption(
                onPressed: () {},
                child: const Text('编辑'),
              ),
              SimpleDialogOption(
                onPressed: () {
                  print("删除${listData[i].id}");
                  DatabaseHelper.internal()
                      .deleteTemplate(listData[i].id)
                      .then((value) {
                    print("删除$value行");
                    getTemplateList(false);
                    Navigator.of(context).pop();
                  });
                },
                child: const Text("删除"),
              )
            ],
          );
        })) {
    }
  }
}

void _sendMsg(String text) async {
  String proccessedText = text.replaceAll("[", "");
  proccessedText = proccessedText.replaceAll("]", "");
  String url = "sms:15173209115;15616665287?body=$proccessedText";
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    print("could not launch $url");
  }
}
