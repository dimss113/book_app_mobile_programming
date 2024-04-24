import 'dart:async';

// ignore: depend_on_referenced_packages
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:book_app/model/book.dart';

class BookDatabase {
  static final BookDatabase instance = BookDatabase._init();

  static Database? _database;

  BookDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    print("initiating database");
    _database = await _initDB('books.db');

    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    try {
      final dbPath = await getDatabasesPath();
      final path = join(dbPath, filePath);

      return await openDatabase(path, version: 1, onCreate: _createDB);

    } catch (error) {
      throw Exception("Error in initiating database");
    }
  }

  Future _createDB(Database db, int version) async {
    try {
      const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
      const textType = 'TEXT NOT NULL';

      await db.execute('''
      CREATE TABLE $tableBooks (
        ${BookFields.id} $idType,
        ${BookFields.title} $textType,
        ${BookFields.description} $textType,
        ${BookFields.createdTime} $textType,
        ${BookFields.bookImage} $textType
      )
      ''');
    } catch (error) {
      throw Exception("Error in creating database");
    }
  }

  Future<Book> create(Book note) async {
    try {
      final db = await instance.database;
      final id = await db.insert(tableBooks, note.toJson());
      return note.copy(id: id);

    } catch (error) {
      throw Exception("Error in creating book");
    }
  }

  Future<Book> readBook(int id) async {
    try {
      final db = await instance.database;
      final maps = await db.query(
        tableBooks,
        columns: BookFields.values,
        where: '${BookFields.id} = ?',
        whereArgs: [id],
      );

      if (maps.isEmpty) throw Exception('ID $id is not found');
      return Book.fromJson(maps[0]);

    } catch(error) {
      throw Exception("Error in reading book");
    }
  }

  Future<List<Book>> readAllBooks() async {
    try {
      final db = await instance.database;
      final result = await db.query(tableBooks);
      return result.map((note) => Book.fromJson(note)).toList();

    } catch (error) {
      throw Exception("Error in reading all books");
    }
  }

  Future<int> update(Book note) async {
    try {

      final db = await instance.database;

      print(note.toJson());

      return await db.update(
        tableBooks,
        note.toJson(),
        where: '${BookFields.id} = ?',
        whereArgs: [note.id],
      );
    } catch (error) {
      throw Exception("Error in updating book");
    }
  }

  Future<int> delete(int id) async {
    try {
      final db = await instance.database;

      return await db
          .delete(tableBooks, where: '${BookFields.id} = ?', whereArgs: [id]);

    } catch (error) {
      throw Exception("Error in deleting book");
    }
  }

  Future close() async {
    try {
      final db = await instance.database;
      db.close();
       
    } catch (error) {
      throw Exception("Error in closing database");
    }
  }
}
