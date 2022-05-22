import 'package:odev/repositories/database_connection.dart';
import 'package:sqflite/sqflite.dart';

class Repository{
  DatabaseConnection? _databaseConnection;
  Repository(){
    _databaseConnection = DatabaseConnection();
  }
  static Database? _database;
  Future<Database?> get database async {
    if(_database !=null) return _database;
    _database ??= await _databaseConnection?.setDatabase();
    return _database;
  }
  //insert data
  insertData(table,data) async{
    var connection = await database;
    return await connection?.insert(table,data);
  }
  //read data from table
  readData(table) async{
    var connection = await database;
    return await connection?.query(table);
  }
  readDataById(table,itemId) async{
    var connection=await database;
    return await connection?.query(table,
        where: "id=?",whereArgs: [itemId]);
  }
  readDataByCategory(table,itemName) async{
    var connection=await database;
    return await connection?.query(table,
        where: "category=?",whereArgs: [itemName]);
  }
  updateData(table,data) async{
    var connection = await database;
    return await connection?.update(table,data,where: "id=?",whereArgs: [data["id"]]);
  }
  deleteDate(table,itemId) async{
    var connection = await database;
    return await connection?.rawDelete("DELETE FROM $table WHERE id=$itemId");
  }
}
