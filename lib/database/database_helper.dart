import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/product_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('phela_v3.db');
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
        name: 'Đà Lạt Phiên Bản Mới',
        price: 69000,
        badge: 'MỚI',
        imagePath: 'assets/images/coffees/Da-Lat-phien-ban-moi-Moi-scaled.jpg',
        isBestSeller: 1,
      ),
      ProductModel(
        name: 'Phan Xi Păng Long Nhãn Đá Xay',
        price: 79000,
        badge: 'HOT',
        imagePath:
            'assets/images/coffees/Phan-Xi-Pang-Long-Nhan-da-xay-scaled.jpg',
        isBestSeller: 1,
      ),
      ProductModel(
        name: 'Phan Xi Păng Phê Phin Đặc Sản',
        price: 75000,
        badge: 'MỚI',
        imagePath:
            'assets/images/coffees/Phan-Xi-Pang-Phe-Phin-Dac-San-da-xay-scaled.jpg',
        isBestSeller: 1,
      ),
      ProductModel(
        name: 'Phê Ame Hạt Colom Ethiopia',
        price: 65000,
        badge: 'BEST',
        imagePath: 'assets/images/coffees/Phe-Ame-hat-Colom-Ethi-scaled.jpg',
        isBestSeller: 1,
      ),
      ProductModel(
        name: 'Phê Đen',
        price: 49000,
        badge: 'CLASSIC',
        imagePath: 'assets/images/coffees/Phe-Den.jpg',
        isBestSeller: 1,
      ),
      ProductModel(
        name: 'Phê Nâu',
        price: 55000,
        badge: 'HOT',
        imagePath: 'assets/images/coffees/Phe-Nau.jpg',
        isBestSeller: 1,
      ),
      ProductModel(
        name: 'Phê Ô Long Bưởi Chanh Vàng',
        price: 69000,
        badge: 'MỚI',
        imagePath:
            'assets/images/coffees/Phe-O-Long-Buoi-Chanh-vang-Moi-scaled.jpg',
        isBestSeller: 1,
      ),
      ProductModel(
        name: 'Phê Xỉu Vani',
        price: 59000,
        badge: 'NEW',
        imagePath: 'assets/images/coffees/Phe-Xiu-Vani.jpg',
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