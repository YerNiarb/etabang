import 'package:postgres/postgres.dart';

class DbConnection {
  static final DbConnection _singleton = DbConnection._internal();
  final PostgreSQLConnection _connection = PostgreSQLConnection(
        "34.118.203.41",
        5432,
        "etabang-dev",
        username: "postgres",
        password: "etabang2023",
      );

  factory DbConnection() {
    return _singleton;
  }

  DbConnection._internal();

  Future<PostgreSQLConnection> getConnection() async {
    if (_connection.isClosed) {
      await _connection.open();
    }
    return _connection;
  }
}
