import 'package:bcrypt/bcrypt.dart';

// Hash a password using bcrypt
Future<String> hashPassword(String password) async {
  final salt = await generateSalt();
  final hash = await hashPasswordWithSalt(password, salt);
  return '$salt$hash';
}

// Verify a password against a bcrypt hash
Future<bool> verifyPassword(String password, String hash) async {
  final salt = hash.substring(0, 29);
  final hashWithoutSalt = hash.substring(29);
  final newHash = await hashPasswordWithSalt(password, salt);
  return newHash == '$salt$hashWithoutSalt';
}

// Generate a random salt for use with bcrypt
Future<String> generateSalt() async {
  return await hashPasswordWithSalt('', BCrypt.gensalt());
}

// Hash a password with a specific salt using bcrypt
Future<String> hashPasswordWithSalt(String password, String salt) async {
  return BCrypt.hashpw(password, salt);
}