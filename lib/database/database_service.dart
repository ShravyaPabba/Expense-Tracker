import 'dart:ffi';

import 'package:expense_tracker/models/expense.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {

  static final DatabaseService _databaseService = DatabaseService._internal();
  factory DatabaseService() => _databaseService;
  DatabaseService._internal();

  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();


    final path = join(databasePath, 'expense_database.db');


    return await openDatabase(
      path,
      onCreate: _onCreate,
      version: 1
    );
  }


  Future<void> _onCreate(Database db, int version) async {

    await db.execute(
      'CREATE TABLE expenses(id INTEGER PRIMARY KEY AUTOINCREMENT, category TEXT, description TEXT,amount INTEGER,'
          'date TEXT)',
    );

  }


  Future<void> insertExpense(Expense expense) async {

    final db = await _databaseService.database;

    await db.insert(
      'expenses',
      expense.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }


  Future<List<Expense>> expensesList() async {

    final db = await _databaseService.database;

    final List<Map<String, dynamic>> maps = await db.query('expenses',orderBy: "date DESC");

    return List.generate(maps.length, (index) => Expense.fromMap(maps[index]));
  }

  Future<Expense> expense(int id) async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps =
    await db.query('expenses', where: 'id = ?', whereArgs: [id]);
    return Expense.fromMap(maps[0]);
  }

  Future<void> updateBreed(Expense expense) async {

    final db = await _databaseService.database;

    await db.update(
      'expenses',
      expense.toMap(),
      where: 'id = ?',
      whereArgs: [expense.id],
    );
  }

  Future<Map<String,double>> expensesGroupList() async{
    final db = await _databaseService.database;
    var  data = Map<String,double>();
    final List<Map<String, dynamic>> maps = await db.rawQuery("SELECT category,SUM(amount) FROM expenses GROUP BY category");
    print(maps);
    for (var element in maps) {
      String category = element['category'];
     int amt = element['SUM(amount)'];
     data[category] = amt.toDouble();
     print(amt);
    }
    print(data);
    return  data;
  }

}
