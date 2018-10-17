import 'package:flutter/material.dart';
import 'package:test4liu/dbHelper.dart';
import 'package:test4liu/entity/Template.dart';
import 'package:test4liu/entity/Field.dart';
import 'package:test4liu/constants/Constants.dart';
import 'package:test4liu/events/SaveTemplateEvent.dart';
import 'package:test4liu/events/SaveFieldEvent.dart';
import 'package:test4liu/widgets/FieldInputFormatter.dart';

class CreateTemplatePage extends StatefulWidget {
  final String title;

  CreateTemplatePage({Key key, @required this.title}) : super(key: key);

  @override
  State<StatefulWidget> createState() => new CreateTemplatePageState(title);
}

class CreateTemplatePageState extends State<CreateTemplatePage> {
  //String templateStr = "";
  final String title;
  final focusNode = FocusNode();
  final controller = TextEditingController();
  final items = List<PopupMenuItem<String>>();

  CreateTemplatePageState(this.title) {}

  @override
  void initState() {
    super.initState();
    getFields();
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
        actions: createAction(),
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
              child: TextField(
                focusNode: focusNode,
                controller: controller,
                decoration: null,
                style: TextStyle(
                    fontSize: 18.0, color: Color.fromARGB(255, 0, 0, 0)),
              ),
            ),
          ),
          Card(
            elevation: 5.0,
            color: Colors.blue,
            child: FlatButton(
              onPressed: () {
                switch (title) {
                  case Constants.createTemplate:
                    DatabaseHelper.internal()
                        .saveTemplate(Template(controller.text))
                        .then((row) {
                      Constants.eventBus.fire(SaveTemplateEvent());
                      Navigator.pop(context, null);
                    });
                    break;
                  case Constants.createField:
                    DatabaseHelper.internal()
                        .saveField(Field(controller.text))
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
            ),
          ),
        ],
      ),
    );
  }

  buildItem(BuildContext context) {
    return items;
  }

  createAction() {
    List<Widget> actions = List();
    switch (title) {
      case Constants.createTemplate:
        actions.add(PopupMenuButton<String>(
          itemBuilder: (context) => buildItem(context),
          onSelected: (text) {
            controller.text = controller.text + "[$text]";
          },
        ));
        break;
    }
    return actions;
  }

  void getFields() {
    DatabaseHelper.internal().getFields().then((values) {
      List<String> fields = [];
      for (var value in values) {
        fields.add(value["field"]);
      }
      print("items:$fields");
      items.addAll(fields.map((String item) {
        return PopupMenuItem<String>(
          value: item,
          child: Text(item),
        );
      }).toList());
    });
  }
}
