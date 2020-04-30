import 'dart:async';
import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:taksi/providers/ubicaciones_guardadas.dart';

class DBHelper {
  static Database _db;
  static const String ID = 'id';
  static const String NOMBRE = 'nombre';
  static const String DIRECCION = 'direccion';
  static const String LATITUD = 'latitud';
  static const String LONGITUD = 'longitud';
  static const String TABLE = 'Ubicaciones';
  static const String DB_NAME = 'ubicaciones.db';

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, DB_NAME);
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) async {
    await db.execute(
        "CREATE TABLE $TABLE ($ID INTEGER PRIMARY KEY, $NOMBRE TEXT, $DIRECCION TEXT, $LATITUD DOUBLE, $LONGITUD DOUBLE)");
  }

  Future<Ubicaciones> save(Ubicaciones ubicacioness) async {
    var dbClient = await db;
    ubicacioness.id = await dbClient.insert(TABLE, ubicacioness.toMap());
    return ubicacioness;

    /*await dbClient.transaction((txn) async{
      var query = "INSERT INTO $TABLE ($NOMBRE) VALUES ('" + ubicaciones.nombre + "')";
      return await txn.rawInsert(query);
    });*/
  }

  Future<List<Ubicaciones>> getUbicaciones() async {
    var dbClient = await db;
    List<Map> maps = await dbClient
        .query(TABLE, columns: [ID, NOMBRE, DIRECCION, LATITUD, LONGITUD]);
    //List<Map> maps = await dbClient.rawQuery("SELECT * FROM $TABLE");
    List<Ubicaciones> ubicaciones = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        ubicaciones.add(Ubicaciones.fromMap(maps[i]));
      }
    }
    return ubicaciones;
  }

  Future<int> delete(int id) async {
    var dbClient = await db;
    return await dbClient.delete(TABLE, where: '$ID = ?', whereArgs: [id]);
  }

  Future<int> update(Ubicaciones ubicaciones) async {
    var dbClient = await db;
    return await dbClient.update(TABLE, ubicaciones.toMap(),
        where: '$ID = ?', whereArgs: [ubicaciones.id]);
  }

  Future close() async {
    var dbClient = await db;
    dbClient.close();
  }
}
