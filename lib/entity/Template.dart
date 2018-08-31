class Template {
  int id;
  String _template;

  Template(this._template);

  Template.map(dynamic obj){
    this._template = obj["template"];
  }


  String get template => _template;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["template"] = _template;
    return map;
  }


}