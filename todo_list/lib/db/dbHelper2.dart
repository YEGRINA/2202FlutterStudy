import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../db/category.dart';

final String TableName = 'categories';

class DBHelper2 {
  var _db;

  Future<Database> get database async {
    if (_db != null) return _db;
    _db = openDatabase(
      // 데이터베이스 경로를 지정합니다. 참고: `path` 패키지의 `join` 함수를 사용하는 것이
      // 각 플랫폼 별로 경로가 제대로 생성됐는지 보장할 수 있는 가장 좋은 방법입니다.
      join(await getDatabasesPath(), 'categories.db'),
      // 데이터베이스가 처음 생성될 때, 저장하기 위한 테이블을 생성합니다.
      onCreate: (db, version) {
        db.execute(
          "CREATE TABLE categories(name TEXT PRIMARY KEY)",
        );
        return db.insert(TableName, Category(name: '전체').toMap());
      },
      // 버전을 설정하세요. onCreate 함수에서 수행되며 데이터베이스 업그레이드와 다운그레이드를
      // 수행하기 위한 경로를 제공합니다.
      version: 1,
    );

    // 처음 db에 '전체' 기본 생성
    // insert(Category(name: '전체'));
    return _db;
  }

  Future<void> insert(Category c) async {
    final db = await database;
    await db.insert(
      TableName,
      c.toMap(),
      // conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Category>> categories() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('categories');

    return List.generate(maps.length, (i) {
      return Category(
        name: maps[i]['name']
      );
    });
  }

  Future<void> update(Category c) async {
    final db = await database;

    await db.update(
      TableName,
      c.toMap(),
      where: "name = ?",
      whereArgs: [c.name],
    );
  }

  Future<void> delete(String name) async {
    final db = await database;

    await db.delete(
      TableName,
      where: "name = ?",
      whereArgs: [name],
    );
  }

  Future<List<Category>> find(String name) async {
    final db = await database;

    final List<Map<String, dynamic>> maps =
    await db.query('categories', where: 'name = ?', whereArgs: [name]);

    return List.generate(maps.length, (i) {
      return Category(
        name: maps[i]['name']
      );
    });
  }
}