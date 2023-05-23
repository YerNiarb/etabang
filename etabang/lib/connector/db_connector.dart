import 'dart:typed_data';

import 'package:postgres/postgres.dart';

class DbConnector {
  late PostgreSQLConnection _connection;

  Future<void> connect() async {
    _connection = PostgreSQLConnection(
      "34.118.203.41",
      5432,
      "etabang-dev",
      username: "postgres",
      password: "etabang2023",
    );

    await _connection.open();
  }

  Future<List<Map<String, Map<String, dynamic>>>> query(String sql) async {
    final results = await _connection.mappedResultsQuery(sql);
    return results;
  }

  Future<void> close() async {
    await _connection.close();
  }
}