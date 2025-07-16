import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

abstract class DatabaseService {
  Future<Database> get database;
  Future<void> closeDatabase();
  String get productsTable;
  String get cartTable;
}

class DatabaseServiceImpl implements DatabaseService {
  static Database? _database;
  static const String _databaseName = 'bom_hamburguer.db';
  static const int _databaseVersion = 1;

  static const String _productsTableName = 'products';
  static const String _cartTableName = 'cart_items';

  @override
  String get productsTable => _productsTableName;

  @override
  String get cartTable => _cartTableName;

  @override
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  @override
  Future<void> closeDatabase() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);

    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $productsTable(
        id INTEGER PRIMARY KEY,
        name TEXT NOT NULL,
        price REAL NOT NULL,
        type TEXT NOT NULL,
        imageUrl TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE $cartTable(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        product_id INTEGER NOT NULL,
        product_name TEXT NOT NULL,
        product_price REAL NOT NULL,
        product_type TEXT NOT NULL,
        product_image_url TEXT,
        quantity INTEGER NOT NULL,
        created_at TEXT NOT NULL
      )
    ''');

    await _insertInitialProducts(db);
  }

  Future<void> _insertInitialProducts(Database db) async {
    final products = [
      {
        'id': 1,
        'name': 'Classic Burger',
        'price': 15.50,
        'type': 'sandwich',
        'imageUrl': null,
      },
      {
        'id': 2,
        'name': 'Cheese Burger',
        'price': 17.00,
        'type': 'sandwich',
        'imageUrl': null,
      },
      {
        'id': 3,
        'name': 'Bacon Burger',
        'price': 19.50,
        'type': 'sandwich',
        'imageUrl': null,
      },
      {
        'id': 4,
        'name': 'fries',
        'price': 8.00,
        'type': 'extra',
        'imageUrl': null,
      },
      {
        'id': 5,
        'name': 'softDrink',
        'price': 5.00,
        'type': 'extra',
        'imageUrl': null,
      },
    ];

    for (final product in products) {
      await db.insert(productsTable, product);
    }
  }
}
