import 'dart:io';
import 'package:path/path.dart';
import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'entity/Template.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = new DatabaseHelper.internal();
  factory DatabaseHelper() => _instance;

  static Database _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  DatabaseHelper.internal();

  initDb() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, "test.db");
    var ourDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return ourDb;
  }

  void _onCreate(Database db, int version) async {
    await db.execute(
        "CREATE TABLE template(id INTEGER PRIMARY KEY, template TEXT)");
    print("Table is created");
  }

  //insertion
  Future<int> saveTemplate(Template template) async {
    var dbClient = await db;
    int res = await dbClient.insert("template", template.toMap());
    return res;
  }




  Future<List<Map<String,dynamic>>> getTemplates() async {
    var dbClient = await db;
    var res = await dbClient.rawQuery('SELECT * FROM template');
    print(res);
    return res;
  }
}