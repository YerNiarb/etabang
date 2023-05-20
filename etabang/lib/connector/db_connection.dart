import 'package:postgres/postgres.dart';

class DbConnection {
  static final DbConnection _singleton = DbConnection._internal();
  final PostgreSQLConnection _connection = PostgreSQLConnection(
        "10.10.10.10",
        5432,
        "etabang-dev",
        username: "postgres",
        password: "postgres",
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
