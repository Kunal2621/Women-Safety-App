import 'package:sqflite/sqflite.dart';
import 'package:sefty/model/constactsm.dart';
class DatabaseHelper {
  String contactTable='contact_table';
  String coId='id';
  String coContactName='name';
  String coContactNumber='number';

   
  //name private constroctor

  DatabaseHelper._creatInstance();

  //instance of data base
  static DatabaseHelper? _databaseHelper;
  

  //initialize the database
  factory DatabaseHelper(){
    if(_databaseHelper==null){
      _databaseHelper=DatabaseHelper._creatInstance();

    }return _databaseHelper!;
  }
//initiaze the database
static Database?_database;
Future<Database>get database async{
  if(_database==null){
    _database=await initializeDatabase();
  }
  return _database!;
}
Future<Database>initializeDatabase() async{
  String directoryPath=await getDatabasesPath();
  String dbLocation=directoryPath+'contact.db';

  var contactDatabase=
  await openDatabase(dbLocation,version: 1,onCreate: _createDbTable);
  return contactDatabase;
}
 
 void _createDbTable(Database db,int newVersion)async{
  await db.execute(
    'CREATE TABLE $contactTable($coId INTEGER PRIMARY KEY AUTOINCREMENT,$coContactName TEXT, $coContactNumber TEXT)'
  );
 }
//get contact object from db
Future<List<Map<String,dynamic>>> getContactMapList()async{
  Database db=await this.database;
  List<Map<String,dynamic>>result=
  await db.rawQuery('SELECT * FROM $contactTable order by $coId ASC');
  return result;
}

//insert a creat object
Future<int> insertContact(TContact contact)async{
  Database db=await this.database;
  var result=await db.insert(contactTable, contact.toMap());
  return result;
}
//update a contact object
Future<int> updateContact(TContact contact)async{
  Database db=await this.database;
  var result=await db.update(contactTable, contact.toMap(),where: '$coId=?',whereArgs: [contact.id]);
  return result;
}
 // declete a contact
 Future<int> deleteContact(int id)async{
  Database db=await this.database;
  int result=
  await db.rawDelete('DELETE FROM $contactTable WHERE $coId=$id');
  return result;
 }
Future<int> getCount()async{
  Database db=await this.database;
  List<Map<String,dynamic>> x=
  await db.rawQuery('SELECT COUNT (*) from $contactTable');
  int result =Sqflite.firstIntValue(x)!;
  return result;
}
//get the map list
Future<List<TContact>> getContactList() async{
  var contactMapList=
  await getContactMapList();
  int count =contactMapList.length;
  List<TContact>contactList =<TContact>[];
  for (int i=0;i<count;i++){
    contactList.add(TContact.fromMapObject(contactMapList[i]));
  }
  return contactList;
}


}