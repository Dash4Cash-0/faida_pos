import 'dart:io';

import 'package:path/path.dart';
import 'package:faida_pos/models/product.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../models/sale_item.dart';

class DatabaseService {
  //get the DB from phone: adb exec-out run-as com.example.faida_pos cat databases/faida.db > faida.db
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

    return await openDatabase(path, version: 3, onCreate: _onCreate, onUpgrade: _onUpgrade);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE products (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    description TEXT,
    price REAL NOT NULL,
    inStock REAL NOT NULL,
    image TEXT,
    isFavorite INTEGER DEFAULT 0
    )
    ''');
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async{
    if(oldVersion < 2) {
      await db.execute(
        'ALTER TABLE products ADD COLUMN inStock REAL NOT NULL DEFAULT 0'
      );
    }
    if(oldVersion < 3) {
      await db.execute('''
      CREATE TABLE sales (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      total REAL NOT NULL,
      amountReceived REAL NOT NULL,
      change REAL NOT NULL,
      createdAt TEXT NOT NULL
      )
      ''');
      await db.execute('''
      CREATE TABLE sale_items(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      saleId INTEGER NOT NULL,
      productId INTEGER,
      name TEXT NOT NULL,
      price REAL NOT NULL,
      quantity REAL NOT NULL,
      subtotal REAL NOT NULL,
      
      FOREIGN KEY (saleId) REFERENCES sales(id)
      )
      ''');
    }

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

  Future<bool> decreaseStock({
    required int productId,
    required double quantity
}) async {
    final db = await instance.db;
    final int result = await db.rawUpdate(
      '''
      UPDATE products
      SET inStock = inStock - ?
      WHERE id = ?
        AND inStock >= ?
      ''',
      [quantity,productId,quantity]
    );
    return result > 0;
  }

  Future<bool> increaseStock({
    required int productId,
    required double quantity
  }) async {
    final db = await instance.db;
    final int result = await db.rawUpdate(
        '''
      UPDATE products
      SET inStock = inStock - ?
      WHERE id = ?
        AND inStock >= ?
      ''',
        [quantity,productId,quantity]
    );
    return result > 0;
  }

  Future<void> processSale({
    required List<SaleItem> items,
    required double amountReceived
}) async {
    final db = await instance.db;

    await db.transaction((txn) async {
      final total = items.fold(0.0, (sum, i) => sum + i.subtotal);
      final change = amountReceived - total;

      final saleId = await txn.insert('sales', {
        'total': total,
        'amountReceived': amountReceived,
        'change': change,
        'createdAt': DateTime.now().toIso8601String(),
      });

      for (final item in items) {
        await txn.insert('sale_items', {
          'saleId': saleId,
          'productId': item.productId,
          'name': item.name,
          'price': item.price,
          'quantity': item.quantity,
          'subtotal': item.subtotal,
        });

        if (item.productId != null) {
          final updated = await txn.rawUpdate(
            '''
          UPDATE products
          SET inStock = inStock - ?
          WHERE id = ?
            AND inStock >= ?
          ''',
            [item.quantity, item.productId, item.quantity],
          );

          if (updated == 0) {
            throw Exception('Not enough stock for ${item.name}');
          }
        }
      }
    });
  }
}