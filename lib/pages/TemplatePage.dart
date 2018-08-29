import 'package:flutter/material.dart';
import 'CreateTemplatePage.dart';

class TemplatePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("template"),
      ),
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
}
