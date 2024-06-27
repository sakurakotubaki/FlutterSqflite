import 'package:sqflite_app/domain/entity/note_model.dart';
import 'package:sqflite_app/domain/repository/mock_repository.dart';

// Viewから呼び出すロジックはControllerを経由する。
class MockController {
  final MockRepository _mockRepository;
  MockController(this._mockRepository);

  Future<List<Note>?> getNotes() async {
    return _mockRepository.getNotes();
  }

  Future<void> insert(Note note) async {
    return _mockRepository.insert(note);
  }

  Future<void> update(Note note) async {
    return _mockRepository.update(note);
  }

  Future<void> delete(Note note) async {
    return _mockRepository.delete(note);
  }
}