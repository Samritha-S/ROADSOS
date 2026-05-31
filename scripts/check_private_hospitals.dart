// scripts/check_private_hospitals.dart
// Run after `dart run scripts/build_db.dart` to list private hospital entries.
import 'package:roadsos/data/local/database_helper.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/widgets.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final db = await DatabaseHelper.instance.database;
  final List<Map<String, Object?>> rows = await db.query(
    'facilities',
    columns: ['name', 'phone', 'district', 'service_type'],
    where: 'service_type = ?',
    whereArgs: ['HOSPITAL'],
  );
  print('--- Hospital contacts (${rows.length}) ---');
  for (final row in rows) {
    print('${row['name']} | ${row['phone']} | ${row['district']}');
  }
  await db.close();
}
