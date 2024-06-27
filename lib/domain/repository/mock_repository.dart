import 'package:sqflite_app/domain/entity/note_model.dart';
import 'package:sqflite_app/application/service/database_helper.dart';

// データベース操作のインターフェース
abstract interface class MockRepository {
  Future<List<Note>?> getNotes();
  Future<void> insert(Note note);
  Future<void> update(Note note);
  Future<void> delete(Note note);
}

// ロジックを持たないデータベース操作の実装クラス
// ロジックは、DatabaseHelperクラスに委譲する
class MockRepositoryImpl implements MockRepository {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  @override
  Future<List<Note>?> getNotes() async {
    return await _databaseHelper.getAllNote();
  }

  @override
  Future<void> insert(Note note) async {
    await _databaseHelper.addNote(note);
  }

  @override
  Future<void> update(Note note) async {
    await _databaseHelper.updateNote(note);
  }

  @override
  Future<void> delete(Note note) async {
    await _databaseHelper.deleteNote(note);
  }
}