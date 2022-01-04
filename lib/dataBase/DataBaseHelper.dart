import 'package:engine_control/dataBase/ParamAdmin.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DataBaseHelper {
  //Variables
  static final dbName = "controlEngineDB.db";
  static final dbVersion = 1;
  static final String TableName = "tableConfig";
  static final String columnId = "id";
  static final String columnNumSim = "numSim";
  static final String columnPin = "pin";

  //DataBase constructor
  DataBaseHelper._();
  static final DataBaseHelper dataBaseHelperInstance = DataBaseHelper._();

  static Database _database;
  Future<Database> get database async{
    if(_database != null) return _database;

    _database = await initDataBase();

    return _database;
  }

  //Initialize database
  Future<Database> initDataBase() async{
   var databasesPath = await getDatabasesPath();
   String path = join(databasesPath, dbName);

   Database database = await openDatabase(path, version: dbVersion, onCreate: _onCreate);

   return database;
  }

  Future _onCreate(Database db, int version) async{
    String query = """
    Create Table $TableName(
    $columnId INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    $columnNumSim VARCHAR(15) NOT NULL,
    $columnPin VARCHAR(7) NOT NULL);
    """;

    db.execute(query);
    insertDefaultData();
  }

  void insertDefaultData() async{
    Database db = await dataBaseHelperInstance.database;
    String query = """
    INSERT INTO $TableName($columnNumSim, $columnPin) VALUES('+22390212223', '123456');
    """;

    await db.rawInsert(query);
  }

  Future<int> updateDB(ParamAdmin paramAdmin) async{
    Database db = await dataBaseHelperInstance.database;
    String query = """
    UPDATE $TableName SET $columnNumSim = ?, $columnPin = ? WHERE $columnId = ?;
    """;

    return await db.rawUpdate(query, [paramAdmin.phone, paramAdmin.pin, paramAdmin.id]);
  }
  Future<List<Map<String, dynamic>>> getData() async{
    Database db = await dataBaseHelperInstance.database;

    return db.rawQuery("SELECT * FROM $TableName;");
  }
}