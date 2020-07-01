import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

Database db;

class DatabaseHelper {
  static const String TODOS_TABLE_NAME = 'todos';
  static const String ID_COLUMN = 'id';
  static const String TITLE_COLUMN = 'title';
  static const String BODY_COLUMN = 'body';
  static const String DATE_COLUMN = 'date';
  static const String IS_DONE_COLUMN = 'isDone';

  Future<void> createDatabase() async {
    final databasePath = await getDatabasesPath();
    final todoDbPath = join(databasePath, 'todos.db');

    db = await openDatabase(todoDbPath,
        version: 1, onCreate: (db, _) => createTodoTable(db));

    print(db);
  }

  Future<void> createTodoTable(db) async {
    final todoTableSQL = '''
    CREATE TABLE $TODOS_TABLE_NAME (
      $ID_COLUMN TEXT PRIMARY KEY,
      $TITLE_COLUMN TEXT,
      $BODY_COLUMN TEXT,
      $DATE_COLUMN TEXT,
      $IS_DONE_COLUMN BIT
    );
    ''';

    await db.execute(todoTableSQL);
  }
}
