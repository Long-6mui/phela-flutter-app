import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/product_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('phela.db');
    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE products (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        price INTEGER NOT NULL,
        badge TEXT NOT NULL,
        imagePath TEXT NOT NULL,
        isBestSeller INTEGER NOT NULL
      )
    ''');

    await _insertDefaultProducts(db);
  }

  Future<void> _insertDefaultProducts(Database db) async {
    final List<ProductModel> products = [
      ProductModel(
        name: 'Phan Xi Păng Phê Phin Đặc Sản',
        price: 75000,
        badge: 'MỚI',
        imagePath: 'assets/images/coffees/phan_xi_pang.jpg',
        isBestSeller: 1,
      ),
      ProductModel(
        name: 'COMBO CHILL 01',
        price: 79000,
        badge: 'COMBO',
        imagePath: 'assets/images/coffees/combo_chill_01.jpg',
        isBestSeller: 1,
      ),
      ProductModel(
        name: 'Ô Long Nhài Sữa',
        price: 69000,
        badge: 'SIZE L',
        imagePath: 'assets/images/coffees/olong_nhai_sua.jpg',
        isBestSeller: 1,
      ),
    ];

    for (final product in products) {
      await db.insert('products', product.toMap());
    }
  }

  Future<List<ProductModel>> getBestSellerProducts() async {
    final db = await instance.database;

    final result = await db.query(
      'products',
      where: 'isBestSeller = ?',
      whereArgs: [1],
    );

    return result.map((map) => ProductModel.fromMap(map)).toList();
  }

  Future<int> insertProduct(ProductModel product) async {
    final db = await instance.database;
    return await db.insert('products', product.toMap());
  }

  Future<void> close() async {
    final db = await instance.database;
    await db.close();
  }
}