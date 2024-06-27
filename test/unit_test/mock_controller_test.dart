import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sqflite_app/application/mock_service.dart/database_helper.dart';
import 'package:sqflite_app/domain/entity/note_model.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

// データベースの初期化
class MockDatabase extends Mock implements Database {}

void main() {
  // テストの実行前に一度だけ実行されるセットアップ関数
  setUpAll(() {
    // sqflite_common_ffiを初期化
    sqfliteFfiInit();
    // データベースファクトリをFFIバージョンに設定
    databaseFactory = databaseFactoryFfi;
  });

  // mocktailを使用したテスト
  test('addNote', () async {
    final db = MockDatabase();
    final note = Note(
      id: 1,
      title: 'title',
      description: 'description',
    );
    // DatabaseHelperの_getDBメソッドをモック化するためにDatabaseHelperを拡張
    final databaseHelper = DatabaseHelperMock(db);
    when(() => db.insert(
      any(),
      any(),
      conflictAlgorithm: any(named: 'conflictAlgorithm'),
    )).thenAnswer((_) async => 1);

    final result = await databaseHelper.addNote(
      note,
    );
    expect(result, 1);
  });
  // mockのデータがselectで取得できるかテスト
  test('getNotes', () async {
    final db = MockDatabase();
    final note = Note(
      id: 1,
      title: 'title',
      description: 'description',
    );
    final databaseHelper = DatabaseHelperMock(db);
    when(() => db.query(
      any(),
      columns: any(named: 'columns'),
      where: any(named: 'where'),
      whereArgs: any(named: 'whereArgs'),
    )).thenAnswer((_) async => [
      {
        'id': note.id,
        'title': note.title,
        'description': note.description,
      }
    ]);

    final result = await databaseHelper.getAllNote();
    expect(result, [note]);
  });
}

// DatabaseHelperを拡張して_getDBメソッドをオーバーライド
class DatabaseHelperMock extends DatabaseHelper {
  final Database mockDb;

  DatabaseHelperMock(this.mockDb);

}