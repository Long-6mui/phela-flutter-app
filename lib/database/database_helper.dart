import 'dart:convert';
import 'dart:typed_data';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/address.dart';
import '../models/product_model.dart';
import '../models/user_profile.dart';
import '../models/order_model.dart'; // <-- Đã thêm import cho OrderModel

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
      version: 5, // <-- Nâng lên version 4
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
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

    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        fullName TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE,
        phone TEXT NOT NULL,
        birthDate TEXT,
        gender TEXT NOT NULL,
        password TEXT NOT NULL,
        avatarBytes TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE addresses (
        id TEXT PRIMARY KEY,
        userEmail TEXT NOT NULL,
        recipientName TEXT NOT NULL,
        phone TEXT NOT NULL,
        address TEXT NOT NULL,
        note TEXT,
        isDefault INTEGER NOT NULL
      )
    ''');

    // <-- THÊM BẢNG ORDERS
    await db.execute('''
      CREATE TABLE orders (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userEmail TEXT NOT NULL,
        storeName TEXT NOT NULL,
        itemName TEXT NOT NULL,
        quantity INTEGER NOT NULL,
        totalPrice INTEGER NOT NULL,
        orderDate TEXT NOT NULL,
        paymentMethod TEXT NOT NULL,
        recipientName TEXT NOT NULL,
        phone TEXT NOT NULL,
        addressStr TEXT NOT NULL,
        isPickup INTEGER NOT NULL,
        itemsJson TEXT
      )
    ''');

    await _insertDefaultProducts(db);
  }

  Future<void> _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS users (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          fullName TEXT NOT NULL,
          email TEXT NOT NULL UNIQUE,
          phone TEXT NOT NULL,
          birthDate TEXT,
          gender TEXT NOT NULL,
          password TEXT NOT NULL,
          avatarBytes TEXT
        )
      ''');
    }

    if (oldVersion < 3) {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS addresses (
          id TEXT PRIMARY KEY,
          userEmail TEXT NOT NULL,
          recipientName TEXT NOT NULL,
          phone TEXT NOT NULL,
          address TEXT NOT NULL,
          note TEXT,
          isDefault INTEGER NOT NULL
        )
      ''');
    }

    // <-- BẢN CẬP NHẬT LÊN VERSION 4: TẠO BẢNG ORDERS CHO NGƯỜI ĐÃ CÓ DB
    if (oldVersion < 4) {
      await db.execute('''
        CREATE TABLE orders (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userEmail TEXT NOT NULL,
        storeName TEXT NOT NULL,
        itemName TEXT NOT NULL,
        quantity INTEGER NOT NULL,
        totalPrice INTEGER NOT NULL,
        orderDate TEXT NOT NULL,
        paymentMethod TEXT NOT NULL,
        recipientName TEXT NOT NULL,
        phone TEXT NOT NULL,
        addressStr TEXT NOT NULL,
        isPickup INTEGER NOT NULL,
        itemsJson TEXT
        )
      ''');
      
    }
    if (oldVersion < 5) {
      try {
        await db.execute('ALTER TABLE orders ADD COLUMN itemsJson TEXT');
      } catch (e) {
        // Bỏ qua nếu cột đã tồn tại
      }
    }
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

  Future<Map<String, dynamic>?> getUserByEmail(String email) async {
    try {
      final db = await instance.database;
      final result = await db.query(
        'users',
        where: 'email = ?',
        whereArgs: [email.trim().toLowerCase()],
        limit: 1,
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () => [],
      );
      return result.isNotEmpty ? result.first : null;
    } catch (e) {
      return null;
    }
  }

  Future<Map<String, dynamic>?> getUserByPhone(String phone) async {
    try {
      final db = await instance.database;
      final result = await db.query(
        'users',
        where: 'phone = ?',
        whereArgs: [phone.trim()],
        limit: 1,
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () => [],
      );
      return result.isNotEmpty ? result.first : null;
    } catch (e) {
      return null;
    }
  }

  Future<int> insertUser(UserProfile profile, String password) async {
    try {
      final db = await instance.database;
      return await db.insert('users', {
        'fullName': profile.fullName,
        'email': profile.email.trim().toLowerCase(),
        'phone': profile.phone,
        'birthDate': profile.birthDate,
        'gender': profile.gender.name,
        'password': password,
        'avatarBytes': _encodeAvatar(profile.avatarBytes),
      }).timeout(
        const Duration(seconds: 10),
        onTimeout: () => -1,
      );
    } catch (e) {
      return -1;
    }
  }

  Future<int> updateUserByEmail(String email, UserProfile profile, String password) async {
    try {
      final db = await instance.database;
      return await db.update(
        'users',
        {
          'fullName': profile.fullName,
          'email': profile.email.trim().toLowerCase(),
          'phone': profile.phone,
          'birthDate': profile.birthDate,
          'gender': profile.gender.name,
          'password': password,
          'avatarBytes': _encodeAvatar(profile.avatarBytes),
        },
        where: 'email = ?',
        whereArgs: [email.trim().toLowerCase()],
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () => -1,
      );
    } catch (e) {
      return -1;
    }
  }

  Future<int> insertAddress(Address address, String userEmail) async {
    try {
      final db = await instance.database;
      return await db.insert('addresses', {
        'id': address.id,
        'userEmail': userEmail.trim().toLowerCase(),
        'recipientName': address.recipientName,
        'phone': address.phone,
        'address': address.address,
        'note': address.note,
        'isDefault': address.isDefault ? 1 : 0,
      });
    } catch (e) {
      return -1;
    }
  }

  Future<int> updateAddress(Address address) async {
    try {
      final db = await instance.database;
      return await db.update(
        'addresses',
        {
          'recipientName': address.recipientName,
          'phone': address.phone,
          'address': address.address,
          'note': address.note,
          'isDefault': address.isDefault ? 1 : 0,
        },
        where: 'id = ?',
        whereArgs: [address.id],
      );
    } catch (e) {
      return -1;
    }
  }

  Future<int> deleteAddressById(String id) async {
    try {
      final db = await instance.database;
      return await db.delete(
        'addresses',
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      return -1;
    }
  }

  Future<List<Address>> getAddressesForUser(String email) async {
    try {
      final db = await instance.database;
      final result = await db.query(
        'addresses',
        where: 'userEmail = ?',
        whereArgs: [email.trim().toLowerCase()],
        orderBy: 'isDefault DESC',
      );
      return result.map((map) => Address.fromMap(map)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<int> clearDefaultAddressForUser(String email) async {
    try {
      final db = await instance.database;
      return await db.update(
        'addresses',
        {'isDefault': 0},
        where: 'userEmail = ?',
        whereArgs: [email.trim().toLowerCase()],
      );
    } catch (e) {
      return -1;
    }
  }

  // ==========================================
  // THÊM CÁC HÀM XỬ LÝ CHO BẢNG ORDERS
  // ==========================================

  Future<int> insertOrder(OrderModel order) async {
    try {
      final db = await instance.database;
      return await db.insert('orders', order.toMap());
    } catch (e) {
      return -1;
    }
  }

  Future<List<OrderModel>> getOrdersForUser(String email) async {
    try {
      final db = await instance.database;
      final result = await db.query(
        'orders',
        where: 'userEmail = ?',
        whereArgs: [email.trim().toLowerCase()],
        orderBy: 'id DESC', // Sắp xếp đơn mới nhất lên đầu
      );
      return result.map((map) => OrderModel.fromMap(map)).toList();
    } catch (e) {
      return [];
    }
  }

  // ==========================================

  Future<void> close() async {
    final db = await instance.database;
    await db.close();
  }

  Future<void> clearAllUsers() async {
    try {
      final db = await instance.database;
      await db.delete('users');
    } catch (e) {
      return;
    }
  }

  Future<void> deleteDatabase() async {
    try {
      final dbPath = await getDatabasesPath();
      final path = join(dbPath, 'phela_v3.db');
      await databaseFactory.deleteDatabase(path);
      _database = null;
    } catch (e) {
      return;
    }
  }

  String? _encodeAvatar(Uint8List? avatarBytes) {
    if (avatarBytes == null || avatarBytes.isEmpty) {
      return null;
    }
    return base64Encode(avatarBytes);
  }
}