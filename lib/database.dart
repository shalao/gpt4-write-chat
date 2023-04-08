import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  // Singleton instance
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  // Singleton accessor
  static DatabaseHelper get instance => _instance;

  // Database connection
  static Database? _database;

  // Constructor
  DatabaseHelper._internal();

  // Get database connection
  Future<Database> get database async =>
      _database ??= await _initDatabase();
      
  // Initialize database
  Future<Database> _initDatabase() async {
    var documentsDirectory = await getApplicationDocumentsDirectory();
    var path = join(documentsDirectory.path, "chat.db");

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  // Create database tables
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE messages (
        id INTEGER PRIMARY KEY,
        content TEXT,
        timestamp TEXT
      )
    ''');
  }
}
