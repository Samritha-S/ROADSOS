import 'package:roadsos/data/local/database_helper.dart';
import 'package:roadsos/data/local/seed_data.dart';
import 'package:sqflite/sqflite.dart';

Future<void> main() async {
  // Ensure Flutter bindings are initialized if needed (not required for pure Dart)
  final db = await DatabaseHelper.instance.database;
  // Seed the database using existing SeedData helper
  await SeedData.insertAll(db);
  print('Database seeded successfully.');
  await db.close();
}


