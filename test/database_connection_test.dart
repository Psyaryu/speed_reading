import 'package:flutter_test/flutter_test.dart';
import 'package:speed_reading/core/data/database_connection.dart';

void main() {
  test('uses stable database file name', () {
    expect(databaseFileName, 'speed_reading.sqlite');
  });
}

