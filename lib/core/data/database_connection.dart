import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

import 'app_database.dart';

const databaseFileName = 'speed_reading.sqlite';

AppDatabase openAppDatabase() {
  return AppDatabase(
    LazyDatabase(() async {
      final directory = await getApplicationDocumentsDirectory();
      final file = File(path.join(directory.path, databaseFileName));
      return NativeDatabase.createInBackground(file);
    }),
  );
}

