import '../db/database_helper.dart';
import '../models/note_model.dart';

class NoteService {
  // Método para crear una nota
  Future<bool> createNote(int userId, String title, String description) async {
    Note note = Note(userId: userId, title: title, description: description);
    int noteId = await DatabaseHelper().createNote(note);
    return noteId > 0;
  }

  // Método para obtener todas las notas de un usuario
  Future<List<Note>> getNotes(int userId) async {
    return await DatabaseHelper().getNotesByUser(userId);
  }

  // Método para actualizar una nota
  Future<bool> updateNote(Note note) async {
    int result = await DatabaseHelper().updateNote(note);
    return result > 0;
  }

  // Método para eliminar una nota
  Future<bool> deleteNote(int noteId) async {
    int result = await DatabaseHelper().deleteNoteById(noteId);
    return result > 0;
  }
}
