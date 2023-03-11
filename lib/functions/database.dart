import 'package:bluechat/models/userModel.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class BluDatabase {
  static final BluDatabase instance = BluDatabase._init();

  static Database? _database;

  BluDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('bluchat.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    final textType = 'TEXT NOT NULL';
    final idint = 'INTEGER NOT NULL';

    await db.execute(
                '''
        CREATE TABLE $userTable( 
          ${userModel.id} $idType, 
          ${userModel.username} $textType, 
          ${userModel.deviceID} $textType,
          ${userModel.profilePhoto} $idint 
          )
              '''
    );
  }

  static Future<User> createUser(User user) async {
    final db = await instance.database;

    // final json = note.toJson();
    // final columns =
    //     '${NoteFields.title}, ${NoteFields.description}, ${NoteFields.time}';
    // final values =
    //     '${json[NoteFields.title]}, ${json[NoteFields.description]}, ${json[NoteFields.time]}';
    // final id = await db
    //     .rawInsert('INSERT INTO table_name ($columns) VALUES ($values)');

    final id = await db.insert(userTable, user.toJson());
    return user.copy(id: id);
  }

  static Future<User> readUser(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      userTable,
      columns: userModel.values,
      where: '${userModel.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return User.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<User>> readAllNotes() async {
    final db = await instance.database;

    final result = await db.query(userTable);

    return result.map((json) => User.fromJson(json)).toList();
  }

  static Future<int> update(User user) async {
    final db = await instance.database;

    return db.update(
      userTable,
      user.toJson(),
      where: '${userModel.id} = ?',
      whereArgs: [user.id],
    );
  }

  Future<int> deleteUser(int id) async {
    final db = await instance.database;

    return await db.delete(
      userTable,
      where: '${userModel.id} = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }
}