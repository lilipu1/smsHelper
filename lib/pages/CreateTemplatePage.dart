import 'package:flutter/material.dart';
import 'package:test4liu/dbHelper.dart';
import 'package:test4liu/entity/Template.dart';

class CreateTemplatePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new CreateTemplatePageState();
}

class CreateTemplatePageState extends State<CreateTemplatePage> {
  TextEditingController _controller = new TextEditingController();
  String templateStr = "";

  CreateTemplatePageState() {
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
        title: Text("创建模板"),
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
              child: EditableText(
                controller: _controller,
                focusNode: new FocusNode(),
                style: TextStyle(color: Colors.black),
                cursorColor: Colors.red,
                maxLines: 10,
                onChanged: (text) {
                  templateStr = text.trim();
                },
              ),
            ),
          ),
          Card(
            elevation: 5.0,
            child: FlatButton(
              onPressed: () {
                print(templateStr);
                DatabaseHelper
                    .internal()
                    .saveTemplate(Template(templateStr))
                    .then((row) {
                  print("行数" + row.toString());
                });
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
}
