import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_app/domain/entity/note_model.dart';

// データべースの操作を行うクラス
class DatabaseHelper {
  // データベースのバージョン
  static const int _version = 1;
  // データベースの名前
  static const String _dbName = 'Notes.db';
  // データベースのインスタンス
  Future<Database> _getDB() async {
    // データベースのパスを取得
    return openDatabase(
      // データベースのパスを指定
      join(await getDatabasesPath(), _dbName),
      // データベースのバージョンを指定
      version: _version,
      // データベースを作成する関数を指定
      onCreate: (db, version) async =>
      // データベースにテーブルを作成
      await db.execute(
        "CREATE TABLE Note(id INTEGER PRIMARY KEY, title TEXT NOT NULL, description TEXT NOT NULL)"
      ),
    );
  }
  // データベースにデータを追加, int型なのは追加したデータのidを返すため
  Future<int> addNote(Note note) async {
    // データベースのインスタンスを取得
    final db = await _getDB();
    // データベースにデータを追加
    return await db.insert(
      'Note',
      note.toJson(),// モデルクラスをMap型に変換
      conflictAlgorithm: ConflictAlgorithm.replace,// データが重複した場合は置き換える
    );
  }
  // データベースのデータを更新, int型なのは更新したデータのidを返すため
  Future<int> updateNote(Note note) async {
    final db = await _getDB();
    return await db.update(
      'Note',
      note.toJson(),
      where: 'id = ?',
      whereArgs: [note.id],
      conflictAlgorithm: ConflictAlgorithm.replace
    );
  }
  // データベースのデータを削除, int型なのは削除したデータのidを返すため
  Future<int> deleteNote(Note note) async {
    final db = await _getDB();
    return await db.delete(
      'Note',
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }
  // データベースのデータを全て取得
  Future<List<Note>?> getAllNote() async {
    final db = await _getDB();

    final List<Map<String, dynamic>> maps = await db.query('Note');

    if(maps.isEmpty) {
      return null;
    } else {
      return List.generate(maps.length, (index) => Note.fromJson(maps[index]));
    }
  }
}