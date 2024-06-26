import 'package:sqflite_app/domain/entity/note_model.dart';
import 'package:sqflite_app/domain/repository/note_repository.dart';

class NoteController {
  final NoteRepository _noteRepository;
  NoteController(this._noteRepository);

  Future<List<Note>?> getNotes() async {
    return _noteRepository.getNotes();
  }

  Future<void> insert(Note note) async {
    return _noteRepository.insert(note);
  }

  Future<void> update(Note note) async {
    return _noteRepository.update(note);
  }

  Future<void> delete(Note note) async {
    return _noteRepository.delete(note);
  }
}