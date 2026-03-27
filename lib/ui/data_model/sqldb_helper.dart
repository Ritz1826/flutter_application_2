import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SqldbHelper {
  late Database db;

  static final SqldbHelper _instance = SqldbHelper._internal();

  factory SqldbHelper() => _instance;

  SqldbHelper._internal();

  Future<Database> initDB() async {
    String path = join(await getDatabasesPath(), "app.db");
    Database result = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        db.execute(
          'CREATE TABLE Test (id INTEGER PRIMARY KEY, name TEXT, value INTEGER, num REAL)',
        );
      },
    );
    return result;
  }
}
