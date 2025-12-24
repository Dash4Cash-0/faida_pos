import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:faida_pos/models/product.dart';

class DatabaseService {

  static final DatabaseService instance = DatabaseService._instance();
  static Database? _database;
  DatabaseService._instance();

  Future<Database> get db async {
    _database ??= await initDb();
    return _database!;
  }

  Future<Database> initDb() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath,'faida.db');

    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE products (
    id INTEGER PRIMARY_KEY,
    name TEXT,
    description TEXT,
    price REAL,
    image TEXT,
    )
    ''');
  }

  Future<int> insertProduct(Product product) async {
    Database db = await instance.db;
    return await db.insert('products', product.toMap());
  }

  Future<List<Map<String, dynamic>>> queryAllProducts() async {
    Database db = await instance.db;
    return await db.query('products');
  }

  Future<int> updateProduct(Product product) async {
    Database db = await instance.db;
    return await db.update('products', product.toMap(), where: 'id = ?', whereArgs: [product.id]);
  }

  Future<int> deleteProduct(int id) async {
    Database db = await instance.db;
    return await db.delete('products', where: 'id = ?', whereArgs: [id]);
  }

}