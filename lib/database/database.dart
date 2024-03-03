import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'itemsmodel.dart';
import 'searchmodel.dart';

class DBProvider {
  DBProvider._();
  int count = 0;
  static final DBProvider db = DBProvider._();

  Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "jagoMart.db");
    return await openDatabase(path, version: 3, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE keranjang ("
          "id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,"
          "item_id INTEGER,"
          "item TEXT,"
          "unit TEXT,"
          "price INTEGER,"
          "disc INTEGER,"
          "qty INTEGER,"
          "pricedisc INTEGER,"
          "image TEXT,"
          "lokasi TEXT"
          ")");
      await db.execute("CREATE TABLE search ("
          "category INTEGER,"
          "item TEXT"
          ")");
      await db.execute("CREATE TABLE notif ("
          "transid TEXT,"
          "status INTEGER,"
          "title TEXT,"
          "message TEXT,"
          "image TEXT,"
          "read INTEGER"
          ")");
    });
  }

  newCart(CartItem newCart) async {
    final db = await database;
    //insert to the table using the new id
    var raw = await db.rawInsert(
        "INSERT Into keranjang (item_id,item,unit,price,disc,qty,pricedisc,image,lokasi)"
        " VALUES (?,?,?,?,?,?,?,?,?)",
        [
          newCart.id,
          newCart.item,
          newCart.unit,
          newCart.price,
          newCart.disc,
          newCart.qty,
          newCart.qty * newCart.pricedisc,
          newCart.image,
          newCart.lokasi,
        ]);
    return raw;
  }

  updateCart(int id, int qty) async {
    final db = await database;
    var res = await db
        .rawUpdate("UPDATE keranjang SET qty = ? WHERE item_id = ?", [qty, id]);
    return res;
  }

  Future<List<CartItem>> getCart(int id) async {
    final db = await database;
    var res =
        await db.query("keranjang", where: "item_id = ?", whereArgs: [id]);
    List<CartItem> list =
        res.isNotEmpty ? res.map((c) => CartItem.fromMap(c)).toList() : [];
    return list;
  }

  Future<List<CartItem>> getAllCart() async {
    final db = await database;
    var res = await db.query("keranjang");
    List<CartItem> list =
        res.isNotEmpty ? res.map((c) => CartItem.fromMap(c)).toList() : [];
    return list;
  }

  deleteCart(int id) async {
    final db = await database;
    return db.delete("keranjang", where: "item_id = ?", whereArgs: [id]);
  }

  deleteAll() async {
    final db = await database;
    db.rawDelete("Delete from keranjang");
  }

  dropDatabase() async {
    final db = await database;
    db.rawDelete("DROP TABLE keranjang");
  }

  //Search Item
  newSearch(SearchItem newSearch) async {
    final db = await database;
    //insert to the table using the new id
    var raw = await db.rawInsert(
        "INSERT Into search (category, item)"
        " VALUES (?,?)",
        [newSearch.category, newSearch.item]);
    return raw;
  }

  Future<List<SearchItem>> getSearch() async {
    final db = await database;
    var res = await db.query("search");
    List<SearchItem> list =
        res.isNotEmpty ? res.map((c) => SearchItem.fromMap(c)).toList() : [];
    return list;
  }

  Future<List<SearchItem>> getSearchByItem(item) async {
    final db = await database;
    var res = await db.query("search", where: "item = ?", whereArgs: [item]);
    List<SearchItem> list =
        res.isNotEmpty ? res.map((c) => SearchItem.fromMap(c)).toList() : [];
    return list;
  }

  deleteHistoryBy(item) async {
    final db = await database;
    return db.delete("search", where: "item= ?", whereArgs: [item]);
  }

  deleteAllHistory() async {
    final db = await database;
    return db.delete("search");
  }
}
