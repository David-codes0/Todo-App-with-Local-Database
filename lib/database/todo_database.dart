import 'package:path/path.dart' show join;
import 'package:sqflite/sqflite.dart';
import 'package:sql_todo/models/todo.dart';
import 'package:sql_todo/models/user.dart';

class TodoDatabase {
  static final TodoDatabase instance = TodoDatabase
      ._initialize(); // creating a singleton to avoid creating multiple instances
  TodoDatabase._initialize(); //  a named constructor
  static Database? _database; // create an instance of sqflite database

  Future _createDB(
    Database db,
    int version,
  ) async {
    const userUsernameType = 'TEXT PRIMARY KEY NOT NULL';
    const textType = 'TEXT NOT NULL';
    const boolType = 'BOOLEAN NOT NULL';

    await db.execute(''' CREATE TABLE $userTable (
      ${UserFields.username} $userUsernameType,
      ${UserFields.name} $textType
    )'''); // executeing

    await db.execute(''' CREATE TABLE $todoTable (
      ${TodoFields.username} $textType,
      ${TodoFields.title} $textType,
      ${TodoFields.done} $boolType,
      ${TodoFields.created} $textType,
      FOREIGN KEY (${TodoFields.username}) REFERENCES $userTable (${UserFields.name})
      )'''); //Execute an SQL query with no return value.
  }

  Future _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = NO');
  }

  Future<Database> _initDB(String fileName) async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, fileName);

    return await openDatabase(
      path,
      version: 1,
      onConfigure: _onConfigure,
      onCreate: _createDB,
    );
  }

  Future close() async {
    final db = await instance.database;

    db!.close();
  }

  Future<Database?> get database async {
    if (_database != null) {
      return _database;
    } else {
      _database = await _initDB('todo.db');
      return _database;
    }
  }

  Future<User> createUser(User user) async {
    final db = await instance.database;
    await db!.insert(userTable, user.toJson());
    return user;
  }

  Future<User> getUser(String username) async {
    // from the Database
    final db = await instance.database;
    final maps = await db!.query(
      userTable,
      columns: UserFields.allFields,
      where: '${UserFields.username} = ?',
      whereArgs: [username],
    );

    if (maps.isNotEmpty) {
      return User.fromJson(maps.first);
    } else {
      throw Exception('User not found in Database !!!');
    }
  }

  Future<List<User>> getAllUsers() async {
    final db = await instance.database;
    final results = await db!.query(userTable,
        orderBy:
            '${UserFields.username} ASC'); // ordering the database in ascending order
    return results.map((e) => User.fromJson(e)).toList();
  }

  Future<int> deleteUser(String username) async {
    // From the database
    final db = await instance.database;
    return db!.delete(userTable,
        where: '${UserFields.username} = ?', whereArgs: [username]);
  }

  Future<int> updateUser(User user) async {
    final db = await instance.database;
    return db!.update(userTable, user.toJson(),
        where: '${UserFields.username} = ?', whereArgs: [user.username]);
  }

  Future<Todo> createTodo(Todo todo) async {
    final db = await instance.database;
    await db!.insert(
      todoTable,
      todo.toJson(),
    );
    return todo;
  }

  Future<int> toggleTodoDone(Todo todo) async {
    todo.done = !todo.done;
    final db = await instance.database;

    return db!.update(
      todoTable,
      todo.toJson(),
      where: '${TodoFields.username} = ? AND ${TodoFields.title} = ?',
      whereArgs: [todo.username, todo.title],
    );
  }

  Future<List<Todo>> getTodos(String username) async {
    final db = await instance.database;

    final result = await db!.query(
      todoTable,
      orderBy:
          '${TodoFields.created} DESC', // get the todo list in descending order
      where:
          '${TodoFields.username} = ?', //getting the todo list by the username
      whereArgs: [username],
    );
    return result.map((e) => Todo.fromJson(e)).toList();
  }

  Future<int> deleteTodo(Todo todo) async {
    // From the database
    final db = await instance.database;
    return db!.delete(
      todoTable,
      where: '${TodoFields.username} = ? AND ${TodoFields.title} = ?',
      whereArgs: [todo.username, todo.title],
    );
  }
}

