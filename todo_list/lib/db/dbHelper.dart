import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../db/todo.dart';

final String TableName = 'todoes';

class DBHelper {
  var _db;

  Future<Database> get database async {
    if (_db != null) return _db;
    _db = openDatabase(
      // 데이터베이스 경로를 지정합니다. 참고: `path` 패키지의 `join` 함수를 사용하는 것이
      // 각 플랫폼 별로 경로가 제대로 생성됐는지 보장할 수 있는 가장 좋은 방법입니다.
      join(await getDatabasesPath(), 'todoes.db'),
      // 데이터베이스가 처음 생성될 때, 저장하기 위한 테이블을 생성합니다.
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE todoes(date TEXT PRIMARY KEY, category TEXT, text TEXT, memo TEXT, checked INTEGER)",
        );
      },
      // 버전을 설정하세요. onCreate 함수에서 수행되며 데이터베이스 업그레이드와 다운그레이드를
      // 수행하기 위한 경로를 제공합니다.
      version: 1,
    );
    return _db;
  }

  Future<void> insertTodo(Todo todo) async {
    final db = await database;
    await db.insert(
      TableName,
      todo.toMap(),
      // conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Todo>> todoes() async {
    final db = await database;

    // 모든 Todo를 얻기 위해 테이블에 질의합니다.
    final List<Map<String, dynamic>> maps = await db.query('todoes');

    // List<Map<String, dynamic>를 List<Todo>으로 변환합니다.
    return List.generate(maps.length, (i) {
      return Todo(
        date: maps[i]['date'],
        category: maps[i]['category'],
        text: maps[i]['text'],
        memo: maps[i]['memo'],
        checked: maps[i]['checked'],
      );
    });
  }

  Future<void> updateTodo(Todo todo) async {
    final db = await database;

    // 주어진 Todo를 수정합니다.
    await db.update(
      TableName,
      todo.toMap(),
      // Todo의 date가 일치하는 지 확인합니다.
      where: "date = ?",
      // Todo의 date를 whereArg로 넘겨 SQL injection을 방지합니다.
      whereArgs: [todo.date],
    );
  }

  Future<void> deleteTodo(String date) async {
    final db = await database;

    // 데이터베이스에서 Todo를 삭제합니다.
    await db.delete(
      TableName,
      // 특정 todo를 제거하기 위해 `where` 절을 사용하세요
      where: "date = ?",
      // Todo의 date를 where의 인자로 넘겨 SQL injection을 방지합니다.
      whereArgs: [date],
    );
  }

  Future<void> deleteTodoAsCategory(String name) async {
    final db = await database;

    // 데이터베이스에서 Todo를 삭제합니다.
    await db.delete(
      TableName,
      // 특정 todo를 제거하기 위해 `where` 절을 사용하세요
      where: "category = ?",
      // Todo의 date를 where의 인자로 넘겨 SQL injection을 방지합니다.
      whereArgs: [name],
    );
  }

  Future<List<Todo>> findTodo(String date) async {
    final db = await database;

    // 모든 Todo를 얻기 위해 테이블에 질의합니다.
    final List<Map<String, dynamic>> maps =
    await db.query('todoes', where: 'date = ?', whereArgs: [date]);

    // List<Map<String, dynamic>를 List<Todo>으로 변환합니다.
    return List.generate(maps.length, (i) {
      return Todo(
        date: maps[i]['date'],
        category: maps[i]['category'],
        text: maps[i]['text'],
        memo: maps[i]['memo'],
        checked: maps[i]['checked'],
      );
    });
  }
}

//jae