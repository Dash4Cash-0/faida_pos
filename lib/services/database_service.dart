import 'dart:io';

import 'package:faida_pos/models/expense_model.dart';
import 'package:faida_pos/models/notifications_model.dart';
import 'package:faida_pos/models/sale.dart';
import 'package:path/path.dart';
import 'package:faida_pos/models/product.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import '../models/sale_item.dart';

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

    return await openDatabase(path, version: 5, onCreate: _onCreate, onUpgrade: _onUpgrade);
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
  CREATE TABLE sale_items (
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

    await db.execute('''
  CREATE TABLE notifications (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    productId INTEGER NOT NULL,
    isLowStock INTEGER DEFAULT 0,
    isOutOfStock INTEGER DEFAULT 0,
    isDismissed INTEGER DEFAULT 0,
    isResolved INTEGER DEFAULT 0,
    createdAt TEXT NOT NULL,
    resolvedAt TEXT,
    dismissedAt TEXT,
    FOREIGN KEY (productId) REFERENCES products(id)
  )
  ''');

    await db.execute('''
  CREATE TABLE expenses (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    expCost REAL NOT NULL,
    expCategory TEXT NOT NULL,
    expDesc TEXT,
    createdAt TEXT NOT NULL
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
    if(oldVersion < 4){
      await db.execute('''
      CREATE TABLE notifications (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      productId INTEGER NOT NULL,
      isLowStock INTEGER DEFAULT 0,
      isOutOfStock INTEGER DEFAULT 0,
      isDismissed INTEGER DEFAULT 0,
      isResolved INTEGER DEFAULT 0,
      createdAt TEXT NOT NULL,
      resolvedAt TEXT,
      dismissedAt TEXT,
      
      FOREIGN KEY (productId) REFERENCES product(id)
      )
      ''');
    }
    if(oldVersion < 5){
      await db.execute('''
      CREATE TABLE expenses (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      expCost REAL NOT NULL,
      expCategory TEXT NOT NULL,
      expDesc TEXT,
      createdAt TEXT NOT NULL
      )
      ''');
    }
  }


  Future<void>outOfStockNotification({
    required Product product}) async {
    Database db = await instance.db;
    final item = product.id;

    await db.transaction((tsx) async{
      tsx.insert('notifications',{
        'productId': item,
        'isOutOfStock': 1,
        'createdAt': DateTime.now().toIso8601String(),
      });
    });
  }


  Future<void>lowStockNotification({
    required Product product}) async {
    Database db = await instance.db;
    final item = product.id;

    await db.transaction((tsx) async{
      tsx.insert('notifications',{
        'productId': item,
        'isLowStock': 1,
        'createdAt': DateTime.now().toIso8601String(),
      });
    });
  }


  Future<int>dismissedNotification(
      NotificationsModel notification,
      bool isDismissed) async{
    Database db = await instance.db;
    return await db.update('notifications',
        {'isDismissed': isDismissed ? 1 : 0},
        where: 'id = ?',
        whereArgs: [notification.id]);
  }

  Future<void> resolveNotificationsForProduct(int productId) async {
    final db = await instance.db;
    await db.update('notifications',
      {
        'isResolved': 1,
        'resolvedAt': DateTime.now().toIso8601String(),
      },
      where: 'productId = ? AND isResolved = 0',
      whereArgs: [productId],
    );
  }
Future<void> deleteNotification(int notificationId) async {
    final db = await instance.db;
    await db.delete('notifications',
    where: 'id = ?',
    whereArgs: [notificationId]);
}

  Future<List<NotificationsModel>> getNotifications() async {
    Database db = await instance.db;
    final maps = await db.query('notifications', orderBy: 'createdAt DESC');
    return maps.map((m) => NotificationsModel.fromMap(m)).toList();
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

  Future<List<Sale>> getSalesByDate(DateTime date) async {
    Database db = await instance.db;

    final startOfDay = DateTime(date.year, date.month, date.day);
    final startTomorrow = startOfDay.add(Duration(days: 1));

    final maps = await db.query(
      'sales',
      where: 'createdAt >= ? AND createdAt < ?',
        whereArgs: [startOfDay.toIso8601String(),
        startTomorrow.toIso8601String()],
    );
    return maps.map((map) => Sale.fromMap(map)).toList();
  }

  Future<List<SaleItem>> getSaleItems(int saleId) async {
    final db = await instance.db;
    final result = await db.query(
      'sale_items',
      where: 'saleId = ?',
      whereArgs: [saleId],
    );
    return result.map((map) => SaleItem.fromMap(map)).toList();
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

  Future<void> processQuickSale({
    required double amountReceived
}) async {
    final db  = await instance.db;

    await db.transaction((txn) async {
      await txn.insert('sales',
          {
            'total': amountReceived,
            'amountReceived': amountReceived,
            'change': 0,
            'createdAt':DateTime.now().toIso8601String(),
          });
    });
  }

  Future<List<Sale>> getSalesInDateRange(DateTime startDate, DateTime endDate) async {
    final db = await instance.db;
    final List<Map<String, dynamic>> maps = await db.query(
      'sales',
      where: 'createdAt >= ? AND createdAt <= ?',
      whereArgs: [startDate.toIso8601String(), endDate.toIso8601String()],
      orderBy: 'createdAt DESC',
    );
    return List.generate(maps.length, (i) => Sale.fromMap(maps[i]));
  }

  Future<int> insertExpense(Expense expense) async {
    final db = await instance.db;
    return await db.insert('expenses', expense.toMap());
  }

  Future<List<Expense>> getExpensesByDate(DateTime date) async {
    final db = await instance.db;
    final startOfDay = DateTime(date.year, date.month, date.day);
    final startTomorrow = startOfDay.add(Duration(days: 1));
    final maps = await db.query(
      'expenses',
      where: 'createdAt >= ? AND createdAt < ?',
      whereArgs: [startOfDay.toIso8601String(), startTomorrow.toIso8601String()],
      orderBy: 'createdAt DESC',
    );
    return maps.map((m) => Expense.fromMap(m)).toList();
  }

  Future<void> deleteExpense(int id) async {
    final db = await instance.db;
    await db.delete('expenses', where: 'id = ?', whereArgs: [id]);
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