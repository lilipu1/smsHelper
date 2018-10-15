class Field {
  int id;
  String _field;

  Field(this._field);

  Field.map(dynamic obj){
    this._field = obj["field"];
  }


  String get field => _field;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["field"] = _field;
    return map;
  }


}