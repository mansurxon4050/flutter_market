import 'dart:io';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import '../model/database_model/add_cart_database_model.dart';

class Databasehelper {
  Databasehelper._privateConstructor();

  static final Databasehelper instance = Databasehelper._privateConstructor();
  static final Databasehelper instance1 = Databasehelper._privateConstructor();

  static Database? _database;
  static Database? _database1;

  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> get database1 async => _database1 ??= await _initDatabase1();

  Future<Database> _initDatabase() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, 'groceries.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }


  Future<Database> _initDatabase1() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, 'infoProducts.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate1);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE groceries(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    productId INTEGER NOT NULL,
    name TEXT NOT NULL,
    image TEXT NOT NULL,
    info TEXT NOT NULL,
    category TEXT NOT NULL,
    price INTEGER NOT NULL,
    allPrice INTEGER NOT NULL,
    count INTEGER NOT NULL,
    type TEXT NOT NULL
    )
    ''');
  }

  Future _onCreate1(Database db, int version) async {
    await db.execute('''
    CREATE TABLE infoProducts(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    productId INTEGER NOT NULL,
    star INTEGER,
    favorite INTEGER
    )
    ''');
  }

  // static Future deleteTable() async {
  //   Database db = await instance1.database1;
  //   return db.rawQuery('DELETE FROM infoProducts');
  // }



  Future<int> inserts1(
      ProductStarFavorInfoModel productStarFavorInfoModel) async {
    Database db = await instance1.database1;
    return await db.insert('infoProducts', productStarFavorInfoModel.toMap());
  }

  Future<int> add1(ProductStarFavorInfoModel productStarFavorInfoModel) async {
    Database db = await instance1.database1;
    var result = await db.query(
      'infoProducts',
      where: 'productId = ?',
      whereArgs: [productStarFavorInfoModel.productId],
    );
    if (result.isNotEmpty) {
      await db.delete('infoProducts',
          where: 'id = ?', whereArgs: [result[0]['id']]);
      return inserts1(productStarFavorInfoModel);
    } else {
      var result = await db.insert(
        'infoProducts',
        productStarFavorInfoModel.toMap(),
      );
      return result;
    }
  }

  Future<List> getInfoProducts(int productId) async {
    Database db = await instance1.database1;
    var productInfo = await db.query(
      'infoProducts',
      where: 'productId = ?',
      whereArgs: [productId],
    );
    return productInfo;
  }

  Future<List<Grocery>> getGrocery() async {
    Database db = await instance.database;
    var groceries = await db.query('groceries', orderBy: 'name');
    List<Grocery> grocerList = groceries.isNotEmpty
        ? groceries.map((c) => Grocery.fromMap(c)).toList()
        : [];
    return grocerList;
  }

  Future<List> getGrocerys() async {
    Database db = await instance.database;
    var groceries = await db.query('groceries', orderBy: 'name');
    return groceries;
  }

  Future<int> add(Grocery grocery) async {
    Database db = await instance.database;
    var result = await db.query(
      'groceries',
      where: 'productId = ?',
      whereArgs: [grocery.productId],
    );
    if (result.isNotEmpty) {
      await db
          .delete('groceries', where: 'id = ?', whereArgs: [result[0]['id']]);
      return inserts(grocery);
    } else {
      var result = await db.insert(
        'groceries',
        grocery.toMap(),
      );
      return result;
    }
  }

  Future<int> inserts(Grocery grocery) async {
    Database db = await instance.database;
    return await db.insert('groceries', grocery.toMap());
  }

  Future<int> remove(int id) async {
    Database db = await instance.database;
    return await db.delete('groceries', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> update(Grocery grocery) async {
    Database db = await instance.database;
    return await db.update('groceries', grocery.toMap(),
        where: 'id = ?', whereArgs: [grocery.id]);
  }
  Future getTotal() async {
    Database db = await instance.database;
    var result =
    await db.rawQuery("SELECT SUM(allPrice) AS TOTAL FROM groceries");
    return result.toList();
  }
  Future getCount() async {
    Database db = await instance.database;
    final count = Sqflite.firstIntValue(
        await db.rawQuery("SELECT COUNT(*) FROM groceries"));
    return count;
  }
  Future<void> clear() async {
    Database db = await instance.database;
    await db.rawQuery('DELETE FROM groceries');
  }
 static Future deleteFavorColumn()async{
    Database db = await instance1.database1;

     return db.delete('infoProducts',where: 'productId',whereArgs: []);
  }
}
