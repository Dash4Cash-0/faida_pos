import 'dart:io';

import 'package:path/path.dart';
import 'package:faida_pos/models/product.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DatabaseService {

  static final DatabaseService instance = DatabaseService._instance();
  static Database? _database;
  DatabaseService._instance();

  Future<Database> get db async {
    _database ??= await initDb();
    return _database!;
  }

  Future<Database> initDb() async {
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath,'faida.db');

    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE products (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    description TEXT,
    price REAL NOT NULL,
    image TEXT,
    isFavorite INTEGER DEFAULT 0
    )
    ''');
  }

  Future<int> insertProduct(Product product) async {
    Database db = await instance.db;
    return await db.insert('products', product.toMap());
  }

  Future<List<Product>> getAllProducts() async {
    Database db = await instance.db;
    final maps = await db.query('products');
    return maps.map((map) => Product.fromMap(map)).toList();
  }

  Future<List<Product>> getFavoriteProducts() async {
    Database db = await instance.db;
    final maps = await db.query(
      'products',
      where: 'isFavorite = ?',
      whereArgs: [1],
    );
    return maps.map((map) => Product.fromMap(map)).toList();
  }

  Future<int> updateProduct(Product product) async {
    Database db = await instance.db;
    return await db.update('products', product.toMap(), where: 'id = ?', whereArgs: [product.id]);
  }

  Future<int> toggleFavorite(int productId, bool isFavorite) async {
    Database db = await instance.db;
    return await db.update(
      'products',
      {'isFavorite': isFavorite ? 1 : 0},
      where: 'id = ?',
      whereArgs: [productId],
    );
  }

  Future<int> deleteProduct(int id) async {
    Database db = await instance.db;
    return await db.delete('products', where: 'id = ?', whereArgs: [id]);
  }

  Future<Product?> getProductById(int id) async {
    final db = await instance.db;
    final maps = await db.query(
      'products',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isEmpty) return null;
    return Product.fromMap(maps.first);
  }

}