import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/user_model.dart';
import '../models/note_model.dart';
import '../models/checklist_model.dart';
import '../models/checklist_item_model.dart';

class DatabaseHelper {
  // Instancia única de la clase
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  // Base de datos
  static Database? _database;

  // Constructor privado
  DatabaseHelper._internal();

  // Getter de la base de datos
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Inicialización de la base de datos
  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'app_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  // Creación de las tablas de la base de datos
  Future<void> _onCreate(Database db, int version) async {
    // Tabla de usuarios
    await db.execute('''
    CREATE TABLE users (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      username TEXT NOT NULL,
      email TEXT NOT NULL UNIQUE,
      password TEXT NOT NULL
    )
  ''');

    // Tabla de notas
    await db.execute('''
    CREATE TABLE notes (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      user_id INTEGER NOT NULL,
      title TEXT NOT NULL,
      description TEXT,
      FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
    )
  ''');

    // Tabla de checklists
    await db.execute('''
    CREATE TABLE checklists (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      user_id INTEGER NOT NULL,
      title TEXT NOT NULL,
      FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
    )
  ''');

    // Tabla de checklist items
    await db.execute('''
    CREATE TABLE checklist_items (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      checklist_id INTEGER NOT NULL,
      content TEXT NOT NULL,
      is_done BOOLEAN NOT NULL DEFAULT 0,
      FOREIGN KEY (checklist_id) REFERENCES checklists(id) ON DELETE CASCADE
    )
  ''');
  }

  // Métodos para interactuar con la tabla de usuarios
  Future<int> createUser(User user) async {
    final db = await database;
    return await db.insert('users', user.toMap());
  }

  Future<User?> getUser(String email, String password) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );
    if (result.isNotEmpty) {
      return User.fromMap(result.first);
    } else {
      return null;
    }
  }

  Future<bool> emailExists(String email) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );
    return result.isNotEmpty;
  }

  // Métodos para interactuar con la tabla de notas
  Future<int> createNote(Note note) async {
    final db = await database;
    return await db.insert(
      'notes',
      note.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Note>> getNotesByUser(int userId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'notes',
      where: 'user_id = ?',
      whereArgs: [userId],
    );
    return List.generate(maps.length, (i) => Note.fromMap(maps[i]));
  }

  Future<int> updateNote(Note note) async {
    final db = await database;
    return await db.update(
      'notes',
      note.toMap(),
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

  Future<int> deleteNoteById(int id) async {
    final db = await database;
    return await db.delete(
      'notes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Métodos para interactuar con la tabla de checklists
  Future<int> createChecklist(Checklist checklist) async {
    final db = await database;
    return await db.insert(
      'checklists',
      checklist.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Checklist>> getChecklistsByUser(int userId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'checklists',
      where: 'user_id = ?',
      whereArgs: [userId],
    );
    return List.generate(maps.length, (i) => Checklist.fromMap(maps[i]));
  }

  Future<int> updateChecklist(Checklist checklist) async {
    final db = await database;
    return await db.update(
      'checklists',
      {'title': checklist.title},
      where: 'id = ?',
      whereArgs: [checklist.id],
    );
  }

  Future<int> deleteChecklistById(int id) async {
    final db = await database;
    return await db.delete(
      'checklists',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Métodos para interactuar con la tabla de checklist items
  Future<int> createChecklistItem(ChecklistItem checklistItem) async {
    final db = await database;
    return await db.insert('checklist_items', {
      'checklist_id': checklistItem.checklistId,
      'content': checklistItem.content,
      'is_done': checklistItem.isDone ? 1 : 0,
    });
  }

  Future<List<ChecklistItem>> getChecklistItemsByChecklistId(
      int checklistId) async {
    final db = await database;
    final checklistItems = await db.query(
      'checklist_items',
      where: 'checklist_id = ?',
      whereArgs: [checklistId],
    );
    return List.generate(
      checklistItems.length,
      (i) => ChecklistItem.fromMap(checklistItems[i]),
    );
  }

  Future<ChecklistItem> getChecklistItemById(int checklistItemId) async {
    final db = await database;
    final checklistItem = await db.query(
      'checklist_items',
      where: 'checklist_id = ?',
      whereArgs: [checklistItemId],
    );
    return ChecklistItem.fromMap(checklistItem.first);
  }

  Future<int> updateChecklistItem(ChecklistItem checklistItem) async {
    final db = await database;
    return await db.update(
      'checklist_items',
      {
        'content': checklistItem.content,
        'is_done': checklistItem.isDone ? 1 : 0,
      },
      where: 'id = ?',
      whereArgs: [checklistItem.id],
    );
  }

  Future<int> deleteChecklistItemById(int id) async {
    final db = await database;
    return await db.delete(
      'checklist_items',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
