import 'package:flutter/material.dart';
import 'package:test4liu/dbHelper.dart';
import 'package:test4liu/entity/Template.dart';
import 'package:test4liu/entity/Field.dart';
import 'package:test4liu/constants/Constants.dart';
import 'package:test4liu/events/SaveTemplateEvent.dart';
import 'package:test4liu/events/SaveFieldEvent.dart';
import 'package:test4liu/widgets/FieldInputFormatter.dart';
import 'package:zefyr/zefyr.dart';

class CreateTemplatePage extends StatefulWidget {
  final String title;

  CreateTemplatePage({Key key, @required this.title}) : super(key: key);

  @override
  State<StatefulWidget> createState() => new CreateTemplatePageState(title);
}

class CreateTemplatePageState extends State<CreateTemplatePage> {
  final document = NotusDocument();
  ZefyrController _controller;

  //String templateStr = "";
  final String title;

  CreateTemplatePageState(this.title) {
    _controller = ZefyrController(document);
    _controller.addListener(() {});
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        leading: BackButton(
          color: Colors.white,
        ),
        centerTitle: true,
        title: Text(title),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: (String value) {
              _controller.document.toDelta().insert(value, {"bold": true});
            },
            itemBuilder: (context) => buildItem(context),
          )
        ],
        elevation: 0.0,
      ),
      body: Column(
        children: <Widget>[
          Card(
            margin: EdgeInsets.fromLTRB(8.0, 5.0, 8.0, 15.0),
            elevation: 3.0,
            color: Colors.white,
            child: Container(
              height: 300.0,
              padding: EdgeInsets.all(8.0),
              child: ZefyrEditor(
                //decoration: InputDecoration(border: InputBorder.none),
                controller: _controller,
                focusNode: FocusNode(),
                //style: TextStyle(color: Colors.black),
                //maxLines: 10,
                //inputFormatters: [FieldInputFormatter()],
                /*onChanged: (text) {
                  templateStr = text.trim();
                },*/
              ),
            ),
          ),
          Card(
            elevation: 5.0,
            child: FlatButton(
              onPressed: () {
                switch (title) {
                  case Constants.createTemplate:
                    DatabaseHelper
                        .internal()
                        .saveTemplate(Template(_controller.document.toDelta().toString()))
                        .then((row) {
                      Constants.eventBus.fire(SaveTemplteEvent());
                      Navigator.pop(context, null);
                    });
                    break;
                  case Constants.createField:
                    DatabaseHelper
                        .internal()
                        .saveField(Field(_controller.document.toDelta().toString()))
                        .then((row) {
                      Constants.eventBus.fire(SaveFieldEvent());
                      Navigator.pop(context, null);
                    });
                    break;
                }
              },
              child: Text(
                "保存",
                style: TextStyle(fontSize: 16.0, color: Colors.white),
              ),
              color: Colors.blue,
              shape: RoundedRectangleBorder(),
            ),
          ),
        ],
      ),
    );
  }

  buildItem(BuildContext context) {
    return [
      PopupMenuItem<String>(
        value: "选项一",
        child: Text("选项一"),
      ),
      PopupMenuItem<String>(
        value: "选项二",
        child: Text("选项二"),
      )
    ];
  }
}
