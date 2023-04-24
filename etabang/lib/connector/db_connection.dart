import 'package:postgres/postgres.dart';

class DbConnection {
  static final DbConnection _singleton = DbConnection._internal();
  final PostgreSQLConnection _connection = PostgreSQLConnection(
        "etabang-dev.ccxiix7tthih.us-west-1.rds.amazonaws.com",
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
